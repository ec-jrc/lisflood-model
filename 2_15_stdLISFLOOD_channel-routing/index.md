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
\alpha_{k,ch} = (\frac{n \cdot P_{ch}^{2/3}}{\sqrt{S_0}})^{0.6}; \beta_k=0.6
$$

where $n$ is Manning’s roughness coefficient and $P_{ch}$ is the wetted perimeter of the channel cross-section. The $n$ roughness value is a calibrated parameter. LISFLOOD assumes a trapezoidal cross section shape and $P_{ch}$ is computed using a static (reference) channel flow depth (half bankfull). Cross section bottom  and top width and bank slope value are provided as input data to the model (these values can be retrieved from local or global databases).

The term $q_{ch}$ (**sideflow**)  represents the runoff that enters the channel per unit channel length:

$$
q_{ch} = \frac{\sum Q_{sr} + \sum Q_{uz} + \sum Q_{lz} + Q_{in} + Q_{res} + Q_{lake} - totQchan_{abstr} - EvapChan }{L_{ch}}
$$

Here, the positive sign indicates water volumes that are addded to the channel flow, conversely, the negative sign indicates water volumes that are removed from the channel. Each contribution (with both positive and negative sign) is defined hereafter. 
* $Q_{sr}, Q_{uz}$ and $Q_{lz}$ denote the contributions of surface runoff, outflow from the upper zone and outflow from the lower zone, respectively. 
* $Q_{in}$ is the inflow from an external inflow hydrograph; by default its value is 0, unless the ['inflow hydrograph' option](https://ec-jrc.github.io/lisflood-model/3_optLISFLOOD_inflow-hydrograph/) is activated. 
* $Q_{res}$ is the water that flows out of a reservoir into the channel; by default its value is 0, unless the ['reservoir' option](https://ec-jrc.github.io/lisflood-model/3_optLISFLOOD_reservoirs/) is activated. 
* $Q_{lake}$ is the water that flows out of a lake into the channel; by default its value is 0, unless the ['lake' option](https://ec-jrc.github.io/lisflood-model/3_02_optLISFLOOD_lakes/) is activated. 
* $totQchan_{abstr}$ is the total volume of water removed from the channel to respond to domestic, agricoltural, livestock, energetic, and industrial water demands. $totQchan_{abstr}$ is by default 0, unless the ['water use' option](https://ec-jrc.github.io/lisflood-model/2_18_stdLISFLOOD_water-use/) is activated. 
* $EvapChan$ is the volume of water that evaporates from the channel; its value is by default 0, unless the ['openwaterevapo' option](https://ec-jrc.github.io/lisflood-code/4_annex_settings_and_options/) is activated. The volume of potential evaporation from water surface per time step is given by the product of teh potential evaporation rate from an open water surface $EW0$ times the pixel water fraction $F_{water}$. $F_{water}$ can be constant or change every month ($ f_{water,i}$, with $i = 1,2,\ldots 12$), as detailed in the ['variable water fraction' chapter](https://ec-jrc.github.io/lisflood-model/3_12_optLISFLOOD_varfractionwater/). The actual evaporation form the channel cannot exceed the 90% of the channel discharge.

$Q_{sr}, Q_{uz}, Q_{lz}, Q_{in}$, $Q_{res}$, $Q_{lake}$, $totQchan_{abstr}$, and $EvapChan$ are all expressed in $[m^3]$ per time step. $L_{ch}$ is the channel length $[m]$, which may exceed the pixel size ($\Delta x$) in case of meandering channels. 


In order to improve the model accuracy, the kinematic wave channel routing can be run using a smaller (user-defined) time-step than the overall simulation time-step ($\Delta t$).

Clearly, the smaller the computational time-step, the larger the computational time required to complete the simulation. 

In order to ammeliorate this problem and achieve the optimal trade-off between computational accuracy and time demand, the kinematic wave calculations for both surface and channel routing have been parallelised using the approach described in Liu *et al.* (2014). 

Users can identify the optimal parallelization approach for their own set-up using the following lines of the settings.xml. 
It is here noted that the setting "numCPUs_parallelNumba" will be applied to both the computation of routing and of soil water infiltration.

```xml
<comment>
**************************************************************
PARALLELISATION WITH NUMBA (USED IN ROUTING AND SOILLOOP)
**************************************************************
</comment>

!-- Parallelisation of using Numba runtime compiled library .
The option "numCPUs_parallelNumba" may take the following values:
    - "0"           : set to NUMBA_NUM_THREADS Environment Variable 
                      (if NUMBA_NUM_THREADS is not set, will take the number of CPU cores determined by python's multiprocessing.cpu_count())
    - "1"           : serial execution (not parallel)
    - "2", "3", ... : manual setting of the number of parallel threads.
                      (if exceeding NUMBA_NUM_THREADS, the value is set to NUMBA_NUM_THREADS) -->
<textvar name="numCPUs_parallelNumba" value="0"/>

<comment>
```


> J. Liu, A. Zhu, Y. Liu, T. Zhu, C. Z. Qin, A layered approach to parallel computing for spatially distributed hydrological modeling, Environ. Model. Softw., 51 (2014), pp. 221-227


[🔝](#top)

