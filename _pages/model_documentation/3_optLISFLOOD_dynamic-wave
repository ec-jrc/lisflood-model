## Dynamic wave option

**Introduction**

This annex describes the LISFLOOD dynamic wave routine, and how it is used. The current implementation of the dynamic wave function in PCRaster is not a complete dynamic wave formulation according to the summary of the Saint Venant equations as discussed in Chow (1988). The implementation currently consists of the friction force term, the gravity force term and the pressure force term and should therefore be correctly characterised as a diffusion wave formulation. The equations are solved as an explicit, finite forward difference scheme. A straightforward iteration using an Euler solution scheme is used to solve these equations. Dynamic wave routing is *optional*, and can be activated by adding the following line to the 'lfoptions' element:

```xml
	<setoption name="dynamicWave" choice="1" />
```



**Time step selection**

The current dynamic wave implementation requires that all equations are solved using a time step that is much smaller (order of magnitude: seconds-minutes) than the typical overall time step used by LISFLOOD
(order of magnitude: hours-day). More specifically, during one (sub) time step no water should be allowed to travel more than 1 cell downstream, i.e.:

$$
\Delta '{t_{dyn}} \le \frac{{\Delta x}}{{V + {c_d}}}
$$
where $\Delta't_{dyn}$ is the sub-step for the dynamic wave $[seconds]$, *∆x* is the length of one channel element (pixel) $[m]$, *V* is the flow velocity $[\frac{m}{s}]$ and $c_d$ is dynamic wave celerity $[\frac{m}{s}]$. 

The dynamic wave celerity can be calculated as (Chow, 1988):

$$
{c_d} = \sqrt {gy}
$$
where *g* is the acceleration by gravity $[\frac{m}{s^{2}}]$ and *y* is the depth of flow $[m]$. For a cross-section of a regular geometric shape, *y* can be calculated from the channel dimensions. Since the current dynamic wave routine uses irregularly shaped cross-section data, we simply assume than *y* equals the water level above the channel bed. The flow velocity is simply:

$$
V = {Q_{ch}}/A
$$
where $Q_{ch}$ is the discharge in the channel $[\frac{m^3}{s}]$, and *A* the cross-sectional area $[m^2]$.

The Courant number for the dynamic wave, $C_{dyn}$, can now be computed as:

$$
C_{dyn} = \frac{(V + c_d)\Delta t}{\Delta x}
$$
where *∆t* is the overall model time step \[s\]. The number of sub-steps is then given by:

$$
SubSteps = \max (1,roundup(\frac{C_{dyn}}{C_{dyn,crit}}))
$$
where $C_{dyn,crit}$ is the critical Courant number. The maximum value of the critical Courant number is 1; in practice it is safer to use a somewhat smaller value (although if you make it too small the model becomes excessively slow). It is recommended to stick to the default value (0.4) that is used the settings file template.



**Input data** 

A number of addition input files are necessary to use the dynamic wave option. First, the channel stretches for which the dynamic wave is to be used are defined on a Boolean map. Next, a cross-section identifier map is needed that links the (dynamic wave) channel pixels to the cross-section table (see further on). A channel bottom level map describes the bottom level of the channel (relative to sea level). Finally, a cross-section table describes the relationship between water height (*H*), channel cross-sectional area (*A*) and wetted perimeter (*P*) for a succession of *H* levels.

The following table lists all required input:

***Table:***  *Input requirements dynamic wave routine* 

| Maps              | Default name  | Description                           | Units                            | Remarks |
| ----------------- | ------------- | ------------------------------------- | -------------------------------- | ------- |
| ChannelsDynamic   | chandyn.map   | dynamic wave channels (1,0)           | -                                | Boolean |
| ChanCrossSections | chanxsect.map | channel cross section IDs             | -                                | nominal |
| ChanBottomLevel   | chblevel.map  | channel bottom level                  | $m$                              |         |
| **Tables**        |               |                                       |                                  |         |
| TabCrossSections  | chanxsect.txt | cross section parameter table (H,A,P) | H: $m$ <br> A: $m^2$ <br> P: $m$ |         |



**Layout of the cross-section parameter table**

The cross-section parameter table is a text file that contains --for each cross-section- a sequence of water levels (*H*) with their corresponding cross-sectional area (*A*) and wetted perimeter (*P*). The format of each line is as follows:

> ID H A P

As an example:

```xml
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



**Using the dynamic wave**

The 'lfuser' element contains two parameters that can be set by the user: *CourantDynamicCrit* (which should always be smaller than 1) and a parameter called *DynWaveConstantHeadBoundary*, which defines the boundary condition at the most downstream cell. All remaining dynamic-wave related input is defined in the 'lfbinding' element, and doesn't require any changes from the user (provided that all default names are used, all maps are in the standard 'maps' directory and the profile table is in the 'tables' directory). In 'lfuser' this will look like this:

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

