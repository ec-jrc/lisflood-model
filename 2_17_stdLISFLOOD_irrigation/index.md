### Paddy-rice irrigation

Paddy-rice irrigation is simulated by a dedicated model subroutine which can be switched on by adding the following lines to the `lfoptions` element of the settings file:

```xml
<setoption choice="1" name="riceIrrigation"/>
```

Water abstraction and return is computed differently during the following phases: soil preparation, planting, growth, and harvest. 

1. **Soil saturation**: it is assumed that the soil is saturated during 10 days, starting from 20 days before the planting day. The **daily** rice soil saturation demand is then computed as follows:
$$RiceSaturationDemand = 0.1 \cdot (w_{s1a} - w_{1a})+(w_{s1b} - w_{1b}) \cdot RiceFrac \cdot \Delta t$$
where $w_{s1a}$, $w_{s1b}$, $w_{1a}$ and $w_{1b}$ are the saturated and actual soil moisture in the superficial and upper soil layers, respectively (all in mm). It is here noted that the superficial and upper soil layers extend to include at least the [rootdepth](https://ec-jrc.github.io/lisflood-code/4_Static-Maps_land-use-depending/). $RiceFrac$ is the fraction of a pixel dedicated to growing rice, a value that is supplied as an input data.

2. **Field flooding** starts after the soil has been saturated (i.e. 10 days before the planting day) and it lasts for 10 days. The water demand during this phase must also account for the losses due to evaporation from the open water surface:
$$
TotalRiceFloodingDemand = RiceFloodingDemand + RiceEvaporationDemand
$$
where $RiceFloodingDemand$ is calculated from $RiceFlooding$, the dail amount of water supplied to the field (in mm/day). For instance, a $RiceFlooding$ supply of 10 mm/day will achieve a water depth of 100 mm.
$$
RiceFloodingDemand = RiceFlooding \cdot RiceFrac \cdot \Delta t
$$
$RiceEvaporationDemand$ is the amount of evaporation required to fulfil the open water eporation potential.
$$
RiceEvaporationDemand = \left[EW_0 - (ES_a+ T_a)\right] \cdot \Delta t
$$
where $EW_0$ is the potential evaporation rate from an open water surface, $ES_a$ is the actual evaporation from the soil, and $T_a$ is the actual transpiration (all in mm/day). The latter two terms are subtracted from the computation as they are already considered when computing [soil evaporation](https://ec-jrc.github.io/lisflood-model/2_08_stdLISFLOOD_soil-evaporation/) and [plant transpiration](https://ec-jrc.github.io/lisflood-model/2_07_stdLISFLOOD_plant-water-uptake/). 

3. **Growing phase** expands from the planting day to 20 days before harvesting. During this phase, the water level in the field is kept constant; therefore, the amount of water supplied to the field during this phase must compensate for evaporation and percolation losses and is computed as follows:
$$
TotalRiceGrowingDemand = RicePercolationWater + RiceEvaporationDemand
$$
where $RicePercolationWater$ depends on the value $RicePercolation$, which represents the amount of water percolating to the upper groundwater layer (UZ):
$$
RicePercolationWater = RicePercolation \cdot RiceFrac \cdot \Delta t
$$
For instance, the percolation for heavy clay soils is *2 mm/day* ([FAO](http://www.fao.org/3/a-s8376e.pdf)).

4. **Draining phase** starts 10 days before harvesting and lasts for 10 days. The draining has the scope to reduce the soil moisture to the field capacity value, the quantity $RiceDrainageWater$ is computed as follows:
$$
RiceDrainageWater = 0.1 \cdot \left( w_{s1a} - w_{fc,1a} \right) + \left( w_{s1b} - w_{fc,1b} \right) \cdot RiceFrac\cdot \Delta t
$$
where $w_{s1a}$, $w_{s1b}$, $w_{fc,1a}$ and $w_{fc,1b}$ are the amounts of moisture at saturation and field capacity in the superficial and upper soil layers, respectively (all in mm). $RiceDrainageWater$ is added to the upper groundwater layer (UZ).
<br>

$RiceSaturationDemand$, $TotalRiceFloodingDemand$, $TotalRiceGrowingDemand$ are [extracted from surface water bodies](https://ec-jrc.github.io/lisflood-model/2_18_stdLISFLOOD_water-use/) according to the calendar day and they define the $RiceIrrSurfWaterAbstr$:
$$
RiceIrrSurfWaterAbstr = RiceSaturationDemand + TotalRiceFloodingDemand + TotalRiceGrowingDemand
$$

$RicePercolationWater$ and $RiceDrainageWater$ are [added to the upper groundwater layer UZ](https://ec-jrc.github.io/lisflood-model/2_13_stdLISFLOOD_groundwater/) according to the calendar day.