# Water demand, abstraction and consumption

## Introduction

This page describes the LISFLOOD water use routine, and how it is used. It is strongly advisable that the water use routine is always used, even in flood forecasting mode, as irrigation and other abstractions can be of substantial influence to flow conditions, and also since the water use mode was used during the calibration.

The water use routine is used to include water demand, abstraction, net consumption and return flow from various societial sectors:
-   dom:  use of water in the public sector, e.g. for domestic use
-   liv:  use of water for livestock
-   ene:  use of cooling water for the energy sector in thermal or nuclear power plants
-   ind:  use of water for the manufacturing industry
-   irr:  water used for crop irrigation
-   ric:  water used for paddy-rice irrigation
Note: the abbreviations 'dom', 'liv' etc are the typical short names also used for the input filenames.

The water use is *optional* but it is strongly recommended to be always used. The module can be activated by adding the following line to the 'lfoptions' element:

```xml
	<setoption choice="1" name="wateruse"/>
```


## Water demand, abstraction and consumption

LISFLOOD distinguishes between water demand, water abstraction, actual water consumption and return flow. The difference between water abstraction and water consumption is the water return flow. Abstractions are typically higher than demands due abstraction limitations (e.g. ecological flow constraints or general availability issues) and/or due to losses during transport from the source of the abstraction to the final destination: e.g. leakage in the public supply network, and transmission losses during irrigation water transport. Water consumption per sector is typically lower than water demand per sector, since only a part of the water evaporates and is lost, and another part is returned to the system later on.


## PART ONE: SECTORS of water demand and consumption

LISFLOOD distinguisges the following sectors of water consumption:
-   dom:  use of water in the public sector, e.g. for domestic use
-   liv:  use of water for livestock
-   ene:  use of cooling water for the energy sector in thermal or nuclear power plants
-   ind:  use of water for the manufacturing industry
-   irr:  water used for crop irrigation
-   ric:  water used for paddy-rice irrigation

Water demand files for each sector need to be created, in mm per timestep per gridcell, so typically:
-   dom.nc (mm per timestep per gridcell) for domestic water demand
-   liv.nc (mm per timestep per gridcell) for livestock water demand
-   ene.nc (mm per timestep per gridcell) for energy-cooling water demand
-   ind.nc (mm per timestep per gridcell) for manufacturing industry water demand

Typically, water demands are related to amounts of population, livestock, Gross Domestic Product (GDP), gross value added (GVA). They are typically obtained by downscaling national or regional reported data using with higher resolution land use maps.

Crop irrigation and Paddy-rice irrigation water demands are simulated in the model, are dealt with by seperate model subroutines and are described in the irrigation chapter.


## Public water usage and leakage

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


## Water usage by the energy sector for cooling

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

So, the actual: 

Energy Water Consumption = EnergyConsumptiveUseFraction * ene.nc

Energy Water Return Flow = (1 - EnergyConsumptiveUseFraction) * ene.nc


## Water usage by the manufacturing industry

The manufucaturing industry also required water for their processing, much depending on the actual product that is produced, e.g. the paper industry or the clothing industry. LISFLOOD typically reads an 'ind.nc' file which determines the water demand for the industry sector in mm/day/pixel. Typically, this map is derived from downscaling national reported data using maps of land use and/or the specific activities.

An "IndustryConsumptiveUseFraction" is used to determine the consumptive water usage of the manufacturing industry. This can either be a fixed value, or a spatial explicit map.

```xml
<textvar name="IndustryConsumptiveUseFraction" value="0.15">
<comment>
Consumptive Use (1-Recycling ratio) for industrial water use (0-1)
</comment>
</textvar>
```

So, the actual: 

Industry Water Consumption = IndustryConsumptiveUseFraction * ind.nc

Industry Water Return Flow = (1 - IndustryConsumptiveUseFraction) * ind.nc


## Livestock water usage

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

Livestock Water Consumption = LivestockConsumptiveUseFraction * liv.nc

Livestock Water Return Flow = (1 - LivestockConsumptiveUseFraction) * liv.nc


## Crop irrigation

Crop irrigation and Paddy-rice irrigation are dealt with by seperate model subroutines and are described in the irrigation chapter.
They can be switched on by adding the following lines to the 'lfoptions' element:

```xml
<setoption choice="1" name="drainedIrrigation"/>
```


## Paddy-rice irrigation

Crop irrigation and Paddy-rice irrigation are dealt with by seperate model subroutines and are described in the irrigation chapter.
They can be switched on by adding the following lines to the 'lfoptions' element:

```xml
<setoption choice="1" name="riceIrrigation"/>
```




## PART TWO: SOURCES of water abstraction

LISFLOOD can abstract water from groundwater or from surface water (rivers, lakes and or reservoirs), or it is derived from unconventional sources, typically desalination. LISFLOOD allows a part of the need for irrigation water may come from re-used treated waste-water. 

The sub-division in these three sources is achieved by creating and using the following maps:
-   fracgwused.nc (values between 0 and 1) ('fraction groundwater used')
-   fracncused.nc (values between 0 and 1) ('fraction non-conventional used')

Next, LISFLOOD automatically assumes that the remaining water (1-fracgwused-fracncused) is derived from various sources of surface water. Surface water sources for abstraction may consist of lakes, reservoirs and rivers themselves. Further details on this are explained below in a seperate paragraph. 


## Water re-use for surface irrigation

LISFLOOD reads a map "waterreusem3.nc" or similar, which defines the annual availability of re-used treated waste-water in a model pixel. During the irrigation season, this amount is deducted from the required irrigation abstraction during a defined number of days ('IrrigationWaterReUseNumDays'), until the available amount is exhausted.

```xml
<textvar name="IrrigationWaterReUseM3" value="$(PathMaps)/waterreuseBAUm3.map">
<comment>
Annual amount (m3) of treated wastewater reused for irrigation
</comment>
</textvar>

<textvar name="IrrigationWaterReUseNumDays" value="143">
<comment>
Number of days over which the annual amount of treated wastewater for irrigation is used
</comment>
</textvar>
```

If a map with zero values for reuse is used, this option has no influence on the model results.


## Groundwater abstractions

At every timestep, LISFLOOD checks if the amount of demanded water that is supposed to be abstracted from a source, is actually available. 

Groundwater abstraction = the total water demand * fracgwused

In the current LISFLOOD version, groundwater is abstracted for a 100%, so no addtional losses are accounted for, by which more would need to be abstracted to meet the demand. Also, in the current LISFLOOD version, no limits are set for groundwater abstraction.

LISFLOOD subtracts groundwater from the Lower Zone (LZ). Groundwater depletion can thus be examined by monitoring the LZ levels between the start and the end of a simulation. Given the intra- and inter-annual fluctuations of LZ, it is advisable to monitor more on decadal periods.

If the Lower Zone groundwater amount decreases below the 'LZThreshold" - a groundwater threshold value -, the baseflow from the LZ to the nearby rivers becomes zero. Further abstractions can reduce LZ to far below the LZThreshold. When sufficient recharge is added again to raise the LZ levels above the LZThreshold, baseflow will start again. This mimicks the behaviour of some river basins in very dry years, during which aquifers temporarily lose their connection to major rivers and baseflow is reduced or stopped.

```xml
<textvar name="LZThreshold" value="$(PathMaps)/lzthreshold.map">
<comment>
threshold value below which there is no outflow to the channel
</comment>
</textvar>
```

These threshold values have to be found through trial and error and/or calibration. The values are likely different for various (sub)river basins. You could start with zero values and then experiment, while monitoring simulated and observed baseflows. Keeping large negative values makes sure that there is always baseflow.

When groundwater is abstracted for usage, it typically could cause a local dip in the LZ values (~ water table) compared to neigbouring pixels. Therefore, a simple option to mimick groundwaterflow is added to LISFLOOD, which evens out the groundwaterlevels with neighbouring pixels. This option can be switched on using:

```xml
	<setoption choice="1" name="groundwaterSmooth"/>
```


## Non-Conventional abstractions: desalination

Water obtained through desalination is the most common type of non-conventional water usage. It will likely only be active near coastal zones only, since otherwise transportation costs are too high. The amount of desalinated water usage in LISFLOOD is defined as:

Deaslinated water abstraction = the total water demand * fracncused

It is assumed that the non-conventional water demand is always available. It is abstracted for a 100%, so no losses are accounted for.


## Surface water abstractions and water regions

If the surface water is available and if there is still a water demand - after groundwater abstractions, water re-use and desalination are taken into account - the remaining water is abstracted from surface water sources in so called 'Waterregions'. These regions are introduced in LISFLOOD due to the ever higher spatial resolution of water resources models. In a 0.5 degree spatial resolution model, users could get away with subtracting the abstraction from the local 0.5x0.5 degree pixel only, since it was large enough. For finer spatial resolutions, it could well happen that the demand exists in one model pixel, but the actual abstraction takes places in another pixel nearby. We assume here that water abstractions to meet a local water demand do take place within a 'waterregion'. 

Waterregions typically are defined in LISFLOOD as sub-river-basins within a country. Typically, to mimick reality, it is advisable to not allow the model for cross-country-border abstractions. Alternatively, and if the information exists, it would be better to align the waterregions with the actual areas managed by drinkingwater institutions, such as regional waterboards. For Europe, we often use the River Basin Districts as defined in the Water Framework Directive, subdivided by country.

Waterregions can be activated in LISFLOOD by adding the following line to the 'lfoptions' element:

```xml
	<setoption choice="1" name="wateruseRegion"/>
```

## Surface water abstractions from lakes and reservoirs

Depending on the presence of lakes and reservoirs in a water region, a part of the surface water abstraction - defined by the FractionLakeReservoirWaterUsed parameter as defined in the settingsfile - takes places from the variable amount of water storage available in the lakes and reservoirs. Thus, lakes and reservoirs cannot be abstracted to zero, but only until a 'reasonable' level. 

```xml
<textvar name="FractionLakeReservoirWaterUsed" value="0.25">
<comment>
lake and reservoir water used, fraction of a pixel (0-1)
</comment>
</textvar>
```

## Surface water abstraction from rivers, and environmental flow

The remaining water abstraction requirement is withdrawn from discharge in the river network within a waterregion. As the exact locations of abstractions are typically not known, we assume that abstractions take place evenly from a waterregion. 

A minum threshold value of water is used to restrict abstractions below that threshold. This threshold - the environmental flow threshold - is user defined in the settingsfile:

```xml
<textvar name="EFlowThreshold" value="$(PathMaps)/dis_nat_10.map">
<comment>
$(PathMaps)/eflow.map
EFlowThreshold is map with m3/s discharge, e.g. the 10th percentile discharge of the baseline run
</comment>
</textvar>
```

For Europe e.g. we have used the 10th percentile discharge from a 'natural' run for 1990-2016, i.e. Europe without reservoirs and human water abstractions. This to mimick natural flow conditions.

The amount that cannot be abstracted is monitores seperately in LISFLOOD as "RegionMonthIrrigationShortageM3" (actually a better term is general water shortage) and can be recalled as a maps:

```xml
<textvar name="RegionMonthIrrigationShortageM3" value="$(PathOut)/IrSh">
<comment>
Irrigation water shortage in m3 for month
</comment>
</textvar>
```


## Preparation of settings file

All in- and output files need to be defined in the settings file. If you are using a default LISFLOOD settings template, all file definitions are already defined in the 'lfbinding' element.


## Water use output files

The water use routine produces a variety of new output maps and indicators, as listed in the following Table:

 ***Table:*** *Output of water use routine.*     

| file     | short description                         | time  | area   | unit      | long description                                 |
| -------- | ----------------------------------------- | ----- | ------ |---------- | ------------------------------------------------ | 
| Fk1.nc   | Falkenmark 1 index (local water only)     | month | region | m3/capita | water availability per capita (local water only) |
| Fk3.nc   | Falkenmark 3 index (external inflow also) | month | region	| m3/capita	| water availability per capita (local water + external inflow)|
| Eflow.nc | eflow breach indicator (1=breached)	     | day   | pixel  | 0 or 1    | number of days that eflow threshold is breached  |
| IrSh.nc  | water shortage                            | month | region | m3        | water shortage due to availability restrictions  |
| WDI.nc   | Water Dependency Index	                   | month | region	| fraction  | local water demand that cannot be met by local water / total water demand|
| WeiA.nc  | Water Exploitation Index Abstraction      | month | region |	fraction  |	water abstraction / (local water + external inflow)|
| WeiC.nc  | Water Exploitation Index Consumption WEI+ | month | region | fraction  | water consumption / (local water + external inflow)|
| WeiD.nc  | Water Exploitation Index Demand WEI       | month | region | fraction  |	water demand / (local water + external inflow)   |
|	domCo.nc | domestic consumption                      | day   | pixel  | mm        |	domestic consumption                             |
| eneCo.nc | energy consumption                        | day   | pixel  |	mm        |	energy consumption                               |
| indCo.nc | industrial consumption                    | day   | pixel  |	mm        |	industrial consumption                           |
| irrCo.nc | irrigation consumption                    | day   | pixel  |	mm        |	irrigation consumption                           |
| livCo.nc | livestock consumption                     | day   | pixel  |	mm        |	livestock consumption                            |

[🔝](#top)

