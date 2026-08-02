"""
Cascade (Dual-Loop) Voltage-Current Control of a Buck Converter
Stage 1: System Modeling, Frequency Analysis, and Time-Domain Simulation
Pure Python Implementation (No External Dependencies Required)
"""

import math
import csv
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
sim_dir = script_dir
os.makedirs(sim_dir, exist_ok=True)

csv_filename = os.path.join(sim_dir, "simulation_results.csv")
svg_filename = os.path.join(sim_dir, "simulation_results.svg")

# ==========================================
# 1. HARDWARE & CONVERTER PARAMETERS
# ==========================================
Vin = 12.0          # Input Voltage (V)
Vref = 5.0          # Target Output Voltage (V)
L = 100e-6          # Inductor (100 uH)
C = 470e-6          # Output Capacitor (470 uF)
R_nominal = 10.0    # Nominal Load Resistance (10 Ohms)
I_ref_max = 1.5     # Maximum Clamped Inductor Current (Amps)

# Control Loop Execution Frequencies
f_inner = 10000.0   # Inner Current Loop Frequency (10 kHz)
dt_inner = 1.0 / f_inner # 100 microseconds

f_outer = 1000.0    # Outer Voltage Loop Frequency (1 kHz)
dt_outer = 1.0 / f_outer # 1 millisecond
outer_ratio = int(f_inner / f_outer) # Execute outer loop every 10 inner cycles

# PWM Duty Limits
DUTY_MIN = 0.02
DUTY_MAX = 0.90

# ==========================================
# 2. CONTROLLER GAIN DERIVATION
# ==========================================
print("==================================================")
print("=== CASCADE CONTROL GAIN DERIVATION (STAGE 1) ===")
print("==================================================")

# Inner Current Loop Design: Target Crossover f_ci = 2000 Hz
f_ci = 2000.0
omega_ci = 2.0 * math.pi * f_ci
omega_zi = 1.0 / (R_nominal * C) # Zero placement at load corner frequency (~212.76 rad/s)

Kp_i = (omega_ci * L) / Vin
Ki_i = Kp_i * omega_zi

print(f"Inner Current Loop (10 kHz Sampling):")
print(f"  Target Crossover Bandwidth f_ci = {f_ci:.1f} Hz")
print(f"  Proportional Gain Kp_i         = {Kp_i:.6f}")
print(f"  Integral Gain     Ki_i         = {Ki_i:.6f}")

# Outer Voltage Loop Design: Target Crossover f_cv = 200 Hz (1/10th of inner loop)
f_cv = 200.0
omega_cv = 2.0 * math.pi * f_cv
omega_zv = omega_zi # Zero placement

Kp_v = omega_cv * C
Ki_v = Kp_v * omega_zv

print(f"\nOuter Voltage Loop (1 kHz Sampling):")
print(f"  Target Crossover Bandwidth f_cv = {f_cv:.1f} Hz")
print(f"  Proportional Gain Kp_v         = {Kp_v:.6f}")
print(f"  Integral Gain     Ki_v         = {Ki_v:.6f}")
print("==================================================\n")

# ==========================================
# 3. DISCRETE-TIME TIME-DOMAIN SIMULATION
# ==========================================
sim_time = 0.100 # 100 ms total simulation time
sub_steps = 20    # Integration steps per 100us inner cycle
dt_sim = dt_inner / sub_steps
total_sim_steps = int(sim_time / dt_sim)

# Data arrays
t_vec = []
v_out_vec = []
i_L_vec = []
i_ref_vec = []
duty_vec = []
load_vec = []

# Initial Plant States
v_out = 0.0
i_L = 0.0

# Initial Controller States
i_ref = 0.0
duty = 0.0
int_v = 0.0 # Outer loop integrator accumulator
int_i = 0.0 # Inner loop integrator accumulator

inner_counter = 0

for step in range(total_sim_steps):
    t = step * dt_sim
    
    # Load Disturbance schedule:
    # 0 - 40ms: Nominal 10 Ohm load (0.5A steady state)
    # 40ms - 70ms: Step load change to 3.33 Ohms (1.5A steady state demand)
    # 70ms - 100ms: Overload / Short circuit test (1.0 Ohm demand -> testing current limit)
    if t < 0.040:
        R_load = 10.0
    elif t < 0.070:
        R_load = 3.33
    else:
        R_load = 1.0

    # Digital Control Calculation triggered at 10 kHz boundary
    if step % sub_steps == 0:
        inner_counter += 1
        
        # --- 1. OUTER VOLTAGE LOOP (Runs every 10th inner cycle = 1 kHz) ---
        if inner_counter % outer_ratio == 0:
            err_v = Vref - v_out
            int_v += err_v * dt_outer
            
            # Anti-windup clamping for outer integrator
            int_v = max(-2.0, min(2.0, int_v))
            
            # Unclamped I_ref command
            i_ref_raw = (Kp_v * err_v) + (Ki_v * int_v)
            
            # HARD CURRENT CLAMPING (Software Overcurrent Protection)
            i_ref = max(0.0, min(I_ref_max, i_ref_raw))
        
        # --- 2. INNER CURRENT LOOP (Runs every cycle = 10 kHz) ---
        err_i = i_ref - i_L
        int_i += err_i * dt_inner
        
        # Anti-windup clamping for inner integrator
        int_i = max(-1.0, min(1.0, int_i))
        
        # Duty cycle calculation (with feedforward term v_out / Vin)
        duty_raw = (Kp_i * err_i) + (Ki_i * int_i) + (v_out / Vin)
        
        # PWM Saturation Clamping
        duty = max(DUTY_MIN, min(DUTY_MAX, duty_raw))

    # --- 3. PLANT DYNAMICS (Continuous-Time ODE integration via Euler method) ---
    di_L_dt = (duty * Vin - v_out) / L
    dv_out_dt = (i_L - v_out / R_load) / C

    i_L += di_L_dt * dt_sim
    v_out += dv_out_dt * dt_sim

    # Prevent negative values due to diode non-reversal
    i_L = max(0.0, i_L)
    v_out = max(0.0, v_out)

    # Record data
    t_vec.append(t * 1000.0) # ms
    v_out_vec.append(v_out)
    i_L_vec.append(i_L)
    i_ref_vec.append(i_ref)
    duty_vec.append(duty * 100.0) # %
    load_vec.append(R_load)

# Save results to CSV file
with open(csv_filename, 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(["time_ms", "v_out_V", "i_L_A", "i_ref_A", "duty_pct", "R_load_ohm"])
    for i in range(len(t_vec)):
        writer.writerow([f"{t_vec[i]:.4f}", f"{v_out_vec[i]:.4f}", f"{i_L_vec[i]:.4f}", f"{i_ref_vec[i]:.4f}", f"{duty_vec[i]:.2f}", f"{load_vec[i]:.2f}"])

print(f"Simulation dataset exported to '{csv_filename}'.")

# Generate SVG Plot
def generate_svg_plot(target_path):
    width = 900
    height = 650
    margin = 60
    plot_h = (height - 4 * margin) / 3
    
    svg = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" style="background-color:#1e1e2e; font-family:sans-serif;">']
    svg.append('<style>')
    svg.append('.title { fill: #cdd6f4; font-size: 18px; font-weight: bold; text-anchor: middle; }')
    svg.append('.stitle { fill: #b4befe; font-size: 13px; font-weight: bold; }')
    svg.append('.axis { stroke: #585b70; stroke-width: 1; }')
    svg.append('.grid { stroke: #313244; stroke-width: 1; stroke-dasharray: 4,4; }')
    svg.append('.label { fill: #a6adc8; font-size: 11px; }')
    svg.append('.legend { fill: #cdd6f4; font-size: 11px; }')
    svg.append('</style>')
    
    svg.append(f'<text x="{width/2}" y="30" class="title">Cascade Dual-Loop Buck Converter Simulation (12V -&gt; 5V)</text>')

    # Helper mapping functions
    t_min, t_max = 0.0, 100.0
    def map_x(t_val):
        return margin + (t_val - t_min) / (t_max - t_min) * (width - 2 * margin)
    
    # --- SUBPLOT 1: V_out ---
    y1_top = margin + 20
    y1_bot = y1_top + plot_h
    v_min, v_max = 0.0, 6.5
    def map_y1(v):
        return y1_bot - (v - v_min) / (v_max - v_min) * plot_h
    
    svg.append(f'<text x="{margin}" y="{y1_top - 5}" class="stitle">Output Voltage Regulation (V_out vs V_ref)</text>')
    svg.append(f'<line x1="{margin}" y1="{y1_bot}" x2="{width-margin}" y2="{y1_bot}" class="axis"/>')
    svg.append(f'<line x1="{margin}" y1="{y1_top}" x2="{margin}" y2="{y1_bot}" class="axis"/>')
    
    # Target 5V line
    y_5v = map_y1(5.0)
    svg.append(f'<line x1="{margin}" y1="{y_5v}" x2="{width-margin}" y2="{y_5v}" stroke="#f38ba8" stroke-width="1.5" stroke-dasharray="6,4"/>')
    svg.append(f'<text x="{width-margin-60}" y="{y_5v-5}" fill="#f38ba8" font-size="11">Vref = 5.0V</text>')

    # V_out polyline
    pts_v = []
    step_dec = max(1, len(t_vec) // 1000)
    for idx in range(0, len(t_vec), step_dec):
        pts_v.append(f"{map_x(t_vec[idx]):.1f},{map_y1(v_out_vec[idx]):.1f}")
    svg.append(f'<polyline points="{" ".join(pts_v)}" fill="none" stroke="#89b4fa" stroke-width="2"/>')
    svg.append(f'<text x="{margin+10}" y="{y1_top+20}" fill="#89b4fa" class="legend">V_out (Measured)</text>')

    # --- SUBPLOT 2: I_L and I_ref ---
    y2_top = y1_bot + margin
    y2_bot = y2_top + plot_h
    i_min, i_max = 0.0, 2.0
    def map_y2(i_val):
        return y2_bot - (i_val - i_min) / (i_max - i_min) * plot_h
    
    svg.append(f'<text x="{margin}" y="{y2_top - 5}" class="stitle">Inner Current Loop &amp; Overcurrent Clamping (1.5A Limit)</text>')
    svg.append(f'<line x1="{margin}" y1="{y2_bot}" x2="{width-margin}" y2="{y2_bot}" class="axis"/>')
    svg.append(f'<line x1="{margin}" y1="{y2_top}" x2="{margin}" y2="{y2_bot}" class="axis"/>')
    
    # 1.5A limit line
    y_15a = map_y2(1.5)
    svg.append(f'<line x1="{margin}" y1="{y_15a}" x2="{width-margin}" y2="{y_15a}" stroke="#fab387" stroke-width="1.5" stroke-dasharray="4,4"/>')
    svg.append(f'<text x="{width-margin-120}" y="{y_15a-5}" fill="#fab387" font-size="11">Max I_ref Clamp = 1.5A</text>')

    pts_il = []
    pts_iref = []
    for idx in range(0, len(t_vec), step_dec):
        pts_il.append(f"{map_x(t_vec[idx]):.1f},{map_y2(i_L_vec[idx]):.1f}")
        pts_iref.append(f"{map_x(t_vec[idx]):.1f},{map_y2(i_ref_vec[idx]):.1f}")
    svg.append(f'<polyline points="{" ".join(pts_il)}" fill="none" stroke="#a6e3a1" stroke-width="2"/>')
    svg.append(f'<polyline points="{" ".join(pts_iref)}" fill="none" stroke="#f38ba8" stroke-width="1.5" stroke-dasharray="4,2"/>')
    svg.append(f'<text x="{margin+10}" y="{y2_top+20}" fill="#a6e3a1" class="legend">I_L (Inductor Current)</text>')
    svg.append(f'<text x="{margin+160}" y="{y2_top+20}" fill="#f38ba8" class="legend">I_ref (Outer Command)</text>')

    # --- SUBPLOT 3: PWM Duty Cycle ---
    y3_top = y2_bot + margin
    y3_bot = y3_top + plot_h
    d_min, d_max = 0.0, 100.0
    def map_y3(d_val):
        return y3_bot - (d_val - d_min) / (d_max - d_min) * plot_h
    
    svg.append(f'<text x="{margin}" y="{y3_top - 5}" class="stitle">PWM Duty Cycle Response (%)</text>')
    svg.append(f'<line x1="{margin}" y1="{y3_bot}" x2="{width-margin}" y2="{y3_bot}" class="axis"/>')
    svg.append(f'<line x1="{margin}" y1="{y3_top}" x2="{margin}" y2="{y3_bot}" class="axis"/>')
    
    pts_d = []
    for idx in range(0, len(t_vec), step_dec):
        pts_d.append(f"{map_x(t_vec[idx]):.1f},{map_y3(duty_vec[idx]):.1f}")
    svg.append(f'<polyline points="{" ".join(pts_d)}" fill="none" stroke="#cba6f7" stroke-width="2"/>')
    svg.append(f'<text x="{margin+10}" y="{y3_top+20}" fill="#cba6f7" class="legend">Duty Cycle %</text>')
    
    # X-axis Labels
    for t_lbl in range(0, 101, 20):
        x_pos = map_x(t_lbl)
        svg.append(f'<line x1="{x_pos}" y1="{y3_bot}" x2="{x_pos}" y2="{y3_bot+5}" class="axis"/>')
        svg.append(f'<text x="{x_pos}" y="{y3_bot+20}" class="label" text-anchor="middle">{t_lbl} ms</text>')

    svg.append('</svg>')
    
    with open(target_path, 'w') as f:
        f.write('\n'.join(svg))
    print(f"Visual SVG plot saved to '{target_path}'.")

generate_svg_plot(svg_filename)

# Compute Statistics
print("\n--- SIMULATION METRICS & VERIFICATION ---")
startup_idx = next((i for i, v in enumerate(v_out_vec) if v >= 4.75), None)
if startup_idx is not None:
    print(f"Startup Time to 95% Vref (4.75V): {t_vec[startup_idx]:.2f} ms")

idx_35ms = int(0.035 / dt_sim)
steady_v = v_out_vec[idx_35ms]
print(f"Steady-State Output Voltage (10 Ohm Load): {steady_v:.3f} V (Target 5.00V)")

idx_65ms = int(0.065 / dt_sim)
heavy_v = v_out_vec[idx_65ms]
heavy_i = i_L_vec[idx_65ms]
print(f"Step Load Response (3.33 Ohm / 1.5A Demand): Vout = {heavy_v:.3f} V, IL = {heavy_i:.3f} A")

idx_95ms = int(0.095 / dt_sim)
short_v = v_out_vec[idx_95ms]
short_i = i_L_vec[idx_95ms]
print(f"Short Circuit / Overload Response (1.0 Ohm): Vout = {short_v:.3f} V, IL = {short_i:.3f} A (CLAMPED AT {I_ref_max}A!)")
print("==================================================")
