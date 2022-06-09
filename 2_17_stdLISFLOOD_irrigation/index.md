### Paddy-rice irrigation

Paddy-rice irrigation is simulated by a dedicated model subroutine which can be switched on by adding the following lines to the 'lfoptions' element:

```xml
<setoption choice="1" name="riceIrrigation"/>
```
Water abstraction and return is computed differently during the following phases: soil preparation, planting, growth, and harvest. 

* Soil saturation: it is assumed that the soil is saturated in 10 days, starting from 20 days before the planting day. The **daily** rice soil saturation demand is then computed as follows:
<br>*RiceSaturationDemand* = $0.1 \cdot (w_{s1a} - w_1a)+(w_{s1b} - w_1b) \cdot$ *RiceFrac* $\cdot \Delta t$
<br>where $w_{s1a}$, $w_{s1b}$ and $w_1a$, $w_1b$ are the maximum and actual amounts of moisture in the superficial and upper soil layers, respectively (all in $[mm]$). It is here noted that the superficial and upper soil layers extend to include at least the [rootdepth](https://ec-jrc.github.io/lisflood-code/4_Static-Maps_land-use-depending/). *RiceFrac* is the fraction of a pixel used to grow rice (this value is suppllied as an input data).

* Field flooding: this phase starts after the soil has been saturated (i.e. 10 days before the planting day) and it requires 10 days. The water demand during this phase must also account for the losses due to the evaporation from the open water surface:
<br>*TotalRiceFloodingDemand = RiceFloodingDemand + RiceEvaporationDemand*
<br>*RiceFloodingDemand* is computed as follows:
<br>*RiceFloodingDemand = RiceFlooding* $\cdot$ *RiceFrac* $\cdot \Delta t$
<br>where *RiceFlooding* is the daily amount of water supplied to the field (in *mm/day*). For instance, a *RiceFlooding* supply of *10 mm/day* will achieve a water depth of *100 mm*. 
<br>*RiceEvaporationDemand* is given by:
<br>*RiceEvaporationDemand =* $[EW0 - (ES_a+ T_a)] \cdot \Delta t$ 
<br>where $EW0$ is the potential evaporation rate from an open water surface, $ES_a$ is the actual evaporation from the soil, and $T_a$ is the actual transpiration (all in $[\frac{mm}{day}]$). The latter two terms are subtracted from the computation as they are already considered when computing [soil evaporation](https://ec-jrc.github.io/lisflood-model/2_08_stdLISFLOOD_soil-evaporation/) and [plant transpiration](https://ec-jrc.github.io/lisflood-model/2_07_stdLISFLOOD_plant-water-uptake/). 

* Growing phase: the water level in the field is kept constant starting from the planting day and up to 20 days before harvesting. The amount of water supplied to the field during this phase must compensate for evaporation and percolation losses and is computed as follows:
<br>*TotalRiceGrowingDemand = RicePercolationWater + RiceEvaporationDemand*
<br>*RicePercolationWater* depends on the value *RicePercolation*, which represents he amount of water percolating to the upper groundwater layer (UZ):
<br>*RicePercolationWater = RicePercolation* $\cdot$ *RiceFrac* $\cdot \Delta t$
<br>For instance, the percolation for heavy clay soils is *2 mm/day* ([FAO](http://www.fao.org/3/a-s8376e.pdf)).

* Draining phase: this phase starts 10 days before the harvesting and lasts for 10 days. The draining has the scope to reduce the soil moisture to the field capacity value, the quantity *RiceDrainageWater* is computed as follows:
<br>*RiceDrainageWater* = $0.1 \cdot (w_{s1a}-w_{fc,1a})+(w_{s1b} - w_{fc,1b}) \cdot$ *RiceFrac* $\cdot \Delta t$
<br>where $w_{s1a}$, $w_{s1b}$ and $w_{fc,1a}$, $w_{fc,1b}$ are the amounts of moisture at saturation and at field capacity in the superficial and upper soil layers, respectively (all in $[mm]$).
<br>*RiceDrainageWater* is added to the upper groundwater layer (UZ).

*RiceSaturationDemand*, *TotalRiceFloodingDemand*, *TotalRiceGrowingDemand* are [extracted from surface water bodies](https://ec-jrc.github.io/lisflood-model/2_18_stdLISFLOOD_water-use/) according to the calendar day and they define the *RiceIrrSurfWaterAbstr*:
<br>*RiceIrrSurfWaterAbstr = RiceSaturationDemand + TotalRiceFloodingDemand + TotalRiceGrowingDemand*


*RicePercolationWater* and *RiceDrainageWater* are [added to the upper groundwater layer UZ](https://ec-jrc.github.io/lisflood-model/2_13_stdLISFLOOD_groundwater/) according to the calendar day.


