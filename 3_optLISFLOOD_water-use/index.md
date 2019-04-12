# Including water use

## Introduction

This page describes the LISFLOOD water use routine, and how it is used. It is strongly advisable to that the water use routine is always used, even in forecasting mode, as irrigation and other abstractions can be of substantial influence to flow conditions.

The water use routine is used to include water consumption from various societial sectors:
-   dom:  use of water in the public sector, e.g. for domestic use
-   liv:  use of water for livestock
-   ene:  use of cooling water for the energy sector in thermal or nuclear power plants
-   ind:  use of water for the manufacturing industry
-   irr:  water used for crop irrigation
-   ric:  water used for paddy-rice irrigation

The water use is *optional* (though strongly recommended to be always used), and can be activated by adding the following line to the 'lfoptions' element:

```xml
	<setoption choice="1" name="wateruse"/>
```


## Crop and paddy-rice irrigation

Crop irrigation and Paddy-rice irrigation are dealt with by seperate model subroutines and are described in different chapters.
They can be switched on by adding the following lines to the 'lfoptions' element:

```xml
<setoption choice="1" name="drainedIrrigation"/>
<setoption choice="1" name="riceIrrigation"/>
```


## Water demand, abstraction and consumption

LISFLOOD distinguishes between water demand, water abstraction, and actual water consumption. The difference between water abstraction and water consumption is the water return flow. Abstractions are typically higher than demands due to losses during transport: e.g. leakage in the public supply network, transmission losses during irrigation water transport. Consumptions are typically lower than demands, since only a part of the water evaporates and is lost, and another part is return to the system later on.

Water demand files for each sector need to be created, in mm per timestep per gridcell, so typically:
-   dom.nc (mm per timestep per gridcell) for domestic water demand
-   liv.nc (mm per timestep per gridcell) for livestock water demand
-   ene.nc (mm per timestep per gridcell) for energy-cooling water demand
-   ind.nc (mm per timestep per gridcell) for manufacturing industry water demand

Typically, water demand files are related to amounts of population, livestock, GDP changes, GVA changes and can be established from national reported data using downscaling from land use maps.


## Sources of water abstraction

LISFLOOD can abstract water from groundwater or from surface water (rivers, lakes and or reservoirs), or it is derived from unconventional sources, such as desalination. This is achieved by creating the following maps:
-   fracgwused.nc (values between 0 and 1)
-   fracncused.nc (values between 0 and 1)

LISFLOOD consequently automatically assumes that the remaining water (1-fracgwused-fracncused) is derived from surface water. 


## Groundwater abstractions

LISFLOOD checks per timestep if the demanded water is available from a source. For groundwater abstraction, water is abstracted from the Lower Zone (LZ), at the moment still without limits. Groundwater depletion can thus be examined by monitoring the LZ levels from the start to the end of a simulation.

If the Lower Zone groundwater demand decreases below the 'LZThreshold" or groundwater threshold, the baseflow is zero. When sufficient recharge is added again to raise the LZ levels above the threshold, baseflow will start again. This mimicks the behaviour of some river basins in very dry episodes, e.g. the Meuse river basin in 1976.

```xml
<textvar name="LZThreshold" value="$(PathMaps)/lzthreshold.map">
<comment>
threshold value below which there is no outflow to the channel
</comment>
</textvar>
```

These threshold values have to be found through trial and error and/or calibration. The values are likely different for various (sub)river basins. You could start with zero values and then experiment. Keeping large negative values makes sure that there is always baseflow.

When groundwater is abstracted for usage, it typically could cause a local dip in the LZ values compared to neigbouring pixels. Therefore, a simple option to mimick groundwaterflow is added to LISFLOOD, which evens out the groundwaterlevels with neighbouring pixels. This option can be switched on using:

```xml
	<setoption choice="1" name="groundwaterSmooth"/>
```


## Non-Conventional abstractions: desalination

It is assumed that the non-conventional fraction of water demand exists. It is abstracted for a 100%.


## Surface water abstractions and water regions

If the surface water is available and there is a water demand, it is abstracted from so called 'Waterregions'. These regions are introduced due to the ever higher spatial resolution of water resources models. In a 0.5 degree spatial resolution, we could get away with subtracting the abstraction from the local pixel only, since it was large enough. For finer spatial resolutions, it could well happen that the demand exists in one model pixel, but the actual abstraction takes places in another pixel nearby. We assume here that water abstractions to meet a local water demand do take place within a 'waterregion'

Waterregions can be activated by adding the following line to the 'lfoptions' element:

```xml
	<setoption choice="1" name="wateruseRegion"/>
```
Depending on the presence of lakes and reservoirs in a water region, a part of the surface water abstraction takes places from the variable amount of water available in them. Note: lakes and reservoirs thus cannot be abstracted to zero. 







## Calculation of water use

The water is withdrawn only from discharge in the river network but not from soil, groundwater or directly from precipitation.

-   For each single day a total demand of withdrawal water is loaded from a sparse stack of maps

-   Water use is taken from the discharge in the river network. First the water use is taken from the same grid cell (see figure below -- pixel No. 1)

-   If the amount of water withdrawal is larger than the water available in this grid cell water is taken from downstream moving along the local drain direction. This is done by implementing a loop substracting the remaining water from the next downstream cell till all the water for water use is taken or a predefined number of iteration is reached (see figure below -- pixel No. 2 to 5)

![Water withdrawal assessing](../media/image56.png)
***Figure:*** *Water withdrawal assessing demand and availability along the flow path.*

In the LISFLOOD settings file you can define:

-   the percentage of water that must remain in a grid cell and is not withdrawn by water use (WUsePercRemain)

-   the maximum number of loops (= distance to the water demand cell). For example in figure above: maxNoWateruse = 5



## Preparation of input data

The following Table gives an overview about the maps and table needed for the water use option.

***Table:*** *Input requirements water use.*                                                                                            

| Maps                           | Default name   | Description                                             | Units           |
| ------------------------------ | -------------- | ------------------------------------------------------- | --------------- |
| Yearly stack of water use maps | wuse0000.xxx   | Total water withdrawal                                  | $\frac{m^3}{s}$ |
| Table                          |                |                                                         |                 |
| WUseofDay                      | WUseofDays.txt | Assignment of day of the year to map stack of water use | -               |



A sparse map stack of one year of total water withdrawal $[\frac{m^3}{s}]$ with a map every 10 days or a month is needed. Because it is assumed that water use follows a yearly circle, this map stack is used again and again for the following years. For example:

```xml
	 t   map name 
	 1   wuse0000.001 
	 2   wuse0000.032 
	 3   wuse0000.060 
	 4   wuse0000.091 
	 5   wuse0000.121 
	 6   wuse0000.152 
	 7   wuse0000.182 
	 8   wuse0000.213 
	 9   wuse0000.244 
	 10  wuse0000.274 
	 11  wuse0000.305 
	 12  wuse0000.335 
```



To assign each day of simulation the right map a lookup table (WUseOfDay.txt) is necessary:

```xml
	 <,0.5> 335    
	 [0.5,32> 1    
	 [32,60> 32    
	 [60,91> 60    
	 [91,121> 91   
	 [121,152> 121 
	 [152,182> 152 
	 [182,213> 182 
	 [213,244> 213 
	 [244,274> 244 
	 [274,305> 274 
	 [305,335> 305 
	 [335,> 335
```



## Preparation of settings file

All in- and output files need to be defined in the settings file. If you are using a default LISFLOOD settings template, all file definitions are already defined in the 'lfbinding' element.

```xml
	<textvar name="PathWaterUse" value="./wateruse">                
	<comment>                                                           
	Water use maps path                                                   
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PrefixWaterUse" value="wuse">                    
	<comment>                                                           
	prefix water use maps                                                 
	</comment>                                                          
	</textvar>                                                          
	<group>                                                             
	<comment>                                                           
	**************************************************************               
	INPUT WATER USE MAPS AND PARAMETERS                                   
	**************************************************************               
	</comment>                                                          
	<textvar name="WaterUseMaps" value="$(PathOut)/wuse">          
	<comment>                                                           
	Reported water use [cu m/s], depending on the availability of       
	discharge                                                             
	</comment>                                                          
	</textvar>                                                          
	<textvar name="WaterUseTS" value="$(PathOut)/wateruseUps.tss"> 
	<comment>                                                           
	Time series of upstream water use at gauging stations                 
	</comment>                                                          
	</textvar>                                                          
	<textvar name="StepsWaterUseTS"                                    
	value="$(PathOut)/stepsWaterUse.tss">                             
	<comment>                                                           
	Number of loops needed for water use                                  
	routine                                                               
	</comment>                                                          
	</textvar>                                                          
	<textvar name="maxNoWateruse" value="5">                        
	<comment>                                                           
	maximum number of loops for calculating the use of water              
	= distance water is taken for water consuption                        
	</comment>                                                          
	</textvar>                                                          
	<textvar name="WUsePercRemain" value="0.2">                     
	<comment>                                                           
	percentage of water which remains in the channel                      
	e.g. 0.2 -> 20 percent of discharge is not taken out                 
	</comment>                                                          
	</textvar>                                                          
	</group>                                                            
```

***PathWaterUse*** is the path to the map stack of water use

***PrefixWaterUse*** is the prefix of the water use maps

***WaterUseMaps*** is the path and prefix of the reported water use $[\frac{m^3}{s}]$ as a result of demand and availability

***WaterUseTS*** are time series of upstream water use $[\frac{m^3}{s}]$ at gauging stations

***StepsWaterUseTS*** is the number of loops needed for water use [-]

***maxNoWateruse*** is maximum number of loops for calculating the use of water (distance water is taken for water consumption)

***WUsePercRemain*** is the percentage of water which remains in the channel (e.g. 0.2 -> 20 percent of discharge is not taken out)



Finally, you have to tell LISFLOOD that you want to simulate water use. To do this, add the following statement to the 'lfoptions' element:

```xml
	<setoption name="wateruse" choice="1" />
```



## Water use output files

The water use routine can produce 2 additional time series and one map (or stack), as listed in the following Table:

 ***Table:*** *Output of water use routine.*     

| Maps            | Default name      | Option          | Units           |
| --------------- | ----------------- | --------------- | --------------- |
| WaterUseMaps    | wusexxxx.xxx      | repwateruseMaps | $\frac{m^3}{s}$ |
| **Time series** |                   |                 |                 |
| Number of loops | stepsWaterUse.tss |                 | -               |
| WaterUseTS      | wateruseUps.tss   | repwateruseTS   | $\frac{m^3}{s}$ |

[🔝](#top)

