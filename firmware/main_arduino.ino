/**
 * @file main_arduino.ino
 * @brief Complete Deterministic Dual-Loop Cascade Control Firmware for Arduino Uno (ATmega328P)
 * 
 * Hardware Timer Setup:
 * - Timer 1 Fast PWM at 10 kHz on Pin 9 (OC1A) with 1600-step resolution (ICR1 = 1599).
 * - Timer 1 COMPA Interrupt running at 10 kHz (100 us execution rate).
 * 
 * Hardware Connections:
 * - Pin 9  -> MOSFET Gate Driver input (e.g., IR2104 IN pin or TC4420)
 * - Pin A0 -> Voltage Divider sensing Vout (10k upper / 4.7k lower -> Factor 3.1276)
 * - Pin A1 -> Current Sensor sensing IL (ACS712-05B or Low-side Shunt)
 */

#include "cascade_control.h"

// ======================================================
// HARDWARE CALIBRATION & PIN SELECTION
// ======================================================
#define PWM_PIN           9     // Timer 1 OC1A PWM Output Pin
#define VOUT_ADC_PIN      A0    // Output Voltage Sensing Pin
#define IL_ADC_PIN        A1    // Inductor Current Sensing Pin

// Voltage Sensing Divider Ratio: Vout = V_adc * (R1 + R2) / R2
// With R1 = 10k, R2 = 4.7k -> Ratio = (10k + 4.7k)/4.7k = 3.127659
#define VOUT_SCALE        (5.0f / 1023.0f * 3.127659f)

// Select Current Sensor Type (1 = ACS712-05B, 2 = Low-Side Shunt 0.1 Ohm + Op-Amp G=10)
#define SENSOR_TYPE_ACS712      1
#define SENSOR_TYPE_LOW_SHUNT   2
#define CURRENT_SENSOR_CHOICE   SENSOR_TYPE_ACS712

#if (CURRENT_SENSOR_CHOICE == SENSOR_TYPE_ACS712)
  #define ACS712_OFFSET_V 2.500f  // 2.5V zero current offset
  #define ACS712_SENS_V_A 0.185f  // 185 mV/A sensitivity for 5A model
#elif (CURRENT_SENSOR_CHOICE == SENSOR_TYPE_LOW_SHUNT)
  #define SHUNT_GAIN_V_A  1.000f  // 1V per Ampere output
#endif

// ======================================================
// CASCADE CONTROLLER INSTANCE
// ======================================================
static CascadeBuck_t buck_sys;

// Volatile variables for background telemetry
volatile float telemetry_v_out = 0.0f;
volatile float telemetry_i_L = 0.0f;
volatile float telemetry_i_ref = 0.0f;
volatile float telemetry_duty = 0.0f;

// Setup Flag
volatile uint8_t system_running = 0;

// ======================================================
// ADC SENSING HELPER FUNCTIONS
// ======================================================
static inline float Read_Vout(void) {
    uint16_t raw_adc = analogRead(VOUT_ADC_PIN);
    return raw_adc * VOUT_SCALE;
}

static inline float Read_IL(void) {
    uint16_t raw_adc = analogRead(IL_ADC_PIN);
    float v_adc = raw_adc * (5.0f / 1023.0f);
    
#if (CURRENT_SENSOR_CHOICE == SENSOR_TYPE_ACS712)
    float i_measured = (v_adc - ACS712_OFFSET_V) / ACS712_SENS_V_A;
    return (i_measured < 0.0f) ? 0.0f : i_measured;
#else
    return v_adc / SHUNT_GAIN_V_A;
#endif
}

// ======================================================
// TIMER 1 COMPA ISR (10 kHz / 100 microseconds period)
// ======================================================
ISR(TIMER1_COMPA_vect) {
    if (!system_running) return;
    
    // 1. Read Analog Sensors
    float v_out = Read_Vout();
    float i_L = Read_IL();
    
    // 2. Execute Dual-Loop Cascade Algorithm
    float duty_command = CascadeBuck_UpdateInnerLoop(&buck_sys, i_L, v_out);
    
    // 3. Convert Duty Cycle (0.0 to 1.0) to Timer Compare Value (0 to ICR1 = 1599)
    uint16_t ocr_val = (uint16_t)(duty_command * 1599.0f);
    if (ocr_val > 1440) ocr_val = 1440; // 90% Max Duty Safety Guard
    if (ocr_val < 32)   ocr_val = 32;   // 2% Min Duty Guard
    
    OCR1A = ocr_val; // Update hardware PWM register instantaneously
    
    // Telemetry updates
    telemetry_v_out = v_out;
    telemetry_i_L = i_L;
    telemetry_i_ref = buck_sys.i_ref;
    telemetry_duty = duty_command * 100.0f;
}

// ======================================================
// HARDWARE INITIALIZATION
// ======================================================
void setup() {
    Serial.begin(115200);
    while (!Serial);
    
    Serial.println(F("=============================================="));
    Serial.println(F(" Cascade Dual-Loop Buck Converter Controller "));
    Serial.println(F(" Target: Arduino Uno (ATmega328P @ 16 MHz)    "));
    Serial.println(F("=============================================="));

    // Configure PWM Output Pin
    pinMode(PWM_PIN, OUTPUT);
    digitalWrite(PWM_PIN, LOW);

    // Initialize Cascade Controller parameters from Stage 1 tuning
    // Kp_v = 0.5906, Ki_v = 125.66, Kp_i = 0.1047, Ki_i = 22.28
    CascadeBuck_Init(&buck_sys, 
                     0.5906f, 125.66f,  // Outer Voltage Loop gains (1 kHz)
                     0.1047f, 22.28f,   // Inner Current Loop gains (10 kHz)
                     5.0f,              // Target Vref = 5.0 V
                     1.5f,              // Clamped Max Iref = 1.5 A
                     12.0f,             // Input Vin = 12.0 V
                     0.02f, 0.90f);     // Min / Max Duty limits

    // Configure Timer 1 for 10 kHz Fast PWM Mode (ICR1 as TOP)
    cli(); // Disable interrupts during configuration
    
    TCCR1A = 0;
    TCCR1B = 0;
    TCNT1  = 0;
    
    // Set Fast PWM mode 14: TOP = ICR1, Update OCR1A at BOTTOM, TOV1 set on TOP
    // TCCR1A: COM1A1 = 1 (Non-inverting PWM on Pin 9), WGM11 = 1, WGM10 = 0
    TCCR1A = _BV(COM1A1) | _BV(WGM11);
    
    // TCCR1B: WGM13 = 1, WGM12 = 1, Prescaler = 1 (CS10 = 1)
    // Frequency = 16,000,000 / (1 * (1599 + 1)) = 10,000 Hz (10 kHz)
    TCCR1B = _BV(WGM13) | _BV(WGM12) | _BV(CS10);
    
    ICR1 = 1599;  // TOP value for 10 kHz PWM
    OCR1A = 0;    // Initial 0% Duty Cycle

    // Enable Timer 1 Output Compare Match A Interrupt
    TIMSK1 = _BV(OCIE1A);
    
    sei(); // Enable global interrupts
    
    system_running = 1;
    Serial.println(F("System Running! 10 kHz Inner ISR / 1 kHz Outer Loop Active."));
    Serial.println(F("Time(ms)\tVout(V)\tIL(A)\tIref(A)\tDuty(%)"));
}

// ======================================================
// MAIN LOOP: TELEMETRY & MONITORING (Non-Blocking)
// ======================================================
void loop() {
    static unsigned long last_print_ms = 0;
    unsigned long current_ms = millis();
    
    // Print serial debug telemetry every 250 ms
    if (current_ms - last_print_ms >= 250) {
        last_print_ms = current_ms;
        
        cli(); // Protect multi-byte reading
        float v = telemetry_v_out;
        float i = telemetry_i_L;
        float iref = telemetry_i_ref;
        float d = telemetry_duty;
        sei();
        
        Serial.print(current_ms);
        Serial.print(F("\t\t"));
        Serial.print(v, 2);
        Serial.print(F("\t"));
        Serial.print(i, 2);
        Serial.print(F("\t"));
        Serial.print(iref, 2);
        Serial.print(F("\t"));
        Serial.println(d, 1);
    }
}
