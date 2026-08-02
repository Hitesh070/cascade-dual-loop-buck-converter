/**
 * @file cascade_control.c
 * @brief Implementation of Cascade (Dual-Loop) PI Control Algorithm
 */

#include "cascade_control.h"

void PI_Init(PI_Controller_t *pi, float Kp, float Ki, float out_min, float out_max, float dt) {
    pi->Kp = Kp;
    pi->Ki = Ki;
    pi->integrator = 0.0f;
    pi->out_min = out_min;
    pi->out_max = out_max;
    pi->dt = dt;
}

void PI_Reset(PI_Controller_t *pi) {
    pi->integrator = 0.0f;
}

float PI_Update(PI_Controller_t *pi, float setpoint, float measured) {
    float error = setpoint - measured;
    
    // Euler Integration
    pi->integrator += error * pi->dt;
    
    // Anti-Windup Clamping on Integrator
    if (pi->integrator > pi->out_max) {
        pi->integrator = pi->out_max;
    } else if (pi->integrator < pi->out_min) {
        pi->integrator = pi->out_min;
    }
    
    // Calculate Proportional + Integral Output
    float output = (pi->Kp * error) + (pi->Ki * pi->integrator);
    
    // Clamp Total Output
    if (output > pi->out_max) {
        output = pi->out_max;
    } else if (output < pi->out_min) {
        output = pi->out_min;
    }
    
    return output;
}

void CascadeBuck_Init(CascadeBuck_t *sys, 
                     float Kp_v, float Ki_v, 
                     float Kp_i, float Ki_i,
                     float v_ref, float i_ref_max, float v_in,
                     float duty_min, float duty_max) {
    sys->v_ref = v_ref;
    sys->i_ref_max = i_ref_max;
    sys->v_in = v_in;
    sys->duty_min = duty_min;
    sys->duty_max = duty_max;
    sys->i_ref = 0.0f;
    sys->outer_divider = 10; // 10 kHz / 10 = 1 kHz outer loop execution
    sys->inner_counter = 0;
    sys->soft_start_done = 0;
    sys->soft_start_vref = 0.0f;
    
    // Initialize Outer Loop PI (dt = 1ms = 0.001s, Output limits: 0.0A to i_ref_max)
    PI_Init(&sys->outer_pi, Kp_v, Ki_v, 0.0f, i_ref_max, 0.001f);
    
    // Initialize Inner Loop PI (dt = 100us = 0.0001s, Output limits: duty_min to duty_max)
    PI_Init(&sys->inner_pi, Kp_i, Ki_i, duty_min, duty_max, 0.0001f);
}

float CascadeBuck_UpdateOuterLoop(CascadeBuck_t *sys, float v_out_measured) {
    // Soft Start Ramp Handling (Ramp reference from 0V to target Vref over 20ms)
    float active_vref = sys->v_ref;
    if (!sys->soft_start_done) {
        sys->soft_start_vref += 0.25f; // Step 0.25V per outer loop cycle (20ms total ramp)
        if (sys->soft_start_vref >= sys->v_ref) {
            sys->soft_start_vref = sys->v_ref;
            sys->soft_start_done = 1;
        }
        active_vref = sys->soft_start_vref;
    }
    
    // Compute raw reference current command
    float raw_i_ref = PI_Update(&sys->outer_pi, active_vref, v_out_measured);
    
    // Hard Clamp Safety Gate
    if (raw_i_ref > sys->i_ref_max) {
        raw_i_ref = sys->i_ref_max;
    } else if (raw_i_ref < 0.0f) {
        raw_i_ref = 0.0f;
    }
    
    sys->i_ref = raw_i_ref;
    return sys->i_ref;
}

float CascadeBuck_UpdateInnerLoop(CascadeBuck_t *sys, float i_L_measured, float v_out_measured) {
    sys->inner_counter++;
    
    // Execute Outer Loop every 10 inner cycles (1 kHz rate)
    if (sys->inner_counter >= sys->outer_divider) {
        sys->inner_counter = 0;
        CascadeBuck_UpdateOuterLoop(sys, v_out_measured);
    }
    
    // Feedforward Duty Term Vout / Vin improves load transient rejection
    float feedforward = v_out_measured / sys->v_in;
    
    // Inner Loop PI output (raw PWM command)
    float raw_duty = PI_Update(&sys->inner_pi, sys->i_ref, i_L_measured) + feedforward;
    
    // PWM Saturation Guard
    if (raw_duty > sys->duty_max) {
        raw_duty = sys->duty_max;
    } else if (raw_duty < sys->duty_min) {
        raw_duty = sys->duty_min;
    }
    
    return raw_duty;
}
