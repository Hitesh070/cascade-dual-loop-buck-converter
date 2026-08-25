# Analysis of All 10 Research Papers

## [1/10] `21367-41687-1-PB.pdf` (11 pages)

### Metadata & Abstract Snippet:
```text
--- PAGE 1 ---
International Journal of Power Electronics and Drive Systems (IJPEDS)
Vol. 12, No. 4, December 2021, pp. 2273~2283
ISSN: 2088-8694, DOI: 10.11591/ijpeds.v12.i4.pp2273-2283      2273
Journal homepage: http://ijpeds.iaescore.com
Simplified cascade multiphase DC-DC buck power converter
for low voltage large current applications: part II --- output
current controller
Nungky Prameswari, Anand Bannet Ganesen, Falah Kharisma Nuraziz, Jihad Furqani, Arwindra
Rizqiawan, Pekik Argo Dahono
Department of Electrical Engineering, School of Electrical Engineering and Informatics, Institute of Technology
Bandung, Bandung, Indonesia
Article Info  ABSTRACT
Article history:
Received May 27, 2021
Revised Sep 22, 2021
Accepted Sep 29, 2021
This paper proposes a control method for new simplified cascade multiphase
direct current -direct current ( DC-DC) buck power converters used for low -
voltage large-current applications such as cathodic protection. To control the
proposed converter, a proportional -integral (PI) controller is used to regulate
the output current of the converter. The control scheme analysis is carried out
by linearizing the small -signal model of the proposed converter to form the
output current transf er functions. This transfer function will be analyzed by
using phase and gain margin approach to obtain the control parameters (Kp,
Ki, and Ti). Simulation and experiment results are included to show the
validity of the proposed concept.
Keywords:
Buck
Cascade
Cathodic protection
Control
Multiphase This is an open access article under the CC BY-SA license.
Corresponding Author:
Nungky Prameswari
Department of Electrical Engineering, School of Electrical Engineering and Informatics
Institute of Technology Bandung
Ganesha St. No. 10, Bandung 40132, Indonesia
Email: nungkyprameswari24@gmail.com
1. INTRODUCTION
Corrosion is one of the destructive phenomena or deterioration of the quality on both metallic or
non-metallic materials due to the interaction betwe
```

### Conclusion / Summary / Future Work:
```text
s are offered in section 6.
2. DYNAMIC MODELING OF NEW SIMPLIFIED CASCADE MULTIPHASE DC -DC BUCK
POWER CONVERTER
According to the optimization that has been done in Part I, it can be shown that the topology as
shown in Figure 1 is the optimal one. This is a simplified two -stage four-phase DC-DC buck converter. The
basic principle of this converter can be explained as the following.
If one of the switches is ON (for example is S 1), the other switches are in the OFF state and the D ON
diode and all secondary diodes except D SEC1 will be forward biased, while the other diodes will be reverse
biased. From this mechanism, current will flow in two directions: from DC source E d to the primary inductor
LP and from diode D ON to capacitor C. Then, both currents will add up and charge ind uctor L S1, before
reaching the load and the other secondary inductors will discharge its current to the load. And the second
mechanism is when all of the switches are OFF, where all diodes D OFF and secondary diodes will be forward
biased and diodes D ON will be reverse biased. From this mechanism, the load will only receive discharged
currents from the secondary inductors. Those two mechanisms also apply alternately to other switches. As
the output side is a four -phase buck converter, the output current capa bility is large and the ripple content
will be very low. Under continuous conduction mode, the average output voltage ratio is shown in (1), where
Vo and Ed are the output and input voltages of the converter, respectively.
𝑉𝑜
𝐸𝑑
= 4𝛼2 (1)
with
𝛼 = 𝑇𝑂𝑁
𝑇𝑆
(2)
is the duty cycle of switching devices with a maximum value of 0.25, TON is the ON -time of transistors and
TS is the switching period of the transistor.
--- PAGE 3 ---
Int J Pow Elec & Dri Syst ISSN: 2088-8694 
Simplified cascade multiphase DC-DC buck power converter for low voltage large … (Nungky Prameswari)
2275
In (1) shows that a very low output voltage can be obtained without using a very low duty cycle. For
two-stage converter, it can be seen that the output voltage is proportional to the square of duty cycle. The
output current is controlled by using a current controller as shown in Figure 1.
Figure 1. New simplified two-stages four-phase converter with current controller
To design the closed loop system, we should model the system in Figure 1 into the small -signal
model. The first step is state space averaging process. Under continuous conductio
```

## [2/10] `26439-51855-1-PB.pdf` (15 pages)

### Metadata & Abstract Snippet:
```text
--- PAGE 1 ---
International Journal of Electrical and Computer Engineering (IJECE)
Vol. 12, No. 3, June 2022, pp. 2363~2377
ISSN: 2088-8708, DOI: 10.11591/ijece.v12i3.pp2363-2377      2363
Journal homepage: http://ijece.iaescore.com
A current control method for bidirectional multiphase DC-DC
boost-buck converter
Gifari Iswandi Hasyim, Sulistyo Wijanarko, Jihad Furqani, Arwindra Rizqiawan, Pekik Argo Dahono
School of Electrical Engineering and Informatics, Institut Teknologi Bandung, Bandung, Indonesia
Article Info  ABSTRACT
Article history:
Received Nov 4, 2021
Revised Dec 15, 2021
Accepted Jan 2, 2022
In the future, more and more electric vehicle (EV) batteries are connected to
the direct current (DC) microgrid. Depending on th e battery state of charge,
the battery voltage can be higher or lower than the DC microgrid voltage. A
converter that is aimed to fulfil such function must be capable of working in
both charging and discharging regardless the voltage level of the battery a nd
DC microgrid. Battery performance degradation due to ripple current
entering the battery is also a concern. In this paper, a converter that can
minimize ripple current that entering battery and operate in two power -flow
directions regardless of battery and DC microgrid voltage level is presented.
A current control method for this kind of converter was proposed.
Experiment on a p rototype was conducted to prove the proposed converter
current control method.
Keywords:
Battery
Control
DC-DC converter
Energy storage
Renewable energy This is an open access article under the CC BY-SA license.
Corresponding Author:
Gifari Iswandi Hasyim
School of Electrical Engineering and Informatics, Institut Teknologi Bandung
Jalan Ganesa No. 10, Lebak Siliwangi, Coblong, Bandung, Jawa Barat 40132, Indonesia
Email: gifarihasyim@gmail.com
1. INTRODUCTION
Utilization of renewable energy to fill energy demand give rise to many distributed generators.
According to conventional way of electric power transmiss
```

### Conclusion / Summary / Future Work:
```text
The proposed converter and its current control strategy for charging and discharging of a battery
connected to a DC microgrid with minimized battery ripple current has been presented. How the battery
ripple current is minimized has be en explained through simulation results. How to use a virtual resisto r to
damp a transient oscillation has been described. A prototype has been constructed and experiment has been
carried out to see the current control capabilities of the proposed converte r. Experimental results have shown
the effectiveness of the current c ontroller for the proposed converter. Effectiveness of virtual resistor in
damping arising resonance in the proposed converter was also shown in the experiment.
ACKNOWLEDGEMENTS
The authors wish to thank the Korea Midland Power Company for the financial support.
```

## [3/10] `7.+15720+72-82.pdf` (11 pages)

### Metadata & Abstract Snippet:
```text
--- PAGE 1 ---
INTERNATIONAL JOURNAL OF INTEGRATED
ENGINEERING
ISSN: 2229-838X     e-ISSN: 2600-7916
IJIE
Vol. 16 No.  7 (2024) 72-82
https://publisher.uthm.edu.my/ojs/index.php/ijie
This is an open access article under the CC BY-NC-SA 4.0 license.
A Cascaded Synchronous Buck Converter for Light Electric
Vehicle Charging Applications
Mohammad Faisal Akhtar1, Siti Rohani Sheikh Raihan1, Nasrudin Abdul
Rahim1, Mohd Khairil Rahmat2*
1  Higher Institution Centre of Excellence (HICoE), UM Power Energy Dedicated Advanced Centre (UMPEDAC),
Level 4, Wisma R&D, University of Malaya, Jalan Pantai Baharu, Kuala Lumpur 59990, MALAYSIA
2  Electrical Engineering Section, British Malaysian Institute,
Universiti Kuala Lumpur (UniKL), Batu 8, Jln Sg. Pusu, 53100 Gombak, Selangor, MALAYSIA
*Corresponding Author: mkhairil@unikl.edu.my
DOI: https://doi.org/10.30880/ijie.2024.16.07.007
Article Info Abstract
Received: 25 June 2024
Accepted: 10 September 2024
Available online: 2 December 2024
In this work,  a cascaded synchronous DC-DC converter  topology is
presented which is suitable for high current applications . In th is
topology, a synchronous buck converter is c ascaded with a series
capacitor synchronous buck converter, which exhibits very low step -
down voltage gain –  thus translating to a high current gain . For this
work, this converter is applied for charging a 24 V, 10 A h Lithium- ion
(Li-ion) battery . The constant-current constant -voltage (CC/CV)
technique is employed with the proposed converter for this application.
Simulations for the system were carried out in MATLAB Simulink, using
the SimPowerSystems toolbox. The converter operation is observed to
align with a typical CC/CV charging profile, with a  93.3% charging
efficiency. Consequently, this topology may be integrated into an off -
board charger for light electric vehicles (LEVs) such as e -bikes and
three-wheeler e-rickshaws – which are typically used in public
transportation. Suitability of the given converter
```

### Conclusion / Summary / Future Work:
```text
A cascaded DC-DC converter – which combined a synchronous buck converter and a series capacitor synchronous
buck converter – was presented in this paper. This converter was then evaluated for battery charging applications
in a MATLAB Simulink environment. For this purpose, a 24 V 10 A h Li- ion battery was chosen.
A charging current of 10 A was maintained due to controller action in the CC stage, which resulted in a steady
increase in battery terminal voltage and SoC. This process continued until the reference voltage –  which was the
maximum battery voltage in this case – was attained. This marked the start of the CV mode, and beyond this point,
the controller action helped hold the battery voltage constant, which led to a steady decrease in the charging current
from its 10 A set point. The SoC’s slope of increase also reduced in this stage. Additionally, the control changeover
resulted in a small transient in the battery voltage and charging current at the start of CV mode. This transient was
kept to a minimum by tuning of PI controller parameters.
Significantly, a satisfactory 93.3% charging efficiency was observed, which is good for the power level at which
the converter operated, thus validating the topology’s usage in charging applications.
Another significant result from the simulations is the verification of the high current gain operation of the given
topology. The battery charging current of 10 a roughly translated to a supply side current of 0.9 A. This corresponds
to the theoretical gain at a duty cycle of approximately 0.4. This indicates the straightforward nature of cascading
converters to achieve a high step-down gain or current gain, and it can be used for other applications which require
the same. This aspect of the converter was f urther validated through hardware experimentation, wherein the
circuit was run in open loop with a 1.8 Ω resistive load. It was observed that the theoretical and the experimental
value of the current gain were found to be close, thus proving its suitability for high current applications.
The simulation results and resultant charging efficiency indicate the suitability of this converter for battery
charging. This converter can potentially be scaled up for battery packs with higher voltage ratings – those which
may be found in electric two/three-wheelers. This work aims to address the need for coverage expansion of LEVs
through improvements in charging infrastructure, with emphasis on
```

## [4/10] `9f139aa842e2b3ac34ead1ed7c0e6087.pdf` (10 pages)

### Metadata & Abstract Snippet:
```text
--- PAGE 1 ---
Design and Analysis of Feedback
Control for DC-DC Buck Converter
Sajad Ahmad Tali, Faroze Ahmad, Inayat Hussain Wani
Islamic University of Science and Technology, Awantipora, J & K, India
Corresponding author: Inayat Hussain Wani, Email: inayathussain9018@gmail.com
The DC-DC buck converters have wide range of emerging applications such as in
photovoltaic systems and linear drives which have the requirement of high effi-
ciency and optimum transient response over dynamic changes in line voltage and
load. The purpose of this manuscript is to make a DC-DC buck converter robust
against the deviations in the input voltage, load current and to reduce the steady
state error. In this paper averaging and linearization of buck converter has been
done and then applying K-Factor method controller has been designed in such a
waythatstabilizestheoutputvoltageofbuckconverterirrespectiveofthelinevolt-
age and load disturbances. Mathematical analysis and MATLAB simulation wave-
forms of proposed method validate that output voltage is maintained irrespective
of the disturbance in line voltage and load variations while retaining acceptable
phase margin.
Keywords: DC-DC buck converter, PWM converter, Compensator, Phase margin,
Bode plot.
2021. In Rahul Srivastava & Aditya Kumar Singh Pundir (eds.),New Frontiers
in Communication and Intelligent Systems, 319–328. Computing & Intelligent
Systems, SCRS, India.https://doi.org/10.52458/978-81-95502-00-4-33
--- PAGE 2 ---
1 Introduction
Modern Switching converters are an essential part of many electronic systems. They are mainly used to
regulate the input voltage and to transfer the power efficiently. Switching converters have applications
in Wind Energy Conversion Systems [1], Photovolta ic Systems (PV), high Voltage DC transmission
system [2], communication equipment’s, Universal Serial Bus (USB) chargers to step down the input
voltage [ 3], battery  powered devices and in many other applications. The output of a switching
co
```

### Conclusion / Summary / Future Work:
```text
The output of a buck converter is dependent on variations in supply voltage, load and non -ideal
behavior of components. Averaging and linearization method is used to obtain transfer function for the
DC-DC buck converter furthermore by K -method the compensator is designed to improve the phase
margin of closed loop buck converter. Mathematical analysis and simulation results verify the output
voltage is stable and reaches steady state quite fast over dynamic changes in line voltage and load. With
the aid of complex control theory, a proper controller can be designed by analyzing the frequency
response of the DC -DC converter to make the DC -DC converter robust against disturbance in load and
supply voltage. The future scope of this work is to validate the  simulation results on hardware and to
improve the transient response of the converter.
```

## [5/10] `TESEA_vol4_n1_504-galleys.pdf` (17 pages)

### Metadata & Abstract Snippet:
```text
--- PAGE 1 ---
Article
Boundary-Based PWM Control Scheme for a DC-DC
Buck Converter Operating in CCM
Hardik Patel1,†
, Ankit Shah 2,∗
1 Instrumentation and Control Engineering Department, Government Engineering College, Rajkot, Gujarat Technological
University, India.
2 Instrumentation and Control Engineering Department, L. D. College of Engineering, Gujarat Technological University,
Ahmedabad, India.
† PhD Research Scholar, Gujarat Technological University, Ahmedabad, India.
∗ Correspondence: ankitshah.ic@ldce.ac.in
Received: 13 March 2023; Accepted: 27 March 2023; Published: 12 April 2023
Abstract: This paper presents a control scheme for DC-DC buck converters operating in Continuous
Conduction Mode (CCM) that achieves fast and accurate regulation of the output voltage while reducing
the computational burden on the control system. The study investigates the boundary-based control scheme
for a buck converter and models the converter circuit as a Switched Dynamical System (SDS) using hybrid
automaton due to its continuous and discrete states. The boundaries of these states are determined to
enable the implementation of a fixed-frequency Pulse-Width Modulation (PWM) control scheme. The
proposed control scheme was evaluated through simulation with variations in input voltage, load, and
reference voltage. It was further analyzed for model mismatch due to parametric variations and parasitic
parameters, which demonstrated its effectiveness and robustness under various operating conditions. The
SDS approach for controlling the buck converter is simple, requires minimal mathematical calculations,
and is free from modeling errors. The output voltage was stable under regulatory and servo problems, as
well as sinusoidal input testing. The proposed scheme was compared with other conventional schemes
and found superior in terms of steady-state and dynamic response. Additionally, integral compensation
was introduced to counter parasitic parameters, which was found to be effectiv
```

### Conclusion / Summary / Future Work:
```text
s
In this paper we proposed a boundary-based PWM control scheme for DC-DC buck converters operating
in CCM. The approach utilizes SDS modeling of the converter circuit, enabling the implementation of a
fixed-frequency PWM control scheme. Simulation results demonstrate the efficacy of the proposed control
--- PAGE 16 ---
Transactions on Energy Systems and Engineering Applications , 4(1): 504, 2023 16 of 17
scheme in achieving fast and accurate regulation of the output voltage while also exhibiting robustness
to parametric variations. Furthermore, we found that incorporating integral compensation is an effective
method for mitigating the impact of parasitic parameters in controller design. The controller’s superior
steady-state and dynamic response compared to other conventional control schemes make it an attractive
option for controlling DC-DC buck converters in CCM. Overall, our proposed control scheme presents a
straightforward and efficient solution for regulating DC-DC buck converters in CCM.
Funding: The authors declare that they did not received financial support for this research.
Author contributions: Conceptualization: Hardik Patel and Ankit Shah; Methodology: Hardik Patel and
Ankit Shah; Investigation: Hardik Patel and Ankit Shah; Writing: Hardik Patel; Writing – Review and
Editing: Ankit Shah.
Disclosure statement: The authors declare no conflict of interest.
```

## [6/10] `Two_Independent_Single-Loop_Voltage_Mode_Control_Method_for_3-Level_Buck_Converter.pdf` (13 pages)

### Metadata & Abstract Snippet:
```text
--- PAGE 1 ---
Received 23 August 2024, accepted 6 October 2024, date of publication 8 October 2024, date of current version 24 October 2024.
Digital Object Identifier 10.1 109/ACCESS.2024.3476409
Two Independent Single-Loop Voltage Mode
Control Method for 3-Level Buck Converter
JUNE-BONG JEONG
1, CHAN-GYU KIM 1, JEONG-IL KANG
2, AND SANG-KYOO HAN
1
1Power Electronics System Laboratory (POESLA), College of Creative Engineering, Kookmin University, Seoul 02707, South Korea
2Samsung Electronics Company Ltd., Suwon, Gyeonggi 16677, South Korea
Corresponding author: Sang-Kyoo Han (djhan@kookmin.ac.kr)
This work was supported in part by the Korea Institute of Energy Technology Evaluation and Planning (KETEP) Grant through the
Korea Government Ministry of Trade, Industry and Energy (MOTIE) (Development of High Efficiency Power Converter Based on
Multidisciplinary Design and Optimization Platform) under Grant 20212020800020, and in part by Samsung Electronics Company Ltd.
ABSTRACT Compared to a basic buck converter, the 3-level buck converter operates with the output inductor
at twice the switching frequency. Additionally, the voltage across its flying capacitor contributes to reducing
the slope of the inductor current. These factors can result in a reduction in the maximum output current
ripple by up to four times, enabling the use of a smaller output inductor. Moreover, the voltage stress on the
switches is only half of the input voltage. Therefore, the 3-level buck converter is advantageous for achieving
high efficiency and high power density. To maintain these advantages, the voltage across the flying capacitor
must be kept at half of the input voltage. Conventionally, this condition is usually ensured by using peak or
valley current mode control methods. However, these methods have complex control circuits or algorithms
and are vulnerable to noise interference because their operation is based on instantaneous peak or valley
current sensing. Additionally, different con
```

### Conclusion / Summary / Future Work:
```text
, VFly is proportional to DA and Vo is
proportional to both DA and DB. Therefore, DA and DB can be
FIGURE 9. Block diagram of proposed two independent single-loop
voltage mode control method: (a) 3-level buck converter circuit diagram,
(b) simplified block diagram of proposed control method, and
(c) proposed control method implemented using simple analog
controllers.
employed to regulate VFly and Vo, respectively. Accordingly,
the proposed control method can be implemented with two
independent single-loop voltage mode controllers for VFly
and Vo, as depicted in Fig. 9. As displayed in the simplified
block diagram of the proposed control method in Fig. 9(b),
Vo control is achieved through the pulse width modulation
(PWM) gate signal. This is generated by comparing the con-
trol signal Vo_ero, which is generated after compensating for
the error between sensed Vo and the control command Vref ,
with the carrier signal VcarB. Independent from Vo control,
VFly control is achieved through the PWM gate signal. This
is generated by comparing the control signal VFly_ero, which
is generated after compensating for the error between sensed
VFly and the control command Vin/2, with the carrier signal
VcarA, having a 180 ◦ phase difference with VcarB. Therefore,
since the proposed control method is simple in terms of its
151388 VOLUME 12, 2024
--- PAGE 8 ---
J.-B. Jeong et al.: Two Independent Single-Loop Voltage Mode Control Method
FIGURE 10. Differences in C Fly charging and discharging currents
according to the carrier signal during control operation (in the case of
VFly < Vin/2, M < 0.5): (a) sawtooth wave carrier signal, (b) triangular
wave carrier signal.
algorithm, it can be implemented with cost-effective and sim-
ple analog controllers, as depicted in Fig. 9(c). Moreover, the
method is robust against noise because it only operates based
on the output and flying capacitor voltages, without requiring
information on the peak or valley currents. Additionally,
since VFly and Vo are independently controlled, concerns
about noise are mitigated, even if the sensing positions for
VFly and Vo are spatially distant from each other, allow-
ing for flexibility in component placement in PCB design.
Furthermore, unlike conventional CMC methods, it ensures
normal operation across all input-to-output voltage conver-
sion ratios without changing the control configuration. The
proposed control method exhibits different control dynamics
depending on the waveform of the carrier sign
```

## [7/10] `energies-11-03086.pdf` (17 pages)

### Metadata & Abstract Snippet:
```text
--- PAGE 1 ---
energies
Article
Control of a DC-DC Buck Converter through
Contraction Techniques
David Angulo-Garcia 1,*, Fabiola Angulo 2, Gustavo Osorio 2 and Gerard Olivar 3
1 Grupo de Modelado Computacional–Dinámica y Complejidad de Sistemas, Instituto de Matemáticas
Aplicadas, Universidad de Cartagena, Carrera 6 # 36–100, Cartagena de Indias 130001, Bolívar, Colombia
2 Departamento de Ingeniería Eléctrica, Electrónica y Computación, Percepción y Control Inteligente–Bloque
Q, Universidad Nacional de Colombia–Sede Manizales, Facultad de Ingeniería y Arquitectura, Campus La
Nubia, Manizales 170003, Colombia; fangulog@unal.edu.co (F.A.); gaosoriol@unal.edu.co (G.O.)
3 Departamento de Matemáticas, Percepción y Control Inteligente–Bloque W, Universidad Nacional de
Colombia–Sede Manizales, Facultad de Ciencias Exactas y Naturales, Campus La Nubia,
Manizales 170003, Colombia; golivart@unal.edu.co
* Correspondence: dangulog@unicartagena.edu.co
Received: 20 September 2018; Accepted: 25 October 2018; Published: 8 November 2018
/gid00030/gid00035/gid00032/gid00030/gid00038/gid00001/gid00033/gid00042/gid00045/gid00001
/gid00048/gid00043/gid00031/gid00028/gid00047/gid00032/gid00046
Abstract: Reliable and robust control of power converters is a key issue in the performance of
numerous technological devices. In this paper we show a design technique for the control of
a DC-DC buck converter with a switching technique that guarantees both good performance and
global stability. We show that making use of the contraction theorem in the Jordan canonical form
of the buck converter, it is possible to ﬁnd a switching surface that guarantees stability but it is
incapable of rejecting load perturbations. To overcome this, we expand the system to include the
dynamics of the voltage error and we demonstrate that the same design procedure is not only able to
stabilize the system to the desired operation point but also to reject load, input voltage, and reference
voltage perturbations.
Keyw
```

### Conclusion / Summary / Future Work:
```text
s and Future Work
In this paper we developed a switched control action for the buck power converter that guarantees
global asymptotic stability, by applying recent results from contraction analysis. To do so, we took
advantage of the Jordan canonical form of the system to fulﬁll the conditions of global stability resulting
from contraction analysis, which wouldn’t have been met in the original form of the system. At ﬁrst,
we applied the design to the original 2D buck converter model where the controller presented good
performance and robustness to voltage reference changes; however, as the load varied, regulation was
lost. To overcome this issue, we extended the 2D-system to take into account the dynamics of the error
inspired by the disturbance-rejection effect of a PI controller. With this design, the controlled system
showed robustness to several types of disturbances including load and input voltage changes.
Although the 3D system is robust, it comes with the price of increasing the settling time respect to
the 2D design. To overcome this issue, one can make use of a different buck converter design (different
capacitance and/or inductance) to achieve the desired time-scale of the dynamics (which is mainly
driven by the factor
√
LC) and then design the controller according to our methodology. It shall be
noticed that other control techniques designed for the buck converter may show better performance in
terms of efﬁciency, however, it is important to stress that the method outlined in this paper is not only
simple in its implementation (design based on hysteresis band) but also quite general. This is because
it is not based on the linearized version of the system but on the nonlinear form, such that the resulting
controller is globally stable, a feature that cannot usually be guaranteed using linearization. Indeed
we have numerically tested the globally stability property by performing extensive simulations for
different initial conditions in the (v, i, y) space. These tests showed convergence for all the simulations.
Throughout this paper we have analyzed and designed the controller assuming that the current
ﬂowing through the inductor is always positive, a topology known as Continuous Conduction Mode
(CCM). Depending on the value of the load and disturbances in it, the buck converter can enter in
--- PAGE 13 ---
Energies 2018, 11, 3086 13 of 17
Discontinuous Conduction Mode (DCM), where the current through the inductor is zero. The control
design tha
```

## [8/10] `energies-14-06214-v2.pdf` (30 pages)

### Metadata & Abstract Snippet:
```text
--- PAGE 1 ---
energies
Article
Cascaded Voltage and Current Control for a Dual Active Bridge
Converter with Current Filters
Michal Gierczynski *
, Lech M. Grzesiak
and Arkadiusz Kaszewski
/gid00030/gid00035/gid00032/gid00030/gid00038/gid00001/gid00033/gid00042/gid00045/gid00001
/gid00048/gid00043/gid00031/gid00028/gid00047/gid00032/gid00046
Citation: Gierczynski, M.;
Grzesiak, L.M.; Kaszewski, A.
Cascaded Voltage and Current
Control for a Dual Active Bridge
Converter with Current Filters.
Energies 2021, 14, 6214. https://
doi.org/10.3390/en14196214
Academic Editor: Mario Marchesoni
Received: 27 July 2021
Accepted: 24 September 2021
Published: 29 September 2021
Publisher’s Note:MDPI stays neutral
with regard to jurisdictional claims in
published maps and institutional afﬁl-
iations.
Copyright: © 2021 by the authors.
Licensee MDPI, Basel, Switzerland.
This article is an open access article
distributed under the terms and
conditions of the Creative Commons
Attribution (CC BY) license (https://
creativecommons.org/licenses/by/
4.0/).
Institute of Control and Industrial Electronics, Warsaw University of Technology, 75 Koszykowa Street,
00-662 Warsaw, Poland; lech.grzesiak@pw.edu.pl (L.M.G.); arkadiusz.kaszewski@pw.edu.pl (A.K.)
* Correspondence: michal.gierczynski@pw.edu.pl
Abstract: The paper describes the cascaded voltage and current control for a bidirectional DC/DC
converter in Dual Active Bridge (DAB) topology. The typical DAB converter circuit was extended by
additional current ﬁlters, which allow it to operate in application ﬁelds with high requirements on
current ripples. The core concept of the presented solution is usage of the modiﬁed Single Phase Shift
(SPS) modulation, which allows to compensate for the DC-bias current occurring in dynamic states
and provides a settling time of half switching cycle during transients. Its features were utilized to
build a simpliﬁed dynamic model of the converter. The linear Proportional-Integral (PI) controllers
are used in 
```

### Conclusion / Summary / Future Work:
```text
that for a given gain margin
value, rising of the controller corner frequency has positive effects on system dynamics. On
the other hand, at some point this effect saturates, as the controller phase lag equals−90◦
in the whole relevant frequency range. The same applies to the amplitude characteristics of
the open-loop system, as at some point the whole relevant part of these characteristics is
ampliﬁed by the falling arm of the PI controller amplitude characteristics, and a further
increase of the corner frequency has no relevant impact on the system behavior. It is then
not important which exact value of the integral time is chosen, as long it assures that the
relevant frequency band of the system lies meaningfully below the corner frequency of
the controller. The already mentioned tuning rule (i.e., the controller corner frequency
ωc (Equation (28)) is separated by at least one whole decade from the one containing the
gain margin cutoff frequency (Equation (24)) calculated for a frequency response of the
plant GP(jω)), which meets this requirement, since the transition zone of the controller
ends approximately one decade below its corner frequency on the logarithmic frequency
scale. In the presented case, the gain margin cutoff frequency calculated for the plant
equals ωgc,P = 3.8× 104 rad/s, i.e., it lies in the decade ω∈
⟨
104; 105⟩
. According to the
formulated rule of thumb the corner frequency should then not be smaller than 106 rad/s
(which corresponds to TI = 1.0× 10−6).
Since there exist a rule on how to choose the integral time, the only parameter left
to tune is the proportional gain of the controller. It can be chosen based on the requested
--- PAGE 12 ---
Energies 2021, 14, 6214 12 of 30
gain margin value. This value should be chosen by a system designer based on the
desirable characteristics of the reference step response. It can be done based on the system
characteristics plotted in Figure 7. There is again a set of six different characteristics, but
this time the integral time of the controller is constant and set to the previously calculated
value of TI = 1.0× 10−6.
101 102 103 104 105
-20
-10
0
10
20
101 102 103 104 105
-225
-180
-135
-90
-45
0
45
101 102 103 104 105
-20
-15
-10
-5
0
5
10
101 102 103 104 105
-60
-40
-20
0
20
40
0 5 10 15 20 25 30
0
0.2
0.4
0.6
0.8
1
1.2
0 5 10 15 20 25 30
-6
-4
-2
0
2
4
a) b)
c) d)
e) f)
Figure 7. The current control loop characteristics at constant integral time of TI = 1.0× 10−6 and for various gain
```

## [9/10] `energies-15-06128.pdf` (21 pages)

### Metadata & Abstract Snippet:
```text
--- PAGE 1 ---
Citation: Hamed, S.B.; Hamed, M.B.;
Sbita, L. Robust Voltage Control of a
Buck DC-DC Converter: A Sliding
Mode Approach. Energies 2022, 15,
6128. https://doi.org/10.3390/
en15176128
Academic Editors: Saad Motahhir,
Najib El Ouanjli and Mustapha
Errouha
Received: 15 June 2022
Accepted: 28 July 2022
Published: 24 August 2022
Publisher’s Note:MDPI stays neutral
with regard to jurisdictional claims in
published maps and institutional afﬁl-
iations.
Copyright: © 2022 by the authors.
Licensee MDPI, Basel, Switzerland.
This article is an open access article
distributed under the terms and
conditions of the Creative Commons
Attribution (CC BY) license (https://
creativecommons.org/licenses/by/
4.0/).
energies
Article
Robust Voltage Control of a Buck DC-DC Converter: A Sliding
Mode Approach
Salah Beni Hamed 1,*, Mouna Ben Hamed 2 and Lassaad Sbita 2
1 Physic Department, High School of Engineers of Tunis, Tunis 1008, Tunisia
2 Electrical Department, National Engineering School of Gabes, Zrig Eddakhlania 6029, Tunisia
* Correspondence: salahbenihamed@yahoo.fr
Abstract: This paper deals with voltage control in a buck DC-DC converter. In fact, dynamic
mathematical equations describing the principle behavior of the above system have been derived.
Due to the nonlinearity of the established model, a nonlinear control algorithm is adopted. It is based
on the sliding mode control approach. To highlight the performance of the latter, a comparative
study with four control algorithms is carried out. The validity of the model and the performance of
the conceived algorithms are veriﬁed in simulation. Both the system and the algorithm controls are
implemented in the Matlab/Simulink environment. Extensive results under different operational
conditions are presented and discussed.
Keywords: buck DC-DC converter; parameter variation; Matlab/Simulink environment; sliding
mode control
1. Introduction
Energy production is one of the most important development priorities. On the
on
```

### Conclusion / Summary / Future Work:
```text
s
In this paper, a mathematical model of the buck DC
-
DC converter is established. A
robust control strategy is adopted for
the output control voltage of the system. The valid-
ity of the latter is demonstrated using the Matlab/Simulink environment. In a comparative
study with four control algorithms
,
PI, IP, FLC and IMC, the simulation results show that
the designed sliding mod
e controller has robust characteristics and a fast dynamic re-
sponse in
the
different studied cases.
Despite all these
good
performances, the chattering phenomenon remains the major
problem of the used sliding mode control algorithm. To avoid this issue, we
intend to use
high
-
order sliding mode control for buck DC
-
DC converter control in future work
s
.
Author Contributions:
Supervision, M.B.H.; Validation, L.S.; Writing
—
review
and
editing, S.B.H.
All authors have read and agreed to the published version of the manuscript.
Funding:
This research received no external funding
.
Institutional Review Board Statement:
Not applicable
.
Informed Consent Statement:
Not applicable
.
Data
Availability Statement:
Not applicable
.
Conflicts of Interest:
The authors declare no conflict of interest.
0
0.05
0.1
0.15
0.2
0.25
0.3
0.35
0.4
0
5
10
Time (s)
Control voltage (v)
Fuzzy logic
IMC
SMC
0
0.05
0.1
0.15
0.2
0.25
0.3
0.35
0.4
0
100
200
300
400
Time (s)
Output voltage (v)
Fuzzy logic
IMC
V
loadref
SMC
0.1
0.1
0.1
0.1
0.1
199.99
200
200.01
Figure 12. DC-DC buck converter parameters variations: (a) trajectory of the inductor, (b) trajectory
of capacitor, (c) control voltage and (d) output voltage.
--- PAGE 19 ---
Energies 2022, 15, 6128 19 of 21
It can be easily noted from both the obtained simulation results for different cases and
the comparative study shown in Table 3 that the highest performance is achieved by the
conceived SMC control algorithm, compared to the others.
7. Conclusions
In this paper, a mathematical model of the buck DC-DC converter is established. A
robust control strategy is adopted for the output control voltage of the system. The validity
of the latter is demonstrated using the Matlab/Simulink environment. In a comparative
study with four control algorithms, PI, IP , FLC and IMC, the simulation results show that
the designed sliding mode controller has robust characteristics and a fast dynamic response
in the different studied cases.
Despite all these good performances, the chattering phenomenon remains
```

## [10/10] `fractalfract-07-00256.pdf` (16 pages)

### Metadata & Abstract Snippet:
```text
--- PAGE 1 ---
Citation: Xie, L.; Wan, D.; Qin, R.
Dual-Loop Voltage–Current Control
of a Fractional-Order Buck-Boost
Converter Using a Fractional-Order
PIλ Controller. Fractal Fract. 2023, 7,
256. https://doi.org/10.3390/
fractalfract7030256
Academic Editor: David Kubanek
Received: 18 January 2023
Revised: 6 March 2023
Accepted: 8 March 2023
Published: 11 March 2023
Copyright: © 2023 by the authors.
Licensee MDPI, Basel, Switzerland.
This article is an open access article
distributed under the terms and
conditions of the Creative Commons
Attribution (CC BY) license (https://
creativecommons.org/licenses/by/
4.0/).
fractal and fractional
Article
Dual-Loop Voltage–Current Control of a Fractional-Order
Buck-Boost Converter Using a Fractional-Order PIλ Controller
Lingling Xie 1, Di Wan 1,* and Rui Qin 2
1 Guangxi Key Laboratory of Power System Optimization and Energy-Saving Technology,
School of Electrical Engineering, Guangxi University, Nanning 530004, China
2 Liuzhou Electricity Supply Bureau, Liuzhou 545005, China
* Correspondence: m15256968200@163.com
Abstract: Based on the fact that the inductor and capacitor are of a non-integer order by nature, to
provide a more accurate theoretical basis for the optimal control of the converter, the fractional-order
model of the Buck-Boost converter in the continuous mode of current is established according to
the fractional-order calculus theory. The fractional-order PIλ control system of the fractional-order
Buck-Boost converter is designed to compare the performance of the integer-order PI controller with
the fractional-order controller. Secondly, the sparrow search algorithm is applied to the optimal
design of the fractional-order PI λ control system of the fractional-order Buck-Boost converter to
improve the system’s phase margin, stability, and robustness. Finally, the simulation is veriﬁed on
the Matlab/Simulink simulation platform and compared with the integer-order PI controller.
Keywords: Buck-Boost converters; fract
```

### Conclusion / Summary / Future Work:
```text
s are given in
Section 5.
2. State Averaging Model for Fractional-Order Buck-Boost Converters
The circuit topology of the fractional-order Buck-Boost converter is shown in Figure 1.
In the ﬁgure, Vin is the power supply voltage, ST and SD are the switching tubes, R is the
circuit resistance, and iL and vC are the inductor current and capacitor voltage, respectively.
α and β are the orders of the inductor and capacitor, respectively.
Fractal Fract. 2023, 7, x FOR PEER REVIEW 2 of 17
controller to control the fractional -order system to form a fully fractional -order system.
Reference [13] established a fractional-order model of the Boost converter in the pseudo -
continuous mode of inductor current and designed a fractional-order nonlinear controller
to improve the dynamic and steady-state performance of the fractional-order system. Ref-
erence [14] proposed a PI λ controller based on the Gray Wolf algorithm as a method for
power factor correction of the internal current controller and the external voltage control-
ler and regulation of the load voltage and compared it with the conventional PI controller.
The simulation results showed the better performance of the PI λ controller based on the
Gray Wolf algorithm. Reference [15] investigated the effect of the fractional-order PIλ con-
troller on the control performance of the Buck converter. It analyzed the impact of the PIλ
controller on the steady -state performance of the system and the stability range of th e
proportional and integral coefficients when λ takes different values under the premise of
ensuring the stability of the system.
The Sparrow Search Algorithm (SSA) is mainly inspired by the foraging and anti -
predation behavior of sparrows. The algorithm is relatively novel, with the advantages of
a strong optimization ability and a fast convergence speed [ 16]. In this paper, the SSA
algorithm is used to optimize the controller parameters and optimize the control perfor-
mance of the control system. This paper is organized as follows. Section 2 uses the frac-
tional-order Caputo calculus definition to build the fractional-order state averaging model
of the Buck-Boost converter and find the transfer function of the converter. In Section 3,
the fractional -order PI λ controller is designed, the fractional -order PI λ control system
model of the fractional-order Buck-Boost converter is built in the Matlab/Simulink simu-
lation platform, and the performance of the fractional -order P
```

