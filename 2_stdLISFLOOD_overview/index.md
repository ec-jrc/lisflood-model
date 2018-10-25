### Overview

The figure below gives an overview of the structure of the LISFLOOD model.

-   a 2-layer soil water balance sub-model

-   sub-models for the simulation of groundwater and subsurface flow (using 2 parallel interconnected linear reservoirs)

-   a sub-model for the routing of surface runoff to the nearest river channel

-   a sub-model for the routing of channel flow (not shown in the Figure)

The processes that are simulated by the model include snow melt (not shown in the Figure), infiltration, interception of rainfall, leaf drainage, evaporation and water uptake by vegetation, surface runoff, preferential flow (bypass of soil layer), exchange of soil moisture between the two soil layers and drainage to the groundwater, sub-surface and groundwater flow, and flow through river channels. Each of these
processes is described in more detail in this technical documentation.

![](https://ec-jrc.github.io/lisflood_manual/media/image6.jpg)



**Figure 1:** Overview  of the LISFLOOD model. $P$: precipitation; $Int$:  interception; $EW_{int}$: evaporation  of  intercepted water; $D_{int}$: leaf  drainage; $ES_a$: evaporation from soil surface; $T_a$: transpiration (water uptake by plant roots); $INF_{act}$: infiltration; $R_s$: surface runoff; $D_{1,2}$: drainage from top- to subsoil; $D_{2,gw}$: drainage from subsoil to upper groundwater zone; $D_{pref,gw}$: preferential flow to upper groundwater zone; $D_{uz,lz}$: drainage from upper- to lower groundwater zone; $Q_{uz}$: outflow from upper groundwater zone; $Q_l$: outflow from lower groundwater zone; $ D_{loss}$: loss from lower groundwater zone.


[:top:](#top)




