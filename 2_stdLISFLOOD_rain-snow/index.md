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
***Figure:** Sinus shaped snow melt coefficient* ($C_m$) *as a function of days of year.*


At high altitudes, where the temperature never exceeds $1^\circ C$, the model accumulates snow without any reduction because of melting loss. In these altitudes runoff from glacier melt is an important part. The snow will accumulate and converted into firn. Then firn is converted to ice and transported to the lower regions. This can take decades or even hundred years. In the ablation area the ice is melted. In LISFLOOD this process is emulated by melting the snow in higher altitudes on an annual basis over summer. A sinus function is used to start ice melting in summer (from 15 June till 15 September) using the temperature of zone B:

![ice melt coefficient](../media/image8.png) 
***Figure:*** *Sinus shaped ice melt coefficient as a function of days of year.*


The amount of snowmelt and ice melt together can never exceed the actual snow cover that is present on the surface.

For large pixel sizes, there may be considerable sub-pixel heterogeneity in snow accumulation and melt, which is a particular problem if there are large elevation differences within a pixel. Because of this, snow melt and accumulation are modelled separately for 3 separate elevation zones, which are defined at the sub-pixel level. This is shown in Figure below:

![snow accumulation and melt modelling](../media/image10.png) 
***Figure:** Definition of sub-pixel elevation zones for snow accumulation and melt modelling. Snowmelt and accumulation calculations in each zone are based on elevation (and derived temperature) in centroid of each zone.*


The division in elevation zones was changed from a3 uniform distribution in the previous LISFLOOD version to a normal distribution, which fits better to the real distribution of e.g. 100m SRTM DEM pixels in a 5x5km grid cell. Three elevation zones *A*, *B*, and *C* are defined with each zone occupying one third of the pixel surface. Assuming further that $T_{avg}$ is valid for the average pixel elevation, average temperature is extrapolated to the centroids of the lower (*A*) and upper (*C*) elevation zones, using a fixed temperature lapse rate, *L*, of  0.0065 °C per meter elevation difference. Snow, snowmelt and snow accumulation are subsequently modelled separately for each elevation zone, assuming that temperature can be approximated by the temperature at the centroid of each respective zone.


[🔝](#top)
