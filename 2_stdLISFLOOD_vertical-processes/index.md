# Drainage (vertical flow processes)

## Frost index soil

When the soil surface is frozen, this affects the hydrological processes occurring near the soil surface. To estimate whether the soil surface is frozen or not, a frost index *F* is calculated. The equation is based on
Molnau & Bissell (1983, cited in Maidment 1993), and adjusted for variable time steps. The rate at which the frost index changes is given by:
$$
\frac{dF}{dt} = - (1 - {A_f})\cdot F - {T_{av}} \cdot {e^{ - 0.04 \cdot K \cdot {d_s}/w \cdot {e_s}}}
$$
$\frac{dF}{dt}$ is expressed in $[\frac{\circ C}{day} \cdot \frac{1}{day}]$.  $A_f$ is a decay coefficient $[\frac{1}{day}]$, $K$ is a a snow depth reduction coefficient $[\frac{1}{cm}]$, $d_s$ is the (pixel-average) depth of the snow cover (expressed as $mm$ equivalent water depth), and $w \cdot e_s$ is a parameter called snow water equivalent, which is the equivalent water depth water of a snow cover (Maidment, 1993). In LISFLOOD, $A_f$ and $K$ are set to 0.97 and 0.57 $[\frac{1}{cm}]$ respectively, and $w \cdot e_s$ is taken as 0.1, assuming an average snow density of 100 $\frac{kg}{m^3}$ (Maidment, 1993). The soil is considered frozen when the frost index rises above a critical threshold of 56. For each time step the value of $F$ $[\frac{\circ C}{ day}]$ is updated as:
$$
F(t) = F(t - 1) + \frac{dF}{dt}\Delta t
$$

>  Note: $F$ is not allowed to become less than 0.

When the frost index rises above a threshold of 56, every soil process is frozen and transpiration, evaporation, infiltration and the outflow to the second soil layer and to upper groundwater layer is set to zero.
Any rainfall is bypassing the soil and transformed into surface runoff till the frost index is equal or less than 56.




## Water available for infiltration and direct runoff

In the permeable fraction of each pixel $(1- f_{dr})$, the amount of water that is available for infiltration, $W_{av}$ $[mm]$ equals (Supit *et al.*,1994):
$$
W_{av} = R \cdot \Delta t + M + D_{int} - Int
$$
where:

  $R$: 		Rainfall $[\frac{mm}{day}]$
  $M$: 	Snow melt $[mm]$
  $D_{int}$: 	Leaf drainage $[mm]$
  $Int$: 	Interception $[mm]$
  $\Delta t$: 	time step $[days]$

Since no infiltration can take place in each pixel's 'direct runoff fraction', direct runoff is calculated as:
$$
R_d = f_{dr} \cdot W_{av}
$$
where $R_d$ is in $mm$ per time step. Note here that $W_{av}$ is valid for the permeable fraction only, whereas $R_d$ is valid for the direct runoff fraction.




## Infiltration capacity

The infiltration capacity of the soil is estimated using the widely-used Xinanjiang (also known as VIC/ARNO) model (e.g. Zhao & Lui, 1995; Todini, 1996). This approach assumes that the fraction of a grid cell that is contributing to surface runoff (read: saturated) is related to the total amount of soil moisture, and that this relationship can be described through a non-linear distribution function. For any grid cell, if $w_1$ is the total moisture storage in the upper soil layer and $w_s1$ is the maximum storage, the corresponding saturated fraction $A_s$ is approximated by the following distribution function:
$$
A_s = 1 - (1 - \frac{w_1}{w_{s1}})^b
$$
where $w_{s1}$ and $w_1$ are the maximum and actual amounts of moisture in the upper soil layer, respectively $[mm]$, and $b$ is an empirical shape parameter. In the LISFLOOD implementation of the Xinanjiang model, $A_s$ is defined as a fraction of the permeable fraction of each pixel (i.e. as a fraction of $(1-d_{rf})$). The infiltration capacity $INF_{pot} [mm]$ is a function of $w_s$ and $A_s$:
$$
INF_{pot}= \frac{w_{s1}}{b + 1} - \frac{w_{s1}}{b +1} \cdot [1 - (1 - A_s)^{\frac{b + 1}{b}}]
$$
Note that the shape parameter *b* is related to the heterogeneity within each grid cell. For a totally homogeneous grid cell *b* approaches zero, which reduces the above equations to a simple 'overflowing bucket' model. Before any water is draining from the soil to the groundwater zone the soil has to be completely filled up. See also red line in the Figure below: e.g. a soil of 60% soil moisture has 40% potential
infiltration capacity. A $b$ value of 1.0 (see black line) is comparable to a leaking bucket : e.g. a soil of 60% soil moisture has only 10% potential infiltration capacity while 30% is draining directly to groundwater. 

![Soil moisture and potential infiltration capacity relation](../media/image27.png)
***Figure:*** *Soil moisture and potential infiltration capacity relation.*

Increasing $b$ even further than 1 is comparable to a sieve (see figure below). Most of the water is going directly to groundwater and the potential infiltration capacity is going toward 0.

![Xinanjiang empirical shape parameter](../media/image28.png)
***Figure:*** *Analogy picture of increasing Xinanjiang empirical shape parameter* $b$.




## Actual infiltration and surface runoff

The actual infiltration $INF_{act} \  [mm]$ is now calculated as:
$$
INF_{act} = min (INF_{pot},W_{av} - D_{pref,gw})
$$
Finally, the surface runoff $R_s \ [mm]$ is calculated as:
$$
R_s = R_d + (1 - f_{dr}) \cdot (W_{av} - D_{pref,gw} - INF_{act})
$$
where $R_d$ is the direct runoff (generated in the pixel's 'direct runoff fraction'). If the soil is frozen (*F* \> critical threshold) no infiltration takes place. The amount of moisture in the upper soil layer is updated after the infiltration calculations:
$$
w_1 = w_1 + INF_{act}
$$



## Soil moisture redistribution 

The description of the moisture fluxes out of the subsoil (and also between the upper- and lower soil layer) is based on the simplifying assumption that the flow of soil moisture is entirely gravity-driven. Starting from Darcy's law for 1-D vertical flow:
$$
q = - K(\theta ) \cdot [\frac{\partial h(\theta )}{\partial z} -1]
$$
where $q [\frac{mm}{day}]$ is the flow rate out of the soil (e.g. upper soil layer, lower soil layer); $K(\theta) [\frac{mm }{day}]$ is the hydraulic conductivity (as a function of the volumetric moisture content of the soil, $\theta [\frac{mm^3}{ mm^3}]$ and $\frac{\partial h (\theta )}{\partial z}$ is the matric potential gradient. If we assume a matric potential gradient of zero, the equation reduces to:
$$
q = K(\theta )
$$
This implies a flow that is always in downward direction, at a rate that equals the conductivity of the soil. The relationship between hydraulic conductivity and soil moisture status is described by the Van Genuchten equation (van Genuchten, 1980), here re-written in terms of mm water slice, instead of volume fractions:
$$
K(w) = K_s \cdot \sqrt{( \frac{w - w_r}{w_s - w_r})} \cdot \{ 1 - [ 1 - ( \frac{w -w_r}{w_s - w_r})^\frac{1}{m}]^m\}^2
$$
where $K_s$ is the saturated conductivity of the soil $[\frac{mm}{day}]$, and $w, w_r$ and $w_s$ are the actual, residual and maximum amounts of moisture in the soil respectively (all in $[mm]$). Parameter $m$ is calculated from the pore-size index, $\lambda$ (which is related to soil texture):
$$
m = \frac{\lambda }{\lambda + 1}
$$
For large values of *Δt* (e.g. 1 day) the above equation often results in amounts of outflow that exceed the available soil moisture storage, i.e:
$$
K(w)\Delta t \gt {w - w_r}
$$
In order to solve the soil moisture equations correctly an iterative procedure is used. At the beginning of each time step, the conductivities for both soil layers $[K_1(w_1), K_2(w_2)]$ are calculated using the Van Genuchten equation. Multiplying these values with the time step and dividing by the available moisture gives a Courant-type numerical stability indicator for each respective layer:
$$
C_1 = \frac{K_1(w_1) \cdot \Delta t}{w_1 - w_{r1}}
$$

$$
C_2 = \frac{K_2(w_2) \cdot \Delta t}{w_2 - w_{r2}}
$$

A Courant number that is greater than 1 implies that the calculated outflow exceeds the available soil moisture, resulting in loss of mass balance. Since we need a stable solution for both soil layers, the
'overall' Courant number for the soil moisture routine is the largest value out of $C_1$ and $C_2$:
$$
C_{soil} = max (C_1,C_2)
$$
In principle, rounding $C_{soil}$ up to the nearest integer gives the number sub-steps needed for a stable solution. In practice, it is often preferable to use a critical Courant number that is lower than 1, because high values can result in unrealistic 'jumps' in the simulated soil moisture pattern when the soil is near saturation (even though mass balance is preserved). Hence, making the critical Courant number a
user-defined value $C_{crit}$, the number of sub-steps becomes:
$$
SubSteps = roundup(\frac{C_{soil}}{C_{crit}})
$$
and the corresponding sub-time-step, $\Delta 't$:
$$
\Delta 't = \frac{\Delta t}{SubSteps}
$$
In brief, the iterative procedure now involves the following steps. First, the number of sub-steps and the corresponding sub-time-step are computed as explained above. The amounts of soil moisture in the upper
and lower layer are copied to temporary variables $w'_1$ and $w'_2$. Two variables, $D_{1,2}$ (flow from upper to lower soil layer) and $D_{2,gw}$ (flow from lower soil layer to groundwater) are initialized (set to zero). Then, for each sub-step, the following sequence of calculations is performed:

1. compute hydraulic conductivity for both layers

2. compute flux from upper to lower soil layer for this sub-step ($D'_{1,2}$, can never exceed storage capacity in lower layer):
   $$
   D'_{1,2} = min [K_1(w'_1)\Delta t,w'_{s2} -w'_2]
   $$

3. compute flux from lower soil layer to groundwater for this sub-step ($D'_{2,gw}$), can never exceed available water in lower layer):
   $$
   D'_{2,gw} = min [K_2(w'_2)\Delta t,w'_2 -w'_{r2}]
   $$

4. update $w'_1$ and $w'_2$

5. add $D'_{1,2}$ to $D_{1,2}$; add $D'_{2,gw}$ to $D_{2,gw}$

If the soil is frozen (*F* \> critical threshold), both $D_{1,2}$ and $D_{2,gw}$ are set to zero. After the iteration loop, the amounts of soil moisture in both layers are updated as follows:
$$
w_1 = w_1 - D_{1,2}
$$

$$
w_2 = w_2 + D_{1,2} - D_{2,gw}
$$


## Preferential bypass flow

For the simulation of preferential bypass flow --i.e. flow that bypasses the soil matrix and drains directly to the groundwater- no generally accepted equations exist. Because ignoring preferential flow completely
will lead to unrealistic model behavior during extreme rainfall conditions, a very simple approach is used in LISFLOOD. During each time step, a fraction of the water that is available for infiltration is added to the groundwater directly (i.e. without first entering the soil matrix). It is assumed that this fraction is a power function of the relative saturation of the topsoil, which results in an equation that is somewhat similar to the excess soil water equation used in the HBV model (e.g. Lindström *et al*., 1997):
$$
D_{pref,gw} =W_{av} \cdot (\frac{w_1}{w_{s1}})^{c_{pref}}
$$
where $D_{pref,gw}$ is the amount of preferential flow per time step $[mm]$, $W_{av}$ is the amount of water that is available for infiltration, and $c_{pref}$ is an empirical shape parameter. $f_{dr}$ is the 'direct runoff fraction' \[-\], which is the fraction of each pixel that is made up by urban area and open water bodies (i.e. preferential
flow is only simulated in the permeable fraction of each pixel) . The equation results in a preferential flow component that becomes increasingly important as the soil gets wetter.

The Figure below shows with $c_{pref} = 0$ (red line) every available water for infiltration is converted into preferential flow and bypassing the soil. $c_{pref} = 1$ (black line) gives a linear relation e.g. at 60% soil saturation 60% of the available water is bypassing the soil matrix. With increasing $c_{pref}$ the percentage of preferential flow is decreasing.

![Soil moisture and preferential flow relation](../media/image34.png)
***Figure:*** *Soil moisture and preferential flow relation.*




## Groundwater

Groundwater storage and transport are modelled using two parallel linear reservoirs, similar to the approach used in the HBV-96 model (Lindström et al., 1997). The upper zone represents a quick runoff component, which includes fast groundwater and subsurface flow through macro-pores in the soil. The lower zone represents the slow groundwater component that generates the base flow. The outflow from the upper zone to the channel, $Q_{uz} [mm]$ equals:
$$
Q_{uz} = \frac{1}{T_{uz}} \cdot UZ \cdot \Delta t
$$
where $T_{uz}$ is a reservoir constant $[days]$ and $UZ$ is the amount of water that is stored in the upper zone $[mm]$. Similarly, the outflow from the lower zone is given by:
$$
Q_{lz} = \frac{1}{T_{lz}} \cdot LZ \cdot \Delta t
$$
Here, $T_{lz}$ is again a reservoir constant $[days]$, and $LZ$ is the amount of water that is stored in the lower zone $[mm]$. The values of both $T_{uz}$ and $T_{lz}$ are obtained by calibration. The upper zone also provides the inflow into the lower zone. For each time step, a fixed amount of water percolates from the upper to the lower zone:
$$
D_{uz,lz} = min (GW_{perc} \cdot \Delta t ,UZ)
$$
Here, $GW_{perc} \ [\frac{mm}{day}]$ is a user-defined value that can be used as a calibration constant. For many catchments it is quite reasonable to treat the lower groundwater zone as a system with a closed lower boundary (i.e. water is either stored, or added to the channel). However, in some cases the closed boundary assumption makes it impossible to obtain realistic simulations. Because of this, it is possible to percolate a fixed amount of water out of the lower zone, as a loss $D_{loss}$:
$$
D_{loss} = min(f_{loss} \cdot \Delta t,LZ)
$$
In the previous version of LISFLOOD $D_{loss}$, was calculated as a fixed fraction of $Q_{lz}$, but this leads to a high dependency of $D_{loss}$ from $GW_{perc}$ and $LZ$. For example if either $GW_{perc}$ or $LZ$ is quite low the parameter $D_{loss}$ turns out to be meaningless.

The loss fraction, $f_{loss}$ \[-\], equals 0 for a completely closed lower boundary. If $f_{loss}$ is set to 1, all outflow from the lower zone is treated as a loss. Water that flows out of the lower zone through $D_{loss}$ is quite literally 'lost' forever. Physically, the loss term could represent water that is either lost to deep groundwater systems (that do not necessarily follow catchment boundaries), or even groundwater extraction wells. When using the model, it is suggested to use $f_{loss}$ with some care; start with a value of zero, and only use any other value if it is impossible to get satisfactory results by adjusting the other calibration parameters. At each time step, the amounts of water in the upper and lower zone are updated for the in- and outgoing fluxes, i.e.:
$$
UZ_t = UZ_{t - 1} + D_{2,gw} - D_{uz,lz} - Q_{uz}
$$

$$
LZ_t = LZ_{t - 1} + D_{uz,lz} - Q_{lz} - D_{loss}
$$

Note that these equations are again valid for the permeable fraction of the pixel only: storage in the direct runoff fraction equals 0 for both $UZ$ and $LZ$.

[🔝](#top)

