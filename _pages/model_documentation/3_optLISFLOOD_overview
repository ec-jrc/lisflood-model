# Optional LISFLOOD processes

## Overview

```R
# currently this overview is copy-pasted together. It needs "cleaning up"!
```



The above model description covers the processes that are simulated in a 'standard' LISFLOOD run. By default, special structures in the river channel e.g. lakes and regulated reservoirs are not taken into account. However, LISFLOOD has some optional features to model these structures. The description of these features can be found in a series of Annexes at the end of this manual.

Features are:

- Including reservoirs, polder, lakes
- including inflow hydrographs
- using a double kinematic wave approach for channel routing
- using the diffusion wave approach instead of kinematic wave for channel routing
- Including transmission loss
- Using water use maps
- Simulating water levels

[🔝](#top)

As explained in **Chapter XXXXX**, the 'lfoptions' element gives you additional control over what LISFLOOD is doing. Using options it is possible to switch certain parts of the model on or off. This way you can tell the model exactly which output files are reported and which ones aren't. Also, they can be used to activate a number of additional model features, such as the simulation of reservoirs and inflow hydrographs.

The table below lists all currently implemented options and their corresponding defaults. All currently implemented options are switches (1= on, 0=off). You can set as many options as you want (or none at all). The Table below lists all currently implemented options[^13]. 

>  Note that each option generally requires additional items in the settings file. For instance, using the inflow hydrograph option requires an input map and time series, which have to be specified in the settings file. If you want to report discharge maps at each time step, you will first have to specify under which name they will be written. The template settings file that is provided with LISFLOOD always contains file definitions for all optional output maps and time series. 

The use of the *output* options is described in detail in **Chapter XXXXX**.

***Table:*** *LISFLOOD options.*                                                                                                                                                                                                                                                                                                         

| Option                                                       | Description                                                  | Default |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------- |
| **SIMULATION OPTIONS**                                       |                                                              |         |
| gridSizeUserDefined                                          | Get grid size attributes (length, area) from user-defined maps (instead of using map location attributes directly) | 0       |
| simulateReservoirs                                           | Simulate retention and hydropower reservoirs (kin. wave only) | 0       |
| simulateLakes                                                | Simulate unregulated lakes (kin. wave only)                  | 0       |
| simulatePolders                                              | Simulate flood protection polders (dyn. wave only)           | 0       |
| inflow                                                       | Use inflow hydrographs                                       | 0       |
| dynamicWave                                                  | Perform dynamic wave channel routing                         | 0       |
| simulateWaterLevels                                          | Simulate water levels in channel                             | 0       |
| TransLoss                                                    | Simulate transmission loss                                   | 0       |
| SplitRouting                                                 | Simulate double kinematic wave                               | 0       |
| VarNoSubStepChannel                                          | Use variable number of sub step for channel routing          | 0       |
| wateruse                                                     | Simulate water use                                           | 0       |
| **OUTPUT, TIME SERIES**                                      |                                                              |         |
| repDischargeTs                                               | Report timeseries of discharge at gauge locations            | 1       |
| repWaterLevelTs                                              | Report timeseries of water level at gauge locations14        | 0       |
| repStateSites                                                | Report timeseries of all intermediate state variables at 'sites' | 0       |
| repRateSites                                                 | Report timeseries of all intermediate rate variables at 'sites' | 0       |
| repMeteoUpsGauges                                            | Report timeseries of meteorological input, averaged over contributing area of each gauging station | 0       |
| repStateUpsGauges                                            | Report timeseries of model state variables, averaged over contributing area of each gauging station | 0       |
| repRateUpsGauges                                             | Report timeseries of model rate variables, averaged over contributing area of each gauging station | 0       |
| **OUTPUT, MASS BALANCE**                                     |                                                              |         |
| repMBTs                                                      | Report timeseries of absolute cumulative mass balance error  | 1       |
| repMBMMTs                                                    | Report timeseries of cumulative mass balance error expressed as mm water slice | 1       |
| **OUTPUT, MAPS,DISCHARGE**                                   |                                                              |         |
| repDischargeMaps                                             | Report maps of discharge (for each time step)                | 0       |
| repWaterLevelMaps[^17]                                       | Report maps of water level in channel (for each time step)   | 0       |
| **OUTPUT, MAPS, STATE VARIABLES (all, at selected time steps)** |                                                              |         |
| repStateMaps                                                 | Report maps of model state variables (as defined by "ReportSteps" variable) | 1       |
| repEndMaps[^18]                                              | Report maps of model state variables (at last time step)     | 0       |
| **OUTPUT, MAPS, STATE VARIABLES**                            |                                                              |         |
| repDSLRMaps                                                  | Report maps of days since last rain (for each time step)     | 0       |
| repFrostIndexMaps                                            | Report maps of frost index (for each time step)              | 0       |
| repWaterDepthMaps                                            | Report maps of depth of water layer on soil surface (for each time step) | 0       |
| repSnowCoverMaps                                             | Report maps of snow cover (for each time step)               | 0       |
| repCumInterceptionMaps                                       | Report maps of interception storage (for each time step)     | 0       |
| repTheta1Maps                                                | Report maps of soil moisture layer 1(for each time step)     | 0       |
| repTheta2Maps                                                | Report maps of soil moisture layer 2 (for each time step)    | 0       |
| repUZMaps                                                    | Report maps of upper zone storage (for each time step)       | 0       |
| repLZMaps                                                    | Report maps of lower zone storage (for each time step)       | 0       |
| repChanCrossSectionMaps                                      | Report maps of channel cross-sectional area (for each time step) | 0       |
| **OUTPUT, MAPS, METEOROLOGICAL FORCING VARIABLES**           |                                                              |         |
| repPrecipitationMaps                                         | Report maps of precipitation (for each time step)            | 0       |
| repTavgMaps                                                  | Report maps of average temperature (for each time step)      | 0       |
| repETRefMaps                                                 | Report maps of potential reference evapotranspiration (for each time step) | 0       |
| repESRefMaps                                                 | Report maps of potential soil evaporation (for each time step) | 0       |
| repEWRefMaps                                                 | Report maps of potential open water evaporation (for each time step) | 0       |
| **OUTPUT, MAPS, RATE VARIABLES**                             |                                                              |         |
| repRainMaps                                                  | Report maps of rain (excluding snow!) (for each time step)   | 0       |
| repSnowMaps                                                  | Report maps of snow (for each time step)                     | 0       |
| repSnowMeltMaps                                              | Report maps of snowmelt (for each time step)                 | 0       |
| repInterceptionMaps                                          | Report maps of interception (for each time step)             | 0       |
| repLeafDrainageMaps                                          | Report maps of leaf drainage (for each time step)            | 0       |
| repTaMaps                                                    | Report maps of actual transpiration (for each time step)     | 0       |
| repESActMaps                                                 | Report maps of actual soil evaporation (for each time step)  | 0       |
| repEWIntMaps                                                 | Report maps of actual evaporation of intercepted water (for each time step) | 0       |
| repInfiltrationMaps                                          | Report maps of infiltration (for each time step)             | 0       |
| repPrefFlowMaps                                              | Report maps of preferential flow (for each time step)        | 0       |
| repPercolationMaps                                           | Report maps of percolation from upper to lower soil layer (for each time step) | 0       |
| repSeepSubToGWMaps                                           | Report maps of seepage from lower soil layer to ground water (for each time step) | 0       |
| repGwPercUZLZMaps                                            | Report maps of percolation from upper to lower ground water zone (for each time step) | 0       |
| repGwLossMaps                                                | Report maps of loss from lower ground water zone (for each time step) | 0       |
| repSurfaceRunoffMaps                                         | Report maps of surface runoff (for each time step)           | 0       |
| repUZOutflowMaps                                             | Report maps of upper zone outflow (for each time step)       | 0       |
| repLZOutflowMaps                                             | Report maps of lower zone outflow (for each time step)       | 0       |
| repTotalRunoffMaps                                           | Report maps of total runoff (surface + upper + lower zone) (for each time step) | 0       |
| **OUTPUT, MAPS (MISCELLANEOUS)**                             |                                                              |         |
| repLZAvInflowMap                                             | Report computed average inflow rate into lower zone (map, at last time step) | 0       |
| repLZAvInflowSites                                           | Report computed average inflow rate into lower zone (time series, at points defined on sites map) | 0       |
| repLZAvInflowUpsGauges                                       | Report computed average inflow rate into lower zone (time series, averaged over upstream area of each gauge location) | 0       |

[🔝](#top)

