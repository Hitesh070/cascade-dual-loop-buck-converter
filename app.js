/**
 * Cascade (Dual-Loop) Voltage-Current Control of a Buck Converter
 * Interactive Browser Simulation Engine & UI Controller
 * Theme: High-Contrast Red, Black, and White
 */

// ======================================================
// 1. STATE & SIMULATION PARAMETERS
// ======================================================
const state = {
    // Hardware Parameters
    Vin: 12.0,           // V
    Vref: 5.0,           // V
    IrefMax: 1.50,       // A
    Rload: 10.0,         // Ohms
    L: 100e-6,           // Henries (100 uH)
    C: 470e-6,           // Farads (470 uF)
    
    // PI Controller Gains
    Kpv: 0.5906,
    Kiv: 125.66,
    Kpi: 0.1047,
    Kii: 22.28,
    
    // Limits
    dutyMin: 0.02,
    dutyMax: 0.90,
    
    // Frequencies
    fInner: 10000.0,     // 10 kHz inner loop
    fOuter: 1000.0,      // 1 kHz outer loop
    
    // Simulation Time Window
    windowMs: 100,       // 100 ms history
    subSteps: 20,        // integration steps per 100us
    
    // Flags
    isSoftStart: false
};

// Data History Buffers for Canvas
const historyData = {
    t: [],
    vout: [],
    vref: [],
    il: [],
    iref: [],
    duty: []
};

// ======================================================
// 2. GAIN CALCULATION HELPER
// ======================================================
function calculateOptimalGains() {
    const omega_ci = 2.0 * Math.PI * 2000.0; // 2 kHz inner bandwidth
    const omega_zi = 1.0 / (state.Rload * state.C);
    
    state.Kpi = parseFloat(((omega_ci * state.L) / state.Vin).toFixed(4));
    state.Kii = parseFloat((state.Kpi * omega_zi).toFixed(2));
    
    const omega_cv = 2.0 * Math.PI * 200.0; // 200 Hz outer bandwidth
    state.Kpv = parseFloat((omega_cv * state.C).toFixed(4));
    state.Kiv = parseFloat((state.Kpv * omega_zi).toFixed(2));
    
    // Update Slider UI
    document.getElementById('slider-kpv').value = state.Kpv;
    document.getElementById('val-kpv').innerText = state.Kpv.toFixed(4);
    document.getElementById('slider-kiv').value = state.Kiv;
    document.getElementById('val-kiv').innerText = state.Kiv.toFixed(2);
    document.getElementById('slider-kpi').value = state.Kpi;
    document.getElementById('val-kpi').innerText = state.Kpi.toFixed(4);
    document.getElementById('slider-kii').value = state.Kii;
    document.getElementById('val-kii').innerText = state.Kii.toFixed(2);
}

// ======================================================
// 3. NUMERICAL SIMULATION RUNNER
// ======================================================
function runSimulation() {
    const dtInner = 1.0 / state.fInner;
    const dtOuter = 1.0 / state.fOuter;
    const outerRatio = Math.round(state.fInner / state.fOuter);
    
    const dtSim = dtInner / state.subSteps;
    const totalSteps = Math.round((state.windowMs / 1000.0) / dtSim);
    
    // Clear buffers
    historyData.t = [];
    historyData.vout = [];
    historyData.vref = [];
    historyData.il = [];
    historyData.iref = [];
    historyData.duty = [];
    
    // Plant States
    let vout = 0.0;
    let il = 0.0;
    
    // Controller States
    let iref = 0.0;
    let duty = 0.0;
    let int_v = 0.0;
    let int_i = 0.0;
    let innerCounter = 0;
    
    let softVref = state.isSoftStart ? 0.0 : state.Vref;
    
    for (let step = 0; step < totalSteps; step++) {
        const t = step * dtSim;
        
        // Soft Start Ramp
        if (state.isSoftStart && softVref < state.Vref) {
            softVref += (state.Vref / 0.020) * dtSim;
            if (softVref > state.Vref) softVref = state.Vref;
        }
        
        // Digital Control execution at 10 kHz
        if (step % state.subSteps === 0) {
            innerCounter++;
            
            // Outer Loop (1 kHz)
            if (innerCounter % outerRatio === 0) {
                const err_v = softVref - vout;
                int_v += err_v * dtOuter;
                int_v = Math.max(-2.0, Math.min(2.0, int_v)); // Anti-windup
                
                const raw_iref = (state.Kpv * err_v) + (state.Kiv * int_v);
                
                // HARD CURRENT CLAMPING
                iref = Math.max(0.0, Math.min(state.IrefMax, raw_iref));
            }
            
            // Inner Loop (10 kHz)
            const err_i = iref - il;
            int_i += err_i * dtInner;
            int_i = Math.max(-1.0, Math.min(1.0, int_i)); // Anti-windup
            
            const raw_duty = (state.Kpi * err_i) + (state.Kii * int_i) + (vout / state.Vin);
            duty = Math.max(state.dutyMin, Math.min(state.dutyMax, raw_duty));
        }
        
        // ODE Plant Dynamics
        const dil_dt = (duty * state.Vin - vout) / state.L;
        const dvout_dt = (il - vout / state.Rload) / state.C;
        
        il += dil_dt * dtSim;
        vout += dvout_dt * dtSim;
        
        il = Math.max(0.0, il);
        vout = Math.max(0.0, vout);
        
        // Record at 10 kHz rate
        if (step % state.subSteps === 0) {
            historyData.t.push(t * 1000.0); // ms
            historyData.vout.push(vout);
            historyData.vref.push(softVref);
            historyData.il.push(il);
            historyData.iref.push(iref);
            historyData.duty.push(duty * 100.0); // %
        }
    }
    
    updateMetricsAndNodes();
    drawCanvasWaveforms();
}

// ======================================================
// 4. METRICS & DIAGRAM UPDATER
// ======================================================
function updateMetricsAndNodes() {
    const len = historyData.t.length;
    if (len === 0) return;
    
    const lastVout = historyData.vout[len - 1];
    const lastIl = historyData.il[len - 1];
    const lastIref = historyData.iref[len - 1];
    const lastDuty = historyData.duty[len - 1];
    
    // Top Bar Metrics
    document.getElementById('metric-vout').innerText = `${lastVout.toFixed(2)} V`;
    document.getElementById('metric-il').innerText = `${lastIl.toFixed(2)} A`;
    document.getElementById('metric-iref').innerText = `${lastIref.toFixed(2)} A`;
    document.getElementById('metric-duty').innerText = `${lastDuty.toFixed(1)} %`;
    
    // Mode Status
    const modeBadge = document.getElementById('metric-mode');
    if (lastIref >= state.IrefMax - 0.01) {
        modeBadge.innerText = `OVERCURRENT CLAMPED (${state.IrefMax.toFixed(2)}A Max)`;
        modeBadge.className = "metric-badge badge-danger";
    } else if (state.isSoftStart) {
        modeBadge.innerText = "Soft-Start Ramping";
        modeBadge.className = "metric-badge badge-warning";
    } else if (state.Rload <= 2.0) {
        modeBadge.innerText = "Short Circuit Protected";
        modeBadge.className = "metric-badge badge-danger";
    } else {
        modeBadge.innerText = "NORMAL REGULATION";
        modeBadge.className = "metric-badge badge-success";
    }
    
    // Architecture Diagram Nodes
    document.getElementById('node-vref').innerText = `Vref = ${state.Vref.toFixed(1)} V`;
    document.getElementById('node-clamp').innerText = `${state.IrefMax.toFixed(2)} A`;
    document.getElementById('node-iref-val').innerText = `Iref = ${lastIref.toFixed(2)} A`;
    document.getElementById('node-duty-val').innerText = `Duty = ${lastDuty.toFixed(1)}%`;
}

// ======================================================
// 5. CANVAS WAVEFORM DRAWING (RED, BLACK, WHITE PALETTE)
// ======================================================
function drawCanvasWaveforms() {
    drawVoutCanvas();
    drawCurrentCanvas();
    drawDutyCanvas();
}

function drawVoutCanvas() {
    const canvas = document.getElementById('canvas-vout');
    const ctx = canvas.getContext('2d');
    const w = canvas.width;
    const h = canvas.height;
    
    ctx.clearRect(0, 0, w, h);
    ctx.fillStyle = "#070709";
    ctx.fillRect(0, 0, w, h);
    
    // Grid Lines
    ctx.strokeStyle = "rgba(255, 255, 255, 0.05)";
    ctx.lineWidth = 1;
    for (let y = 0; y <= h; y += h/4) {
        ctx.beginPath();
        ctx.moveTo(0, y);
        ctx.lineTo(w, y);
        ctx.stroke();
    }
    for (let x = 0; x <= w; x += w/5) {
        ctx.beginPath();
        ctx.moveTo(x, 0);
        ctx.lineTo(x, h);
        ctx.stroke();
    }
    
    const vMax = 8.0;
    const mapY = (v) => h - (v / vMax) * h;
    const mapX = (tMs) => (tMs / state.windowMs) * w;
    
    // Target Vref dashed line (Crimson Red)
    const yRef = mapY(state.Vref);
    ctx.strokeStyle = "#ff1e42";
    ctx.setLineDash([6, 4]);
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.moveTo(0, yRef);
    ctx.lineTo(w, yRef);
    ctx.stroke();
    ctx.setLineDash([]);
    
    // Measured Vout Trace (Stark Pure White Trace)
    ctx.strokeStyle = "#ffffff";
    ctx.lineWidth = 2.5;
    ctx.beginPath();
    for (let i = 0; i < historyData.t.length; i++) {
        const x = mapX(historyData.t[i]);
        const y = mapY(historyData.vout[i]);
        if (i === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
    }
    ctx.stroke();
}

function drawCurrentCanvas() {
    const canvas = document.getElementById('canvas-current');
    const ctx = canvas.getContext('2d');
    const w = canvas.width;
    const h = canvas.height;
    
    ctx.clearRect(0, 0, w, h);
    ctx.fillStyle = "#070709";
    ctx.fillRect(0, 0, w, h);
    
    // Grid
    ctx.strokeStyle = "rgba(255, 255, 255, 0.05)";
    ctx.lineWidth = 1;
    for (let y = 0; y <= h; y += h/4) {
        ctx.beginPath();
        ctx.moveTo(0, y); ctx.lineTo(w, y); ctx.stroke();
    }

    const iMax = 3.0;
    const mapY = (iVal) => h - (iVal / iMax) * h;
    const mapX = (tMs) => (tMs / state.windowMs) * w;
    
    // Safety limit line (Dark Maroon Limit Line)
    const yLimit = mapY(state.IrefMax);
    ctx.strokeStyle = "#80001a";
    ctx.setLineDash([4, 4]);
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.moveTo(0, yLimit);
    ctx.lineTo(w, yLimit);
    ctx.stroke();
    ctx.setLineDash([]);
    
    // Clamped Command Iref Trace (White Dashed)
    ctx.strokeStyle = "#ffffff";
    ctx.setLineDash([4, 2]);
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    for (let i = 0; i < historyData.t.length; i++) {
        const x = mapX(historyData.t[i]);
        const y = mapY(historyData.iref[i]);
        if (i === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
    }
    ctx.stroke();
    ctx.setLineDash([]);
    
    // Inductor Current IL Trace (Electric Crimson Red Solid)
    ctx.strokeStyle = "#ff1e42";
    ctx.lineWidth = 2.2;
    ctx.beginPath();
    for (let i = 0; i < historyData.t.length; i++) {
        const x = mapX(historyData.t[i]);
        const y = mapY(historyData.il[i]);
        if (i === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
    }
    ctx.stroke();
}

function drawDutyCanvas() {
    const canvas = document.getElementById('canvas-duty');
    const ctx = canvas.getContext('2d');
    const w = canvas.width;
    const h = canvas.height;
    
    ctx.clearRect(0, 0, w, h);
    ctx.fillStyle = "#070709";
    ctx.fillRect(0, 0, w, h);
    
    // Grid
    ctx.strokeStyle = "rgba(255, 255, 255, 0.05)";
    ctx.lineWidth = 1;
    for (let y = 0; y <= h; y += h/4) {
        ctx.beginPath();
        ctx.moveTo(0, y); ctx.lineTo(w, y); ctx.stroke();
    }

    const mapY = (dPct) => h - (dPct / 100.0) * h;
    const mapX = (tMs) => (tMs / state.windowMs) * w;
    
    // Duty cycle trace (Pure White Trace)
    ctx.strokeStyle = "#ffffff";
    ctx.lineWidth = 2.0;
    ctx.beginPath();
    for (let i = 0; i < historyData.t.length; i++) {
        const x = mapX(historyData.t[i]);
        const y = mapY(historyData.duty[i]);
        if (i === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
    }
    ctx.stroke();
}

// ======================================================
// 6. UI EVENT LISTENERS
// ======================================================
function initEventListeners() {
    // Navigation Tabs
    document.querySelectorAll('.nav-tab').forEach(tab => {
        tab.addEventListener('click', (e) => {
            document.querySelectorAll('.nav-tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
            
            const target = e.currentTarget.getAttribute('data-tab');
            e.currentTarget.classList.add('active');
            document.getElementById(`tab-${target}`).classList.add('active');
        });
    });

    // Preset Action Buttons
    document.getElementById('btn-softstart').addEventListener('click', () => {
        state.isSoftStart = true;
        state.Rload = 10.0;
        document.getElementById('slider-rload').value = 10.0;
        document.getElementById('val-rload').innerText = "10.0 \u03A9";
        runSimulation();
        state.isSoftStart = false;
    });

    document.getElementById('btn-step-load').addEventListener('click', () => {
        state.isSoftStart = false;
        state.Rload = 3.33; // 1.5A demand
        document.getElementById('slider-rload').value = 3.33;
        document.getElementById('val-rload').innerText = "3.33 \u03A9";
        runSimulation();
    });

    document.getElementById('btn-short-circuit').addEventListener('click', () => {
        state.isSoftStart = false;
        state.Rload = 1.0; // Short circuit
        document.getElementById('slider-rload').value = 1.0;
        document.getElementById('val-rload').innerText = "1.00 \u03A9";
        runSimulation();
    });

    document.getElementById('btn-reset-params').addEventListener('click', () => {
        state.Vin = 12.0;
        state.Vref = 5.0;
        state.IrefMax = 1.5;
        state.Rload = 10.0;
        state.L = 100e-6;
        state.C = 470e-6;
        state.isSoftStart = false;
        
        document.getElementById('slider-vin').value = 12.0;
        document.getElementById('val-vin').innerText = "12.0 V";
        document.getElementById('slider-vref').value = 5.0;
        document.getElementById('val-vref').innerText = "5.0 V";
        document.getElementById('slider-irefmax').value = 1.5;
        document.getElementById('val-irefmax').innerText = "1.50 A";
        document.getElementById('slider-rload').value = 10.0;
        document.getElementById('val-rload').innerText = "10.0 \u03A9";
        document.getElementById('slider-inductor').value = 100;
        document.getElementById('val-inductor').innerText = "100 \u03BCH";
        document.getElementById('slider-capacitor').value = 470;
        document.getElementById('val-capacitor').innerText = "470 \u03BCF";
        
        calculateOptimalGains();
        runSimulation();
    });

    // Sliders
    document.getElementById('slider-vin').addEventListener('input', (e) => {
        state.Vin = parseFloat(e.target.value);
        document.getElementById('val-vin').innerText = `${state.Vin.toFixed(1)} V`;
        runSimulation();
    });

    document.getElementById('slider-vref').addEventListener('input', (e) => {
        state.Vref = parseFloat(e.target.value);
        document.getElementById('val-vref').innerText = `${state.Vref.toFixed(1)} V`;
        runSimulation();
    });

    document.getElementById('slider-irefmax').addEventListener('input', (e) => {
        state.IrefMax = parseFloat(e.target.value);
        document.getElementById('val-irefmax').innerText = `${state.IrefMax.toFixed(2)} A`;
        runSimulation();
    });

    document.getElementById('slider-rload').addEventListener('input', (e) => {
        state.Rload = parseFloat(e.target.value);
        document.getElementById('val-rload').innerText = `${state.Rload.toFixed(1)} \u03A9`;
        runSimulation();
    });

    document.getElementById('slider-inductor').addEventListener('input', (e) => {
        state.L = parseFloat(e.target.value) * 1e-6;
        document.getElementById('val-inductor').innerText = `${e.target.value} \u03BCH`;
        runSimulation();
    });

    document.getElementById('slider-capacitor').addEventListener('input', (e) => {
        state.C = parseFloat(e.target.value) * 1e-6;
        document.getElementById('val-capacitor').innerText = `${e.target.value} \u03BCF`;
        runSimulation();
    });

    // PI Gain Sliders Input Listeners
    document.getElementById('slider-kpv').addEventListener('input', (e) => {
        state.Kpv = parseFloat(e.target.value);
        document.getElementById('val-kpv').innerText = state.Kpv.toFixed(4);
        runSimulation();
    });

    document.getElementById('slider-kiv').addEventListener('input', (e) => {
        state.Kiv = parseFloat(e.target.value);
        document.getElementById('val-kiv').innerText = state.Kiv.toFixed(2);
        runSimulation();
    });

    document.getElementById('slider-kpi').addEventListener('input', (e) => {
        state.Kpi = parseFloat(e.target.value);
        document.getElementById('val-kpi').innerText = state.Kpi.toFixed(4);
        runSimulation();
    });

    document.getElementById('slider-kii').addEventListener('input', (e) => {
        state.Kii = parseFloat(e.target.value);
        document.getElementById('val-kii').innerText = state.Kii.toFixed(2);
        runSimulation();
    });

    // Accordion Toggle
    document.getElementById('toggle-gains').addEventListener('click', () => {
        const content = document.getElementById('gains-content');
        content.classList.toggle('hidden');
    });

    document.getElementById('btn-recalc-gains').addEventListener('click', () => {
        calculateOptimalGains();
        runSimulation();
    });

    // Copy Firmware Code
    document.getElementById('btn-copy-code').addEventListener('click', () => {
        const code = document.getElementById('firmware-code-block').innerText;
        navigator.clipboard.writeText(code).then(() => {
            const btn = document.getElementById('btn-copy-code');
            btn.innerHTML = '<i data-lucide="check"></i> Copied!';
            setTimeout(() => {
                btn.innerHTML = '<i data-lucide="copy"></i> Copy Code';
                lucide.createIcons();
            }, 2000);
        });
    });
}

// Load Arduino Firmware Snippet
function loadFirmwareCode() {
    const codeSnippet = `/**
 * @file main_arduino.ino
 * @brief Cascade Dual-Loop Voltage & Current Control for Arduino Uno
 */
#include "cascade_control.h"

#define PWM_PIN           9     // Timer 1 OC1A (10 kHz PWM Output)
#define VOUT_ADC_PIN      A0    // Output Voltage Sense (Divider Factor 3.1276)
#define IL_ADC_PIN        A1    // Current Sense (ACS712-05B or Shunt)

static CascadeBuck_t buck_sys;

// 10 kHz Deterministic Interrupt Routine (100 microseconds period)
ISR(TIMER1_COMPA_vect) {
    float v_out = analogRead(A0) * (5.0 / 1023.0 * 3.1276);
    float i_L   = (analogRead(A1) * (5.0 / 1023.0) - 2.5) / 0.185;
    
    // Execute Dual-Loop PI Control
    float duty = CascadeBuck_UpdateInnerLoop(&buck_sys, i_L, v_out);
    OCR1A = (uint16_t)(duty * 1599.0f); // Fast PWM Register update
}

void setup() {
    CascadeBuck_Init(&buck_sys, 0.5906f, 125.66f, 0.1047f, 22.28f, 5.0f, 1.5f, 12.0f, 0.02f, 0.90f);
    
    // Configure Timer 1 for 10 kHz Fast PWM Mode (ICR1 = 1599)
    TCCR1A = _BV(COM1A1) | _BV(WGM11);
    TCCR1B = _BV(WGM13) | _BV(WGM12) | _BV(CS10);
    ICR1 = 1599;
    TIMSK1 = _BV(OCIE1A); // Enable 10 kHz Interrupt
}`;
    document.getElementById('firmware-code-block').innerText = codeSnippet;
}

// Dom Ready Initialization
document.addEventListener('DOMContentLoaded', () => {
    initEventListeners();
    loadFirmwareCode();
    calculateOptimalGains();
    runSimulation();
});
