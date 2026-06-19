# LISFLOOD input files

All input that LISFLOOD requires are either in map or table format. This chapter describes the most important input files.
A companion document, the [**LISFLOOD USER GUIDE**](https://ec-jrc.github.io/lisflood-code/) provides a list of all the input files required for the model set-up (including both the standard and the optional processes).


## Meteorological input variables

The meteorological conditions are the drivers of the hydrological processes. LISFLOOD uses the following meteorological input variables:


| **Code**      | **Description**                                        | **Unit**               |
| --------- | -------------------------------------------------- | ------------------ |
| $P$       | Precipitation                                      | $[\frac{mm}{day}]$ |
| $ET0$     | Potential (reference) evapotranspiration rate      | $[\frac{mm}{day}]$ |
| $EW0$    | Potential evaporation rate from open water surface | $[\frac{mm}{day}]$ |
| $ES0$     | Potential evaporation rate from bare soil surface  | $[\frac{mm}{day}]$ |
| $T_{avg}$ | Average *daily* temperature                        | $^\circ C$         |

> **Note** that the routines for snow melt and soil freezing  use empirical relations which are based on daily temperature data. Just as an example, feeding hourly temperature data into the snow melt routine can result in a gross overestimation of snow melt. This is because even on a day on which the average temperature is below $T_m$ (no snow melt),the instantaneous (or hourly) temperature may be higher for a part of the day, leading to unrealistically high simulated snow melt rates. When using sub-daily computational time steps, the computed daily amount of snow melt is reduced according to the sub-daily time interval.

Both precipitation and evaporation are internally converted from *intensities* $[\frac{mm}{day}]$ to *quantities per time step* $[mm]$ by multiplying them with the time step, $\Delta t$ (in $days$). For the sake of consistency, all in- and outgoing fluxes will also be described as *quantities per time step* $[mm]$ in the following,  unless stated otherwise. $ET0$, $EW0$ and $ES0$ can be calculated using standard meteorological observations. 
**LISVAP** is a dedicated pre-processing application that has been developed for the computation of $ET0$, $EW0$ and $ES0$. The methodologies implemented in LISVAP are detailed in a [separate manual](https://ec-jrc.github.io/lisflood-lisvap/).


## Input maps

The use of maps is essential to include the sub-grid variability of each parameter.

***Table:*** *LISFLOOD input maps.*

| Map                                                       | Default name   | Units, range                                           | Description                                                  |
| --------------------------------------------------------- | ------------------- | ------------------------------------------------------ | ------------------------------------------------------------ |
| **GENERAL**                                               |                     |                                                        |                                                              |
| MaskMap                                                   | area.map            | Unit: - <br> Range: 0 or 1                             | Boolean map that defines model boundaries                    |
| **TOPOGRAPHY**                                            |                     |                                                        |                                                              |
| Ldd                                                       | ldd.map             | U.: flow directions <br> R.: 1 ≤ map ≤ 9               | local drain direction map (with value 1-9); this file contains flow directions from each cell to its steepest downslope neighbour. Ldd directions are coded according to the following diagram: <br> ![](../media/image58.png) <br> This resembles the numeric key pad of your PC's keyboard, except for the value 5, which defines a cell without local drain direction (pit). The pit cell at the end of the path is the outlet point of a catchment. |
| Grad                                                      | gradient.map        | U.: $\frac{m}{m}$  <br> R.: map > 0 <br> !!!           | Slope gradient                                               |
| Elevation Stdev                                           | elvstd.map          | U.: $m$ <br> R.: map ≥ 0                               | Standard deviation of elevation                              |
| **LAND USE -- fraction maps**                             |                     |                                                        |                                                              |
| Fraction of water                                         | fracwater.map       | U.: [-] <br> R.: 0 ≤ map ≤ 1                           | Fraction of inland water for each cell. Values range from 0 (no water at all) to 1 (pixel is 100% water) |
| Fraction of sealed surface                                | fracsealed.map      | U.: [-] <br> R.: 0 ≤ map ≤ 1                           | Fraction of impermeable surface for each cell. Values range from 0 (100% permeable surface -- no urban at all) to 1 (100% impermeable surface). |
| Fraction of forest                                        | fracforest.map      | U.:[-] <br> R.: 0 ≤ map ≤ 1                            | Forest fraction for each cell. Values range from 0 (no forest at all) to 1 (pixel is 100% forest) |
| Fraction of other land cover                              | fracother.map       | U.: [-] <br> R.: 0 ≤ map ≤ 1                           | Other (agricultural areas, non-forested natural area, pervious surface of urban areas) fraction for each cell. |
| **LAND COVER depending maps**                             |                     |                                                        |                                                              |
| Crop coef. for forest                                     | cropcoef_forest.map | U.: [-] <br> R.: 0.8≤ map ≤ 1.2                        | Crop coefficient for forest                                  |
| Crop coef. for other                                      | cropcoef_other.map  | U.: [-] <br> R.: 0.8≤ map ≤ 1.2                        | Crop coefficient for other                                   |
| Crop group number for forest                              | crgrnum_forest.map  | U.: [-] <br> R.: 1 ≤ map ≤ 5                           | Crop group number for forest                                 |
| Crop group number for other                              | crgrnum_other.map   | U.: [-] <br> R.: 1 ≤ map ≤ 5                           | Crop group number for other                                  |
| Manning for forest                                        | mannings_forest.map | U.: [-] <br> R.: 0.2≤ map ≤ 0.4                        | Manning's roughness for forest                               |
| Manning for other                                         | mannings_other.map  | U.: [-] <br> R.: 0.01≤ map ≤0.3                        | Manning's roughness for other                                |
| Soil depth for forest for layer1                         | soildepth1_forest.map | U.: $mm$ <br> R.: map ≥ 50                             | Forest soil depth for soil layer 1 (superficial)           |
| Soil depth for other for layer1                          | soildepth1_other.map  | U.: $mm$ <br> R.: map ≥ 50                             | Other soil depth for soil layer 1 (superficial)            |
| Soil depth for forest for layer2                         | Soildepth2_forest.map | U.: $mm$ <br> R.: map ≥ 50                             | Forest soil depth for soil layer 2 (upper)                          |
| Soil depth for other for layer2                          | Soildepth2_other.map  | U.: $mm$ <br> R.: map ≥ 50                             | Other soil soil depth for soil layer 2 (upper)                    |
| Soil depth for forest for layer3                          | Soildepth3_forest.map | U.: $mm$ <br> R.: map ≥ 50                             | Forest soil depth for soil layer 3 (lower)                         |
| Soil depth for other for layer3                           | Soildepth3_other.map  | U.: $mm$ <br> R.: map ≥ 50                             | Other soil soil depth for soil layer 3(lower)                      |
| **SOIL HYDRAULIC PROPERTIES (depending on soil texture)** |                     |                                                        |                                                              |
| ThetaSat1 for forest                                      | thetas1_forest.map  | U.: [-] <br> R.: 0 < map < 1                           | Saturated volumetric soil moisture content layer 1           |
| ThetaSat1 for other                                       | thetas1_other.map   | U.: [-] <br> R.: 0 < map < 1                           | Saturated volumetric soil moisture content layer 1           |
| ThetaSat2 for forest                                      | thetas2_forest.map  | U.: [-] <br> R.: 0 < map < 1                           | Saturated volumetric soil moisture content layer 2           |
| ThetaSat2 for other                                       | thetas2_other.map   | U.: [-] <br> R.: 0 < map < 1                           | Saturated volumetric soil moisture content layer 2           |
| ThetaSat3 for forest and other                             | thetas3.map         | U.: [-] <br> R.: 0 < map < 1                         | Saturated volumetric soil moisture content layer 3           |
| ThetaRes1 for forest                                      | thetar1_forest.map  | U.: [-] <br> R.: 0 < map < 1                           | Residual volumetric soil moisture content layer 1            |
| ThetaRes1 for other                                       | thetar1_other.map   | U.: [-] <br> R.: 0 < map < 1                           | Residual volumetric soil moisture content layer 1            |
| ThetaRes2 for forest                                      | thetar2_forest.map  | U.: [-] <br> R.: 0 < map < 1                           | Residual volumetric soil moisture content layer 2            |
| ThetaRes2 for other                                       | thetar2_other.map   | U.: [-] <br> R.: 0 < map < 1                           | Residual volumetric soil moisture content layer 2            |
| ThetaRes3 for forest and other                             | thetar3.map         | U.: [-] <br> R.: 0 < map < 1                         | Residual volumetric soil moisture content layer 3            |
| Lambda1 for forest                                        | lambda1_forest.map  | U.: [-] <br> R.: 0 < map < 1                           | Pore size index (λ) layer 1                                  |
| Lambda1 for other                                         | lambda1_other.map   | U.: [-] <br> R.: 0 < map < 1                           | Pore size index (λ) layer 1                                  |
| Lambda2 for forest                                        | lambda2_forest.map  | U.: [-] <br> R.: 0 < map < 1                           | Pore size index (λ) layer 2                                  |
| Lambda2 for other                                         | lambda2_other.map   | U.: [-] <br> R.: 0 < map < 1                           | Pore size index (λ) layer 2                                 |
| Lambda3 for forest and other                               | lambda3.map         | U.: [-] <br> R.: 0 < map < 1                         | Pore size index (λ) layer 3                                  |
| GenuAlpha1 for forest                                     | alpha1_forest.map   | U.: [-] <br> R.: 0 < map < 1                           | Van Genuchten parameter α layer 1                            |
| GenuAlpha1 for other                                      | alpha1_other.map    | U.: [-] <br> R.: 0 < map < 1                           | Van Genuchten parameter α layer 1                            |
| GenuAlpha2 for forest                                     | alpha2_forest.map   | U.: [-] <br> R.: 0 < map < 1                           | Van Genuchten parameter α layer 2                            |
| GenuAlpha2 for other                                      | alpha2_other.map    | U.: [-] <br> R.: 0 < map < 1                           | Van Genuchten parameter α layer 2                            |
| GenuAlpha3 for forest and other                            | alpha3.map          | U.: [-] <br> R.: 0 < map < 1                          | Van Genuchten parameter α layer 3                            |
| Sat1 for forest                                           | ksat1_forest.map    | U.: $\frac{cm} {day}$ <br> R.: 1 ≤ map ≤ 100           | Saturated conductivity layer 1                               |
| Sat1 for other                                            | ksat1_other.map     | U.: $\frac{cm} {day}$ <br> R.: 1 ≤ map ≤ 100           | Saturated conductivity layer 1                               |
| Sat2 for forest                                           | ksat2_forest.map    | U.: $\frac{cm} {day}$ <br> R.: 1 ≤ map ≤ 100           | Saturated conductivity layer 2                               |
| Sat2 for other                                            | ksat2_other.map     | U.: $\frac{cm} {day}$ <br> R.: 1 ≤ map ≤ 100           | Saturated conductivity layer 2                               |
| Sat3 for forest and other                                 | ksat3.map           | U.: $\frac{cm} {day}$ <br> R.: 1 ≤ map ≤ 100           | Saturated conductivity layer 3                               |
| **CHANNEL GEOMETRY**                                       |                     |                                                        |                                                              |
| Channels                                                   | chan.map            | U.: [-] <br> R.: 0 or 1                                | Map with Boolean 1 for all channel pixels, and Boolean 0 for all other pixels on MaskMap |
| ChanGrad                                                   | changrad.map        | U.: $\frac{m} {m}$ <br> R.: map > 0  <br> !!!          | Channel gradient                                             |
| ChanMan                                                    | chanman.map         | U.: [-] <br> R.: map > 0                               | Manning's roughness coefficient for channels                 |
| ChanLength                                                 | chanleng.map        | U.: $m$ <br> R.: map > 0                               | Channel length (can exceed grid size, to account for meandering rivers) |
| ChanBottomWidth                                            | chanbw.map          | U.: $m$ <br> R.: map > 0                               | Channel bottom width                                         |
| ChanSdXdY                                                  | chans.map           | U.: $\frac{m} {m}$ <br> R.: map ≥ 0                    | Channel side slope Important: defined as horizontal divided by vertical distance (dx/dy); this may be confusing because slope is usually defined the other way round (i.e. dy/dx)! |
| ChanDepthThreshold                                        | chanbnkf.map        | U.: $m$ <br> R.: map > 0                               | Bankfull channel depth                                       |
| **DEVELOPMENT OF VEGETATION OVER TIME**                    |                     |                                                        |                                                              |
| LAIMaps for forest                                         | lai_forest          | U.: $\frac{m^2} {m^2}$ <br> R.: map ≥ 0                | Pixel-average Leaf Area Index for forest                     |
| LAIMaps for irrigated areas                                | lai_irrigation          | U.: $\frac{m^2} {m^2}$ <br> R.: map ≥ 0                | Pixel-average Leaf Area Index for irrigated areas                    |
| LAIMaps for other                                          | lai_other           | U.: $\frac{m^2} {m^2}$ <br> R.: map ≥ 0                | Pixel-average Leaf Area Index for other                      |
| **DEFINITION OF INPUT/OUTPUT TIMESERIES**                  |                     |                                                        |                                                              |
| Gauges                                                     | outlets.map         | U.: [-] <br> R.: For each station an individual number | Nominal map with locations at which discharge timeseries are reported (usually correspond to gauging stations) |
| Sites                                                      | sites.map           | U.: [-] <br> R.: For each station an individual number | Nominal map with locations (individual pixels or areas) at which timeseries of intermediate state and rate variables are reported (soil moisture, infiltration, snow, etcetera) |



***Table:*** *Optional maps that define grid size.* 

| Map             | Default name | Units, range             | Description           |
| --------------- | ------------ | ------------------------ | --------------------- |
| PixelLengthUser | pixleng.map  | U.: $m$ <br> R.: map > 0 | Map with pixel length |
| PixelAreaUser   | pixarea.map  | U.: $m$ <br> R.: map > 0 | Map with pixel area   |



## Tables
The following table gives an overview of the relevant tables required by LISFLOOD.

***Table:*** *LISFLOOD input tables.*                      

| Table                                            | Default name | Description                                                           |
| -----------------------------------------------  | ------------ | ----------------------------------------------------------------------|
| **LAND USE**                                     |              |                                                                       |
| Day of the year -> LAI                           | LaiOfDay.txt | Lookup table: Day of the year -> LAI map                              |
| **LAKE MODULE**                                  |              |                                                                       |
| Lake ID -> area                                  | lakearea.txt | Lookup table: lake ID -> lake surface area $[m^2]$                    |
| Lake ID -> $\alpha$                              | lakea.txt    | Lookup table: lake ID -> lake parameter $\alpha$                      |
| Lake ID -> av. inflow                            | lakeavin.txt | Lookup table: lake ID -> lake average inflow $[m^3/s]$                |
| **RESERVOIR MODULE**                             |              |                                                                       |
| Reservoir ID -> total storage                    | rstor.txt    | Lookup table: reservoir ID -> total reservoir storage volume  $[m^3]$ |
| Reservoir ID -> conservative storage             | rclim.txt    | Lookup table: reservoir ID -> conservative storage volume  $[m^3]$    |
|  Reservoir ID -> flood storage limit             | rflim.txt    | Lookup table: reservoir ID -> flood storage volume  $[m^3]$    |
|  Reservoir ID -> minimum outflow                 | rminq.txt    | Lookup table: reservoir ID -> minimum outflow  $[m^3\s]$              |
|  Reservoir ID -> maximum non-damaging outflow    | rndq.txt     | Lookup table: reservoir ID ->  maximum non-damaging outflow $[m^3\s]$ |

[🔝](#top)
