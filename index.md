
![](media/image2.png)

# Disclaimer
Both the program code and this manual have been carefully inspected before printing. However, no  warranties, either expressed or implied, are made concerning the accuracy, completeness, reliability, usability, performance, or fitness for any particular purpose of the information contained in this manual, to the software described in this manual, and to other material supplied in connection therewith. The material  is provided \"as is\". The entire risk as to its quality and performance is with the user.



## Introduction
The LISFLOOD model is a hydrological rainfall-runoff model that is capable of simulating the hydrological processes that occur in a catchment. LISFLOOD has been developed by the floods group of the Natural Hazards Project of the Joint Research Centre (JRC) of the European Commission. The specific development objective was to produce a tool that can be used in large and trans-national catchments for a variety of applications, including:

- Flood forecasting

- Assessing the effects of river regulation measures
- Assessing the effects of land-use change
- Assessing the effects of climate change

Although a wide variety of existing hydrological models are available that are suitable for *each* of these individual tasks, few *single* models are capable of doing *all* these jobs. Besides this, our objective requires a model that is spatially distributed and, at least to a certain extent, physically-based. Also, the focus of our work is on European catchments. Since several databases exist that contain pan-European information on soils (King *et al.*, 1997; Wösten *et al.*, 1999), land cover (CEC, 1993), topography (Hiederer & de Roo, 2003) and meteorology (Rijks *et al.*, 1998), it would be advantageous to have a model that makes the best possible use of these data. Finally, the wide scope of our objective implies that changes and extensions to the model will be required from time to time. Therefore, it is essential to have a model code that can be easily  maintained and modified. LISFLOOD has been specifically developed to satisfy these requirements. The model is designed to be applied across a wide range of spatial and temporal scales. LISFLOOD is grid-based, and applications so far have employed grid cells of as little as 100 metres for medium-sized catchments, to 5000 metres for modelling the whole of Europe and up to 0.1° (around 10 km) for modelling globally. Long-term water balance can be simulated (using a daily time step), as well as individual flood events (using hourly time intervals, or even smaller). The output of a "water balance run" can be used to provide the initial conditions of a "flood run". Although the model's primary output product is channel discharge, all internal rate and state variables (soil moisture, for example) can be written as output as well. In addition, all output can be written as grids, or time series at user-defined points or areas. The user has complete control over how output is written, thus minimising any waste of disk space or CPU time.

[:top:](#top)

## About LISFLOOD

The LISFLOOD model is implemented in the PCRaster Environmental Modelling language Version 3.0.0 (Wesseling et al., 1996), wrapped in a Python based interface. PCRaster is a raster GIS environment that has its own high-level computer language, which allows the construction of iterative spatio-temporal environmental models. The Python wrapper of LISFLOOD enables the user to control the model inputs and outputs and the selection of the model modules. This approach combines the power, relative simplicity and maintainability of code written in the the PCRaster Environmental Modelling language and the flexibility of Python.
LISFLOOD runs on any operating for which Python and PCRaster are available. Currently these include 32-bits Windows (e.g. Windows XP, Vista, 7) and a number of Linux distributions.

[:top:](#top)
## About this User Manual

This revised User Manual documents LISFLOOD version December 1 2013, and replaces all previous documentation of the model (e.g. van der Knijff & de Roo, 2008; de Roo *et. al.*, 2003). The scope of this document is to give model users all the information that is needed for successfully using LISFLOOD.
Chapter 2 explains the theory behind the model, including all model equations and the changes to the previous version. The remaining chapters cover all practical aspects of working with LISFLOOD. Chapter 3 to 8 explains how to setup LISFLOOD, how to modify the settings and the outputs.
A series of Annexes at the end of this document describe some optional features that can be activated  when running the model. Most model users will not need these features (which are disabled by default), and for the sake of clarity we therefore decided to keep their description out of the main text. The  current document does not cover the calculation of the potential evapo (transpi)ration rates that are  needed as input to the model. A separate pre-processor (LISVAP) exists that calculates these variables  from standard (gridded) meteorological observations. LISVAP is documented in a separate volume (van  der Knijff, 2006). 

[:top:](#top)

## Process descriptions

Overview
--------

Figure 2.1 gives an overview of the structure of the LISFLOOD model.

-   a 2-layer soil water balance sub-model

-   sub-models for the simulation of groundwater and subsurface flow (using 2 parallel interconnected linear reservoirs)

-   a sub-model for the routing of surface runoff to the nearest river channel

-   a sub-model for the routing of channel flow (not shown in the Figure)

The processes that are simulated by the model include snow melt (not shown in the Figure), infiltration, interception of rainfall, leaf drainage, evaporation and water uptake by vegetation, surface runoff, preferential flow (bypass of soil layer), exchange of soil moisture between the two soil layers and drainage to the groundwater, sub-surface and groundwater flow, and flow through river channels. Each of these
processes is described in more detail in the following.

![](media/image6.jpg)

###### Figure 2.1 Overview of the LISFLOOD model. 
###### $P = precipitation;$ $Int = interception;$   $EW_{int} = evaporation\  of\  intercepted\ water; $ $D_{int} = leaf\  drainage;$ $ES_a = evaporation \ from \ soil \ surface;$ $T_a = transpiration \ (water \ uptake \ by \ plant \ roots); $ $INF_{act} = infiltration; $ $R_s = surface \ runoff;$ $D_{1,2} = drainage \ from \ top- to \ subsoil;$ $D_{2,gw} = drainage \ from \ subsoil \ to \ upper \ groundwater \ zone;$ $D_{pref,gw} = preferential \ flow \ to \ upper \ groundwater \ zone; $ $D_{uz,lz} = drainage \ from \ upper- \ to \ lower \ groundwater \ zone; $ $Q_{uz} = outflow \ from \ upper \ groundwater \ zone;$ $ Q_l = outflow \ from \ lower \ groundwater \ zone;  $ $D_{loss} = loss \ from \ lower \ groundwater zone.$

###### Note that snowmelt is not included in the Figure (even though it is simulated by the model).*


[:top:](#top)

Treatment of meteorological input variables
-------------------------------------------

The meteorological conditions provide the driving forces behind the water balance. LISFLOOD uses the following meteorological input variables:



| Code      | Description                                        | Unit               |
| --------- | -------------------------------------------------- | ------------------ |
| $P$       | Precipitation                                      | $[\frac{mm}{day}]$ |
| $ET0$     | Potential (reference) evapotranspiration rate      | $[\frac{mm}{day}]$ |
| $EW0$     | Potential evaporation rate from open water surface | $[\frac{mm}{day}]$ |
| $ES0$     | Potential evaporation rate from bare soil surface  | $[\frac{mm}{day}]$ |
| $T_{avg}$ | Average *daily* temperature                        | $^\circ C$         |


###### Note that the model needs *daily* average temperature values, even if the model is run on a smaller time interval (e.g. hourly). This is because the routines for snowmelt and soil freezing are use empirical relations which are based on daily temperature data. Just as an example, feeding hourly temperature data into the snowmelt routine can result in a gross overestimation of snowmelt. This is because even on a day on which the average temperature is below *Tm*  (no snowmelt), the instantaneous (or hourly) temperature may be higher for a part of the day, leading to unrealistically high simulated snowmelt rates

Both precipitation and evaporation are internally converted from *intensities* $[\frac{mm}{day}]$ to *quantities per time step* $[mm]$ by multiplying them with the time step, $\Delta t$ (in $days$). For the sake of consistency, all in- and outgoing fluxes will also be described as *quantities per time step* $[mm]$ in the following, unless stated otherwise. $ET0$, $EW0$ and $ES0$ can be calculated using standard meteorological observations. To this end a dedicated pre-processing application has been developed (LISVAP), which is documented in a separate volume (van der Knijff, 2006).

[:top:](#top)

Rain and snow
-------------

If the average temperature is below 1°C, all precipitation is assumed to be snow. A snow correction factor is used to correct for undercatch of snow precipitation. Unlike rain, snow accumulates on the soil surface 
until it melts. The rate of snowmelt is estimated using a simple degree-day factor method. Degree-day factor type snow melt models usually take the following form (e.g. see WMO, 1986):

$M = {C_m}({T_{avg}} - {T_m})$ (2-1)


where *M* is the rate of snowmelt, $T_{avg}$ is the average daily temperature, $T_m$ is some critical temperature and $C_m$ is a degree-day factor \[$\frac{mm} {°C \ day}$\]. Speers *et al.* (1979) developed an extension of this equation which accounts for accelerated snowmelt that takes place when it is raining (cited in Young, 1985). The equation is supposed to apply when rainfall is greater than 30 mm in 24 hours. Moreover, although the equation is reported to work sufficiently well in forested areas, it is not valid in areas that are above the tree line, where  radiation is the main energy source for snowmelt). LISFLOOD uses a variation on the equation of Speers *et  al.* The modified equation simply assumes that for each mm of rainfall, the rate of snowmelt increases with 1% (compared to a 'dry' situation). This yields the following equation:

$M = {C_m} \cdot C_{Seasonal}(1 + 0.01 \cdot R\Delta t)(T_{avg} - T_m) \cdot \Delta t$ (2-2)

where *M* is the snowmelt per time step \[$mm$\], *R* is rainfall (not snow!) intensity \[$\frac {mm}{day}$], and $\Delta t$ is the time interval \[$days$\]. $T_m$ has a value of 0 $^\circ C$, and $C_m$ is a degree-day factor \[$\frac{mm} {^\circ C \cdot day}$\]. However, it should be stressed that the value of $C_m$ can actually vary greatly both in space and time (e.g. see Martinec *et al*., 1998).

Therefore, in practice this parameter is often treated as a calibration constant. A low value of $C_m$ indicates slow snow melt. $C_{Seasonal}$ is a seasonal variable melt factor which is also used in several other models (e.g. Anderson 2006, Viviroli et al., 2009). There are mainly two reasons to use a seasonally variable melt factor:

-   The solar radiation has an effect on the energy balance and varies with the time of the year.

-   The albedo of the snow has a seasonal variation, because fresh snow is more common in the mid winter and aged snow in the late winter/spring. This produce an even greater seasonal variation in
    the amount of net solar radiation

Figure 2.2 shows an example where a mean value of: 3.0 $\frac{mm} {^\circ C \cdot day}$  is used. The value of $C_m$ is reduced by 0.5 at $21^{st}$ December and a 0.5 is added on the $21^{st}$ June. In between a sinus function is applied

![](media/image7.jpg)

###### Figure 2.2 Sinus shaped snow melt coefficient ($C_m$) as a function of days of year

At high altitudes, where the temperature never exceeds $1^\circ C$, the model accumulates snow without any reduction because of melting loss. In these altitudes runoff from glacier melt is an important part. The snow will accumulate and converted into firn. Then firn is converted to ice and transported to the lower regions. This can take decades or even hundred years. In the ablation area the ice is melted. In LISFLOOD this process is emulated by melting the snow in higher altitudes on an annual basis over summer. A sinus function is used to start ice melting in summer, starting on the 15 June and ending on the 15 September (see fig 2.3) and using the temperature of zone B (see fig 2.3.)

![](media/image8.png)

###### Figure 2.3 Sinus shaped ice melt coefficient as a function of days of year

The amount of snowmelt and icemelt together can never exceed the actual snow cover that is present on the surface.

For large pixel sizes, there may be considerable sub-pixel heterogeneity in snow accumulation and melt, which is a particular problem if there are large elevation differences within a pixel. Because of this, snow melt and accumulation are modelled separately for 3 separate elevation zones, which are defined at the sub-pixel level. This is shown in Figure 2.4.

The division in elevation zones was changed from a uniform distribution in the previous LISFLOOD version to a normal distribution, which fits better to the real distribution of e.g. 100m SRTM DEM pixels in a 5x5km
grid cell. 3 elevation zones *A*, *B*, and *C* are defined with each zone occupying one third of the pixel surface. Assuming further that $T_{avg}$ is valid for the average pixel elevation, average temperature is extrapolated to the centroids of the lower (*A*) and upper (*C*) elevation zones, using a fixed temperature lapse rate, *L*, of  0.0065 °C per meter elevation difference. Snow, snowmelt and snow accumulation are subsequently modelled separately for each elevation zone, assuming that temperature can be approximated by the temperature at the centroid of each respective zone.

![](media/image10.png)



###### Figure 2.4 Definition of sub-pixel elevation zones for snow accumulation and melt modelling. Snowmelt and accumulation calculations in each zone are based on elevation (and derived temperature) in centroid of each zone

$StD: Standard \  Deviation\  of \ the\  DEM$

$quant: 0.9674 \ Quantile\  of\  the\  normal\  distribution:\  u_{0,833}=0.9674$

$L \ temperature\  lapse\  rate.$

[:top:](#top)

Frost index soil
----------------

When the soil surface is frozen, this affects the hydrological processes occurring near the soil surface. To estimate whether the soil surface is frozen or not, a frost index *F* is calculated. The equation is based on
Molnau & Bissell (1983, cited in Maidment 1993), and adjusted for variable time steps. The rate at which the frost index changes is given by:

$\frac{dF}{dt} = - (1 - {A_f})\cdot F - {T_{av}} \cdot {e^{ - 0.04 \cdot K \cdot {d_s}/w \cdot {e_s}}}$ (2-4)

$\frac{dF}{dt}$ is expressed in $[\frac{\circ C}{day} \cdot \frac{1}{day}]$.  $A_f$ is a decay coefficient $[\frac{1}{day}]$, $K$ is a a snow depth reduction coefficient

$[\frac{1}{cm}]$, $d_s$ is the (pixel-average) depth of the snow cover (expressed as $mm$ equivalent water depth), and $w \cdot e_s$ is a parameter called snow water equivalent, which is the equivalent water depth water of a snow cover (Maidment, 1993). In LISFLOOD, $A_f$ and $K$ are set to 0.97 and 0.57 $[\frac{1}{cm}]$ respectively, and $w \cdot e_s$ is taken as 0.1, assuming an average snow density of 100 $\frac{kg}{m^3}$ (Maidment, 1993). The soil is considered frozen when the frost index rises above a critical threshold of 56. For each time step the value of $F$ $[\frac{\circ C}{ day}]$ is updated as:

$F(t) = F(t - 1) + \frac{dF}{dt}\Delta t$   (2-5)

$F$ is not allowed to become less than 0.

When the frost index rises above a threshold of 56, every soil process is frozen and transpiration, evaporation, infiltration and the outflow to the second soil layer and to upper groundwater layer is set to zero.
Any rainfall is bypassing the soil and transformed into surface runoff till the frost index is equal or less than 56.

[:top:](#top)

Adressing sub-grid variability in land cover
--------------------------------------------

In the previous versions of LISFLOOD a number of parameters are linked directly to land cover classes by using lookup tables. The spatially dominant value has been used to assign the corresponding grid parameter values. This implies that some of the sub-grid variability in land use, and consequently in the parameter of interest, is lost (figure 2.5)

![](media/image13.jpg)



###### Figure 2.5 Land cover aggregation approach in previous versions of LISFLOOD

In order account properly for land use dynamics, some conceptual changes have been made to render LISFLOOD more land-use sensitive. To account for the sub-grid variability in land use, we model the within-grid variability. In the modified version of the hydrological model, the spatial distribution and frequency of each class is defined as a percentage of the whole represented area of the new pixel. Combining land cover classes and modeling aggregated classes, is known as the concept of hydrological response units (HRU). The logic behind this approach is that the non-linear nature of the rainfall runoff processes on different land cover surfaces observed in reality will be better captured. This concept is also used in models such as SWAT (Arnold and Fohrer, 2005) and PREVAH (Viviroli et al., 2009). LISFLOOD has been transferred a HRU approach on sub-grid level, as shown in figure 2.6.

![](media/image14.jpg)



###### Figure 2.6 LISFLOOD land cover aggregation by modelling aggregated land use classes separately: Percentages of forest (dark green); water (blue), impervious surface (red), other classes (light green)

[:top:](#top)

Soil model
----------

If a part of a pixel is made up of built-up areas this will influence that pixel's water-balance. LISFLOOD's 'direct runoff fraction's parameter ($f_{dr}$) defines the fraction of a pixel that is impervious.
For impervious areas, LISFLOOD assumes that:

1.  A depression storage is filled by precipitation and snowmelt and emptied by evaporation

2.  Any water that is not filling the depression storage, reaches the surface is added directly to surface runoff

3.  The storage capacity of the soil is zero (i.e. no soil moisture storage in the direct runoff fraction)

4.  There is no groundwater storage

For open water (e.g. lakes, rivers) the water fraction parameter $(f_{water})$ defines the fraction that is covered with water (large lakes that are in direct connection with major river channels can be modelled using LISFLOOD's lake option, which is described in Annex 5 of this manual). For water covered areas, LISFLOOD assumes that:

1.  The loss of actual evaporation is equal to the potential evaporation on open water

2.  Any water that is not evaporated, reaches the surface is added directly to surface runoff

3.  The storage capacity of the soil is zero (i.e. no soil moisture storage in the water fraction)

4.  There is no groundwater storage

For the part of a pixel that is forest $(f_{forest})$ or other land cover $(f_{other}=1-f_{forest}-f_{dr}-f_{water})$ the description of all soil- and groundwater-related processes below (evaporation, transpiration, infiltration, preferential flow, soil moisture redistribution and groundwater flow) are valid. While the modelling structure for forest and other classes is the same, the difference is the use of different map sets for leaf area index, soil and soil hydraulic properties. Because of the nonlinear nature of the rainfall runoff processes this should yield better results than running the model with average parameter values. Table 2 summarises the profiles of the four individually modelled categories of land cover classes

###### Table 2.1 Summary of hydrological properties of the four categories modelled individually in the modified version of LISFLOOD.



| Category                                                     | Evapotranspiration                                           | Soil                                                      | Runoff                                                       |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :-------------------------------------------------------- | :----------------------------------------------------------- |
| Forest                                                       | High level of evapo-transpiration (high Leaf area index) seasonally dependant | Large rooting depth                                       | Low concentration time                                       |
| Impervious surface                                           | Not applicable                                               | Not applicable                                            | Surface runoff but initial loss and depression storage, fast concentration time |
| Inland water                                                 | Maximum evaporation                                          | Not applicable                                            | Fast concentration time                                      |
| Other (agricultural areas, non-forested natural area, pervious surface of urban areas) | Evapotranspiration lower than for forest but still significant | Rooting depth lower than for forest but still significant | Medium concentration time                                    |



If you activate any of LISFLOOD's options for writing internal model fluxes to time series or maps (described in Chapter 8), the model will report the real fluxes, which are the fluxes multiplied by the corresponding fraction. Figure 2.7 illustrates this for evapotranspiration (evaporation and transpiration) which calculated
differently for each of this four aggregated classes. The total sum of evapotranspiration for a pixel is calculated by adding up the fluxes for each class multiplied by the fraction of each class.

![](media/image24.png)

###### Figure 2.7  $ET_{forest} \to ET_{other} \to ET_{dr} \to ET_{water} $ simulation of aggregated land cover classes in LISFLOOD.

In this example, evapotranspiration (ET) is simulated for each aggregated class separately  $(ET_{forest}, ET_{dr}, ET_{water}, ET_{other}) $ As result of the soil model you get four different surface fluxes weighted by the corresponding fraction $(f_{dr},f_{water},f_{forest},f_{other})$, respectively two fluxes for the upper and lower groundwater zone and for groundwater loss also weighted by the corresponding fraction $(f_{forest},f_{other})$. However a lot of the internal flux or states (e.g. preferential flow for forested areas) can be written to disk as map or timeseries by activate LISFLOOD's options (described in Chapter 8).

[:top:](#top)

Interception
------------

Interception is estimated using the following storage-based equation (Aston, 1978, Merriam, 1960):

$Int = S_{max} \cdot [1 - e ^{\frac{- k \cdot R \cdot \Delta t} {S_{max}}}]$ (2-6)

where $Int [mm]$ is the interception per time step, $S_{max} [mm]$ is the maximum interception, $R$ is the rainfall intensity $[\frac{mm}{day}]$ and the factor $k$ accounts for the density of the vegetation. $S_{max}$ is calculated using an empirical equation (Von Hoyningen-Huene, 1981):

$\begin{cases} S_{max} = 0.935 + 0.498 \cdot LAI - 0.00575 \cdot LAI^2 &[LAI \gt 0.1]\\ S_{max } = 0 & [LAI \le 0.1]\end{cases}$ (2-7)

where $LAI$ is the average Leaf Area Index \[m^2^ m^-2^\] of each model element (pixel). *k* is estimated as:

$k = 0.046 \cdot LAI$ (2-8)

The value of $Int$ can never exceed the interception storage capacity, which is defined as the difference between $S_{max}$ and the accumulated amount of water that is stored as interception, $Int_{cum}$.

[:top:](#top)

Evaporation of intercepted water
--------------------------------

Evaporation of intercepted water, *EW~int~*, occurs at the potential evaporation rate from an open water surface, *EW0*. The *maximum* evaporation per time step is proportional to the fraction of vegetated
area in each pixel (Supit *et al.*,1994):

$EW_{max } = EW0 \cdot [1 - e^{- \kappa_{gb} \cdot LAI}] \cdot \Delta t$ (2-9)

where $EW0$ is the potential evaporation rate from an open water surface $[\frac{mm}{day}]$, and $EW_{max}$ is in $[mm]$ per time step. Constant $\kappa_{gb}$ is the extinction coefficient for global solar radiation.
Since evaporation is limited by the amount of water stored on the leaves, the actual amount of evaporation from the interception store equals:

$EW_{int} = _{min}({EW_{max } \cdot \Delta t},{Int_{cum}})$ (2-10)

where *EW~int~* is the actual evaporation from the interception store $[mm]$ per time step, and $EW0$ is the potential evaporation rate from an open water surface $[\frac{mm}{day}]$ It is assumed that on average all water in the interception store $Int_{cum}$ will have evaporated or fallen to the soil surface as leaf drainage within one day. Leaf drainage is therefore modelled as a linear reservoir with a time constant (or residence time) of one day, i.e:

$D_{int} = \frac{1}{T_{int}} \cdot Int_{cum} \cdot \Delta t$ (2-11)

where $D_{int}$ is the amount of leaf drainage per time step $[mm]$ and $T_{int}$ is a time constant for the interception store $[days]$, which is set to 1 day.

[:top:](#top)

Water available for infiltration and direct runoff
--------------------------------------------------

In the permeable fraction of each pixel $(1- f_{dr})$, the amount of water that is available for infiltration, $W_{av}$ $[mm]$ equals (Supit *et al.*,1994):

$W_{av} = R \cdot \Delta t + M + D_{int} - Int$  (2-12)

where:

$R:\ Rainfall [\frac{mm}{day}]$
$M:\ Snow\ melt [mm]$
$D_{int}:\ Leaf\ drainage [mm]$
$Int : Interception [mm]​$