## Irrigation

Crop irrigation and Paddy-rice irrigation are dealt with by separate model subroutines.

### Crop irrigation

Crop irrigation can be switched on by adding the following lines to the 'lfoptions' element:

```xml
<setoption choice="1" name="drainedIrrigation"/>
```


### Paddy-rice irrigation

Paddy-rice irrigation is simulated by a dedicated model subroutine which can be switched on by adding the following lines to the 'lfoptions' element:

```xml
<setoption choice="1" name="riceIrrigation"/>
```
Water abstraction and return is computed differently during the following phases: soil preparation, planting, growth, and harvest. 
* Soil saturation: it is assumed that the soil is saturated in 10 days, starting from 20 days before the planting day. The **daily** rice soil saturation demand is then computed as follows

$$
RiceSaturationDemand = 0.1 \cdot (w_s_1 - w_1)+(w_s_2 - w_2) \cdot RiceFraction \cdot \Delta t
$$

where $w_s_1$, $w_s_2$ and $w_1$, $w_2$ are the maximum and actual amounts of moisture in the upper and lower soil layers, respectively (all in $[mm]$), and $RiceFraction is the fraction of a pixel used to grow rice (this value is suppllied as an input data).

* Field flooding: this phase starts after the soil has been saturated (i.e. 10 days before the planting day) and it requires 10 days. The water demand during this phase must also account for the losses due to the evaporation from the open water surface:

$$
TotalRiceFloodingDemand = RiceFloodingDemand + RiceEvaporationDemand
$$

$$
RiceFloodingDemand = RiceFlooding \cdot RiceFraction \cdot \Delta t 
$$

where RiceFlooding is the daily amount of water supplied to the field (in $[\frac{mm}{day}]$). For instance, a RiceFlooding supply of 10 $[\frac{mm}{day}]$ will achieve a **final** water depth of 1000 mm. 

$$
RiceEvaporationDemand = [EW0 - (ES_a+ T_a)] \cdot \Delta t 
$$

where $EW0$ is the potential evaporation rate from an open water surface, $ES_a$ is the actual evaporation from the soil, and $T_a$ is the actual transpiration (all in $[\frac{mm}{day}]$). The latter two terms are subtracted from the computation as they are alredy considered when computing soil evaporation and transpiration **ADD CHAPTERS/LINKS**. 

* Growing phase: the water level in the field is kept constant starting from the planting day and up to 20 days before harvesting. The amount of water supplied to the field during this phase must compensate for evaporation and percolation losses and is computed as follows:

$$
TotalRiceGrowingDemand = RicePercolationDemand + RiceEvaporationDemand
$$

and 

$$
RicePercolationWater = RicePercolation \cdot RiceFraction \cdot \Delta t 
$$

where $RicePercolation$ is the amount of water percolating to the upper groundwater layer (UZ). For instance, the percolation for heavy clay soils is 2 mm/day (FAO) **ADD LINK**.

* Draining phase: this phase starts 10 days before the harvesting and lasts for 10 days. The draining has the scope to reduce the soil moisture to the field capacity value, the RiceDrainageWater is computed using the equation below and it is added to the upper groundwater layer (UZ).

$$
RiceDrainageWater = 0.1 \cdot (w_s_1 - w_f_c_1)+(w_s_2 - w_f_c_2) \cdot RiceFraction \cdot \Delta t
$$

$RiceSaturationDemand$, $TotalRiceFloodingDemand$, $TotalRiceGrowingDemand$ are extracted from surface water bodies according to the calendar day (**ADD CHAPTER/LINK**).

$RicePercolationWater$ and $RiceDrainageWater$ are added to the upper groundwater layer UZ  accpording to the calendar day (**ADD CHAPTER/LINK**).


