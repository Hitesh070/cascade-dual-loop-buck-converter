
==================================================
ANALYSIS OF: 26439-51855-1-PB.pdf (15 pages)
==================================================

--- KEY PARAGRAPHS MENTIONING LIMITATIONS / FUTURE WORK / HARDWARE ---

> --- PAGE 7 ---
> Int J Elec & Comp Eng  ISSN: 2088-8708  
>  
> A current control method for bidirectional multiphase DC-DC boost-buck converter (Gifari Iswandi Hasyim) 
> 2369 
> Table 1. Components of the proposed converter prototype 
> Parameter value 
> A-part Capacitor (𝐶𝐴) 47 µF 
> A-part Inductor (𝐿𝐴) 4.2 mH 
> B-part Inductor (𝐿𝐵) 2.1 mH 

==================================================
ANALYSIS OF: 7.+15720+72-82.pdf (11 pages)
==================================================

--- KEY PARAGRAPHS MENTIONING LIMITATIONS / FUTURE WORK / HARDWARE ---

> --- PAGE 1 ---
>  INTERNATIONAL JOURNAL OF INTEGRATED 
> ENGINEERING 
> ISSN: 2229-838X     e-ISSN: 2600-7916 
>  IJIE 
> Vol. 16 No.  7 (2024) 72-82 
> https://publisher.uthm.edu.my/ojs/index.php/ijie 
>    
>  
> This is an open access article under the CC BY-NC-SA 4.0 license. 

> --- PAGE 2 ---
> Int. Journal of Integrated Engineering Vol. 16 No. 7 (2024) p. 72-82 73 
>  
>  
> electric two-wheelers in Netherlands [3]. LEV sales growth in different regions in the 2019-2021 period is shown 
> in Fig. 1 [1]. The upward trend in sales can be clearly observed, especially in Asian countries.  
>  
>  
>  
>  

> --- PAGE 3 ---
> 74 Int. Journal of Integrated Engineering Vol. 16 No. 7 (2024) p. 72-82 
>  
>  
> A good charging control technique is also equally important. It must effectively complement the chosen 
> topology, and it must deliver optimal charging performance without causing battery damage. Taking this into 
> consideration, the constant- current constant-voltage (CC/CV) technique [17] is chosen, as it remains popular in 
> numerous charging applications. In this method, the charging current is held at a set point until the battery voltage 
> reaches its maximum value. Beyond that point, the voltage remains fixed and the current steadily decreases.  
> In this study, cascaded DC-DC converter topology –combination of a synchronous buck converter and a series 

> --- PAGE 6 ---
> Int. Journal of Integrated Engineering Vol. 16 No. 7 (2024) p. 72-82 77 
>  
>  
> Using volt-second balance principle on inductor L3, we arrive at the following equation. 
>  (8) 
>  
> Combining equations (7) and (8), the overall step-down gain for the proposed converter is obtained. 
>  
>  (9) 

> --- PAGE 9 ---
> 80 Int. Journal of Integrated Engineering Vol. 16 No. 7 (2024) p. 72-82 
>  
>  
> expected, the controller action ensures that the battery terminal voltage is maintained at the 27.93 V set point, 
> and it is also seen in Fig. 9. One point to note here is the small transient of approximately 0.05 V and 2 A in the 
> terminal voltage and charg ing current respectively. This occurs as a result of the changeover action of the 
> controller from the CC to CV mode. Lastly, the SoC variation shows that due to the reducing current and the 
> constant voltage, the slope of its increase has also reduced. 
>  

> --- PAGE 10 ---
> Int. Journal of Integrated Engineering Vol. 16 No. 7 (2024) p. 72-82 81 
>  
>  
> To further corroborate the high current gain nature of the proposed converter, a prototype was built wherein 
> the components of the same values as in Table 1 were chosen –  with the overall layout of the prototype as shown 
> in Fig. 11. Cree C3M0065100K SiC MO SFETs were used as switches in the converter, mainly because of their 
> superior switching characteristics over a conventional MOSFET. The converter was operated in an open loop 
> condition with a 1.8 Ω resistive load, and the duty cycle of the switch operation was fixed at 0.4. As shown in Fig. 
> 12, the load current (in yellow) was observed to be approximately 15 A, while the input current (in blue) was 

==================================================
ANALYSIS OF: energies-14-06214-v2.pdf (30 pages)
==================================================

--- KEY PARAGRAPHS MENTIONING LIMITATIONS / FUTURE WORK / HARDWARE ---

> --- PAGE 1 ---
> energies
> Article
> Cascaded Voltage and Current Control for a Dual Active Bridge
> Converter with Current Filters
> Michal Gierczynski *
>  , Lech M. Grzesiak
>  and Arkadiusz Kaszewski
> /gid00030/gid00035/gid00032/gid00030/gid00038/gid00001/gid00033/gid00042/gid00045/gid00001
> /gid00048/gid00043/gid00031/gid00028/gid00047/gid00032/gid00046

> --- PAGE 6 ---
> Energies 2021, 14, 6214 6 of 30
> current waveform (solid red line) to converge to the steady-state one. This algorithm is
> designed in such a way that the transient state lasts no longer than half of the switching
> cycle [13]. It assures that the waveforms of the transformer currents iL1(t) and iL2(t), as
> well as the DC-side bridge currents iH1(t) and iH2(t) are the same as in the steady-state in
> the second half of each switching cycle (even during dynamic converter operation). This is
> a very important feature of this modulation scheme, which plays a fundamental role in the
> presented closed loop control system.
> 2.2. Current Control Loop

> --- PAGE 7 ---
> Energies 2021, 14, 6214 7 of 30
> limitation only then, if it results in an absolute value lower than the maximal current due
> to the converter’s speciﬁcation:
> imax(k) = min(iH2,avg,max (k), Ispec), (14)
> imin(k) =−imax(k), (15)
> where imax(k) is the actual maximal controller output limitation; imin(k) is the actual
> minimal controller output limitation; Ispec is the maximal output current value according
> to the converter’s speciﬁcation (A). The same limitation values are used for the voltage
> controller described in the next section.

> --- PAGE 22 ---
> Energies 2021, 14, 6214 22 of 30
> The additional current limitation value for both controllers is set according to device
> speciﬁcation (see Table A1) at value Ispec = 25 A and an output of the controllers is limited
> according to Equations (14) and (15).
> The ﬁrst test was carried out for a reference output voltage value of vout,ref = 200 V
> and for the controller parameters set according to Equations (31)–(33) and Equations (48)
> and (49). The results are shown in Figure 16. The measured value of the input voltage
> signal vin (violet color) equals 674 V as opposed to its reference value of 670 V . This voltage
> is controlled by the active rectiﬁer and this 4 V discrepancy is most likely caused by a

> --- PAGE 23 ---
> Energies 2021, 14, 6214 23 of 30
> ﬁlter current signal if2 cannot exceed the 75% of its reference value (in the analyzed case
> this boundary current value equals 18.75 A).
> Based on the results shown in Figure 16, it can be seen that the voltage control system
> works properly. After reaching the reference value of 200 V , the output voltage signalvout
> is regulated at the constant value even during rapid load changes. At the beginning of
> the Phase 2 the 16 Ω load is applied, which results in a 12.5 A load current during the
> steady-state operation. It can be observed that the ﬁlter current signal if2 properly follows
> its reference value during the transient. After applying the load, the input voltage signal

> --- PAGE 24 ---
> Energies 2021, 14, 6214 24 of 30
> The majority of the results are very similar to those from the previous test (see
> Figure 16 for comparison). The main difference in the system behavior can be observed at
> the beginning of Phase 2. The response of the control system becomes oscillatory, which is
> also clearly visible in all the relevant control signals. After a short while the oscillations fade
> away and the system enters a steady-state. The reason for this behavior is the fact that for
> some duration, the control system operates in the proximity of the maximal current, where
> its characteristics are not linear anymore. Let us analyze this oscillating phase in details.
> After applying the load, the input voltage vin drops to the value of 606 V . Substituting

> --- PAGE 25 ---
> Energies 2021, 14, 6214 25 of 30
> It can be clearly seen that the load current value is close enough to its limit to bring
> the control system into oscillations during the whole Phase 2 duration. The system retains
> stability ﬁrst after the load change at the beginning of Phase 3.
> In order to improve the system behavior, the voltage controller should be re-tuned for
> the reduced dynamics. Thanks to the tuning rule derived in Section 2.3, it is a straightfor-
> ward task, as there is only one parameter of the controller to choose (i.e., the integral time
> value) and the second one (i.e., the proportional gain) is determined by means of the tuning
> rule. The new voltage controller parameters were determined based on the characteristics

> --- PAGE 26 ---
> Energies 2021, 14, 6214 26 of 30
> output voltage value of vout,ref = 200 V, should be repeated with changed voltage controller
> parameters according to Equations (51)–(53). The results of this test are shown in Figure 20.
> Figure 20. Experimental results for voltage controller tuned with reduced dynamics : reference voltage value for the
> active rectiﬁer vin,ref = 670 V, reference output voltage value for the DAB converter vout,ref = 200 V, additional current
> limitation Ispec = 25 A, resistive load R = 16 Ω.
> It can be observed that the voltage ﬂuctuations during the load steps (see the zoomed
> parts of the Figure 20) are greater than their counterparts obtained with the voltage con-
> troller tuned for higher dynamics (compared with results shown in Figure 16). During

> --- PAGE 27 ---
> Energies 2021, 14, 6214 27 of 30
> it was possible to greatly simplify a modelling process of the converter dynamics. It
> should be emphasized that the used modulation scheme was developed based on the SPS
> modulation, which is possibly the most simple one. It has some important drawbacks,
> such as an extremely low converter efﬁciency in some operational areas. The literature
> reports more complex modulation schemes, e.g., EPS, DPS, or TPS [ 3], which allow to
> overcome this issue. Hence, it is hard to claim a full industrial maturity of the presented
> solution if it uses such a basic modulation scheme. For this reason it is important to discuss
> its extend-ability for the more performative modulation algorithms. Since the presented

> --- PAGE 28 ---
> Energies 2021, 14, 6214 28 of 30
> The author of [11] solved this problem by using the DC-link voltage signal vDC2(t)
> as the feedback in the voltage control loop instead of the vout(t). Nevertheless, these
> two signals are equal only during the steady-state operation, which in consequence
> must deteriorate the voltage control performance during transients, especially the
> load changes (which is the most important test case for the voltage regulatory system).
> The solution presented here does not posses this drawback. The measurement of the
> DC-link voltage of the secondary-side H-bridge vDC2(t) is not needed and there is a
> possibility to directly measure and control the output voltage signal vout(t) without

> --- PAGE 30 ---
> Energies 2021, 14, 6214 30 of 30
> References
> 1. De Doncker, R.W.; Divan, D.M.; Kheraluwala, M.H. A three-phase soft-switched high power density DC/DC converter for high
> power applications. In Proceedings of the Conference Record of the 1988 IEEE Industry Applications Society Annual Meeting,
> Pittsburgh, PA, USA, 2–7 October 1988; pp. 796–805. [CrossRef]
> 2. Zhao, B.; Song, Q.; Liu, W.; Sun, Y. Overview of Dual-Active-Bridge Isolated Bidirectional DC–DC Converter for High-Frequency-
> Link Power-Conversion System. IEEE T rans. Power Electron. 2014, 29, 4091–4106. [CrossRef]
> 3. Hou, N.; Li, Y.W. Overview and Comparison of Modulation and Control Strategies for a Nonresonant Single-Phase Dual-Active-
> Bridge DC-DC Converter. IEEE T rans. Power Electron. 2020, 35, 3148–3172. [CrossRef]

==================================================
ANALYSIS OF: TESEA_vol4_n1_504-galleys.pdf (17 pages)
==================================================

--- KEY PARAGRAPHS MENTIONING LIMITATIONS / FUTURE WORK / HARDWARE ---

> --- PAGE 1 ---
> Article
> Boundary-Based PWM Control Scheme for a DC-DC
> Buck Converter Operating in CCM
> Hardik Patel1,†
>  , Ankit Shah 2,∗
> 1 Instrumentation and Control Engineering Department, Government Engineering College, Rajkot, Gujarat Technological
> University, India.
> 2 Instrumentation and Control Engineering Department, L. D. College of Engineering, Gujarat Technological University,
> Ahmedabad, India.

> --- PAGE 2 ---
> Transactions on Energy Systems and Engineering Applications , 4(1): 504, 2023 2 of 17
> DC-DC converters, the buck converter is one of the most commonly used topologies for step-down power
> conversion. However, the presence of switching elements in the circuit makes the controller design more
> complicated.
> Among the recent research in the field of DC-DC converters, both small-signal and large-signal models
> are commonly used to study the behavior of the system under different operating conditions [ 2, 3, 4].
> Small-signal models derived using state-space analysis are useful for designing control systems and
> analyzing the stability and performance of the converter. The drawback of small-signal models is that
> they assume dynamics slower than the switching frequency, which can lead to inaccurate predictions

> --- PAGE 3 ---
> Transactions on Energy Systems and Engineering Applications , 4(1): 504, 2023 3 of 17
> To address the issues mentioned above, we propose a boundary-based PWM approach with minimal
> mathematical computations. In this approach, the buck converter is modeled as SDS, and parasitic
> parameters are counteracted by integral compensation. As a Current-Mode Control (CMC) technique,
> it offers superior current regulation compared to V oltage-Mode Control (VMC) which is particularly
> advantageous for applications with variable loads or high ripple currents. The reason is that CMC directly
> regulates the current flowing through the inductor, whereas VMC regulates the output voltage by indirectly
> controlling the inductor current through the error amplifier, which can result in slower response and poor
> stability under certain conditions. Additionally, CMC can provide inherent protection against over-current

> --- PAGE 5 ---
> Transactions on Energy Systems and Engineering Applications , 4(1): 504, 2023 5 of 17
> The buck converter is modeled as SDS with two modes:
> 1. During the ON time of the MOSFET, the dynamics of the system are described by a Linear
> Time-Invariant (LTI) system where the input voltage is applied to the inductor and the output voltage
> is regulated by the switching action of the diode.
> 2. During the OFF time of the MOSFET, the dynamics of the system are described by a different LTI
> system where the inductor discharges through the output capacitor, resulting in a voltage drop.
> The switching between these two modes is governed by the D of the MOSFET, which determines the
> amount of time the switch spends in each of them.

> --- PAGE 9 ---
> Transactions on Energy Systems and Engineering Applications , 4(1): 504, 2023 9 of 17
> Figure 6. Simulation diagram of boundary-based PWM control scheme for buck converter.

> --- PAGE 12 ---
> Transactions on Energy Systems and Engineering Applications , 4(1): 504, 2023 12 of 17
> (a) t = 0.01 s
>  (b) t = 0.06 s
> (c) t = 0.09 s
> Figure 10. State variables transients for set-point variations: (a) waveforms of iL and vo for change in
> Vre f from 5 V to 8 V at t = 0.01 s. (b) waveforms of iL and vo for change in Vre f from 8 V to 5 V at
> t = 0.06 s. (c) waveforms of iL and vo for change in Vre f from 5 V to 3.3 V at t = 0.09 s.
> Overall, the simulation results demonstrate the superior performance of the proposed controller for both
> regulatory and servo control problems, as it maintains stable output voltage without significant overshoot

> --- PAGE 14 ---
> Transactions on Energy Systems and Engineering Applications , 4(1): 504, 2023 14 of 17
> Figure 11b indicates that the ∆iL remains relatively stable despite the -20% variation in capacitance
> value, with all other nominal parameters held constant. However, a minor variation in ∆vo is visible. The
> reason is that the capacitor will discharge more quickly when the MOSFET is turned off, and then charge
> more slowly when the MOSFET is turned on. When the capacitance value is increased by 20%, there is a
> sudden drop in the output voltage. However, this dip is typically transient and settles down within a period
> of 0.4 ms, as depicted in Figure 11b. The reason for this drop is that the larger capacitance takes longer
> to charge up, and the inductor needs more time to transfer energy to the capacitor. As a result, the output
> voltage temporarily decreases until the capacitor is fully charged.

> --- PAGE 15 ---
> Transactions on Energy Systems and Engineering Applications , 4(1): 504, 2023 15 of 17
> Parameter PID [8] FOPID [8] Proposed Method
> Vo(V) 9.933 9.99 10
> Rise time (µs) 92.687 40.614 2.943
> Slew rate (mV/ms) 85.735 105.223 3863
> ∆Vo (V) 0.02 0 0.006
> Mp (%) 15.698 0.505 0.503
> Undershoot (%) 2 2.06 1.997
> Ts (ms) 19.98 0.003 3.535

> --- PAGE 16 ---
> Transactions on Energy Systems and Engineering Applications , 4(1): 504, 2023 16 of 17
> scheme in achieving fast and accurate regulation of the output voltage while also exhibiting robustness
> to parametric variations. Furthermore, we found that incorporating integral compensation is an effective
> method for mitigating the impact of parasitic parameters in controller design. The controller’s superior
> steady-state and dynamic response compared to other conventional control schemes make it an attractive
> option for controlling DC-DC buck converters in CCM. Overall, our proposed control scheme presents a
> straightforward and efficient solution for regulating DC-DC buck converters in CCM.
> Funding: The authors declare that they did not received financial support for this research.
> Author contributions: Conceptualization: Hardik Patel and Ankit Shah; Methodology: Hardik Patel and
