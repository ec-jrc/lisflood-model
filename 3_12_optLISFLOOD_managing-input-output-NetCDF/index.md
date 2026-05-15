## Read and write NetCDF files

> Albeit OS LISFLOOD can still read maps in pcraster format, users are strongly recommended to prepare their own input maps in NetCDF format: pcraster format will be discarded in future versions of OS LISFLOOD (timeline not yet defined). Users interested in converting their existing pcraster maps into NetCDF format can refer to the [OS LISFLOOD untility pcr2nc](https://github.com/ec-jrc/lisflood-utilities#pcr2nc).


### Reading NetCDF files

LISFLOOD can read files containing forcing data and static maps both as NetCDF single map (without "time" variable) and as NetCDF stack (with "time" variable).

Reading of NetCDF files is activated using readNetcdfStack switch in lfoption section in Settings XML file:

```xml
<setoption choice="1"  name="readNetcdfStack"/>
```

If NetCDF file contains "time" variable, LISFLOOD reads NetCDF files by timestamps. Correspondence between LISFLOOD time steps and NetCDF timestamps is automatically computed within the model. LISFLOOD can run on any sub-period included in forcings data.

NetCDF forcings files (pr, ta, e0, es, et) are completely independent from LISFLOOD settings, meaning they can cover any period of time starting from any date, but they must include the entire LISFLOOD simulation period. A check is performed at the beginning of the simulation and an error message is provided if simulation period is outside forcings maps period. Missing maps are not allowed for forcings data and checks are in place to prevent using daily maps to perform sub-daily simulations.

Particular attention must be paid when running LISFLOOD using time steps. Time steps set in Settings XML file always refer to the date specified as CalendarDayStart. Time step values will be automatically converted to dates and corresponding date values will be read from NetCDF files.

#### Options to manage NetCDF input files

+ **NetCDFTimeChunks**: chunking size in the time dimension. This option was implemented to optimize the loading of the meteo maps. Recommended value is “auto" but chunking size can be specified manually (e.g. "10") or set to “-1" to load the whole time series into memory (very fast but expensive in terms of memory). 
+ **MapsCaching** (True or False): option designed for lisflood calibration. If set to True, all the static maps and forcings will be stored in a cache so that they don't have to be loaded by each lisflood instance. This option sets the value of NetCDFTimeChunks to "-1", meaning that the whole time series in the NetCDF inputs is loaded into memory. 



### Writing NetCDF files

LISFLOOD can write both NetCDF single maps (without "time" variable) and as NetCDF stacks (with "time" variable). Writing of NetCDF files is activated using switches in lfoption section in Settings XML file:


```xml
<setoption choice="1"  name="writeNetcdfStack"/>

<setoption choice="1"  name="writeNetcdf"/>
```

End files and State files can be saved in NetCDF file format, state files can be saved for a specified sub-period (sub-period can only be set using time steps) within the simulation period using:

```xml
<textvar name="ReportSteps" value="2801..9999">
```

#### Options to manage output files

+ **OutputMapsChunks**: this option is used to write output maps every X steps (default 1).  
+ **OutputMapsDataType**: this option sets the output data type and may take the following values: "float64" or "float32" (default float64). This option applies to all output maps.

