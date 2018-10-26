## Direct evaporation from the soil surface

The **maximum amount of evaporation from the soil surface** equals the maximum evaporation from a shaded soil surface, $ES_{max} [mm]$, which is computed as:

$$
ES_{max} = ES0 \cdot e^{(\frac{- \kappa _{gb} \cdot LAI} {\Delta t})}
$$

where $ES0$ is the potential evaporation rate from bare soil surface $[\frac{mm}{day}]$. The **actual evaporation from the soil** mainly depends on the amount of soil moisture near the soil surface: evaporation decreases as the topsoil is drying. In the model this is simulated using a reduction factor which is a function of the number of days since the last rain storm (Stroosnijder, 1987, 1982):

$$
ES_a = ES_{max } \cdot (\sqrt{D_{slr}} - \sqrt{D_{slr} - 1} )
$$

The variable $D_{slr}$ represents the number of days since the last rain event. Its value accumulates over time: if the amount of water that is available for infiltration ($W_{av}$) remains below a critical threshold it increases by an amount of $\Delta t [days]$ for each time step. It is reset to 1 only if the critical amount of water is exceeded (In the LISFLOOD settings file this critical amount is currently expressed as an *intensity* $[\frac{mm}{day}]$. This is because the equation was originally designed for a daily time step only. Because the current implementation will likely lead to *DSLR* being reset too frequently, the exact formulation may change in future versions (e.g. by keeping track of the accumulated available water of the last 24 hours)).  

The **actual soil evaporation** is always the smallest value out of the result of the equation above and the available amount of moisture in the soil, i.e.:

$$
ES_a = \min (ES_a,w_1 - w_{res1})
$$

where $w_1 [mm]$ is the amount of moisture in the upper soil layer and $w_{res1} [mm]$ is the residual amount of soil moisture. Like transpiration, direct evaporation from the soil is set to zero if the soil is frozen. The amount of moisture in the upper soil layer is updated after the evaporation calculations:

$$
w_1 = w_1 - ES_a
$$

