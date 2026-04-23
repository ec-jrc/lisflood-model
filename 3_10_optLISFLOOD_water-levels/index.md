## Reporting of water level values from the channel bottom


### Introduction

Within LISFLOOD it is possible to simulate and report water level values from the channel bottom (water depth values). This is achieved by switching on a dedicated module called "simulateWaterLevels". This module is *optional*, and it can be activated by adding the following line to the 'lfoptions' element:

```xml
	<setoption name="simulateWaterLevels" choice="1" />
```

If the option is switched on, water level values from the channel bottom (water depth values) are calculated for river channel pixels where flow routing is computed *using the [kinematic wave](/3_05_optLISFLOOD_kinematic-wave) solution*. Using this option does *not* influence flow routing results, and it is only a reporting option. Computed water level values from the channel bottom can include both the main channel and (where needed) the second line of routing (Split Routing option).

**Limitation 1** : In the current implementation, water level values from the channel bottom (water depth values) are not reported for pixels where routing is computed using the [diffusive wave routing](/3_14_optLISFLOOD_diffusive-wave). 

**Limitation 2** : The computation of water level values from the channel bottom (water depth values) requires information about river geometry (bathymetry). **Inaccuracies in the representation of channel geometry will directly affect the computation of water level**. As detailed in the chapter [Channel geomtery](/4_Static-Maps_channel-geometry/index.md) of the [user guide](https://ec-jrc.github.io/lisflood-code/), OS LISFLOOD assumes a trapezoidal cross section (image below), with geometrical parameters (e.g. bottom width, banckfull depth) computed using approximated equations or continenatl to global datasets. These approximations must be taken into account when using the results of the module described in this page.

### Calculation of water level values from the channel bottom

When using the kinematic solution of the Saint Venant Equations, only approximate water levels can be estimated from the cross-sectional (wetted) channel area, $A_{ch}$ for each time step. Since the channel cross-section is described as a trapezoid, water levels follow directly from $A_{ch}$ , channel bottom width, side slope and bankfull level. If $A_{ch}$ exceeds the bankfull cross-sectional area ($A_{bf}$), the surplus is distributed evenly over the (rectangular) floodplain, and the depth of water on the floodplain is added to the (bankfull) channel depth. The Figure below further illustrates the cross-section geometry. All water levels are relative to channel bottom level ($z_{bot}$ in the Figure).

![kinematic wave routing](../media/image57.png)
***Figure:*** *Geometry of channel cross-section in kinematic wave routing. With* $W_b$: *channel bottom width;* $W_u$: *channel upper width;* $z_{bot}$: *channel bottom level;* $z_{fp}$: *floodplain bottom level;* $s$: *channel side slope;* $W_{fp}$: *floodplain width;* $A_{bf}$: *channel cross-sectional area at bankfull;* $A_{fp}$: *floodplain cross-sectional area;* $D_{bf}$: *bankfull channel depth,* $D_{fp}$: *depth of water in the floodplain.*

In order to calculate water levels, LISFLOOD needs a map with the width of the floodplain in \[m\], which is defined by 'lfbinding' variable *FloodPlainWidth* (the default name of this map is *chanfpln.map*).




### Reporting of water levels

Water levels can be reported as time series (at the gauge locations that are also used for reporting discharge), or as maps.

To generate a time series, add the following line to the 'lfoptions' element of your settings file:

```xml
	<setoption name="repWaterLevelTs" choice="1" />
```

For maps, use the following line instead:

```xml
	<setoption name="repWaterLevelMaps" choice="1" />
```

In either case, the reporting options should be used *in addition* to the 'simulateWaterLevels' option. If you do not include the 'simulateWaterLevels' option, there will be nothing to report and LISFLOOD will exit with an error message.



### Preparation of settings file

The naming of the reported water level time series and maps is defined in the settings file. If you are using a default LISFLOOD settings template, all file definitions are already defined in the 'lfbinding' element.

Time series:

```xml
	<textvar name="WaterLevelTS" value="$(PathOut)/waterLevel.tss"> 
	<comment>                                                            
	Reported water level [m]                                             
	</comment>                                                           
	</textvar>                                                           
```

Map stack:

```xml
	<textvar name="WaterLevelMaps" value="$(PathOut)/wl"> 
	<comment>                                                  
	Reported water level [m]                                   
	</comment>                                                 
	</textvar>                                                 
```

[🔝](#top)


