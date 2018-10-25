## Evaporation of intercepted water

Evaporation of intercepted water, $EW_{int}$, occurs at the potential evaporation rate from an open water surface, $EW0$. The *maximum* evaporation per time step is proportional to the fraction of vegetated
area in each pixel (Supit *et al.*,1994):

$$
EW_{max } = EW0 \cdot [1 - e^{- \kappa_{gb} \cdot LAI}] \cdot \Delta t
$$

where $EW0$ is the potential evaporation rate from an open water surface $[\frac{mm}{day}]$, and $EW_{max}$ is in $[mm]$ per time step. Constant $\kappa_{gb}$ is the extinction coefficient for global solar radiation.
Since evaporation is limited by the amount of water stored on the leaves, the actual amount of evaporation from the interception store equals:

$$
EW_{int} = _{min}({EW_{max } \cdot \Delta t},{Int_{cum}})
$$

where $EW_{int}$ is the actual evaporation from the interception store $[mm]$ per time step, and $EW0$ is the potential evaporation rate from an open water surface $[\frac{mm}{day}]$ It is assumed that on average all water in the interception store $Int_{cum}$ will have evaporated or fallen to the soil surface as leaf drainage within one day. Leaf drainage is therefore modelled as a linear reservoir with a time constant (or residence time) of one day, i.e:

$$
D_{int} = \frac{1}{T_{int}} \cdot Int_{cum} \cdot \Delta t
$$

where $D_{int}$ is the amount of leaf drainage per time step $[mm]$ and $T_{int}$ is a time constant for the interception store $[days]$, which is set to 1 day.
