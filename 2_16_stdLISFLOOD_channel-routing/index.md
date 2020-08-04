## Channel routing

Flow through the channel is simulated using the **kinematic wave equations**. The basic equations and the numerical solution are identical to those used for the surface runoff routing:

$$
\frac{\partial Q_{ch}}{\partial x} \cdot \frac{\partial A_{ch}}{\partial t} = q_{ch}
$$

where $Q_{ch}$ is the channel discharge $[\frac{m^3}{s}]$, $A_{ch}$ is the cross-sectional area of the flow $[m^2]$ and $q_ch$ is the amount of lateral inflow per unit flow length $[\frac{m^2}{s}]$. The momentum equation then becomes:

$$
\rho \cdot gA_{ch} \cdot (S_0 - S_f) = 0
$$

where $S_0$ now equals the gradient of the channel bed, and $S_0=S_f$. As with the surface runoff, values for parameter $α_{k,ch}$ are estimated using Manning's equation:

$$
\alpha _{k,ch} = (\frac{n \cdot P_{ch}^{2/3}}{\sqrt{S_0}})^{0.6}; \beta _k=0.6
$$

At present, LISFLOOD uses values for $α_{k,ch}$ which are based on a static (reference) channel flow depth (half bankfull) and measured channel dimensions. The term $q_{ch}$ (**sideflow**) now represents the runoff that enters the channel per unit channel length:

$$
q_{ch} = \frac{\sum Q_{sr} + \sum Q_{uz} + \sum Q_{lz} + Q_{in} + Q_{res} + Q_{lake} - Q_{polder} - totQchan_{abstr} - Evap }{L_{ch}}
$$

Here, $Q_{sr}, Q_{uz}$ and $Q_{lz}$ denote the contributions of surface runoff, outflow from the upper zone and outflow from the lower zone, respectively. $Q_{in}$ is the inflow from an external inflow hydrograph; by default its value is 0, unless the ['inflow hydrograph' option](https://ec-jrc.github.io/lisflood-model/3_optLISFLOOD_inflow-hydrograph/) is activated. $Q_{res}$ is the water that flows out of a reservoir into the channel; by default its value is 0, unless the ['reservoir' option](https://ec-jrc.github.io/lisflood-model/3_optLISFLOOD_reservoirs/) is activated. $Q_{sr}, Q_{uz}, Q_{lz}, Q_{in}$ and $Q_{res}$ are all expressed in [$m^3]$ per time step. $L_{ch}$ is the channel length $[m]$, which may exceed the pixel size ($\Delta x$) in case of meandering channels. The kinematic wave channel routing can be run using a smaller time-step than the over simulation timestep, $\Delta t$, if needed.


[🔝](#top)

