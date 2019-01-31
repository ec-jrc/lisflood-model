# Atmospheric processes and data 

## Treatment of meteorological input variables

The meteorological conditions provide the driving forces behind the water balance. LISFLOOD uses the following meteorological input variables:


| **Code**      | **Description**                                        | **Unit**               |
| --------- | -------------------------------------------------- | ------------------ |
| $P$       | Precipitation                                      | $[\frac{mm}{day}]$ |
| $ET0$     | Potential (reference) evapotranspiration rate      | $[\frac{mm}{day}]$ |
| $EW0$    | Potential evaporation rate from open water surface | $[\frac{mm}{day}]$ |
| $ES0$     | Potential evaporation rate from bare soil surface  | $[\frac{mm}{day}]$ |
| $T_{avg}$ | Average *daily* temperature                        | $^\circ C$         |

> **Note** that the model needs *daily* average temperature values, even if the model is run on a smaller time interval (e.g. hourly). This is because the routines for snowmelt and soil freezing are use empirical relations which are based on daily temperature data <span style="color:red"> **Cinzia is that still correct??**</span>. Just as an example, feeding hourly temperature data into the snowmelt routine can result in a gross overestimation of snowmelt. This is because even on a day on which the average temperature is below $T_m$  (no snowmelt), the instantaneous (or hourly) temperature may be higher for a part of the day, leading to unrealistically high simulated snowmelt rates.


Both precipitation and evaporation are internally converted from *intensities* $[\frac{mm}{day}]$ to *quantities per time step* $[mm]$ by multiplying them with the time step, $\Delta t$ (in $days$). For the sake of consistency, all in- and outgoing fluxes will also be described as *quantities per time step* $[mm]$ in the following, unless stated otherwise. $ET0$, $EW0$ and $ES0$ can be calculated using standard meteorological observations. To this end a dedicated pre-processing application has been developed (LISVAP), which is documented in a separate manual. <span style="color:red"> Insert link to LISVAP manual once it is produced</span>


## Rain and snow

If the average temperature is below 1°C, all precipitation is assumed to be snow. A snow correction factor is used to correct for undercatch of snow precipitation. Unlike rain, snow accumulates on the soil surface 
until it melts. The rate of snowmelt is estimated using a simple degree-day factor method. Degree-day factor type snow melt models usually take the following form (e.g. see WMO, 1986):

$$
M = {C_m}({T_{avg}} - {T_m})
$$

where 
   *M* is the rate of snowmelt, 
   $T_{avg}$ is the average daily temperature, 
   $T_m$ is some critical temperature and 
   $C_m$ is a degree-day factor $[\frac{mm} {°C \ day}]$. 

Speers *et al.* (1979) developed an extension of this equation which accounts for accelerated snowmelt that takes place when it is raining (cited in Young, 1985). The equation is supposed to apply when rainfall is greater than 30 mm in 24 hours. Moreover, although the equation is reported to work sufficiently well in forested areas, it is not valid in areas that are above the tree line, where  radiation is the main energy source for snowmelt). LISFLOOD uses a variation on the equation of Speers *et  al.* The modified equation simply assumes that for each mm of rainfall, the rate of snowmelt increases with 1% (compared to a 'dry' situation). This yields the following equation:

$$
M = {C_m} \cdot C_{Seasonal}(1 + 0.01 \cdot R\Delta t)(T_{avg} - T_m) \cdot \Delta t
$$

where 
   *M* is the snowmelt per time step $[mm]$, 
   *R* is rainfall (not snow!) intensity $[\frac {mm}{day}]$, and 
   $\Delta t$ is the time interval $[days]$. 
   $T_m$ has a value of 0 $^\circ C$, and 
   $C_m$ is a degree-day factor $[\frac{mm} {^\circ C \cdot day}]$. 

However, it should be stressed that the value of $C_m$ can actually vary greatly both in space and time (e.g. see Martinec *et al*., 1998). Therefore, __in practice this parameter is often treated as a calibration constant__. A low value of $C_m$ indicates slow snow melt. $C_{Seasonal}$ is a seasonal variable melt factor which is also used in several other models (e.g. Anderson 2006, Viviroli et al., 2009). There are mainly two reasons to use a seasonally variable melt factor:

-   The solar radiation has an effect on the energy balance and varies with the time of the year.

-   The albedo of the snow has a seasonal variation, because fresh snow is more common in the mid winter and aged snow in the late winter/spring. This produce an even greater seasonal variation in
    the amount of net solar radiation

The following Figure shows an example where a mean value of: 3.0 $\frac{mm} {^\circ C \cdot day}$  is used. The value of $C_m$ is reduced by 0.5 at $21^{st}$ December and a 0.5 is added on the $21^{st}$ June. In between a sinus function is applied

![snow melt coefficient](../media/image7.jpg)
***Figure:*** *Sinus shaped snow melt coefficient* ($C_m$) *as a function of days of year.*

At high altitudes, where the temperature never exceeds $1^\circ C$, the model accumulates snow without any reduction because of melting loss. In these altitudes runoff from glacier melt is an important part. The snow will accumulate and converted into firn. Then firn is converted to ice and transported to the lower regions. This can take decades or even hundred years. In the ablation area the ice is melted. In LISFLOOD this process is emulated by melting the snow in higher altitudes on an annual basis over summer. A sinus function is used to start ice melting in summer (from 15 June till 15 September) using the temperature of zone B:

![ice melt coefficient](../media/image8.png)
***Figure:*** *Sinus shaped ice melt coefficient as a function of days of year.*

The amount of snowmelt and ice melt together can never exceed the actual snow cover that is present on the surface.

For large pixel sizes, there may be considerable sub-pixel heterogeneity in snow accumulation and melt, which is a particular problem if there are large elevation differences within a pixel. Because of this, snow melt and accumulation are modelled separately for 3 separate elevation zones, which are defined at the sub-pixel level. This is shown in Figure below:

![sub-pixel elevation zones](../media/image10.png)
***Figure:*** *Definition of sub-pixel elevation zones for snow accumulation and melt modelling. Snowmelt and accumulation calculations in each zone are based on elevation (and derived temperature) in centroid of each zone.*

The division in elevation zones was changed from a uniform distribution in the previous LISFLOOD version to a normal distribution, which fits better to the real distribution of e.g. 100m SRTM DEM pixels in a 5x5km grid cell. Three elevation zones *A*, *B*, and *C* are defined with each zone occupying one third of the pixel surface. Assuming further that $T_{avg}$ is valid for the average pixel elevation, average temperature is extrapolated to the centroids of the lower (*A*) and upper (*C*) elevation zones, using a fixed temperature lapse rate, *L*, of  0.0065 °C per meter elevation difference. Snow, snowmelt and snow accumulation are subsequently modelled separately for each elevation zone, assuming that temperature can be approximated by the temperature at the centroid of each respective zone.





## Direct evaporation from the soil surface

The maximum amount of evaporation from the soil surface equals the maximum evaporation from a shaded soil surface, $ES_{max} [mm]$, which is computed as:
$$
ES_{max} = ES0 \cdot e^{(\frac{- \kappa _{gb} \cdot LAI} {\Delta t})}
$$
where $ES0​$ is the potential evaporation rate from bare soil surface $[\frac{mm}{day}]​$. The actual evaporation from the soil mainly depends on the amount of soil moisture near the soil surface: evaporation decreases as the topsoil is drying. In the model this is simulated using a reduction factor which is a function of the number of days since the last rain storm (Stroosnijder, 1987, 1982):
$$
ES_a = ES_{max } \cdot (\sqrt{D_{slr}} - \sqrt{D_{slr} - 1} )
$$
The variable $D_{slr}$ represents the number of days since the last rain event. Its value accumulates over time: if the amount of water that is available for infiltration ($W_{av}$) remains below a critical threshold
it increases by an amount of $\Delta t [days]$ for each time step. It is reset to 1 only if the critical amount of water is exceeded (In the LISFLOOD settings file this critical amount is currently expressed as an *intensity* $[\frac{mm}{day}]$. This is because the equation was originally designed for a daily time step only. Because the current implementation will likely lead to *DSLR* being reset too frequently, the exact formulation may change
in future versions (e.g. by keeping track of the accumulated available water of the last 24 hours)).  

The actual soil evaporation is always the smallest value out of the result of the equation above and the available amount of moisture in the soil, i.e.:
$$
ES_a = \min (ES_a,w_1 - w_{res1})
$$
where $w_1 [mm]$ is the amount of moisture in the upper soil layer and $w_{res1} [mm]$ is the residual amount of soil moisture. Like transpiration, direct evaporation from the soil is set to zero if the soil is frozen. The amount of moisture in the upper soil layer is updated after the evaporation calculations:
$$
w_1 = w_1 - ES_a
$$



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




## Interception

Interception is estimated using the following storage-based equation (Aston, 1978, Merriam, 1960):
$$
Int = S_{max} \cdot [1 - e ^{\frac{- k \cdot R \cdot \Delta t} {S_{max}}}]
$$
where $Int [mm]$ is the interception per time step, $S_{max} [mm]$ is the maximum interception, $R$ is the rainfall intensity $[\frac{mm}{day}]$ and the factor $k$ accounts for the density of the vegetation. $S_{max}$ is calculated using an empirical equation (Von Hoyningen-Huene, 1981):


$$
\begin{cases} S_{max} = 0.935 + 0.498 \cdot LAI - 0.00575 \cdot LAI^2 &[LAI \gt 0.1]\\ S_{max } = 0 & [LAI \le 0.1]\end{cases}
$$
where $LAI$ is the average Leaf Area Index $[\frac{m^2}{ m^{2}}]$ of each model element (pixel). $k$ is estimated as:
$$
k = 0.046 \cdot LAI
$$
The value of $Int$ can never exceed the interception storage capacity, which is defined as the difference between $S_{max}$ and the accumulated amount of water that is stored as interception, $Int_{cum}$.




## Water uptake by plant roots and transpiration

Water uptake and transpiration by vegetation and direct evaporation from the soil surface are modelled as two separate processes. The approach used here is largely based on Supit *et al*. (1994) and Supit & Van Der
Goot (2000). The **maximum transpiration** per time step \[mm\] is given by:
$$
T_{max } = k_{crop} \cdot ET0 \cdot [1 - e^{( - \kappa_{gb} \cdot LAI)}] \cdot \Delta t - EW_{int}
$$
Where $ET0$ is the potential (reference) evapotranspiration rate $[\frac{mm}{day}]$, constant $κ_{gb}$ is the extinction coefficient for global solar radiation \[-\] and $k_{crop}$ is a crop coefficient, a ration between the potential (reference) evapotranspiration rate and the potential evaporation rate of a specific crop. $k_{crop}$ is 1 for most vegetation types, except for some excessively transpiring crops like sugarcane or rice. 

> Note that the energy that has been 'consumed' already for the evaporation of intercepted water is simply subtracted here in order to respect the overall energy balance. 

The **actual transpiration rate** is reduced when the amount of moisture in the soil is small. In the model, a reduction factor is applied to simulate this effect:
$$
r_{WS} = \frac{w_1 - w_{wp1}}{w_{crit1} -w_{wp1}}
$$
where $w_1$ is the amount of moisture in the upper soil layer $[mm]$, $w_{wp1} [mm]$ is the amount of soil moisture at wilting point (pF 4.2) and $w_{crit1} [mm]$ is the amount of moisture below which water uptake is reduced and plants start closing their stomata. The **critical amount of soil moisture** is calculated as:
$$
w_{crit1} = (1 - p) \cdot (w_{fc1} - w_{wp1}) + w_{wp1}
$$
where $w_{fc1} [mm]$ is the amount of soil moisture at field capacity and $p$ is the soil water depletion fraction. $R_{WS}$ varies between 0 and 1. Negative values and values greater than 1 are truncated to 0 and 1, respectively. $p$ represents the fraction of soil moisture between $w_{fc1}$ and $w_{wp1}$ that can be extracted from the soil without reducing the transpiration rate. Its value is a function of both vegetation type and the potential evapotranspiration rate. The procedure to estimate $p$ is described in detail in Supit & Van Der Goot (2003). The following Figure illustrates the relation between $R_{WS}, w,w_{crit}, w_{fc}, w_{wp}$:

![transpiration](../media/image26.png)
***Figure:*** *Reduction of transpiration in case of water stress.* $r_{ws}$ *decreases linearly to zero between* $w_{crit}$ *and* $w_{wp}$.

The **actual transpiration** $T_a$ is now calculated as:
$$
T_a = r_{WS} \cdot T_{max }
$$


with $T_a$ and $T_{max}$ in $[mm]$.

Transpiration is set to zero when the soil is frozen (i.e. when frost index *F* exceeds its critical threshold). The amount of **moisture in the upper soil layer** is updated after the transpiration calculations:
$$
w_1 = w_1 - T_a
$$
[🔝](#top)

