# Cascade (Dual-Loop) Voltage-Current Controlled Buck Converter
> **2nd-Year Control Systems Engineering Project**  
> Complete Hardware, Simulation, Firmware, Simulink Models & Interactive Studio

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
├── index.html                         # Interactive Web UI Studio
├── styles.css                         # Web UI Stylesheet (Red, Black, White Theme)
├── app.js                             # Real-Time Browser Simulation Engine & Canvas Graphs
├── README.md                          # Comprehensive Project Guide & Setup Manual
├── simulation/
│   ├── plant_model.py                 # Python Numerical Modeling & Simulation Script
│   ├── setup_cascade_buck_simulink.m  # MATLAB Script to Programmatically Create Simulink Model
│   ├── simulink_guide.md              # Detailed Simulink Block Diagram & Simscape Guide
│   ├── simulation_results.csv         # Exported Time-Domain Simulation Dataset
│   └── simulation_results.svg         # Generated Visual SVG Waveform Plot
└── firmware/
    ├── cascade_control.h              # Hardware-Independent C Control Header
    ├── cascade_control.c              # Dual-Loop PI Control & Anti-Windup Core
    └── main_arduino.ino               # Arduino Uno Timer 1 Fast PWM & 10 kHz ISR Sketch
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

---

### 2. MATLAB / Simulink Demonstration
We provide an automated script [`simulation/setup_cascade_buck_simulink.m`](file:///c:/Users/hites/OneDrive/Documents/Projects%20&%20Research%20Work/Cascade%20(Dual-Loop)%20Voltage-Current%20Control%20of%20a%20Buck%20Converter/simulation/setup_cascade_buck_simulink.m) that programmatically builds and configures the complete Simulink model (`cascade_buck_simulink.slx`).

1. Open MATLAB.
2. Navigate to `simulation/` directory.
3. Run `setup_cascade_buck_simulink`.
4. MATLAB will generate the complete block diagram, configure discrete 10 kHz inner loop and 1 kHz outer loop PI controllers with 1.5A overcurrent clamping, and open the model for simulation.
5. Refer to [`simulation/simulink_guide.md`](file:///c:/Users/hites/OneDrive/Documents/Projects%20&%20Research%20Work/Cascade%20(Dual-Loop)%20Voltage-Current%20Control%20of%20a%20Buck%20Converter/simulation/simulink_guide.md) for full block-by-block and Simscape Electrical physical circuit documentation.

---

### 3. Python Plant Simulation (`simulation/plant_model.py`)
Run the mathematical model and discrete-time simulation in Python:

```bash
python simulation/plant_model.py
```

---

### 4. Microcontroller Firmware Setup (Arduino Uno)

#### Hardware Pinout Mapping
| Arduino Pin | Hardware Component | Function |
| :--- | :--- | :--- |
| **Pin 9 (OC1A)** | MOSFET Gate Driver (IR2104 / TC4420) | 10 kHz Fast PWM Output (1600 steps resolution) |
| **Pin A0** | Resistor Voltage Divider ($R_1=10\text{k}\Omega, R_2=4.7\text{k}\Omega$) | Output Voltage Sensing ($V_{out}$) |
| **Pin A1** | ACS712-05B Sensor or Low-Side $0.1\Omega$ Shunt + Op-Amp | Inductor Current Sensing ($I_L$) |

#### Timer 1 Register Setup (10 kHz ISR)
```c
ICR1   = 1599; // 10 kHz PWM TOP (16 MHz / 10 kHz - 1)
TCCR1A = _BV(COM1A1) | _BV(WGM11); // Fast PWM Mode 14
TCCR1B = _BV(WGM13) | _BV(WGM12) | _BV(CS10); // Prescaler = 1
TIMSK1 = _BV(OCIE1A); // Enable 10 kHz COMPA Interrupt ISR
```

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
