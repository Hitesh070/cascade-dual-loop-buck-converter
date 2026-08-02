/**
 * @file cascade_control.h
 * @brief Cascade (Dual-Loop) Voltage-Current Control Algorithm for Buck Converter
 * 
 * Hardware-Independent ANSI C implementation of PI cascade control.
 */

#ifndef CASCADE_CONTROL_H
#define CASCADE_CONTROL_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

/**
 * @brief PI Controller Structure with Anti-Windup Clamping
 */
typedef struct {
    float Kp;             ///< Proportional Gain
    float Ki;             ///< Integral Gain
    float integrator;     ///< Integrator Accumulator
    float out_min;        ///< Minimum Output Limit
    float out_max;        ///< Maximum Output Limit
    float dt;             ///< Sampling Time (seconds)
} PI_Controller_t;

/**
 * @brief Dual-Loop Cascade Buck System Control Structure
 */
typedef struct {
    PI_Controller_t outer_pi;  ///< Outer Voltage Loop PI Controller (1 kHz)
    PI_Controller_t inner_pi;  ///< Inner Current Loop PI Controller (10 kHz)
    
    float v_ref;               ///< Target Output Voltage (e.g., 5.0 V)
    float i_ref;               ///< Intermediate Target Inductor Current (clamped output of outer loop)
    float i_ref_max;           ///< Maximum Clamped Inductor Current Safety Limit (e.g., 1.5 A)
    float v_in;                ///< Nominal Input Supply Voltage (e.g., 12.0 V)
    
    float duty_min;            ///< Minimum Duty Cycle (e.g., 0.02 = 2%)
    float duty_max;            ///< Maximum Duty Cycle (e.g., 0.90 = 90%)
    
    uint16_t outer_divider;    ///< Divide ratio (10 for 10kHz inner -> 1kHz outer)
    uint16_t inner_counter;    ///< Cycle counter
    
    uint8_t soft_start_done;   ///< Soft-start status flag
    float soft_start_vref;     ///< Ramp voltage reference during soft start
} CascadeBuck_t;

/**
 * @brief Initialize PI controller instance
 */
void PI_Init(PI_Controller_t *pi, float Kp, float Ki, float out_min, float out_max, float dt);

/**
 * @brief Reset PI controller integrator state
 */
void PI_Reset(PI_Controller_t *pi);

/**
 * @brief Compute PI controller output step with anti-windup clamping
 */
float PI_Update(PI_Controller_t *pi, float setpoint, float measured);

/**
 * @brief Initialize complete Dual-Loop Cascade Controller
 */
void CascadeBuck_Init(CascadeBuck_t *sys, 
                     float Kp_v, float Ki_v, 
                     float Kp_i, float Ki_i,
                     float v_ref, float i_ref_max, float v_in,
                     float duty_min, float duty_max);

/**
 * @brief Execute Outer Voltage Loop (1 kHz / 1 ms execution rate)
 * @return Clamped reference current I_ref command for inner loop
 */
float CascadeBuck_UpdateOuterLoop(CascadeBuck_t *sys, float v_out_measured);

/**
 * @brief Execute Inner Current Loop (10 kHz / 100 us ISR execution rate)
 * @return Duty Cycle normalized [0.0 - 1.0] to write to PWM timer register
 */
float CascadeBuck_UpdateInnerLoop(CascadeBuck_t *sys, float i_L_measured, float v_out_measured);

#ifdef __cplusplus
}
#endif

#endif // CASCADE_CONTROL_H
