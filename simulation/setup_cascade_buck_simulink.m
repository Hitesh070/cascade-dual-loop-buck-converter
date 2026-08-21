%% =========================================================================
% CASCADE (DUAL-LOOP) VOLTAGE-CURRENT CONTROLLED BUCK CONVERTER
% MATLAB Initialization & Robust Simulink Model Generator Script
% =========================================================================
% Target Application: 2nd-Year Control Systems Project
% Hardware Parameters: Vin = 12V, Vref = 5V, L = 100uH, C = 470uF, R = 10 Ohm
% Saturation Safety Limit: Max Iref = 1.5A
% =========================================================================

clear; clc; close all;

%% 1. CONVERTER & CONTROL PARAMETERS
Vin       = 12.0;       % Nominal Input Voltage (V)
Vref      = 5.0;        % Target Output Voltage (V)
L         = 100e-6;     % Power Inductor (100 uH)
C         = 470e-6;     % Output Capacitor (470 uF)
R_nominal = 10.0;       % Nominal Load Resistance (10 Ohms)
I_ref_max = 1.5;        % Clamped Max Inductor Current Safety Limit (A)

% Control Frequencies
f_inner   = 10000.0;    % Inner Current Loop Frequency (10 kHz)
Ts_inner  = 1.0 / f_inner; % 100 microseconds

f_outer   = 1000.0;     % Outer Voltage Loop Frequency (1 kHz)
Ts_outer  = 1.0 / f_outer; % 1 millisecond

% PWM Duty Limits
Duty_min  = 0.02;       % 2% Min Duty Guard
Duty_max  = 0.90;       % 90% Max Duty Guard

%% 2. TRANSFER FUNCTIONS & PI GAIN DERIVATIONS
% Inner Current Loop Crossover: f_ci = 2000 Hz
f_ci      = 2000.0;
omega_ci  = 2.0 * pi * f_ci;
omega_zi  = 1.0 / (R_nominal * C); % Zero placement (~212.76 rad/s)

Kp_i = (omega_ci * L) / Vin;
Ki_i = Kp_i * omega_zi;

% Outer Voltage Loop Crossover: f_cv = 200 Hz
f_cv      = 200.0;
omega_cv  = 2.0 * pi * f_cv;
omega_zv  = omega_zi;

Kp_v = omega_cv * C;
Ki_v = Kp_v * omega_zv;

fprintf('====================================================\n');
fprintf(' CASCADE CONTROL SYSTEM PARAMETERS CALCULATED \n');
fprintf('====================================================\n');
fprintf('Inner Loop (10 kHz, Ts = %0.1f us):\n', Ts_inner*1e6);
fprintf('  Kp_i = %0.6f\n', Kp_i);
fprintf('  Ki_i = %0.6f\n', Ki_i);
fprintf('Outer Loop (1 kHz, Ts = %0.1f ms):\n', Ts_outer*1e3);
fprintf('  Kp_v = %0.6f\n', Kp_v);
fprintf('  Ki_v = %0.6f\n', Ki_v);
fprintf('Safety Clamping: Max Iref = %0.2f A\n', I_ref_max);
fprintf('====================================================\n\n');

%% 3. PROGRAMMATIC SIMULINK MODEL CREATION
modelName = 'cascade_buck_simulink';

% Close existing model if already loaded in memory
if bdIsLoaded(modelName)
    close_system(modelName, 0);
end

% Create and open new system
new_system(modelName);
open_system(modelName);

% Set Model Configuration (Fixed-step / Continuous ODE solver)
set_param(modelName, 'Solver', 'ode45', 'StopTime', '0.10');

% -------------------------------------------------------------------------
% BLOCK 1: VOLTAGE REFERENCE & ERROR SUM
% -------------------------------------------------------------------------
add_block('simulink/Sources/Step', [modelName '/Vref_Target'], ...
    'Time', '0', 'Before', '0', 'After', num2str(Vref), ...
    'Position', [40, 145, 80, 175]);

add_block('simulink/Math Operations/Add', [modelName '/Sum_Voltage_Error'], ...
    'Inputs', '+-', ...
    'Position', [130, 150, 150, 170]);

% -------------------------------------------------------------------------
% BLOCK 2: OUTER VOLTAGE PI CONTROLLER (1 kHz / 1 ms Discrete PI)
% -------------------------------------------------------------------------
add_block('simulink/Math Operations/Gain', [modelName '/Kp_v_Gain'], ...
    'Gain', num2str(Kp_v), ...
    'Position', [190, 115, 240, 145]);

add_block('simulink/Math Operations/Gain', [modelName '/Ki_v_Gain'], ...
    'Gain', num2str(Ki_v), ...
    'Position', [190, 175, 240, 205]);

add_block('simulink/Discrete/Discrete-Time Integrator', [modelName '/Outer_Integrator'], ...
    'IntegratorMethod', 'Forward Euler', ...
    'SampleTime', num2str(Ts_outer), ...
    'LimitOutput', 'on', 'UpperSaturationLimit', num2str(I_ref_max), 'LowerSaturationLimit', '0', ...
    'Position', [270, 175, 320, 205]);

add_block('simulink/Math Operations/Add', [modelName '/Sum_Outer_PI'], ...
    'Inputs', '++', ...
    'Position', [350, 145, 370, 175]);

% Hard Current Safety Clamp on Iref Command (0.0 to 1.5A)
add_block('simulink/Discontinuities/Saturation', [modelName '/Iref_Safety_Clamp'], ...
    'UpperLimit', num2str(I_ref_max), 'LowerLimit', '0', ...
    'Position', [400, 145, 440, 175]);

% -------------------------------------------------------------------------
% BLOCK 3: INNER CURRENT PI CONTROLLER (10 kHz / 100 us Discrete PI)
% -------------------------------------------------------------------------
add_block('simulink/Math Operations/Add', [modelName '/Sum_Current_Error'], ...
    'Inputs', '+-', ...
    'Position', [490, 150, 510, 170]);

add_block('simulink/Math Operations/Gain', [modelName '/Kp_i_Gain'], ...
    'Gain', num2str(Kp_i), ...
    'Position', [550, 115, 600, 145]);

add_block('simulink/Math Operations/Gain', [modelName '/Ki_i_Gain'], ...
    'Gain', num2str(Ki_i), ...
    'Position', [550, 175, 600, 205]);

add_block('simulink/Discrete/Discrete-Time Integrator', [modelName '/Inner_Integrator'], ...
    'IntegratorMethod', 'Forward Euler', ...
    'SampleTime', num2str(Ts_inner), ...
    'LimitOutput', 'on', 'UpperSaturationLimit', '1.0', 'LowerSaturationLimit', '-1.0', ...
    'Position', [630, 175, 680, 205]);

add_block('simulink/Math Operations/Add', [modelName '/Sum_Inner_PI'], ...
    'Inputs', '++', ...
    'Position', [710, 145, 730, 175]);

% Feedforward Gain: Vout / Vin
add_block('simulink/Math Operations/Gain', [modelName '/Feedforward_Gain'], ...
    'Gain', num2str(1/Vin), ...
    'Position', [630, 75, 680, 105]);

add_block('simulink/Math Operations/Add', [modelName '/Sum_Duty'], ...
    'Inputs', '++', ...
    'Position', [765, 140, 785, 170]);

% PWM Saturation Clamp (2% to 90% Duty)
add_block('simulink/Discontinuities/Saturation', [modelName '/PWM_Duty_Clamp'], ...
    'UpperLimit', num2str(Duty_max), 'LowerLimit', num2str(Duty_min), ...
    'Position', [815, 140, 855, 170]);

% -------------------------------------------------------------------------
% BLOCK 4: CONTINUOUS BUCK CONVERTER PLANT MODEL
% -------------------------------------------------------------------------
% Current Dynamics: G_id(s) = Vin / (s*L)
add_block('simulink/Continuous/Transfer Fcn', [modelName '/G_id_Inductor_Current'], ...
    'Numerator', ['[' num2str(Vin) ']'], 'Denominator', ['[' num2str(L) ' 0]'], ...
    'Position', [905, 135, 995, 175]);

% Voltage Dynamics: G_vi(s) = 1 / (s*C + 1/R)
add_block('simulink/Continuous/Transfer Fcn', [modelName '/G_vi_Output_Voltage'], ...
    'Numerator', '[1]', 'Denominator', ['[' num2str(C) ' ' num2str(1/R_nominal) ']'], ...
    'Position', [1050, 135, 1150, 175]);

% -------------------------------------------------------------------------
% BLOCK 5: MULTI-CHANNEL DASHBOARD SCOPES & TRACKING MONITORS
% -------------------------------------------------------------------------
% Constant 1.5A Limit line for scope
add_block('simulink/Sources/Constant', [modelName '/Limit_1_5A_Line'], ...
    'Value', num2str(I_ref_max), ...
    'Position', [905, 15, 950, 35]);

% Mux for Inductor Current Tracking Scope (Iref, IL, 1.5A Safety Line)
add_block('simulink/Signal Routing/Mux', [modelName '/Mux_IL'], ...
    'Inputs', '3', ...
    'Position', [1030, 25, 1035, 85]);

add_block('simulink/Sinks/Scope', [modelName '/Scope_IL_Tracking'], ...
    'Position', [1075, 40, 1115, 70]);

% Mux for Output Voltage Tracking Scope (Vref, Vout)
add_block('simulink/Signal Routing/Mux', [modelName '/Mux_Vout'], ...
    'Inputs', '2', ...
    'Position', [1200, 95, 1205, 145]);

add_block('simulink/Sinks/Scope', [modelName '/Scope_Vout_Tracking'], ...
    'Position', [1245, 105, 1285, 135]);

% Dedicated Scope for PWM Duty Cycle
add_block('simulink/Sinks/Scope', [modelName '/Scope_Duty_Cycle'], ...
    'Position', [905, 75, 945, 105]);

% Master 3-Channel Dashboard Scope
add_block('simulink/Sinks/Scope', [modelName '/Cascade_Master_Dashboard'], ...
    'NumInputPorts', '3', ...
    'Position', [1245, 185, 1295, 245]);

% Numerical Displays
add_block('simulink/Sinks/Display', [modelName '/Display_Vout_V'], ...
    'Position', [1245, 270, 1335, 300]);

add_block('simulink/Sinks/Display', [modelName '/Display_IL_A'], ...
    'Position', [1075, 270, 1165, 300]);

% -------------------------------------------------------------------------
% 4. CONNECT SIGNAL LINES
% -------------------------------------------------------------------------
% Voltage Outer Loop Routing
add_line(modelName, 'Vref_Target/1', 'Sum_Voltage_Error/1');
add_line(modelName, 'Sum_Voltage_Error/1', 'Kp_v_Gain/1');
add_line(modelName, 'Sum_Voltage_Error/1', 'Ki_v_Gain/1');
add_line(modelName, 'Ki_v_Gain/1', 'Outer_Integrator/1');
add_line(modelName, 'Kp_v_Gain/1', 'Sum_Outer_PI/1');
add_line(modelName, 'Outer_Integrator/1', 'Sum_Outer_PI/2');
add_line(modelName, 'Sum_Outer_PI/1', 'Iref_Safety_Clamp/1');

% Inner Current Loop Routing
add_line(modelName, 'Iref_Safety_Clamp/1', 'Sum_Current_Error/1');
add_line(modelName, 'Sum_Current_Error/1', 'Kp_i_Gain/1');
add_line(modelName, 'Sum_Current_Error/1', 'Ki_i_Gain/1');
add_line(modelName, 'Ki_i_Gain/1', 'Inner_Integrator/1');
add_line(modelName, 'Kp_i_Gain/1', 'Sum_Inner_PI/1');
add_line(modelName, 'Inner_Integrator/1', 'Sum_Inner_PI/2');
add_line(modelName, 'Sum_Inner_PI/1', 'Sum_Duty/2');
add_line(modelName, 'Feedforward_Gain/1', 'Sum_Duty/1');
add_line(modelName, 'Sum_Duty/1', 'PWM_Duty_Clamp/1');

% Plant Dynamics Routing
add_line(modelName, 'PWM_Duty_Clamp/1', 'G_id_Inductor_Current/1');
add_line(modelName, 'G_id_Inductor_Current/1', 'G_vi_Output_Voltage/1');

% Feedback Routing
add_line(modelName, 'G_id_Inductor_Current/1', 'Sum_Current_Error/2', 'autorouting', 'on');
add_line(modelName, 'G_vi_Output_Voltage/1', 'Sum_Voltage_Error/2', 'autorouting', 'on');
add_line(modelName, 'G_vi_Output_Voltage/1', 'Feedforward_Gain/1', 'autorouting', 'on');

% Scope & Monitor Connections
add_line(modelName, 'Vref_Target/1', 'Mux_Vout/1', 'autorouting', 'on');
add_line(modelName, 'G_vi_Output_Voltage/1', 'Mux_Vout/2', 'autorouting', 'on');
add_line(modelName, 'Mux_Vout/1', 'Scope_Vout_Tracking/1');

add_line(modelName, 'Iref_Safety_Clamp/1', 'Mux_IL/1', 'autorouting', 'on');
add_line(modelName, 'G_id_Inductor_Current/1', 'Mux_IL/2', 'autorouting', 'on');
add_line(modelName, 'Limit_1_5A_Line/1', 'Mux_IL/3', 'autorouting', 'on');
add_line(modelName, 'Mux_IL/1', 'Scope_IL_Tracking/1');

add_line(modelName, 'PWM_Duty_Clamp/1', 'Scope_Duty_Cycle/1');

% Master Dashboard Multi-Port Connections
add_line(modelName, 'Mux_Vout/1', 'Cascade_Master_Dashboard/1', 'autorouting', 'on');
add_line(modelName, 'Mux_IL/1', 'Cascade_Master_Dashboard/2', 'autorouting', 'on');
add_line(modelName, 'PWM_Duty_Clamp/1', 'Cascade_Master_Dashboard/3', 'autorouting', 'on');

% Numerical Displays
add_line(modelName, 'G_vi_Output_Voltage/1', 'Display_Vout_V/1', 'autorouting', 'on');
add_line(modelName, 'G_id_Inductor_Current/1', 'Display_IL_A/1', 'autorouting', 'on');

% Save Model
save_system(modelName);
fprintf('====================================================\n');
fprintf(' SUCCESS: Simulink Model "%s.slx" Created! \n', modelName);
fprintf(' Scopes Included in Model:\n');
fprintf('  1. Scope_Vout_Tracking       (Vref vs Measured Vout)\n');
fprintf('  2. Scope_IL_Tracking         (Iref vs IL vs 1.5A Limit)\n');
fprintf('  3. Scope_Duty_Cycle          (Instantaneous Duty Cycle)\n');
fprintf('  4. Cascade_Master_Dashboard  (3-Channel Master Scope)\n');
fprintf('  5. Live Numerical Displays   (Vout and IL)\n');
fprintf('====================================================\n');
