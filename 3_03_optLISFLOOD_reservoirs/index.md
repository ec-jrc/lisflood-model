## Reservoirs

### Introduction

This page describes the LISFLOOD reservoirs routine, and how it is used. The simulation of reservoirs is *optional*, and it can be activated by adding the following line to the 'lfoptions' element:

```xml
	<setoption name="simulateReservoirs" choice="1" />
```

Reservoirs can be simulated on channel pixels where kinematic wave routing is used. The routine does *not* work for channel stretches where the dynamic wave is used!

### Description of the reservoir routine 

Reservoirs are simulated as points in the channel network. The inflow into each reservoir, $I [\frac{m^3}{s}]$, equals the channel flow upstream of the reservoir. Operational rules for reservoirs are not included implicitly in LISFLOOD, but the model mimics them by using a number of rules which define reservoir output as a function of the relative filling. The relative filling of a reservoir, $F$, is the ratio between the water volume stored in the reservoir at a specific time step, $V_t\ [m^3]$, and its total storage capacity, $S\ [m^3]$:

$$
F = \frac{V_t}{S} \in [0, 1]
$$

There are three _special_ relative filling levels:
- The _conservative storage limit_, $L_c$, is the lower limit of reservoir water storage (reservoirs are never completely empty).
- The _flood storage limit_, $L_f$, is the upper limit of the operational relative filling (reservoirs are never filled completly for safety reasons).
- The _normal storage capacity_, $L_n$, is the available capacity of a reservoir. It is a value in between $L_f$ and $L_c$. 

Three discharge values define the way the outflow $[\frac{m^3}{s}]$ of a reservoir is regulated. 
- The _minimum outflow_, $Q_{min}$, is the lowest discharge that is maintained for e.g. ecological reasons. 
- The _non-damaging outflow_, $Q_{nd}$, is the maximum possible outflow that will not cause problems downstream.
- The _normal outflow_, $Q_{n}$, is the one valid when the reservoir is within its _normal storage_ filling level.

The previous six parameters ($L_c$, $L_f$, $L_n$, $Q_{min}$, $Q_{nd}$, $Q_{n}$) are input data. Apart from them, there are two adimensional calibration parameters that modulate the reservoir behaviour when its normal filling ($L_n$) is exceeded. 

* $\alpha$ defines a new filling level in between $L_n$ and $L_f$. Therefore, it can assume values between 0.01 and 0.99.
$$
L_{n,adj} = L_n + \alpha \cdot (L_f - L_n)
$$
* $\beta$ defines the outflow at the previous $L_{n,adj}$ filling level. It can assume values between 0.25 and 2.
$$
Q_{n,adj} = \beta \cdot Q_{n} \\
Q_{min} \lt Q_{n,adj} \lt Q_{nd}
$$

The outflow, $Q \; [\frac{m^3}{s}]$, depends on the reservoir relative filling:

$$
Q = \begin{cases} \\
\min\left(Q_{min}, \; \frac{V_t}{\Delta t}\right) & if \; F \le 2 \cdot L_c \\
Q_{min} + \left( Q_{n,adj}  - Q_{min} \right) \cdot \frac{F - 2 \cdot L_c}{L_n - 2 \cdot L_c} & if \; 2 \cdot L_c \lt F \le L_n \\
Q_{n,adj} & if \; L_n \lt F \le  L_{n,adj} \\
Q_{n,adj}  + (Q_{nd} - Q_{n,adj}) \cdot \frac{F - L_{n,adj}}{L_f - L_{n,adj}} & if \; L_{n,adj} \lt F \le L_f \\
\max \left( \left( F - L_f -0.01 \right) \cdot \frac{S}{\Delta t} , \; Q_{max} \right) & if \; F \gt L_f \\
\end{cases}
$$
where $\Delta t$ is the duration of a time step in seconds (for a daily simulation it would be 86400 s), and
$$
Q_{max} = \min \left( Q_{nd} , \; \max \left( 1.2 \cdot I , \, Q_{n,adj} \right) \right)
$$

Finally, the following condition prevents the outflow from being too large compared to the inflow.

$$
Q = \min \left( Q , \max \left( I , Q_{n,adj} \right) \right) \quad \text{if} \quad Q > 1.2 \cdot I \quad \text{and} \quad L_{n,adj} < F < L_f
$$

***
<font color='red'>
$$
Q = \begin{cases} \\
Q_{min} & if \; F \le 2 \cdot L_c \\
Q_{min} + \left( Q_{n,adj}  - Q_{min} \right) \cdot \frac{F - 2 \cdot L_c}{L_n - 2 \cdot L_c} & if \; 2 \cdot L_c \lt F \le L_n \\
Q_{n,adj} & if \; L_n \lt F \le  L_{n,adj} \\
\min \left( Q_{n,adj}  + (Q_{nd} - Q_{n,adj}) \cdot \frac{F - L_{n,adj}}{L_f - L_{n,adj}} , \; \max \left( 1.2 \cdot I , \; Q_{n,adj} \right) \right) & if \; L_{n,adj} \lt F \le L_f \\
\max \left( \left( F - L_f \right) \cdot \frac{S}{\Delta t} , \; \min \left( Q_{nd} , \; \max \left( 1.2 \cdot I , \, Q_{n,adj} \right) \right) \right) & if \; F \gt L_f \\
\end{cases}
$$

where $\Delta t$ is the duration of a time step in seconds (for a daily simulation it would be 86400 s). Finally, the following condition prevents the reservoir from emptying below $L_c$ or from overtopping.

$$
Q = \max \left( \min \left( Q , \; \frac{ \left( F - L_c \right) \cdot S}{\Delta t} \right) , \; \frac{ \left( F - 1 \right) \cdot S}{\Delta t} \right)
$$

<font color='red'>**Changes**</font>
* <font color='red'>When $F \le 2 \cdot L_c$, I've removed the minimum limitation because I apply it at the very end. Apart from that, the limitation is now $\frac{V_t - V_c}{\Delta t}$ instead of simply $\frac{V_t}{\Delta t}$, so that the reservoir storage is never below the conservative limit.</font>
* <font color='red'>When $L_{n,adj} \lt F \le L_f$, I've added the limitation that was previously done in the end of the routine, since it only applies to this storage zone. On top of it, I have changed the limitation to $\max \left( 1.2 \cdot I , \, Q_{n,adj} \right)$ instead of $\max \left( I , \, Q_{n,adj} \right)$ to be coherent with the rule in the following storage zone.</font>
* <font color='red'>When $F \gt L_f$, I've removed the $\frac{0.01 \cdot S}{\Delta t}$ reduction of the outflow, because I don't understand its purpose and a 1% of the total volume can be a very large discharge if released in a single time step.</font>
* <font color='red'>I've added a condition at the end of the routine to make sure that the storage stays between the conservative limit and the total capacity.</font>
</font>
***

***
<font color='green'>
$$
Q = \begin{cases} \\
Q_{min} & if \; F \le 2 \cdot L_c \\
Q_{min} + \left( Q_{n,adj}  - Q_{min} \right) \cdot \frac{F - 2 \cdot L_c}{L_n - 2 \cdot L_c} & if \; 2 \cdot L_c \lt F \le L_n \\
Q_{n,adj} & if \; L_n \lt F \le  L_{n,adj} \\
\min \left( Q_{n,adj}  + (Q_{nd} - Q_{n,adj}) \cdot \frac{F - L_{n,adj}}{L_f - L_{n,adj}} , \; \max \left( 1.2 \cdot I , \; Q_{n,adj} \right) \right) & if \; L_{n,adj} \lt F \le L_f \\
\max \left( Q_{nd} , \; I \right) & if \; F \gt L_f \\
\end{cases}
$$

where $\Delta t$ is the duration of a time step in seconds (for a daily simulation it would be 86400 s). Finally, the following condition prevents the reservoir from emptying below $L_c$ or from overtopping.

$$
Q = \max \left( \min \left( Q , \; \frac{ \left( F - L_c \right) \cdot S}{\Delta t} \right) , \; \frac{ \left( F - 1 \right) \cdot S}{\Delta t} \right)
$$

<font color='green'>**Changes**</font>
* <font color='green'>When $F \le 2 \cdot L_c$, I've removed the minimum limitation because I apply it at the very end. Apart from that, the limitation is now $\frac{V_t - V_c}{\Delta t}$ instead of simply $\frac{V_t}{\Delta t}$, so that the reservoir storage is never below the conservative limit.</font>
* <font color='green'>When $L_{n,adj} \lt F \le L_f$, I've added the limitation that was previously done in the end of the routine, since it only applies to this storage zone. On top of it, I have changed the limitation to $\max \left( 1.2 \cdot I , \, Q_{n,adj} \right)$ instead of $\max \left( I , \, Q_{n,adj} \right)$ to be coherent with the rule in the following storage zone.</font>
* <font color='green'>When $F \gt L_f$, I've removed the $\frac{0.01 \cdot S}{\Delta t}$ reduction of the outflow, because I don't understand its purpose and a 1% of the total volume can be a very large discharge if released in a single time step.</font>
* <font color='green'>I've added a condition at the end of the routine to make sure that the storage stays between the conservative limit and the total capacity.</font>
</font>
***

    
Summary of symbols:
<br>&nbsp;&nbsp;&nbsp;&nbsp;$S$:		Reservoir storage capacity $[m^3]$
<br>&nbsp;&nbsp;&nbsp;&nbsp;$F$:		Reservoir relative filling (1 at total storage capacity) \[-\]
<br>&nbsp;&nbsp;&nbsp;&nbsp;$I$:	Reservoir inflow $[\frac{m^3} {s}]$
<br>&nbsp;&nbsp;&nbsp;&nbsp;$Q$:	Reservoir outflow $[\frac{m^3} {s}]$
<br>&nbsp;&nbsp;&nbsp;&nbsp;$L_c$:	Conservative storage limit \[-\]
<br>&nbsp;&nbsp;&nbsp;&nbsp;$L_n$:	Normal storage limit \[-\]
<br>&nbsp;&nbsp;&nbsp;&nbsp;$L_f$:	Flood storage limit \[-\]
<br>&nbsp;&nbsp;&nbsp;&nbsp;$Q_{min}$:	Minimum outflow $[\frac{m^3} {s}]$
<br>&nbsp;&nbsp;&nbsp;&nbsp;$Q_{n}$:	Normal outflow $[\frac{m^3} {s}]$
<br>&nbsp;&nbsp;&nbsp;&nbsp;$Q_{nd}$:	Non-damaging outflow  $[\frac{m^3} {s}]$
<br>&nbsp;&nbsp;&nbsp;&nbsp;$\alpha$:	calibration parameter used to modulate $L_n$ \[-\] (`adjust_Normal_FLood` in the settings file)
<br>&nbsp;&nbsp;&nbsp;&nbsp;$\beta$:	calibration parameter used to modulate $Q_{n}$ \[-\] (`ReservoirRnormqMult` in the settings file)

>**Note**. The reservoir outflow is calculated using the same computational time interval used for the channel routing.

![Reservoirs_operation](../media/reservoirs_routine.png)

***Figure:*** *Schematic of the reservoir routine.*

### Preparation of input data 

For the simulation of reservoirs a number of additional input files are necessary. 

1. The locations of the reservoirs are defined on a (nominal) map called *res.map*. It is important that all reservoirs are located on a channel pixel (you can verify this by displaying the reservoirs map on top of the channel map). Also, since each reservoir receives its inflow from its upstream neighbouring channel pixel, you may want to check if each reservoir has any upstream channel pixels at all; if not, the reservoir will gradually empty during a model run!. 
2. The management of the reservoirs is described by 7 tables (TXT files). Each of these tables should contain as many lines as reservoirs, and each line contains two columns (tab separated) with the reservoir ID and the value of the corresponding characteristic. An example of such text file is as follows:

```text
1	77.2
2	79.9
```

The following table lists all required input:

***Table:*** *Input requirements for the reservoir routine.*

| **Maps**    | **Default name**   | **Description** | **Units**   | **Remarks** |
|-------------|--------------------|-----------------|-------------|-------------|
| ReservoirSites | res.map     | reservoir locations  | \-          | nominal     |
| TabTotStorage | rtstor.txt  | reservoir storage capacity  | $[m^3]$ |             |
| TabConservativeStorageLimit | rclim.txt   | conservative storage limit | \-          | fraction of storage |
| TabNormalSt orageLimit| rnlim.txt   | normal storage limit     | \-          | capacity    |
| TabFloodStorageLimit | rflim.txt   | flood storage limit      | \-          |             |
| TabMinOutflowQ | rminq.txt   | minimum outflow    | $[m^3]$ |             |
| TabNormalOutflowQ | rnormq.txt  | normal outflow     | $[m^3]$ |             |
| TabNonDamagingOutflowQ | rndq.txt    | non-damaging outflow | $[m^3]$ |             |

When you create the map with the reservoir sites, pay special attention to the following: if a reservoir is on the most downstream cell (i.e. the outlet of the catchment, see Figure below), the reservoir routine may produce erroneous output. In particular, the mass balance errors cannot be calculated correctly in that case. The same applies if you simulate only a sub-catchment of a larger map (by selecting the subcatchment in the mask map). This situation can usually be avoided by extending the mask map donwstream by one cell in downstream direction.

![Placement of the reservoirs](../media/image42.png)

***Figure:*** *Placement of the reservoirs: reservoirs on the outlet (left) result in erroneous behavior of the reservoir routine.*

### Preparation of settings file

All in- and output files need to be defined in the settings file. If you are using a default LISFLOOD settings template, all file definitions are already defined in the `lfbinding` element. Just make sure that the map with the reservoir locations is in the "maps" directory, and all tables in the "tables" directory. 
Finally, you have to tell LISFLOOD that you want to simulate reservoirs. To do this, add the following statement to the `lfoptions` element:

```xml
	<setoption name="simulateReservoirs" choice="1" />
```

Now you are ready to run the model. If you want to compare the model results both with and without the inclusion of reservoirs, you can switch off the simulation of reservoirs either by:

1.  Removing the `simulateReservoirs` statement from the `lfoptions` element, or
2.  changing it into `\<setoption name="simulateReservoirs" choice="0" /\>`.

Both have exactly the same effect. You don't need to change anything in either `lfuser` or `lfbinding`; all file definitions here are simply ignored during the execution of the model.

### Reservoir output files

The reservoir routine produces 3 additional time series and one map, as listed in the following table:

***Table:***  *Output of reservoir routine.*                    

| **Maps / Time series** | **Default name** | **Description**                       | **Units**       | **Remarks** |
| ---------------------- | ---------------- | ------------------------------------- | --------------- | ----------- |
| ReservoirFillState     | rsfilxxx.xxx     | reservoir fill at last time step[^10] | \-              |             |
| ReservoirInflowTS      | qresin.tss       | inflow into reservoirs                | $\frac{m^3}{s}$ |             |
| ReservoirOutflowTS     | qresout.tss      | outflow out of reservoirs             | $\frac{m^3}{s}$ |             |
| ReservoirFillTS        | resfill.tss      | reservoir fill                        | \-              |             |
                                                     
Note that you can use the map with the reservoir fill at the last time step to define the initial conditions of a succeeding simulation, e.g.:

```xml
	<textvar name="ReservoirInitialFillValue" value="/mycatchment/rsfil000.730">
```

[🔝](#top)