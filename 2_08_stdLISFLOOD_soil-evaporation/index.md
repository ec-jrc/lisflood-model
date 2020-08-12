## Evaporation from soil surface

The **maximum amount of evaporation from the soil surface** equals the maximum evaporation from a shaded soil surface, $ES_{max} [mm]$, which is computed as:

$$
ES_{max} = ES0 \cdot e^{(\frac{- \kappa _{gb} \cdot LAI} {\Delta t})}
$$

where $ES0$ is the potential evaporation rate from bare soil surface $[\frac{mm}{day}]$. The **actual evaporation from the soil** mainly depends on the amount of soil moisture near the soil surface: evaporation decreases as the topsoil is drying. In the model this is simulated using a reduction factor which is a function of the number of days since the last rain storm (Stroosnijder, 1987, 1982):

$$
ES_a = ES_{max } \cdot (\sqrt{D_{slr}} - \sqrt{D_{slr} - 1} )
$$

The variable $D_{slr}$ represents the number of days since the last rain event. Its value increases over time: if the amount of water that is available for infiltration ($W_{av}$) is below a critical threshold,  $D_{slr}$ increases by an amount of $\Delta t [days]$ for each time step. $D_{slr}$ is reset to 1 if the critical amount of water is exceeded.
In the LISFLOOD settings file this critical amount is currently expressed as an *intensity* $[\frac{mm}{day}]$. This is because the equation was originally designed for a daily time step only. Because the current implementation will likely lead to *DSLR* being reset too frequently, the exact formulation may change in future versions (e.g. by keeping track of the accumulated available water of the last 24 hours). 

The **actual soil evaporation** is always the smallest value out of the result of the equation above and the available amount of moisture in the soil, i.e.:

$$
ES_a = \min (ES_a,w_1 - w_{res1})
$$

where $w_1 [mm]$ is the amount of moisture in the upper soil layer and $w_{res1} [mm]$ is the residual amount of soil moisture . Like transpiration, direct evaporation from the soil is set to zero if the soil is frozen (i.e. when the [frost index $F$](https://ec-jrc.github.io/lisflood-model/2_05_stdLISFLOOD_frost-index/) is above the crtitical threshold value). 

The actual soil evaporation is extracted from the superficial soil layer ($ES_a_1_a$) and, subsequently, from the upper soil layer ($ES_a_1_b$):

$$
ES_a_1_a = \min ([w_1_a - w_{res1a}] , ES_a) \\
ES_a_1_b = \max ([ES_a-ES_a_1_a], 0)
$$

The amount of moisture in the superficial and upper soil layers is then updated as follows:

$$
w_1_a = w_1_a - ES_a_1_a \\
w_1_b = w_1_b - ES_a_1_b \\
w_1 = w_1_a + w_1_b
$$



[🔝](#top)

