# Cascade (Dual-Loop) Voltage-Current Controlled Buck Converter

A comprehensive hardware, simulation, and control systems design project implementing deterministic discrete-time dual-loop cascade control with soft-clamped overcurrent protection for a DC-DC Buck Converter (12V to 5V, 1.5A Maximum Current Limit).

---

## 1. System Overview and Control Architecture

A DC-DC Buck Converter steps down a higher DC input voltage ($V_{in} = 12\text{ V}$) to a regulated DC output voltage ($V_{out} = 5\text{ V}$) across a variable resistive load. While traditional single-loop voltage mode control relies solely on output voltage feedback, it exhibits slow transient response and lacks inherent current protection against short-circuit faults.

This design implements a **Cascade (Dual-Loop) Control Architecture** with frequency-separated nested feedback loops:

```
[ V_ref ] ---> [ Outer Voltage PI Loop ] ---> [ Soft-Clamp Saturation ] ---> [ Inner Current PI Loop ] ---> [ PWM Generator ] ---> [ Buck Converter Plant ]
                     (1 kHz / 1 ms)                 (Max I_ref = 1.5A)             (10 kHz / 100 us)              (10 kHz)                 (L, C, Load)
                            ^                                                              ^                                                     |
                            |                                                              |                                                     |
                            +----------------- Voltage Feedback (V_out) -------------------+---------------- Inductor Current Feedback (I_L) ----+
```

### Control Loop Hierarchy
1. **Outer Voltage Loop (1 kHz / 1 ms):**
   - Regulates output voltage $V_{out}$ against target reference $V_{ref} = 5.0\text{ V}$.
   - Computes the required inductor current reference $I_{ref}$.
   - Implements anti-windup clamping and a hard software current ceiling ($I_{ref} \le 1.5\text{ A}$).

2. **Inner Current Loop (10 kHz / 100 us):**
   - Regulates instantaneous inductor current $I_L$ to track $I_{ref}$.
   - Directly calculates the required PWM duty cycle $D$ with a feedforward compensation term ($V_{out} / V_{in}$).
   - Operating at 10 times the outer loop bandwidth, it rejects line and load disturbances before they affect the output voltage.

---

## 2. Mathematical Modeling and PI Tuning

### Small-Signal Plant Transfer Functions
- **Control-to-Current Transfer Function:**
  $$G_{id}(s) \approx \frac{V_{in}}{s L}$$
- **Current-to-Voltage Transfer Function:**
  $$G_{vi}(s) \approx \frac{1}{s C + \frac{1}{R}}$$

### Controller Gains (10x Bandwidth Separation Rule)
- **Inner Current Loop ($f_{c,i} = 2000\text{ Hz}$, $T_s = 100\ \mu\text{s}$):**
  - Proportional Gain: $K_{p,i} = \frac{\omega_{c,i} L}{V_{in}} = 0.104720$
  - Integral Gain: $K_{i,i} = K_{p,i} \cdot \omega_{z} = 22.280799$
- **Outer Voltage Loop ($f_{c,v} = 200\text{ Hz}$, $T_s = 1\text{ ms}$):**
  - Proportional Gain: $K_{p,v} = \omega_{c,v} C = 0.590619$
  - Integral Gain: $K_{i,v} = K_{p,v} \cdot \omega_{z} = 125.663706$
  - Where $\omega_z = \frac{1}{R C} \approx 212.76\text{ rad/s}$.

---

## 3. Repository Structure

```
Cascade-Buck-Converter/
├── index.html                                        # Web-based interactive simulation studio
├── styles.css                                        # Modern dark-theme stylesheet
├── app.js                                            # Simulation engine and dynamic canvas renderer
├── README.md                                         # Project manual and technical documentation
├── Cascade (Dual-Loop) Voltage-Current Control.pptx  # Project presentation deck
├── .gitignore                                        # Git version control ignore rules
│
├── docs/                                             # Technical notes and literature review
│   ├── 10_papers_summary.md                          # Review of 10 relevant peer-reviewed papers
│   ├── papers_breakdown.md                           # Comparative table and methodology analysis
│   └── papers_deep_analysis.md                       # Quantitative benchmark of CC/CV transition
│
├── simulation/                                       # Simulation and mathematical modeling
│   ├── cascade_buck_simulink.slx                     # Simulink system model
│   ├── setup_cascade_buck_simulink.m                 # Automated MATLAB script for model creation
│   ├── simulink_guide.md                             # Step-by-step Simulink and Simscape guide
│   ├── plant_model.py                                # Python continuous/discrete simulation
│   ├── simulation_results.csv                        # Time-domain output data
│   └── simulation_results.svg                        # Vector waveform plot
│
├── firmware/                                         # Microcontroller implementation
│   ├── cascade_control.h                             # Hardware-independent C header
│   ├── cascade_control.c                             # PI controller core with anti-windup
│   └── main_arduino.ino                              # Arduino Uno Timer 1 Fast PWM and 10 kHz ISR
│
└── papers/                                           # Reference literature library (10 PDF files)
```

---

## 4. Execution and Verification Instructions

### 4.1 Interactive Web Application UI
The project includes a standalone, browser-based simulation interface that visualizes dynamic responses in real time.

- **Option A: Local Server**
  ```bash
  python -m http.server 8000
  ```
  Navigate to `http://localhost:8000` in any web browser.

- **Option B: Direct Launch**
  Open `index.html` directly in a browser.

### 4.2 MATLAB / Simulink Simulation
The script `simulation/setup_cascade_buck_simulink.m` programmatically constructs, parameterizes, and connects the complete dual-loop model in Simulink.

1. Open MATLAB.
2. In the Command Window, navigate to the `simulation` directory:
   ```matlab
   cd('simulation')
   setup_cascade_buck_simulink
   ```
3. The script opens `cascade_buck_simulink.slx`.
4. Click **Run** in Simulink to view response curves across the configured scopes:
   - `Scope_Vout_Tracking`: Output voltage versus setpoint.
   - `Scope_IL_Tracking`: Inductor current versus reference and 1.5A safety clamp.
   - `Scope_Duty_Cycle`: PWM duty cycle commands.
   - `Cascade_Master_Dashboard`: Synchronized 3-channel display.

### 4.3 Python Simulation Script
To execute the discrete mathematical ODE simulation:
```bash
python simulation/plant_model.py
```
Output results and performance metrics will be printed in the terminal, and dataset files will be updated in the `simulation/` directory.

### 4.4 Arduino Uno Hardware Setup
The firmware in `firmware/` runs deterministically on an ATmega328P (Arduino Uno) clocked at 16 MHz.

#### Pin Connections
| Arduino Pin | Connection | Function |
| :--- | :--- | :--- |
| **Pin 9 (OC1A)** | Gate Driver Input (IR2104 / TC4420) | 10 kHz Fast PWM Output (ICR1 = 1599, 1600 steps) |
| **Pin A0** | Resistor Voltage Divider ($10\text{ k}\Omega / 4.7\text{ k}\Omega$) | Output Voltage Sense ($V_{out}$) |
| **Pin A1** | Current Sensor (ACS712-05B or Shunt + Op-Amp) | Inductor Current Sense ($I_L$) |

#### Timer 1 Configuration (10 kHz ISR)
```c
ICR1   = 1599;                                 // 10 kHz TOP count at 16 MHz
TCCR1A = _BV(COM1A1) | _BV(WGM11);             // Fast PWM Mode 14
TCCR1B = _BV(WGM13) | _BV(WGM12) | _BV(CS10);  // Prescaler = 1
TIMSK1 = _BV(OCIE1A);                          // Enable 10 kHz COMPA Interrupt ISR
```

---

## 5. Performance Verification Benchmarks

| Metric | Proposed Soft-Clamped Cascade | Traditional Mode-Switching |
| :--- | :--- | :--- |
| **Settling Time (0 to 95% $V_{ref}$)** | 2.68 ms | 14.5 ms |
| **Steady-State Voltage Error** | < 0.02 V | < 0.05 V |
| **Step-Load Recovery ($10\ \Omega \rightarrow 3.33\ \Omega$)** | < 2.0 ms (70 mV drop) | 12.0 ms (450 mV drop) |
| **Short-Circuit Inductor Current** | Clamped at 1.500 A | Unbounded / Relay Tripped |
| **CC-to-CV Handover Current Spike** | 0.00 A (Bumpless) | +1.85 A (3.35 A Peak Surge) |

---

## 6. Academic References

1. N. Prameswari, A. B. Ganesen, F. K. Nuraziz, J. Furqani, A. Rizqiawan, and P. A. Dahono, "Simplified cascade multiphase DC-DC buck power converter for low voltage large current applications: part II --- output current controller," *Int. J. Power Electron. Drive Syst. (IJPEDS)*, vol. 12, no. 4, pp. 2273–2283, Dec. 2021, doi: 10.11591/ijpeds.v12.i4.pp2273-2283.
2. G. I. Hasyim, S. Wijanarko, J. Furqani, A. Rizqiawan, and P. A. Dahono, "A current control method for bidirectional multiphase DC-DC boost-buck converter," *Int. J. Electr. Comput. Eng. (IJECE)*, vol. 12, no. 3, pp. 2363–2377, Jun. 2022, doi: 10.11591/ijece.v12i3.pp2363-2377.
3. M. F. Akhtar, S. R. S. Raihan, N. A. Rahim, and M. K. Rahmat, "A Cascaded Synchronous Buck Converter for Light Electric Vehicle Charging Applications," *Int. J. Integr. Eng. (IJIE)*, vol. 16, no. 7, pp. 72–82, 2024, doi: 10.30880/ijie.2024.16.07.008.
4. S. A. Tali, F. Ahmad, and I. H. Wani, "Design and Analysis of Feedback Control for DC-DC Buck Converter," in *New Frontiers in Communication and Intelligent Systems*, R. Srivastava and A. K. S. Pundir, Eds. India: Computing & Intelligent Systems, SCRS, 2021, pp. 319–328, doi: 10.52458/978-81-95502-00-4-33.
5. H. Patel and A. Shah, "Boundary-Based PWM Control Scheme for a DC-DC Buck Converter Operating in CCM," *Trans. Energy Syst. Eng. Appl. (TESEA)*, vol. 4, no. 1, Art. no. 504, pp. 1–17, Apr. 2023, doi: 10.32397/tesea.vol4.n1.504.
6. J.-B. Jeong, C.-G. Kim, J.-I. Kang, and S.-K. Han, "Two Independent Single-Loop Voltage Mode Control Method for 3-Level Buck Converter," *IEEE Access*, vol. 12, pp. 148113–148123, Oct. 2024, doi: 10.1109/ACCESS.2024.3476409.
7. D. Angulo-Garcia, F. Angulo, G. Osorio, and G. Olivar, "Control of a DC-DC Buck Converter through Contraction Techniques," *Energies*, vol. 11, no. 11, Art. no. 3086, Nov. 2018, doi: 10.3390/en11113086.
8. M. Gierczyński, L. M. Grzesiak, and A. Kaszewski, "Cascaded Voltage and Current Control for a Dual Active Bridge Converter with Current Filters," *Energies*, vol. 14, no. 19, Art. no. 6214, Sep. 2021, doi: 10.3390/en14196214.
9. S. B. Hamed, M. B. Hamed, and L. Sbita, "Robust Voltage Control of a Buck DC-DC Converter: A Sliding Mode Approach," *Energies*, vol. 15, no. 17, Art. no. 6128, Aug. 2022, doi: 10.3390/en15176128.
10. L. Xie, D. Wan, and R. Qin, "Dual-Loop Voltage–Current Control of a Fractional-Order Buck-Boost Converter Using a Fractional-Order PI^\lambda Controller," *Fractal Fract.*, vol. 7, no. 3, Art. no. 256, Mar. 2023, doi: 10.3390/fractalfract7030256.

---

## 7. License

This project is licensed under the MIT License - see the LICENSE file for details.
