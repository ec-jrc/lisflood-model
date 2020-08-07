## Water use


### Introduction

This page describes the LISFLOOD water use routine, and how it is used. It is strongly advisable that the water use routine is always used, even in flood forecasting mode, as irrigation and other abstractions can be of substantial influence to flow conditions, and also since the water use mode was used during the calibration.

The water use routine is used to include water demand, abstraction, net consumption and return flow from various societial sectors:
-   dom:  use of water in the public sector, e.g. for domestic use
-   liv:  use of water for livestock
-   ene:  use of cooling water for the energy sector in thermal or nuclear power plants
-   ind:  use of water for the manufacturing industry
-   irr:  water used for crop irrigation
-   ric:  water used for paddy-rice irrigation

The module water use can be activated by adding the following line to the 'lfoptions' element:

```xml
	<setoption choice="1" name="wateruse"/>
```


### Water demand, abstraction and consumption

LISFLOOD distinguishes between water demand, water abstraction, water consumption and return flow. Abstractions are typically higher than demands due leakage in the public supply network, transmission and evaporation losses during irrigation water transport. Water consumption per sector is typically lower than water demand per sector, since only a part of the water is actually used (and hence exits the system), while the remaining fraction is returned to the system later on. The difference between water abstraction and water consumption is the water return flow. The consumptive water use is the water removed from available supplies without return to a water resource system. LISFLOOD computes the consumptive water use.

### PART ONE: SECTORS of water demand and consumption

LISFLOOD distinguisges the following sectors of water consumption:
-   dom:  use of water in the public sector, e.g. for domestic use
-   liv:  use of water for livestock
-   ene:  use of cooling water for the energy sector in thermal or nuclear power plants
-   ind:  use of water for the manufacturing industry

Water demand files for each sector need to be created, in mm per day per gridcell, so typically:
-   dom.nc (mm per timestep per gridcell) for domestic water demand
-   liv.nc (mm per timestep per gridcell) for livestock water demand
-   ene.nc (mm per timestep per gridcell) for energy-cooling water demand
-   ind.nc (mm per timestep per gridcell) for manufacturing industry water demand

Typically, water demands are related to amounts of population, livestock, Gross Domestic Product (GDP), gross value added (GVA). They are typically obtained by downscaling national or regional reported data using with higher resolution land use maps.

Paddy-rice irrigation water demand is simulated as described in the [dedicated chapter](https://ec-jrc.github.io/lisflood-model/2_17_stdLISFLOOD_irrigation/); this chapter explains the computation of the water demand for crop irrigation.


#### Public water usage and leakage

Public water demand is the water requirement through the public supply network. The water demand externally estimated in mm/day/gridcell and is read into LISFLOOD. Typically, domestic water demands are obtained by downscaling national reported data with higher resolution population maps.

LISFLOOD takes into account that leakage exist in the public supply network, which is defined in an input map:

```xml
<textvar name="LeakageFraction" value="$(PathMaps)/leakage.map">
<comment>
$(PathMaps)/leakage.map
   Fraction of leakage of public water supply (0=no leakage, 1=100% leakage)
</comment>
</textvar>
```

The leakage - typically only available as an average percentage per country - is then used to determine the required water abstraction:

Domestic Water Abstraction = dom.nc * (1 + leakage.map)

The actual water consumption of the domestic sector is much less than the abstraction, and is defined by a fixed coefficient or a map if spatial differences are known:

```xml
<textvar name="DomesticConsumptiveUseFraction" value="0.20">
<comment>
	Consumptive Use (1-Recycling ratio) for domestic water use (0-1)
	Source: EEA (2005) State of Environment
</comment>
</textvar>
```

So, the actual: 

Domestic Water Consumption = DomesticConsumptiveUseFraction * dom.nc

Domestic Water Return Flow = (1 - DomesticConsumptiveUseFraction) * dom.nc

$$
DomesticWaterAbstraction = DomesticWaterDemand \cdot DomesticWaterSavingConstant \cdot DomesticWaterLeakageConstant
$$

where 
* $$DomesticWaterSavingConstant = 1 - WaterSavingFraction$$ and $WaterSavingFraction$ accounts for water saving strategies implemented by the households (and not included in the current use scenario).
* $$DomesticWaterLeakageConstant = \frac{1}{1-[DomesticLeakageFraction \cdot (1 - DomesticLeakageReductionFraction)]}$$. $DomesticLeakageFraction$ represents the fraction of water lost during transport from the source of the abstraction to the final destination and $DomesticLeakageReductionFraction$ allows to account for a reduction in leakage compared to the current scenario.
$WaterSavingFraction$, $DomesticLeakageFraction$, and $DomesticLeakageReductionFraction$ are provided as input data, the baseline value is 0, the maximum value is 1. The value of $DomesticWaterAbstraction$ is decreased by $$DomesticWaterSavingConstant$ and increased by $DomesticWaterLeakageConstant$.

The leakage volume is then computed as follows:

$$
Leakage = (DomesticWaterLeakageConstant - 1) \cdot DomesticWaterDemand \cdot DomesticWaterSavingConstant
$$

The input value $LeakageWaterLossFraction$ allows to compute the leakage volume which is lost because of evaporation:

$$
LeakageWaterEvaporated = Leakage \cdot LeakageWaterLossFraction
$$

Finally, it must be considered that only a fraction of the domestic water demand is consumed by the households. This fraction is the $DomesticConsumptiveUseFraction$, its value varies between 0 and 1 and it is provided as input data.

The total amount of water which leaves the system (and consequently must be subtracted from the water balance) due to domestic water use is then computed as follows:

$$
DomesticWaterConsumptiveUse = DomesticWaterDemand \cdot DomesticWaterSavingConstant \cdot DomesticConsumptiveUseFraction + LeakageWaterEvaporated 
$$

It is here noted that the return flow is given by the difference between the domestic water abstraction and the domestic water consumptive use.


#### Water usage by the energy sector for cooling

Thermal powerplants generate energy through heating water, turn it into steam which spins a steam turbine which drives an electrical generator. Almost all coal, petroleum, nuclear, geothermal, solar thermal electric, and waste incineration plants, as well as many natural gas power stations are thermal, and they require water for cooling during their processing.
LISFLOOD typically reads an 'ene.nc' file which determines the water demand for the energy sector in mm/day/pixel. Typically, this map is derived from downscaling national reported data using a map of the thermal power plants.

An "EnergyConsumptiveUseFraction" is used to determine the consumptive water usage of thermal power plants

```xml
<textvar name="EnergyConsumptiveUseFraction" value="$(PathMaps)/energyconsumptiveuse.map">
<comment>
	# Consumptive Use (1-Recycling ratio) for energy water use (0-1)
</comment>
</textvar>
```

For small rivers the consumptive use varies between 1:2 and 1:3, so 0.33-0.50 (Source: Torcellini et al. (2003) "Consumptive Use for US Power Production"), while for plants close to large open water bodies values of around 0.025 are valid.


The $EnergyWaterAbstraction$ is assumed equal to the $EnergyWaterDemand$ (i.e. losses are assumed to be 0). So, the actual $EnergyWaterConsumptiveUse$ is:

$$
EnergyWaterConsumptiveUse = EnergyWaterDemand \cdot EnergyConsumptiveUseFraction 
$$

It is here noted that the return flow is given by the difference between the water abstraction and the water consumptive use.


#### Water usage by the manufacturing industry

The manufucaturing industry also required water for their processing, much depending on the actual product that is produced, e.g. the paper industry or the clothing industry. LISFLOOD typically reads an 'ind.nc' file which determines the water demand for the industry sector in mm/day/pixel. Typically, this map is derived from downscaling national reported data using maps of land use and/or the specific activities.

The amount of water that needs to be abstracted to comply with the demand of the manufacturing industry ($IndustrialWaterAbstraction$) is often lower than the actual demand ($IndustrialWaterDemand$) as part of the water is re-used within the industrial processes. The $WaterReUseFraction$ is provided as inpout data, its value varies between 0 and 1 (for instance, a value of 0.5 indicates that half of the water is re-used, that is, used twice). The $IndustrialWaterAbstraction$  is then computed as follows:

$$
IndustrialWaterAbstraction = IndustrialWaterDemand * (1 - WaterReUseFraction)
$$

An $IndustrialConsumptiveUseFraction$ is used to determine the consumptive water usage of the manufacturing industry. This can either be a fixed value, or a spatial explicit map.

```xml
<textvar name="IndustrialConsumptiveUseFraction" value="0.15">
<comment>
Consumptive Use (1-Recycling ratio) for industrial water use (0-1)
</comment>
</textvar>
```

The $IndustrialWaterConsumptiveUse$ is the computed as follows:

$$
IndustrialWaterConsumptiveUse = IndustrialWaterAbstraction \cdot IndustrialConsumptiveUseFraction 
$$

It is here noted that the return flow is given by the difference between the water abstraction and the water consumptive use.


#### Livestock water usage

Livestock also requires water. LISFLOOD typically reads a 'liv.nc' file which determines the water demand for livestock in mm/day/pixel. Mubareka et al. (2013) (http://publications.jrc.ec.europa.eu/repository/handle/JRC79600) estimated the water requirements for the livestock sector. These maps are calculated based on livestock density maps for 2005, normalized by the best available field data at continental scale. Water requirements are calculated for these animal categories: cattle, pigs, poultry and sheep and goats. The cattle category is further disaggregated to calves, heifers, bulls and dairy cows. Using values given in the literature, a relationship using air temperature is inferred for the daily water requirements per livestock category. Daily average temperature maps are used in conjunction with the livestock density maps in order to create a temporal series of water requirements for the livestock sector in Europe. 

An "LivestockConsumptiveUseFraction" is used to determine the consumptive water usage of livestock. This can either be a fixed value, or a spatial explicit map.

```xml
<textvar name="LivestockConsumptiveUseFraction" value="0.15">
<comment>
Consumptive Use (1-Recycling ratio) for livestock water use (0-1)
</comment>
</textvar>
```

So, the actual: 

$$
LivestockWaterConsumptiveUse = LivestockConsumptiveUseFraction * LivestockWaterDemand
$$

The $LivestockWaterAbstraction$ is assumed equal to the $LivestockWaterDemand$.

It is here noted that the return flow is given by the difference between the water abstraction and the water consumptive use.

#### Water usage for crop irrigation

Crop irrigation and paddy-rice irrigation are simulated using seperate model subroutines. The methodology for the modelling of paddy-rice irrigation is described [here](https://ec-jrc.github.io/lisflood-model/2_17_stdLISFLOOD_irrigation/). This paragraph explains the computation of the water volume required by crop irrigation. The modelling of crop irrigation requires the following keyword in the 'lfoptions' element:

```xml
<setoption choice="1" name="drainedIrrigation"/>
```
Crop irrigation water demand is assumed equal to the difference between potential transpiration ($T_{max}$) and actual transpiration ($T_a$). The computation of $T_{max}$ and $T_a$ is described in the chapter [Water uptake by roots and transpiration](https://ec-jrc.github.io/lisflood-model/2_07_stdLISFLOOD_plant-water-uptake/). If $T_a$ is compared with the amount of water already available in the soil to compute the amount of water to be supplied by irrigation:

$$
T_{a,irrig} = \min (T_a, w_1 - w_{wp1})
$$

$CropIrrigationWaterDemand$ is then computed by:

$$
CropIrrigationWaterDemand = ( T_{max} - T_{a,irrig} ) \cdot IrrigationMult
$$

where $IrrigationMult$ is a non-dimensional factor generally larger than 1 having the function to account for the additional amount of water required to prevent salinisation problems.

$CropIrrigationWaterAbstraction$ is larger than $CropIrrigationWaterDemand$ in order to account for the water losses within the irrigation system. These losses are quantified using two non-dimensional factors, namely the $IrrigationEfficiency$ and the $ConveyanceEfficiency$. Both these factors can vary between 0 and 1, the values are required as input data. For example, $IrrigationEfficiency$ is ~0.90 for drip irrigation, and ~0.75 for sprinkling irrigation; $ConveyanceEfficiency$ is ~0.80 for a common type channel. $CropIrrigationWaterAbstraction$ is the computed as follows:

$$
CropIrrigationWaterAbstraction = \frac{CropIrrigationWaterDemand}{IrrigationEfficiency \cdot ConveyanceEfficiency}
$$

If the soil is frozen (i.e. the $FrostIndex$ is larger than the $FrostIndexThreshold$), $CropIrrigationWaterDemand$ is set to 0.


                   
### PART TWO: soruces of water abstraction

LISFLOOD can abstract water from groundwater or from surface water (rivers, lakes and or reservoirs), or it is derived from unconventional sources, typically desalination.  

The sub-division in these three sources is achieved by creating and using the following maps:
-   fracgwused.nc (values between 0 and 1) ($FractionGroundwaterUsed$)
-   fracncused.nc (values between 0 and 1) ($FractionNONconventionalSourcesUsed$)

Next, LISFLOOD automatically assumes that the remaining water (1-fracgwused-fracncused) is derived from various sources of surface water.
Specifically, $DomesticWaterConsumpttiveUse$, $IndustrialWaterConsumpttiveUse$, and $LivestockWaterConsumpttiveUse$ can be supplied by groundwater, non-conventional water sources, and surface water. Water resources allocation is computed as follows:

$$
DomesticWaterAbstractionGW = FractionGroundwaterUsed  \cdot DomesticWaterConsumptiveUse
DomesticWaterAbstractionNONconv= FractionNONconventionalSourcesUsed  \cdot DomesticWaterConsumptiveUse
DomesticWaterAbstractionSurfaceWater = DomesticWaterConsumptiveUse - DomesticWaterAbstractionGW  - DomesticWaterAbstractionNONconv
$$

$$
IndustrialWaterAbstractionGW = FractionGroundwaterUsed  \cdot IndustrialWaterConsumptiveUse
IndustrialWaterAbstractionNONconv= FractionNONconventionalSourcesUsed  \cdot IndustrialWaterConsumptiveUse
IndustrialWaterAbstractionSurfaceWater = IndustrialWaterConsumptiveUse - IndustrialWaterAbstractionGW  - IndustrialWaterAbstractionNONconv
$$

$$
LivestockWaterAbstractionGW = FractionGroundwaterUsed  \cdot LivestockWaterConsumptiveUse
LivestockWaterAbstractionNONconv= FractionNONconventionalSourcesUsed  \cdot LivestockWaterConsumptiveUse
LivestockWaterAbstractionSurfaceWater = LivestockWaterConsumptiveUse - LivestockWaterAbstractionGW  - LivestockWaterAbstractionNONconv
$$

$EnergyWaterConsumpttiveUse$ is supplied exclusively by surface water: $$ EnergyAbstractionSurfaceWater = EnergyConsumptiveUse$$.

$CropIrrigationWaterAbstraction$ is supplied by groundwater and surface water:

$$
CropIrrigationWaterAbstractionGW = FractionGroundwaterUsed  \cdot CropIrrigationWaterAbstraction
CropIrrigationWaterAbstractionSurfaceWater = CropIrrigationWaterAbstraction - CropIrrigationWaterAbstractionGW 
$$

[$RiceIrrigationAbstractionSurfaceWater$](https://ec-jrc.github.io/lisflood-model/2_17_stdLISFLOOD_irrigation/) is supplied exclusively by surface water.

Surface water sources for abstraction may consist of lakes, reservoirs, and rivers. The definition of the contribution of each surface water body is explained in the paragraph *Surface water abstractions from reservoirs, lakes, and rivers*.

#### Groundwater abstractions 

The total amount of water that is required from groundwater resources is:

$$
TotalWaterAbstractionFromGroundWater = DomesticWaterAbstractionGW  + IndustrialWaterAbstractionGW  + 
LivestockWaterAbstractionGW + CropIrrigationWaterAbstractionGW 
$$

**In the current LISFLOOD version, groundwater is abstracted for a 100%, so no addtional losses are accounted for, by which more water would need to be abstracted to meet the demand. Also, in the current LISFLOOD version, no limits are set for groundwater abstraction.**

LISFLOOD subtracts groundwater from the Lower Zone (LZ). Groundwater depletion can thus be examined by monitoring the LZ levels between the start and the end of a simulation. Given the intra- and inter-annual fluctuations of LZ, it is advisable to extend the monitoring period to at least a decade.

The total amount of water that is required from groundwater resources is compared to the amount of water that is actually available in the Lower Zone. If the water storage in the lower groundwater zone  decreases below the value $LZThreshold$ [mm], the flow from the lower zone to the nearby rivers (base-flow) stops. When sufficient recharge is added to raise the lower zone levels above the threshold, base-flow starts again. This mimics the behaviour of some river basins in very dry episodes, where aquifers temporarily lose their connection to major rivers and base-flow is reduced. The value $$LZThreshold$$ has to be found via calibration. Note that keeping large negative values makes sure that there is always baseflow.

```xml
<textvar name="LZThreshold" value="$(PathMaps)/lzthreshold.map">
<comment>
threshold value below which there is no outflow to the channel
</comment>
</textvar>
```

When groundwater is abstracted for usage, it typically could cause a local dip in the LZ values (~ water table) compared to neigbouring pixels. Therefore, a simple option to mimick groundwaterflow is added to LISFLOOD, which evens out the groundwaterlevels with neighbouring pixels. This option can be switched on using:

```xml
	<setoption choice="1" name="groundwaterSmooth"/>
```

#### Non-Conventional abstractions: desalination

Water obtained through desalination is the most common type of non-conventional water usage. It will likely only be active near coastal zones only, since otherwise transportation costs are too high. The amount of desalinated water usage in LISFLOOD is defined using the factor $FractionNONconventionalSourcesUsed$. 
It is assumed that the non-conventional water demand is always available. It is abstracted for a 100%, so no losses are accounted for.
The total amount of water supplied by non-conventional sources is:

$$
TotalWaterAbstractionFromNonConventionalSources = DomesticWaterAbstractionNONconv  + IndustrialWaterAbstractioNONconv  + 
LivestockWaterAbstractionNONconv  
$$


#### Surface water abstractions and water regions

The total amount of water to be abstracted by surface water bodies is:

$$
TotalWaterAbstractionFromSurfaceWater = DomesticWaterAbstractionSurfaceWater  + IndustrialWaterAbstractionSurfaceWater  + 
LivestockWaterAbstractionSurfaceWater + EnergyAbstractionSurfaceWater + CropIrrigationWaterAbstractionSurfaceWater +  RiceIrrigationWaterAbstractionSurfaceWater
$$

The $TotalWaterAbstractionFromSurfaceWater$ is extracted within *water regions*. These regions are introduced in LISFLOOD due to allow the realistic representation of surface water abstraction in high resolution modelling set-ups. When using a 0.5 degree spatial resolution model, the abstraction of surface water from the local 0.5x0.5 degree pixel is a reasonable representation of the real process. Conversely, when using finer spatial resolutions, the water demand of a pixel could be supplied by another pixel nearby (that is, water demand and water abstraction actually occur in different pixels). The *water regions* were therefore introduced to solve this problem. Specifically, a *water region* is the area icluding the locations of water demand and abstraction.

*Water regions* are generally defined by sub-river-basins within a Country. In order to mimick reality, it is advisable to avoid cross-Country-border abstractions. Whenever information is available, it is strongly recommended to align the *water regions* with the actual areas managed by water management authorities, such as regional water boards. In Europe, the River Basin Districts, as defined in the Water Framework Directive and subdivided by country, can be used.

*Water regions* can be activated in LISFLOOD by adding the following line to the 'lfoptions' element:

```xml
	<setoption choice="1" name="wateruseRegion"/>
```

## Surface water abstractions from lakes and reservoirs

Lakes and reservoirs within a *water region* can supply part of the surface water abstraction.  The parameter $FractionLakeReservoirWaterUsed$ defines the fraction of surface water abstraction which should be supplied by lakes and reservoirs. TThe value of this parameter (between 0 and 1) is provided in input to the model.

LISFLOOD then computes the available water volume in lakes and reservoirs. **The available water volume of a lake is defined equal to the 10% of its total volume storage**. **The available water volume in a reservoir is assumed equal to the minimum between the 1% of its [total storage capacity](https://ec-jrc.github.io/lisflood-model/3_03_optLISFLOOD_reservoirs/) and the 2% of the volume [stored in the reservoir](https://ec-jrc.github.io/lisflood-model/3_03_optLISFLOOD_reservoirs/) at the computational time step.**  These conditions are imposed to constantly preserve a 'reasonable' amount of water in reservoirs and lakes. The total water volume which can be potentially abstracted from reservoirs and lakes is then:

$$
TotalAvailableVolumeLakesReservoirs = AvailableVolumeLakes + AvailableVolumeReservoirs 
$$

It is here reminded that all the lakes and reservoirs within the same *water region* as the water demand are considered for the computation of the available water volume.

The volume which is actually abstracted from lakes and reservoirs within a *water region* is then given by:

$$
WaterAbstractedLakesReservoirs = \min (TotalAvailableVolumeLakesReservoirs , FractionLakeReservoirWaterUsed \cdot TotalWaterAbstractionFromSurfaceWater)
$$

The quantities below are then subtracted from the [lake storage](https://ec-jrc.github.io/lisflood-model/3_02_optLISFLOOD_lakes/) and the [reservoir storage](https://ec-jrc.github.io/lisflood-model/3_03_optLISFLOOD_reservoirs/):

$$
WaterAbstractedLakes = \frac{WaterAbstractedLakesReservoirs}{TotalAvailableVolumeLakesReservoirs} * AvailableVolumeLakes
WaterAbstractedReservoirs = \frac{WaterAbstractedLakesReservoirs}{TotalAvailableVolumeLakesReservoirs} * AvailableVolumeReservoirs
$$


#### Surface water abstraction from rivers, and environmental flow

The remaining water abstraction volume is demanded to the rivers. The amount of water that *should be* extracted from the rivers is computed by:

$$
WaterToBeAbstractedChannels = TotalWaterAbstractionFromSurfaceWater - WaterAbstractedLakesReservoirs
$$

$WaterToBeAbstractedChannels$ is withdrawn from discharge in the river network within the same *water region*. Moreoever, since the exact locations of abstractions are typically not known, river water abstractions are assumed to be homogeneously distributed within the *water region*.

River discharge at aech time step $Q_{ch}$ is computed by the routing modules, using either the [kinematic approach](https://ec-jrc.github.io/lisflood-model/2_16_stdLISFLOOD_channel-routing/) or the [dynamic approach](https://ec-jrc.github.io/lisflood-model/3_06_optLISFLOOD_dynamic-wave/). 
A minum amount of water must always flow in a river. This value is the *environmental flow threshold* ($EFlowThreshold$) and it is imposed by the user in the settingsfile:

```xml
<textvar name="EFlowThreshold" value="$(PathMaps)/dis_nat_10.map">
<comment>
$(PathMaps)/eflow.map
EFlowThreshold is map with m3/s discharge, e.g. the 10th percentile discharge of the baseline run
</comment>
</textvar>
```

For Europe e.g.  the 10th percentile discharge from a 'natural' run for 1990-2016 can be used to define the environmental flow threshold. In order to mimick natural flow conditions, a 'natural' run does not include without reservoirs and human water abstractions. LISFLOOD also counts the number of days in which the channel flow is lower than the *environmental flow threshold* ($EFlowThreshold$) as this piece of information is important for water rousources and ecosystem management.

The water volume which can be potentially abstracted from the river within a *water region* is then:

$$
AvailableVolumeChannels = \max((Q_{ch} - EFlowThreshold) \cdot \Deltat , 0) \cdot (1 - WUsePercRemain) 
$$

where $WUsePercRemain$ is the percentage of water which always remains in the channel. This value (between 0 and 1) is defined by the user.

The amount of water extracted from the rivers is:

$$
WaterAbstractedFromChannels = \min (AvailableVolumeChannel , WaterToBeAbstractedChannels)
$$

A condition in which $$WaterAbstractedFromChannels \lt WaterToBeAbstractedChannels$$ means that the sum of the water abstractions from groundwater, non-convential sources, and surface water is lower than the total water abstraction demand. The amount of water which was requested but could not be supplied is the $WaterUseShortage$ and it is quantified as follows:

$$
WaterUseShortage =  WaterToBeAbstractedChannels - WaterToBeAbstractedChannels
$$

In condition of water scarcity, water uses are satisfied according to the following order of importance: domestic, energetic, livestock, industry, and irrigation. The latter sentence implies that when $$WaterUseShortage  \gt 0$$, LISFLOOD reduces the water volume delivered to the irrigated fields. Specifically, the amount $WaterUseShortage$ is subtracted from the total amount of water required from surface water bodies by crops and paddy rice, meaning that the total amount of water effectively supplied to the irrigated fields ($IrrigationWater$) is:

$$
IrrigationWater = CropIrrigationWaterAbstractionGW  + CropIrrigationWaterAbstractionSurfaceWater +  RiceIrrigationWaterAbstractionSurfaceWater - WaterUseShortage
$$

The value $IrrigationWater$ is then used to compute the water content of the superficial soil layer ($w_{1a}$) and of the upper soil layer ($w_{1b}$). The value $IrrigationWater$ (after convertion in [mm]) is first added to the superficial soil layer, until the water content of this layer ($w_{1a}$) is equal $$w_{fill,1a} = \min(w_{crit,1a}, w_{fc,1a}). The remainder amount of water (if any) is then added to the upper soil layer ($w_{1b}$). It is here reminded that $w_{crit}$ is the amount of moisture below which water uptake is reduced and plants start closing their stomata, while $w_{fc}$ is the amount of soil moisture at field capacity; a detailed description can be found in the chapter [water uptake by plant roots and transpiration](https://ec-jrc.github.io/lisflood-model/2_07_stdLISFLOOD_plant-water-uptake/). Finally, the [actual transpiration rate](https://ec-jrc.github.io/lisflood-model/2_07_stdLISFLOOD_plant-water-uptake/) ($T_a$) is updated to account for the soil moisture deficit due to the irrigation shortage.

Finally, in order to check the conservation of mass within the modelled system, LISFLOOD computes the amount of water consumed by irrigation $IrriLossCum$ (this amount of water exits the system): this value accounts for the irrigation water abstracted from groundwater, the irrigation water effectively abstracted from surface water, the amount of water returned to the system due to leakages and losses (defined by the factors $IrrigationEfficiency$ and $ConveyanceEfficiency$), the resulting water content of the superficial and upper soil layers.


#### Water use output files

The water use routine produces a variety of new output maps and indicators, a number of relevant examples is listed in the following Table:

 ***Table:*** *Output of water use routine.*     

| file     | short description                         | time  | area   | unit      | long description                                 |
| -------- | ----------------------------------------- | ----- | ------ |---------- | ------------------------------------------------ | 
| Eflow.nc | eflow breach indicator (1=breached)	     | day   | pixel  | 0 or 1    | number of days that eflow threshold is breached  |
| eneCo.nc | energy consumptive use                    | day   | pixel  |	mm        |	energy consumptive use                           |
| indCo.nc | industrial consumptive use                | day   | pixel  |	mm        |	industrial consumptive use                       |
| livCo.nc | livestock consumptive use                 | day   | pixel  |	mm        |	livestock consumptive use                        |
| domCo.nc | domestic consumptive use                  | day   | pixel  |	mm        |	domestic consumptive use                         |
| Fk1.nc 	 | Falkenmark 1 index (local water only)     | month |region  |	m3/capita |	water availability per capita (local water only) |
| Fk3.nc   | Falkenmark 3 index (external inflow also) | month | region	| m3/capita	| water availability per capita (local water + external inflow)|
| IrSh.nc  | water shortage                            | month | region | m3        | water shortage due to availability restrictions  |
| WDI.nc   | Water Dependency Index	                   | month | region	| fraction  | local water demand that cannot be met by local water / total water demand|
| WeiA.nc  | Water Exploitation Index Abstraction      | month | region |	fraction  |	water abstraction / (local water + external inflow)|
| WeiC.nc  | Water Exploitation Index Consumption WEI+ | month | region | fraction  | water consumption / (local water + external inflow)|
| WeiD.nc  | Water Exploitation Index Demand WEI       | month | region | fraction  |	water demand / (local water + external inflow)   |

[🔝](#top)

