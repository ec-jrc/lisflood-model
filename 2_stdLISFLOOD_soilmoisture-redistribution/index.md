## Soil moisture redistribution 

The description of the moisture fluxes out of the subsoil (and also between the upper- and lower soil layer) is based on the simplifying assumption that the flow of soil moisture is entirely gravity-driven. Starting from **Darcy's law for 1-D vertical flow rate**:

$$
q = - K(\theta ) \cdot [\frac{\partial h(\theta )}{\partial z} -1]
$$

where $q [\frac{mm}{day}]$ is the flow rate out of the soil (e.g. upper soil layer, lower soil layer); $K(\theta) [\frac{mm }{day}]$ is the hydraulic conductivity (as a function of the volumetric moisture content of the soil, $\theta [\frac{mm^3}{ mm^3}]$ and $\frac{\partial h (\theta )}{\partial z}$ is the matric potential gradient. If we assume a matric potential gradient of zero, the equation reduces to:

$$
q = K(\theta )
$$

This implies a flow that is always in downward direction, at a rate that equals the conductivity of the soil. The relationship between hydraulic conductivity and soil moisture status is described by the **Van Genuchten equation** (van Genuchten, 1980), here re-written in terms of mm water slice, instead of volume fractions:

$$
K(w) = K_s \cdot \sqrt{( \frac{w - w_r}{w_s - w_r})} \cdot \{ 1 - [ 1 - ( \frac{w -w_r}{w_s - w_r})^\frac{1}{m}]^m\}^2
$$

where $K_s$ is the **saturated conductivity** of the soil $[\frac{mm}{day}]$, and $w, w_r$ and $w_s$ are the actual, residual and maximum amounts of moisture in the soil respectively (all in $[mm]$). Parameter $m$ is calculated from the pore-size index, $\lambda$ (which is related to soil texture):

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
**'overall' Courant number** for the soil moisture routine is the largest value out of $C_1$ and $C_2$:

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

5. add $$D'_{1,2}$$ to $$D_{1,2}$$; add $$D'_{2,gw}$$ to $$D_{2,gw}$$

If the soil is frozen (*F* \> critical threshold), both $D_{1,2}$ and $D_{2,gw}$ are set to zero. After the iteration loop, the amounts of soil moisture in both layers are updated as follows:

$$
w_1 = w_1 - D_{1,2}
$$

$$
w_2 = w_2 + D_{1,2} - D_{2,gw}
$$

