# Standard LISFLOOD processes

## Overview

### LISFLOOD model scheme

The figure below provides a first overview on the processes included in LISFLOOD:

![Overview  of the LISFLOOD model](../media/image6.png)
**Figure:** Overview  of the LISFLOOD model. $P$: precipitation; $E$:  evaporation & evapotranspiration; $SnCoef$: snow melt; $b_{xin}$: infiltration; $Chan_{N2}$: surface runoff; $GW_{perc}$: drainage from upper- to lower groundwater zone; $T_{uz}$: outflow from upper groundwater zone; $T_{lz}$: outflow from lower groundwater zone; $R_{ch}$: drainage from subsoil to upper groundwater zone; drainage from top- to subsoil; $C_{pref}$: preferential flow to upper groundwater zone.

**


![ LISFLOOD model scheme (symbols)](../media/LISFLOOD.png){:height="200px" width="200px"} ![ LISFLOOD model scheme (explained)](../media/LISFLOOD_explained.png)
**Figure:** model variables and component

The standard LISFLOOD model setup is made up of the following components:

- a 3-layer soil water balance sub-model
- sub-models for the simulation of groundwater and subsurface flow (using 2 parallel interconnected linear reservoirs)
- a sub-model for the routing of surface runoff to the nearest river channel
- a sub-model for the routing of channel flow

The processes that are simulated by the model include also snow melt, infiltration, interception of rainfall, leaf drainage, evaporation and water uptake by vegetation, surface runoff, preferential flow (bypass of soil layer), exchange of soil moisture between the two soil layers and drainage to the groundwater, sub-surface and groundwater flow, and flow through river channels.

### Sub-grid variability

Before going into detail with the individual hydrological processes, here first some explaination on a larger conceptual approach on how LISFLOOD is dealing with sub-grid variability in land cover and the consecutive influence on various processes.

#### Representation of land cover

In LISFLOOD a number of parameters are linked directly to land cover classes. In the past, this was done through lookup tables. The spatially dominant land use class had been used (see Figure below) to assign the corresponding grid parameter values. This implies that some of the sub-grid variability in land use, and consequently in the parameter of interest, were lost.

![Land cover aggregation approach in previous versions of LISFLOOD](../media/image13.jpg)
**_Figure:_** *Land cover aggregation approach in previous versions of LISFLOOD.*

In order to account properly for land use dynamics, some conceptual changes have been made to render LISFLOOD more land-use sensitive. To account for the sub-grid variability in land use, we model the within-grid variability. In the latest version of the hydrological model, the spatial distribution and frequency of each class is defined as a percentage of the whole represented area of the new pixel. Combining land cover classes and modeling aggregated classes, is known as the concept of hydrological response units (HRU). The logic behind this approach is that the non-linear nature of the rainfall-runoff processes on different land cover surfaces observed in reality will be better captured. This concept is also used in models such as SWAT (Arnold and Fohrer, 2005) and PREVAH (Viviroli et al., 2009). LISFLOOD has been transferred a HRU approach on sub-grid level, as shown here:

![LISFLOOD land cover aggregation by modelling aggregated land use classes separately](../media/image63.png)
**_Figure:_** *LISFLOOD land cover aggregation by modelling aggregated land use classes separately: Percentages of forest (dark green); water (blue), impervious surface (red), irrigated agriculture (green) other classes (light green).*

#### Soil model

If a part of a pixel is made up of built-up areas this will influence that pixel's water-balance. LISFLOOD's 'direct runoff fraction's parameter ($f_{dr}$) defines the fraction of a pixel that is impervious.

**For impervious areas**, LISFLOOD assumes that:
1. A depression storage is filled by precipitation and snowmelt and emptied by evaporation
2. Any water that is not filling a depression storage, reaches the surface and is added directly to surface runoff
3. The storage capacity of the soil is zero (i.e. no soil moisture storage in the direct runoff fraction)
4. There is no groundwater storage

**For open water** (e.g. lakes, rivers) the water fraction parameter ($f_{water}$) defines the fraction that is covered with water (large lakes that are in direct connection with major river channels can be modelled using [LISFLOOD's lake option](https://ec-jrc.github.io/lisflood-model/3_optLISFLOOD_lakes/). 

**For water covered areas**, LISFLOOD assumes that:
1. Actual evaporation is equal to potential evaporation on open water
3. The storage capacity of the soil is zero (i.e. no soil moisture storage in the water fraction)
4. There is no groundwater storage

**For forest** $(f_{forest})$ **or irrigated agriculture** $(f_{irrigated})$ **or other land cover** $(f_{other}=1-f_{forest}-f{irrigated}-f_{dr}-f_{water})$ the description of all soil- and groundwater-related processes below (evaporation, transpiration, infiltration, preferential flow, soil moisture redistribution and groundwater flow) are valid. While the modelling structure for forest, irrigated agriculture and other classes is the same, the difference is the use of different map sets for leaf area index, soil and soil hydraulic properties. Because of the nonlinear nature of the rainfall runoff processes this should yield better results than running the model with average parameter values. The table below summarises the profiles of the four individually modelled categories of land cover classes.

***Table:*** *Summary of hydrological properties of the five categories modelled individually in the modified version of LISFLOOD.*

| Category                                                     | Evapotranspiration                                           | Soil                                                      | Runoff                                                       |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :-------------------------------------------------------- | :----------------------------------------------------------- |
| Forest                                                       | High level of evapo-transpiration (high Leaf area index) seasonally dependent | Large rooting depth                                       | Low concentration time                                       |
| Impervious surface                                           | Not applicable                                               | Not applicable                                            | Surface runoff but initial loss and depression storage, fast concentration time |
| Inland water                                                 | Maximum evaporation                                          | Not applicable                                            | Fast concentration time                                      |
| Irrigated agriculture                                        | Evapotranspiration lower than for forest but still significant | Rooting depth lower than for forest but still significant | Medium concentration time                                    |
| Other (agricultural areas, non-forested natural area, pervious surface of urban areas) | Evapotranspiration lower than for forest but still significant | Rooting depth lower than for forest but still significant | Medium concentration time                                    |

If you activate any of LISFLOOD's options for writing internal model fluxes to time series or maps (described in [TODO]()), 
the model will report the real fluxes, which are the fluxes multiplied by the corresponding fraction. 
The Figure below illustrates this for evapotranspiration (evaporation and transpiration) which calculated differently for each of this five aggregated classes. 
The total sum of evapotranspiration for a pixel is calculated by adding up the fluxes for each class multiplied by the fraction of each class.

![simulation of aggregated land cover classes](../media/image24-resize.png)
***Figure:***  $ET_{forest} \to ET_{irrigated}\to ET_{other} \to ET_{dr} \to ET_{water}$ *simulation of aggregated land cover classes in LISFLOOD.*

In this example, evapotranspiration (ET) is simulated for each aggregated class separately  $(ET_{forest}, ET_{irrigated},ET_{dr}, ET_{water}, ET_{other})$ 
As result of the soil model you get five different surface fluxes weighted by the corresponding fraction $(f_{dr},f_{water},f_{forest},f_{other},f_{irrigated})$, 
respectively three fluxes for the upper and lower groundwater zone and for groundwater loss also weighted by the corresponding fraction $(f_{forest},f_{irrigated},f_{other})$. 
However a lot of the internal flux or states (e.g. preferential flow for forested areas) can be written 
to disk as map or timeseries by activate LISFLOOD's options (described in [TODO]()).

[🔝](#top)
