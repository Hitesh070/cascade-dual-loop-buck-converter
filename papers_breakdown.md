# Detailed Breakdown of Papers in the `papers/` Directory

## Paper: `26439-51855-1-PB.pdf` (Total Pages: 15)

### Introduction / Abstract / Metadata Snippet:
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
According to conventional way of electric power transmission and distribution, these distributed generators
must be connected first to the main grid before thei r produced outputs are able to be transmitted and
distributed to various users. The problem with this approach is a large investment is required to connect these
distributed generators to the main grid. One way to take advantage of these distributed genera tors, without
having to integrate them to the main grid, is to build a microgrids near these distribute d generators and
connect them to th
```

### Extracted Key Sections (Discussion / Conclusion / Results):
#### Conclusion / Summary:
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

## Paper: `7.+15720+72-82.pdf` (Total Pages: 11)

### Introduction / Abstract / Metadata Snippet:
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
transportation. Suitability of the given converter is further
corroborated by the observed charging efficiency . This work can
potentially aim to address the issue of downtime that drivers of electric
three-wheelers may face during peak operating hours. Consequently,
this can open doors for fur ther adoption of light electric vehicles for
public transportation.
Keywords
Light electric vehicle, synchronous
DC-DC converter, non-isolated DC-
DC converter, constant current,
constant voltage
1. Introduction
The usage of fossil fuels in internal comb
```

### Extracted Key Sections (Discussion / Conclusion / Results):
#### Conclusion / Summary:
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
through improvements in charging infrastructure, with emphasis on off-board charging for electric three-wheelers
suited for public transportation. In this regard. This can als o help alleviate any possible issue of vehicle battery
discharge during peak operating hours. Further validation may be done through hardware implementation and
real-time operation of the proposed DC-DC converter topology to gauge the suitability of the given converter for a
higher battery rating and evaluate the charging time.
Acknowledgement
The work is supported financially by
```

## Paper: `energies-14-06214-v2.pdf` (Total Pages: 30)

### Introduction / Abstract / Metadata Snippet:
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
are used in both voltage and current control loops. Based on the developed dynamic models, the
tuning rules for both controllers were derived. In both cases, a number of the tuned parameters
were reduced from two to one (which can present a great practical value for application engineers).
The proposed solutions are validated based on a laboratory prototype. An important part of the
experiments was devoted to non-linear effects occurring near the current limitation boundary of the
system. The paper ends wit
```

### Extracted Key Sections (Discussion / Conclusion / Results):
#### Conclusion / Summary:
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
Figure 7. The current control loop characteristics at constant integral time of TI = 1.0× 10−6 and for various gain margin
Gm,req values: (a,c) amplitude and phase Bode plots of the open-loop system frequency response, (b) amplitude Bode plot
of the closed-loop system frequency response, (d) amplitude Bode plot of the disturbance frequency response of the system,
(e) response of the system on a unit step of the reference signal, (f) response of the system on a unit step of the disturbance
signal.
--- PAGE 13 ---
Energies 2021, 14, 6214 13 of 30
On the other hand, the requested gain margin is varied between t
```

## Paper: `TESEA_vol4_n1_504-galleys.pdf` (Total Pages: 17)

### Introduction / Abstract / Metadata Snippet:
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
was introduced to counter parasitic parameters, which was found to be effective.
© 2023 by the authors. Published by Universidad T ecnológica de Bolívar under the terms of the Creative Commons Attribution 4.0
License. Further distribution of this work must maintain attribution to the author(s) and the published article’s title, journal citation,
and DOI. https://doi.org/10.32397/tesea.vol4.n1.504
1. Introduction
DC-DC converters have become an essential component in many electronic systems due to their ability
to efficiently convert a DC voltage from one level to another 
```

### Extracted Key Sections (Discussion / Conclusion / Results):
#### Conclusion / Summary:
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

