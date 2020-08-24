## Evaporation of intercepted water

Evaporation of intercepted water, $EW_{int}$, occurs at the potential evaporation rate from an open water surface, $EW0$. The *maximum* evaporation per time step is proportional to the fraction of vegetated
area in each pixel (Supit *et al.*,1994):

$$
EW_{max } = EW0 \cdot [1 - e^{- \kappa_{gb} \cdot LAI}] \cdot \Delta t
$$

where $EW0$ is the potential evaporation rate from an open water surface $[\frac{mm}{day}]$, and $EW_{max}$ is in $[mm]$ per time step. Constant $\kappa_{gb} [-]$ is the extinction coefficient for global solar radiation. In LISFLOOD, $\kappa_{gb}$ is given by the product $0.75 \cdot \kappa_{df}$, where $\kappa_{df} [-]$ is the extinction coefficient for diffuse visible light: its value is provided as input to the model and it varies between 0.4 and 1.1.

The actual amount of evaporation $EW_{int} mm]$ is clearly limited by the amount of water stored on the leaves $Int_{cum}$:

$$
EW_{int} = \min({EW_{max } \cdot \Delta t},{Int_{cum}})
$$

$EW_{int}$ quantifies the amount of water that is lost from the interception storage because of evaporation. Another amount of water falls to the soil because of leaf drainage. Specifically, leaf drainage is modelled as a linear reservoir:

$$
D_{int} = \frac{1}{T_{int}} \cdot Int_{cum} \cdot \Delta t
$$

where $D_{int}$ is the amount of leaf drainage per time step $[mm]$ and $T_{int}$ is a time constant (or residence time) of the interception store $[days]$.  $T_{int}$ can be defined by the user, however, a value of 1 day is strongly recommended. Setting $T_{int}=1 [day]$ means that all the water in the interception store $Int_{cum}$ evaporates or falls to the soil surface as leaf drainage within one day.
