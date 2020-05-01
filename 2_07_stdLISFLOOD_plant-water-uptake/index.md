## Water uptake by plant roots and transpiration

Water uptake and transpiration by vegetation and direct evaporation from the soil surface are modelled as two separate processes. The approach used here is largely based on Supit *et al*. (1994) and Supit & Van Der
Goot (2000). The **maximum transpiration** per time step \[mm\] is given by:

$$
T_{max } = k_{crop} \cdot ET0 \cdot [1 - e^{( - \kappa_{gb} \cdot LAI)}] \cdot \Delta t - EW_{int}
$$

Where $ET0$ is the potential (reference) evapotranspiration rate $[\frac{mm}{day}]$, constant $κ_{gb}$ is the extinction coefficient for global solar radiation \[-\] and $k_{crop}$ is a crop coefficient, a ration between the potential (reference) evapotranspiration rate and the potential evaporation rate of a specific crop. $k_{crop}$ is 1 for most vegetation types, except for some excessively transpiring crops like sugarcane or rice. 

> Note that the energy that has been 'consumed' already for the evaporation of intercepted water is simply accounted for here by subtracting the evaporated water volume here ($EW_{int}$). This is done in order to respect the overall energy balance. 

The **actual transpiration rate** is reduced when the amount of moisture in the soil is small. In the model, a reduction factor is applied to simulate this effect:

$$
R_{WS} = \frac{w_1 - w_{wp1}}{w_{crit1} -w_{wp1}}
$$

where $w_1$ is the amount of moisture in the superficial and upper soil layers $[mm]$, $w_{wp1} [mm]$ is the amount of soil moisture at wilting point (pF 4.2) and $w_{crit1} [mm]$ is the amount of moisture below which water uptake is reduced and plants start closing their stomata. The **critical amount of soil moisture** is calculated as:

$$
w_{crit1} = (1 - p) \cdot (w_{fc1} - w_{wp1}) + w_{wp1}
$$

where $w_{fc1} [mm]$ is the amount of soil moisture at field capacity and $p$ is the soil water depletion fraction. $R_{WS}$ varies between 0 and 1. Negative values and values greater than 1 are truncated to 0 and 1, respectively. $p$ represents the fraction of soil moisture between $w_{fc1}$ and $w_{wp1}$ that can be extracted from the soil without reducing the transpiration rate. Its value is a function of both vegetation type and the potential evapotranspiration rate. The procedure to estimate $p$ is described in detail in Supit & Van Der Goot (2003). The following Figure illustrates the relation between $R_{WS}, w,w_{crit}, w_{fc}, w_{wp}$:

![Reduction of transpiration in case of water stress](../media/image26.png)
***Figure:*** *Reduction of transpiration in case of water stress.* $r_{ws}$ *decreases linearly to zero between* $w_{crit}$ *and* $w_{wp}$.

The **actual transpiration** $T_a$ is now calculated as:

$$
T_a = R_{WS} \cdot T_{max }
$$

with $T_a$ and $T_{max}$ in $[mm]$.

Transpiration is set to zero when the soil is frozen (i.e. when frost index *F* exceeds its critical threshold). The amount of **moisture in the upper soil layer** is updated after the transpiration calculations:

$$
w_1 = w_1 - T_a
$$

[🔝](#top)
