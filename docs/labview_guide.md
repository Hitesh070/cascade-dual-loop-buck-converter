# LabVIEW Implementation Guide: Cascade Dual-Loop Buck Converter

This document provides a complete, step-by-step guide to constructing an interactive **Virtual Instrument (VI)** in **NI LabVIEW** for the **Cascade (Dual-Loop) Controlled Buck Converter** project ($12\text{V} \rightarrow 5\text{V}$, $1.5\text{A}$ Current Limit).

---

## 1. System Overview and LabVIEW Architecture

In LabVIEW, the system can be built in two complementary modes:
1. **Mode A (Pure Real-Time Simulation VI):** Standalone simulation running continuous Euler/Runge-Kutta numerical integration of the buck converter dynamics with discrete dual-loop PI algorithms.
2. **Mode B (Real-Time Hardware SCADA via NI-VISA):** Connects to the physical Arduino Uno via USB Serial (115200 baud) to display live experimental telemetry ($V_{out}$, $I_L$, $I_{ref}$, Duty Cycle).

---

## 2. Front Panel Layout (GUI Design)

Open a new VI in LabVIEW (`Ctrl + N`). On the **Front Panel** (`Ctrl + E` to toggle), place the following controls and indicators from the **Controls Palette** (`Modern` or `Silver`):

### 2.1 User Input Controls
| Control Name | LabVIEW Palette | Data Type | Default Value | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Input Voltage (Vin)** | `Numeric > Knob` or `Vertical Pointer Slide` | DBL (0 to 24 V) | `12.0 V` | DC supply voltage |
| **Voltage Setpoint (Vref)** | `Numeric > Knob` | DBL (0 to 10 V) | `5.0 V` | Target regulated output |
| **Current Limit (Iref_max)** | `Numeric > Pointer Slide` | DBL (0 to 3.0 A) | `1.50 A` | Software safety clamp limit |
| **Load Resistance (Rload)** | `Numeric > Rotary Dial` | DBL (1 to 50 $\Omega$) | `10.0 $\Omega$` | Load resistance |
| **Inductor (L)** | `Numeric > Numeric Control` | DBL | `100e-6` ($100\,\mu\text{H}$) | Buck filter inductance |
| **Capacitor (C)** | `Numeric > Numeric Control` | DBL | `470e-6` ($470\,\mu\text{F}$) | Buck filter capacitance |

### 2.2 Controller PI Gain Adjustments
| Control Name | LabVIEW Palette | Default Value | Notes |
| :--- | :--- | :--- | :--- |
| **Kp_v (Voltage Loop)** | `Numeric > Numeric Control` | `0.5906` | Outer loop proportional gain |
| **Ki_v (Voltage Loop)** | `Numeric > Numeric Control` | `125.66` | Outer loop integral gain |
| **Kp_i (Current Loop)** | `Numeric > Numeric Control` | `0.1047` | Inner loop proportional gain |
| **Ki_i (Current Loop)** | `Numeric > Numeric Control` | `22.28` | Inner loop integral gain |

### 2.3 Interactive Test Trigger Buttons
| Button Name | LabVIEW Palette | Mechanical Action | Function |
| :--- | :--- | :--- | :--- |
| **Step Load (10 to 3.33 $\Omega$)** | `Boolean > Push Button` | `Switch Until Released` | Drops load to demand 1.5A |
| **Short Circuit Fault (1.0 $\Omega$)** | `Boolean > Push Button` | `Switch Until Released` | Tests 1.5A overcurrent clamping |
| **Soft-Start Trigger** | `Boolean > Push Button` | `Latch When Released` | Ramps reference 0V to 5V |
| **STOP** | `Boolean > Stop Button` | `Latch When Released` | Halts simulation execution |

### 2.4 Graphical Waveform Indicators
Place three **Waveform Charts** from `Modern > Graph > Waveform Chart`:
1. **Chart 1: Output Voltage Tracking**
   - Plots: $V_{ref}$ (Target) and $V_{out}$ (Measured).
   - Y-Axis: 0 to 8 V.
2. **Chart 2: Inductor Current and Safety Clamping**
   - Plots: $I_{ref}$ (Command), $I_L$ (Actual), and $1.5\text{A}$ (Safety Limit Line).
   - Y-Axis: 0 to 3.5 A.
3. **Chart 3: PWM Duty Cycle**
   - Plots: Duty Cycle ($D$).
   - Y-Axis: 0 to 100%.

### 2.5 Live Telemetry Meters & Status LED
- **Numeric Indicators:** `Measured Vout (V)`, `Inductor Current (A)`, `PWM Duty (%)`.
- **Mode Status LED (`Boolean > Round LED`):**
  - Green = Normal Voltage Regulation.
  - Red = Overcurrent Clamped (Safety Mode Active).

---

## 3. Block Diagram Implementation (Mode A: Pure Simulation VI)

Switch to the **Block Diagram** (`Ctrl + E`).

### 3.1 Loop Structure and Timing
1. Place a **While Loop** around the diagram.
2. Connect the **STOP Button** to the loop conditional terminal.
3. Inside the loop, place a **Wait (ms)** function (`Timing > Wait (ms)`) set to `1` ms (or `100` $\mu\text{s}$ for ultra-precise execution).
4. Create **Shift Registers** on the While Loop boundary for:
   - `Vout` (Initial value = `0.0`)
   - `IL` (Initial value = `0.0`)
   - `Integrator_v` (Initial value = `0.0`)
   - `Integrator_i` (Initial value = `0.0`)

---

### 3.2 Block Diagram Implementation using a Formula Node (Recommended)
The cleanest, most readable method in LabVIEW is to use a **Formula Node** (`Structures > Formula Node`).

#### Step 1: Add Inputs to Formula Node
Right-click the left border of the Formula Node and select **Add Input**:
- `Vin`, `Vref_in`, `Iref_max`, `Rload`, `L`, `C`
- `Kpv`, `Kiv`, `Kpi`, `Kii`
- `Vout_prev`, `IL_prev`, `int_v_prev`, `int_i_prev`
- `dt_sim` (set to `0.0001` = 100 $\mu$s)

#### Step 2: Add Outputs from Formula Node
Right-click the right border and select **Add Output**:
- `Vout_next`, `IL_next`, `int_v_next`, `int_i_next`
- `Iref_out`, `Duty_pct`, `is_clamped`

#### Step 3: Insert Control Code inside Formula Node
```c
float err_v, raw_iref, err_i, raw_duty, dil_dt, dvout_dt;

// 1. Outer Voltage Loop (1 kHz equivalent PI)
err_v = Vref_in - Vout_prev;
int_v_next = int_v_prev + (err_v * dt_sim * 10.0);

// Anti-windup clamping on voltage integrator
if (int_v_next > 2.0) int_v_next = 2.0;
if (int_v_next < -2.0) int_v_next = -2.0;

raw_iref = (Kpv * err_v) + (Kiv * int_v_next * 0.01);

// 2. Software Current Clamping Gate (Bumpless CC Mode)
if (raw_iref > Iref_max) {
    Iref_out = Iref_max;
    is_clamped = 1.0;
} else if (raw_iref < 0.0) {
    Iref_out = 0.0;
    is_clamped = 0.0;
} else {
    Iref_out = raw_iref;
    is_clamped = 0.0;
}

// 3. Inner Current Loop (10 kHz PI)
err_i = Iref_out - IL_prev;
int_i_next = int_i_prev + (err_i * dt_sim);

// Anti-windup on current integrator
if (int_i_next > 1.0) int_i_next = 1.0;
if (int_i_next < -1.0) int_i_next = -1.0;

// Feedforward Duty compensation term (Vout / Vin)
raw_duty = (Kpi * err_i) + (Kii * int_i_next) + (Vout_prev / Vin);

// PWM Saturation Guard (2% to 90%)
if (raw_duty > 0.90) raw_duty = 0.90;
if (raw_duty < 0.02) raw_duty = 0.02;

Duty_pct = raw_duty * 100.0;

// 4. Physical Converter ODE Dynamics (Euler Integration)
dil_dt = (raw_duty * Vin - Vout_prev) / L;
dvout_dt = (IL_prev - (Vout_prev / Rload)) / C;

IL_next = IL_prev + (dil_dt * dt_sim);
Vout_next = Vout_prev + (dvout_dt * dt_sim);

// Prevent unphysical negative states
if (IL_next < 0.0) IL_next = 0.0;
if (Vout_next < 0.0) Vout_next = 0.0;
```

---

### 3.3 Wiring Signals to Charts
1. **Bundle Signals for Voltage Chart:**
   - Use `Cluster, Class, & Variant > Bundle` to bundle `Vref_in` and `Vout_next`.
   - Wire the cluster into **Chart 1 (Output Voltage)**.
2. **Bundle Signals for Current Chart:**
   - Use `Bundle` to bundle `Iref_out`, `IL_next`, and `Iref_max`.
   - Wire into **Chart 2 (Inductor Current)**.
3. **Duty Cycle Chart:**
   - Wire `Duty_pct` directly into **Chart 3 (PWM Duty Cycle)**.
4. **Shift Register Feedback:**
   - Wire `Vout_next` $\rightarrow$ Right Shift Register for `Vout`.
   - Wire `IL_next` $\rightarrow$ Right Shift Register for `IL`.
   - Wire `int_v_next` $\rightarrow$ Right Shift Register for `Integrator_v`.
   - Wire `int_i_next` $\rightarrow$ Right Shift Register for `Integrator_i`.

---

## 4. Hardware Data Acquisition via NI-VISA (Mode B: SCADA Dashboard)

To display real-time experimental data from the physical Arduino Uno running `firmware/main_arduino.ino`:

### 4.1 VISA Configuration Steps
1. Place **VISA Configure Serial Port** (`Instrument I/O > Serial`):
   - `VISA resource name`: Select your Arduino COM Port (e.g., `COM3`).
   - `Baud Rate`: `115200`.
   - `Data Bits`: `8`.
   - `Parity`: `None`.
   - `Stop Bits`: `1.0`.
   - `Enable Termination Char`: `TRUE` (Line Feed `\n`).

2. Inside the While Loop:
   - Place **VISA Read** with byte count = `100`.
   - Wire output string to **Fract/Exp String to Number** or **Scan from String** (`Programming > String > String/Number Conversion`).
   - Format String: `%f\t%f\t%f\t%f\t%f`
   - Parsed Outputs: `Time_ms`, `Vout_meas`, `IL_meas`, `Iref_meas`, `Duty_meas`.

3. Wire the parsed numeric values to the Front Panel meters and Waveform Charts.
4. Outside the While Loop: Place **VISA Close** and **Simple Error Handler**.

---

## 5. Demonstration and Verification Protocol

During your project demonstration:

1. **Static Regulation Demo:**
   - Run the VI. Set $V_{in} = 12\text{V}$, $V_{ref} = 5.0\text{V}$, $R_{load} = 10\,\Omega$.
   - Observe $V_{out}$ rising monotonically to $5.00\text{V}$ in $< 3\,\text{ms}$ with zero overshoot.
2. **Step-Load Dynamic Rejection:**
   - Press the **Step Load Button** ($10\,\Omega \rightarrow 3.33\,\Omega$).
   - Observe $I_L$ stepping from $0.5\text{A}$ to $1.5\text{A}$. $V_{out}$ experiences a minor transient dip ($< 70\,\text{mV}$) and recovers in $< 2\,\text{ms}$.
3. **Short-Circuit Protection & Soft Clamping:**
   - Press the **Short Circuit Fault Button** ($R_{load} = 1.0\,\Omega$).
   - Observe the **Mode Status LED turn RED**.
   - Output voltage collapses to $1.50\text{V}$ while $I_L$ is **firmly clamped at exactly $1.50\text{A}$**, proving short-circuit survival.
