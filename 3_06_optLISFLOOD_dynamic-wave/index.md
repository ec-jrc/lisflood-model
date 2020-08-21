## Diffusive and dynamic wave options

### Introduction

The kinematic solution is the only numerical methodology currently implemented by LISFLOOD. Nevertheless, a future development of the model can feature the implementation of the diffusive or dynamic solutions of the Saint Venant equations. This page describes one option for such a further development.
> Within the current implementation, the option *dynamicWave* must be switched off.



### PCRaster solution of the diffusive wave formulation

PCRaster provides a solution of the diffusive wave formulation of the Saint Venant equations which includes the friction force term, the gravity force term and the pressure force term. The equations are solved as an explicit, finite forward difference scheme. 


#### Time step selection

The numerical solution requires a time step that is much smaller (order of magnitude: seconds-minutes) than the typical overall time step used by LISFLOOD (order of magnitude: hours-day). More specifically, during one (sub) time step no water should be allowed to travel more than 1 cell downstream, i.e.:

$$
\Delta '{t_{dyn}} \le \frac{\Delta x}{V + {c_d}}
$$

where 
    <br> $\Delta't_{dyn}$ is the sub-step for the dynamic wave $[seconds]$, 
    <br> *∆x* is the length of one channel element (pixel) $[m]$, 
    <br> *V* is the flow velocity $[\frac{m}{s}]$ and 
    <br> $c_d$ is dynamic wave celerity $[\frac{m}{s}]$. 

The dynamic wave celerity can be calculated as (Chow, 1988):

$$
{c_d} = \sqrt {gy}
$$

where *g* is the gravitational acceleration $[\frac{m}{s^{2}}]$ and *y* is the flow depth $[m]$. For a cross-section of a regular geometric shape, *y* can be calculated from the channel dimensions. When using irregularly shaped cross-section data, *y* can be approximated by the water level above the channel bed. 

The flow velocity is simply:

$$
V = \frac{Q_{ch}}{A}
$$

where 
    <br> $Q_{ch}$ is the discharge in the channel $[\frac{m^3}{s}]$, and 
    <br> $A$ the cross-sectional area $[m^2]$.

The Courant number, $C_{dyn}$, can now be computed as:

$$
C_{dyn} = \frac{(V + c_d)\Delta t}{\Delta x}
$$

where *∆t* is the overall model time step \[s\]. 
    
The number of sub-steps of the numerical solution is then given by:

$$
SubSteps = \max (1,roundup(\frac{C_{dyn}}{C_{dyn,crit}}))
$$

where $C_{dyn,crit}$ is the critical Courant number. The maximum value of the critical Courant number is 1; in practice it is safer to use a somewhat smaller value such as 0.4. 



#### Input data

A number of additional input files are necessary to solve the diffusion wave equations. First, the channel stretches for which this numerical solution has to be used must be defined by a Boolean map. Next, a cross-section identifier map is needed to links the (diffusion or dynamic wave) channel pixels to the cross-section table (see further down). Further, a channel bottom level map that describes the bottom level of the channel (relative to sea level) is required. Finally, a cross-section table that describes the relationship between water height (*H*), channel cross-sectional area (*A*) and wetted perimeter (*P*) for a succession of *H* levels is needed.

The following table lists all the required inputs:

***Table:***  

| Maps              | Default name  | Description                           | Units                            | Remarks |
| ----------------- | ------------- | ------------------------------------- | -------------------------------- | ------- |
| ChannelsDynamic   | chandyn.map   | dynamic wave channels (1,0)           | -                                | Boolean |
| ChanCrossSections | chanxsect.map | channel cross section IDs             | -                                | nominal |
| ChanBottomLevel   | chblevel.map  | channel bottom level                  | $m$                              |         |
| **Tables**        |               |                                       |                                  |         |
| TabCrossSections  | chanxsect.txt | cross section parameter table (H,A,P) | H: $m$ <br> A: $m^2$ <br> P: $m$ |         |



#### Layout of the cross-section parameter table

The cross-section parameter table is a text file that contains --for each cross-section- a sequence of water levels (*H*) with their corresponding cross-sectional area (*A*) and wetted perimeter (*P*). The format of each line is as follows:

> ID H A P

As an example:

```text
+---------------------------------+
| ID H A P                        |
| 167 0 0 0                       |
| 167 1.507 103.044 114.183       |
| 167 3.015 362.28 302.652        |
| 167 4.522 902.288 448.206       |
| 167 6.03 1709.097 600.382       |
| 167 6.217 1821.849 609.433      |
| 167 6.591 2049.726 615.835      |
| 167 6.778 2164.351 618.012      |
| 167 6.965 2279.355 620.14       |
| 167 7.152 2395.037 626.183      |
| 167 7.526 2629.098 631.759      |
| 167 7.713 2746.569 634.07       |
| 167 7.9 2864.589 636.93         |
| 167 307.9 192201.4874 5225.1652 |
+---------------------------------+
```



Note here that the first *H*-level is always 0, for which *A* and *P* are (of course) 0 as well. For the last line for each cross-section it is recommended to use some very (i.e. unrealistically) high *H*-level. The reason for doing this is that the dynamic wave routine will crash if during a simulation a water level (or cross-sectional area) is simulated which is beyond the range of the table. This can occur due to a number of reasons (e.g. if the measured cross-section is incomplete, or during calibration of the model). To estimate the corresponding values of *A* and *P* one could for example calculate *dA/dH* and *dP/dH* over the last two 'real' (i.e. measured) *H*-levels, and extrapolate the results to a very high *H*-level.

The number of H/A/P combinations that are used for each cross section is user-defined. LISFLOOD automatically interpolates in between the table values.



#### Using the numerical solution wave

The 'lfuser' element has already been edited for the use of the dynamic wave solution. In fact, it contains two parameters that can be set by the user: *CourantDynamicCrit* (which should always be smaller than '1') and a parameter called *DynWaveConstantHeadBoundary*, which defines the boundary condition at the most downstream cell. All remaining dynamic-wave related inputs can be defined in the 'lfbinding' element, and do not require any changes from the user (provided that all default names are used, all maps are in the standard 'maps' directory and the profile table is in the 'tables' directory). In 'lfuser' this will look like this:

```xml
	<comment>                                                           
	**************************************************************               
	DYNAMIC WAVE OPTION                                                   
	**************************************************************               
	</comment>                                                          
	<textvar name="CourantDynamicCrit" value="0.5">                 
	<comment>                                                           
	Critical Courant number for dynamic wave                              
	value between 0-1 (smaller values result in greater numerical         
	accuracy,                                                             
	but also increase computational time)                                 
	</comment>                                                          
	</textvar>                                                          
	<textvar name="DynWaveConstantHeadBoundary" value="0">          
	<comment>                                                           
	Constant head [m] at most downstream pixel (relative to altitude    
	at most downstream pixel)                                             
	</comment>                                                          
	</textvar>                                                          
```

[🔝](#top)

