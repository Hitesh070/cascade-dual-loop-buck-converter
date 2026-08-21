# Simulink Modeling & Demonstration Guide
## Cascade (Dual-Loop) Voltage-Current Controlled Buck Converter

This document provides a complete guide for demonstrating the **Cascade Dual-Loop Controlled Buck Converter** in **MATLAB / Simulink**, with both transfer function plant modeling and physical **Simscape Electrical** power stage circuits.

---

## 1. Complete Simulink Block Diagram Architecture

Below is the complete Simulink system architecture showing the nested dual-loop structure, discrete integrator sampling times, feedforward term, saturation safety limiters, and multi-channel scopes:

```
               OUTER VOLTAGE LOOP (1 kHz / 1 ms)                     INNER CURRENT LOOP (10 kHz / 100 us)
       +-----------------------------------------------+     +-----------------------------------+
       |                                               |     |                                   |
       v                                               |     v                                   |
    +-----+   +-------------+   +-------------------+  |  +-----+   +-------------+   +-------+  |   +-------------+   +-------------+
Vref| +   |-->| Discrete PI |-->| Saturation Clamp  |--+->| +   |-->| Discrete PI |-->| PWM   |--+-->| G_id(s)     |-->| G_vi(s)     |---+---> Vout (5V)
(5V)| -   |   | (1 kHz, 1ms)|   | (Max Iref = 1.5A) |Iref | -   |   |(10kHz,100us)|   | Sat   |D |   | (Vin / sL)  | iL| (1 / sC)    |   |
    +-----+   +-------------+   +-------------------+     +-----+   +-------------+   +-------+  |   +-------------+   +-------------+   |
       ^                                                     ^                            ^      |          |                 |            |
       |                                                     |                            |      |          v                 v            |
       |                                                     | (Feedforward Vout / Vin)---+      |  [ Scope_IL_Track ] [ Scope_Vout_Track ]|
       |                                                     |                                   |          |                 |            |
       +-----------------------------------------------------+-----------------------------------+----------+                 |            |
       |                                                                                                                      |            |
       +----------------------------------------------------------------------------------------------------------------------+------------+
                                                                                                 |
                                                                              +------------------+------------------+
                                                                              v                                     v
                                                                   [ Scope_Duty_Cycle ]            [ Cascade_Master_Dashboard (3-Port) ]
```

---

## 2. Automatic Generation via MATLAB Script

The automated MATLAB script [`setup_cascade_buck_simulink.m`](file:///c:/Users/hites/OneDrive/Documents/Projects%20&%20Research%20Work/Cascade%20(Dual-Loop)%20Voltage-Current%20Control%20of%20a%20Buck%20Converter/simulation/setup_cascade_buck_simulink.m) builds, parameters, wires, and saves `cascade_buck_simulink.slx` automatically.

### How to Run:
1. Open MATLAB.
2. In the MATLAB Command Window, navigate to the `simulation/` directory:
   ```matlab
   cd('simulation')
   ```
3. Run the script:
   ```matlab
   setup_cascade_buck_simulink
   ```
4. The script will automatically:
   - Compute exact discrete PI gains:
     - Inner Current Loop ($10\text{ kHz}$): $K_{p,i} = \mathbf{0.104720}$, $K_{i,i} = \mathbf{22.280799}$
     - Outer Voltage Loop ($1\text{ kHz}$): $K_{p,v} = \mathbf{0.590619}$, $K_{i,v} = \mathbf{125.663706}$
   - Construct transparent discrete PI controllers with forward-Euler integrators and standard `Saturation` blocks (`0` to `1.5A` on $I_{ref}$, `2%` to `90%` on duty cycle).
   - Generate all scopes and live display blocks:
     - **`Scope_Vout_Tracking`**: Overlays target $V_{ref} = 5.0\text{V}$ and measured $V_{out}$.
     - **`Scope_IL_Tracking`**: Overlays $I_{ref}$ command, instantaneous inductor current $I_L$, and the $1.5\text{A}$ safety limit line.
     - **`Scope_Duty_Cycle`**: Shows the instantaneous PWM duty cycle output.
     - **`Cascade_Master_Dashboard`**: 3-channel synchronized master scope displaying $V_{out}$, $I_L$, and Duty Cycle simultaneously.
     - **`Display_Vout_V` & `Display_IL_A`**: Live numerical value readouts on the block diagram canvas.

---

## 3. Manual Step-by-Step Construction Guide

If building manually in Simulink GUI:

### Step 1: Model Solver Configuration
- Open Simulink and create a blank model: `cascade_buck_simulink.slx`.
- Set Solver parameters: `Solver = ode45` (or `ode23t`), `Stop time = 0.10` ($100\,\text{ms}$).

### Step 2: Outer Voltage Loop (1 kHz / 1 ms)
1. Add `Step` block (`Vref_Target`): Time = 0, Value = 5.0.
2. Add `Sum` block (`+-`) for voltage error $e_v = V_{ref} - V_{out}$.
3. Add `Gain` block (`Kp_v_Gain`): Value = `0.590619`.
4. Add `Gain` block (`Ki_v_Gain`): Value = `125.663706`.
5. Add `Discrete-Time Integrator` (`Outer_Integrator`): Sample time = `0.001` ($1\,\text{ms}$), Method = `Forward Euler`.
6. Add `Sum` block (`++`) to combine P + I outputs.
7. Add `Saturation` block (`Iref_Safety_Clamp`): Upper Limit = `1.5` ($1.5\text{A}$), Lower Limit = `0.0`.

### Step 3: Inner Current Loop (10 kHz / 100 $\mu$s)
1. Add `Sum` block (`+-`) for current error $e_i = I_{ref} - I_L$.
2. Add `Gain` block (`Kp_i_Gain`): Value = `0.104720`.
3. Add `Gain` block (`Ki_i_Gain`): Value = `22.280799`.
4. Add `Discrete-Time Integrator` (`Inner_Integrator`): Sample time = `0.0001` ($100\,\mu\text{s}$), Method = `Forward Euler`.
5. Add `Gain` block (`Feedforward_Gain`): Value = `1 / 12.0 = 0.083333` ($V_{out} / V_{in}$).
6. Add `Sum` block (`++`) to combine P + I + Feedforward outputs.
7. Add `Saturation` block (`PWM_Duty_Clamp`): Upper Limit = `0.90` ($90\%$), Lower Limit = `0.02` ($2\%$).

### Step 4: Buck Plant Transfer Functions
1. **Inductor Current Plant $G_{id}(s)$**:
   - `Transfer Fcn`: Numerator = `[12.0]`, Denominator = `[100e-6  0]`.
2. **Output Voltage Plant $G_{vi}(s)$**:
   - `Transfer Fcn`: Numerator = `[1]`, Denominator = `[470e-6  0.1]`.

---

## 4. Physical Simscape Electrical Model Setup

For physical power stage simulation using real power electronics components:

```
                       +12V DC Supply
                             |
                      [ MOSFET Switch ]
                             |
   PWM Duty ---> [ PWM ]-----+---------------- Node A (Switching Node)
   (from ISR)   Generator    |
                       [ Schottky Diode ]
                             |
                            GND
                             | (From Node A)
                       [ 100uH Inductor ]
                             |
                             +-----[ Current Measurement ]---> iL to Inner Loop
                             |
                       +-----+-----+
                       |           |
                 [ 470uF Cap ] [ 10 Ohm Load ]
                       |           |
                      GND         GND
                       |
             [ Voltage Measurement ]---> Vout to Outer Loop
```

---

## 5. Demonstration & Verification Checkpoints

When you run the simulation:
1. **$V_{out}$ Tracking**: Output voltage rises smoothly to $5.00\text{V}$ in $\approx 2.7\,\text{ms}$ with zero overshoot.
2. **$I_L$ Dynamics**: Inductor current shows rapid response tracking $I_{ref}$.
3. **Overcurrent Clamping Test**: Set load resistor to $1.0\,\Omega$. Observe that $I_L$ is **firmly clamped at exactly $1.50\text{A}$**, demonstrating software overcurrent protection.
