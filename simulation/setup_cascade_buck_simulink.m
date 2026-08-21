%% =========================================================================
% CASCADE (DUAL-LOOP) VOLTAGE-CURRENT CONTROLLED BUCK CONVERTER
% MATLAB Initialization & Simulink Model Generator Script
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
Duty_min  = 0.02;       % 2%
Duty_max  = 0.90;       % 90%

%% 2. TRANSFER FUNCTIONS & PI GAIN DERIVATIONS
% Inner Loop Crossover: f_ci = 2000 Hz
f_ci      = 2000.0;
omega_ci  = 2.0 * pi * f_ci;
omega_zi  = 1.0 / (R_nominal * C); % Zero placement at load corner freq (~212.76 rad/s)

Kp_i = (omega_ci * L) / Vin;
Ki_i = Kp_i * omega_zi;

% Outer Loop Crossover: f_cv = 200 Hz
f_cv      = 200.0;
omega_cv  = 2.0 * pi * f_cv;
omega_zv  = omega_zi;

Kp_v = omega_cv * C;
Ki_v = Kp_v * omega_zv;

fprintf('====================================================\n');
fprintf(' CASCADE CONTROL SIMULINK PARAMETERS LOADED \n');
fprintf('====================================================\n');
fprintf('Inner Loop (10 kHz, Ts = %0.1f us):\n', Ts_inner*1e6);
fprintf('  Kp_i = %0.6f\n', Kp_i);
fprintf('  Ki_i = %0.6f\n', Ki_i);
fprintf('Outer Loop (1 kHz, Ts = %0.1f ms):\n', Ts_outer*1e3);
fprintf('  Kp_v = %0.6f\n', Kp_v);
fprintf('  Ki_v = %0.6f\n', Ki_v);
fprintf('====================================================\n\n');

%% 3. PROGRAMMATIC SIMULINK MODEL CREATION
modelName = 'cascade_buck_simulink';

% Close existing model if open, then create new system
if bdIsLoaded(modelName)
    close_system(modelName, 0);
end
new_system(modelName);
open_system(modelName);

% Set Model Parameters
set_param(modelName, 'Solver', 'ode45', 'StopTime', '0.10');

% Add Blocks
% --- Inputs & References ---
add_block('simulink/Sources/Step', [modelName '/Vref_Step'], ...
    'Time', '0', 'Before', '0', 'After', num2str(Vref), ...
    'Position', [30, 100, 70, 130]);

% --- Outer Voltage Loop PI (Discrete 1 kHz) ---
add_block('simulink/Discrete/Discrete PID Controller', [modelName '/Outer_Voltage_PI'], ...
    'P', num2str(Kp_v), 'I', num2str(Ki_v), 'D', '0', ...
    'SampleTime', num2str(Ts_outer), ...
    'LimitOutput', 'on', 'UpperLimit', num2str(I_ref_max), 'LowerLimit', '0', ...
    'Position', [130, 95, 190, 135]);

% --- Inner Current Loop PI (Discrete 10 kHz) ---
add_block('simulink/Discrete/Discrete PID Controller', [modelName '/Inner_Current_PI'], ...
    'P', num2str(Kp_i), 'I', num2str(Ki_i), 'D', '0', ...
    'SampleTime', num2str(Ts_inner), ...
    'LimitOutput', 'on', 'UpperLimit', num2str(Duty_max), 'LowerLimit', num2str(Duty_min), ...
    'Position', [260, 95, 320, 135]);

% --- Feedforward Gain (Vout/Vin approximation) ---
add_block('simulink/Math Operations/Gain', [modelName '/Feedforward_Gain'], ...
    'Gain', num2str(1/Vin), ...
    'Position', [260, 160, 310, 190]);

add_block('simulink/Math Operations/Add', [modelName '/Sum_Duty'], ...
    'Inputs', '++', ...
    'Position', [350, 105, 370, 135]);

% --- Plant Model (Transfer Functions for Inductor Current & Output Voltage) ---
% G_id(s) = Vin / (s*L)
add_block('simulink/Continuous/Transfer Fcn', [modelName '/G_id_Plant'], ...
    'Numerator', ['[' num2str(Vin) ']'], 'Denominator', ['[' num2str(L) ' 0]'], ...
    'Position', [410, 100, 480, 140]);

% G_vi(s) = 1 / (s*C + 1/R)
add_block('simulink/Continuous/Transfer Fcn', [modelName '/G_vi_Plant'], ...
    'Numerator', '[1]', 'Denominator', ['[' num2str(C) ' ' num2str(1/R_nominal) ']'], ...
    'Position', [530, 100, 600, 140]);

% --- Load Disturbance Step (10 Ohm to 3.33 Ohm at t = 40ms) ---
add_block('simulink/Sources/Step', [modelName '/Load_Disturbance'], ...
    'Time', '0.04', 'Before', num2str(1/R_nominal), 'After', num2str(1/3.33), ...
    'Position', [530, 200, 560, 230]);

% --- Feedback Connections & Scopes ---
add_block('simulink/Math Operations/Add', [modelName '/Sum_Outer'], ...
    'Inputs', '+-', ...
    'Position', [90, 105, 110, 125]);

add_block('simulink/Math Operations/Add', [modelName '/Sum_Inner'], ...
    'Inputs', '+-', ...
    'Position', [220, 105, 240, 125]);

add_block('simulink/Sinks/Scope', [modelName '/Scope_Vout'], ...
    'Position', [650, 105, 680, 135]);

add_block('simulink/Sinks/Scope', [modelName '/Scope_IL'], ...
    'Position', [520, 40, 550, 70]);

% --- Add Signal Lines ---
% Outer Loop Lines
add_line(modelName, 'Vref_Step/1', 'Sum_Outer/1');
add_line(modelName, 'Sum_Outer/1', 'Outer_Voltage_PI/1');
add_line(modelName, 'Outer_Voltage_PI/1', 'Sum_Inner/1');

% Inner Loop Lines
add_line(modelName, 'Sum_Inner/1', 'Inner_Current_PI/1');
add_line(modelName, 'Inner_Current_PI/1', 'Sum_Duty/1');
add_line(modelName, 'Feedforward_Gain/1', 'Sum_Duty/2');
add_line(modelName, 'Sum_Duty/1', 'G_id_Plant/1');

% Plant & Feedback Lines
add_line(modelName, 'G_id_Plant/1', 'G_vi_Plant/1');
add_line(modelName, 'G_id_Plant/1', 'Scope_IL/1');
add_line(modelName, 'G_id_Plant/1', 'Sum_Inner/2', 'autorouting', 'on');
add_line(modelName, 'G_vi_Plant/1', 'Scope_Vout/1');
add_line(modelName, 'G_vi_Plant/1', 'Sum_Outer/2', 'autorouting', 'on');
add_line(modelName, 'G_vi_Plant/1', 'Feedforward_Gain/1', 'autorouting', 'on');

% Save Simulink Model
save_system(modelName);
fprintf('Simulink model "%s.slx" created and saved successfully!\n', modelName);
