# Cascade (Dual-Loop) Voltage-Current Controlled Buck Converter
> **2nd-Year Control Systems Engineering Project**  
> Complete Hardware, Simulation, Firmware & Interactive Studio

---

## 📖 Executive Summary & How It Works

A **Buck Converter** steps down a higher DC input voltage ($12\text{V}$) to a lower, stable DC output voltage ($5\text{V}$) by rapidly pulsing a MOSFET switch ON and OFF using Pulse Width Modulation (PWM).

In traditional single-loop power supplies, the controller measures only the output voltage $V_{out}$. Because output capacitors delay voltage changes, single-loop systems react slowly to load spikes and provide **zero protection against short-circuit current surges** that destroy MOSFETs.

To solve this, **Cascade Dual-Loop Control** establishes a strict hierarchy using two nested feedback loops running at different frequencies:

```
 [ V_ref ] ---> ( Outer Voltage Loop: 1 kHz ) ---> [ I_ref (Clamped 1.5A) ] ---> ( Inner Current Loop: 10 kHz ) ---> [ Duty Cycle ] ---> [ Buck Hardware ]
                     ^                                                                  ^
                     |                                                                  |
             [ Measures V_out ]                                                 [ Measures I_L ]
```

1. **Outer Voltage Loop (Slow / Strategic - 1 kHz / 1 ms):** Samples $V_{out}$, compares it to $V_{ref}$, and computes how much inductor current is needed using a PI controller. Its output becomes the target current command $I_{ref}$ for the inner loop. **Crucially, $I_{ref}$ is hard clamped at $1.5\text{A}$ in software**, making it physically impossible for the circuit to draw destructive short-circuit currents.
2. **Inner Current Loop (Fast / Tactical - 10 kHz / 100 $\mu$s):** Measures instantaneous inductor current $I_L$, compares it to $I_{ref}$, and adjusts the PWM duty cycle directly. Because inductor current changes instantaneously compared to capacitor voltage, the inner loop absorbs input voltage spikes and sudden load changes before they distort $V_{out}$.

By separating control bandwidths—making the inner current loop 10 times faster than the outer voltage loop ($f_{c,i} \approx 2000\text{ Hz}$, $f_{c,v} \approx 200\text{ Hz}$)—the inner loop absorbs inductor dynamics, simplifying the complex second-order $LC$ system into a highly stable first-order system to the outer loop.

---

## 📂 Repository Structure

```
Cascade Buck Converter/
├── index.html                 # Interactive Web UI Studio
├── styles.css                 # Web UI Stylesheet (Red, Black, White Theme)
├── app.js                     # Real-Time Browser Simulation Engine & Canvas Graphs
├── README.md                  # Comprehensive Project Guide & Setup Manual
├── simulation/
│   ├── plant_model.py         # Python Numerical Modeling & Simulation Script
│   ├── simulation_results.csv # Exported Time-Domain Simulation Dataset
│   └── simulation_results.svg # Generated Visual SVG Waveform Plot
└── firmware/
    ├── cascade_control.h      # Hardware-Independent C Control Header
    ├── cascade_control.c      # Dual-Loop PI Control & Anti-Windup Core
    └── main_arduino.ino       # Arduino Uno Timer 1 Fast PWM & 10 kHz ISR Sketch
```

---

## 🚀 How to Run

### 1. Interactive Web UI Studio (Browser Simulation)
No installation required. You can launch the interactive simulation dashboard in two ways:

- **Method A (Local Web Server - Recommended)**:
  ```bash
  python -m http.server 8000
  ```
  Open your web browser and navigate to **`http://localhost:8000`**.

- **Method B (Direct File)**:
  Double-click `index.html` to open it directly in any modern browser.

**Web App Features:**
- Adjust $V_{in}$, $V_{ref}$, safety limit $I_{ref\_max}$, $R_{load}$, $L$, $C$, and PI gains ($K_{p,v}, K_{i,v}, K_{p,i}, K_{i,i}$) with real-time slider updates.
- One-click test triggers: **Soft-Start Ramp**, **Step Load ($10\Omega \rightarrow 3.3\Omega$)**, and **Short Circuit ($1.0\Omega$)**.
- Dynamic real-time HTML5 Canvas plotting of $V_{out}$, $I_L$, $I_{ref}$, and PWM Duty Cycle.

---

### 2. Python Plant Simulation (`simulation/plant_model.py`)
Run the mathematical model and discrete-time simulation in Python:

```bash
python simulation/plant_model.py
```

**Expected Output:**
```text
==================================================
=== CASCADE CONTROL GAIN DERIVATION (STAGE 1) ===
==================================================
Inner Current Loop (10 kHz Sampling):
  Target Crossover Bandwidth f_ci = 2000.0 Hz
  Proportional Gain Kp_i         = 0.104720
  Integral Gain     Ki_i         = 22.280799

Outer Voltage Loop (1 kHz Sampling):
  Target Crossover Bandwidth f_cv = 200.0 Hz
  Proportional Gain Kp_v         = 0.590619
  Integral Gain     Ki_v         = 125.663706
==================================================

Simulation dataset exported to 'simulation/simulation_results.csv'.
Visual SVG plot saved to 'simulation/simulation_results.svg'.

--- SIMULATION METRICS & VERIFICATION ---
Startup Time to 95% Vref (4.75V): 2.68 ms
Steady-State Output Voltage (10 Ohm Load): 5.001 V (Target 5.00V)
Step Load Response (3.33 Ohm / 1.5A Demand): Vout = 4.968 V, IL = 1.495 A
Short Circuit / Overload Response (1.0 Ohm): Vout = 1.500 V, IL = 1.500 A (CLAMPED AT 1.5A!)
==================================================
```

---

### 3. Microcontroller Firmware Setup (Arduino Uno)

#### Hardware Pinout Mapping
| Arduino Pin | Hardware Component | Function |
| :--- | :--- | :--- |
| **Pin 9 (OC1A)** | MOSFET Gate Driver (IR2104 / TC4420) | 10 kHz Fast PWM Output (1600 steps resolution) |
| **Pin A0** | Resistor Voltage Divider ($R_1=10\text{k}\Omega, R_2=4.7\text{k}\Omega$) | Output Voltage Sensing ($V_{out}$) |
| **Pin A1** | ACS712-05B Sensor or Low-Side $0.1\Omega$ Shunt + Op-Amp | Inductor Current Sensing ($I_L$) |

#### Timer 1 Register Setup (10 kHz ISR)
The Arduino firmware configures Timer 1 for 10 kHz Fast PWM Mode (Mode 14, TOP = `ICR1 = 1599`):
```c
ICR1   = 1599; // 10 kHz PWM TOP (16 MHz / 10 kHz - 1)
TCCR1A = _BV(COM1A1) | _BV(WGM11); // Fast PWM Mode 14
TCCR1B = _BV(WGM13) | _BV(WGM12) | _BV(CS10); // Prescaler = 1
TIMSK1 = _BV(OCIE1A); // Enable 10 kHz COMPA Interrupt ISR
```

#### Steps to Flash Firmware:
1. Open Arduino IDE.
2. Open `firmware/main_arduino.ino`.
3. Ensure `cascade_control.h` and `cascade_control.c` are in the same folder.
4. Select Board: **Arduino Uno**, Port: your COM port.
5. Click **Upload**.
6. Open Serial Monitor at **115200 baud** to view real-time telemetry.

---

## 🛠️ Stage-by-Stage Implementation Path

### Stage 1: System Modeling & Frequency Analysis (~10 Hours)
- **Control-to-Current Transfer Function**: $G_{id}(s) \approx \frac{V_{in}}{sL}$
- **Current-to-Voltage Transfer Function**: $G_{vi}(s) \approx \frac{1}{sC}$
- **Inner Loop Tuning ($f_{c,i} = 2000\text{ Hz}$)**: $K_{p,i} = \mathbf{0.104720}$, $K_{i,i} = \mathbf{22.2808}$
- **Outer Loop Tuning ($f_{c,v} = 200\text{ Hz}$)**: $K_{p,v} = \mathbf{0.590619}$, $K_{i,v} = \mathbf{125.6637}$

### Stage 2: Hardware Assembly (~15 Hours)
- **Power Stage**: N-channel MOSFET (IRF540N), Schottky Diode (1N5822), $100\,\mu\text{H}$ Inductor, $470\,\mu\text{F}$ Capacitor.
- **Gate Drive & Sensing**: Dedicated gate driver IC (IR2104 / TC4420), voltage divider for $V_{out}$ sensing, current sensor (ACS712-05B).
- **Open-Loop Test**: Verify that 30% duty cycle generates ~3.6V before enabling closed loop.

### Stage 3: Microcontroller Firmware (~15 Hours)
- Program Timer 1 for 10 kHz Fast PWM and 10 kHz COMPA interrupt.
- Execute 10 kHz inner loop and 1 kHz outer loop inside ISR with anti-windup clamping and soft-start ramping.

### Stage 4: Testing & Demo (~10 Hours)
- **Static Regulation**: Verify $V_{out} = 5.00\text{V} \pm 0.05\text{V}$ under steady load.
- **Step Load Transient**: Step load from $10\,\Omega$ to $3.33\,\Omega$ ($1.5\text{A}$ demand) and observe fast recovery.
- **Short Circuit Protection**: Drop load to $1.0\,\Omega$ and show $I_L$ smoothly clamped at $1.50\text{A}$ without component failure.

---

## 📜 License & Credits

Developed for 2nd-Year Control Systems Engineering curriculum. Open source under MIT License.
