Simulation of reservoirs
---------------------------------

**Introduction**

This annex describes the LISFLOOD reservoirs routine, and how it is used. The simulation of reservoirs is *optional*, and it can be activated by adding the following line to the 'lfoptions' element:

```xml
	<setoption name="simulateReservoirs" choice="1" />
```

Reservoirs can be simulated on channel pixels where kinematic wave routing is used. The routine does *not* work for channel stretches where the dynamic wave is used!



**Description of the reservoir routine** 

Reservoirs are simulated as points in the channel network. The inflow into each reservoir equals the channel flow upstream of the reservoir. The outflow behaviour is described by a number of parameters. First, each reservoir has a total storage capacity $S\ [m^3]$. The relative filling of a reservoir, $F$, is a fraction between 0 and 1. There are three 'special' filling levels. First, each reservoir has a 'dead storage' fraction, since reservoirs never empty completely. The corresponding filling fraction is the 'conservative storage limit', $L_c$. For safety reasons a reservoir is never filled to the full storage capacity. The 'flood storage limit' $L_f$ represents this maximum allowed storage fraction. The buffering capacity of a reservoir is the storage available between the 'flood storage limit' and the 'normal storage limit' ($L_n$). Three additional parameters define the way the outflow of a reservoir is regulated. For e.g. ecological reasons each reservoir has a 'minimum outflow' ($O_{min}$, $[\frac{m^3} {s}]$). For high discharge situations, the 'non-damaging outflow' ($O_{nd}$, $[\frac{m^3} {s}]$) is the maximum possible outflow that will not cause problems downstream. The 'normal outflow' ($O_{norm}$, $[\frac{m^3} {s}]$) is valid once the reservoir reaches its 'normal storage' filling level.

Depending on the relative filling of the reservoir, outflow ($O_{res},[\frac{m^3}{s}]$) is calculated as:

$$
O_{res} = min (O_{min} ,\frac{1}{\Delta t} {\cdot F\cdot S) \ ; F \le 2 \cdot L_c}
$$

$$
O_{res} = O_{min } + (O_{norm} - O_{min}) \cdot \frac{(F - 2L_c)}{(L_n - 2L_c)}    ; L_n \ge F \gt 2L_c
$$

$$
O_{res} = O_{norm} + \frac{(F - L_n)}{(L_f - L_n)} \cdot \max((I_{res} - O_{norm}),(O_{nd} - O_{norm})); L_f \ge F \gt L_n
$$

$$
O_{res} = \max (\frac{(F - L_f)}{\Delta t} \cdot S,O_{nd}) ; F \gt L_f
$$

with:

   $S$:		Reservoir storage capacity $[m^3]$
   $F$:		Reservoir fill (fraction, 1 at total storage capacity) \[-\]
   $L_c$:	Conservative storage limit \[-\]
   $L_n$:	Normal storage limit \[-\]
   $L_f$:	Flood storage limit \[-\]
   $O_{min}$:	Minimum outflow $[\frac{m^3} {s}]$
   $O_{norm}$:	Normal outflow $[\frac{m^3} {s}]$
   $O_{nd}$:	Non-damaging outflow  $[\frac{m^3} {s}]$
   $I_{res}$:	Reservoir inflow $[\frac{m^3} {s}]$

In order to prevent numerical problems, the reservoir outflow is calculated using a user-defined time interval (or *Δt*, if it is smaller than this value).



**Preparation of input data** 

For the simulation of reservoirs a number of addition input files are necessary. First, the locations of the reservoirs are defined on a (nominal) map called '*res.map*'. It is important that all reservoirs are located on a channel pixel (you can verify this by displaying the reservoirs map on top of the channel map). Also, since each reservoir receives its inflow from its upstream neighbouring channel pixel, you may want to check if each reservoir has any upstream channel pixels at all (if not, the reservoir will gradually empty during a model run!). The management of the reservoirs is described by 7 tables. The following table lists all required input:

***Table:*** *Input requirements reservoir routine.*

| **Maps**    | **Default name**   | **Description** | **Units**   | **Remarks** |
|-------------|-------------|-------------|-------------|-------------|
| ReservoirSites | res.map     | reservoir locations  | \-          | nominal     |
| TabTotStorage | rtstor.txt  | reservoir storage capacity  | $[m^3]$ |             |
| TabConservativeStorageLimit | rclim.txt   | conservative storage limit | \-          | fraction of storage |
| TabNormalSt orageLimit| rnlim.txt   | normal storage limit     | \-          | capacity    |
| TabFloodStorageLimit | rflim.txt   | flood storage limit      | \-          |             |
| TabMinOutflowQ | rminq.txt   | minimum outflow    | $[m^3]$ |             |
| TabNormalOutflowQ | rnormq.txt  | normal outflow     | $[m^3]$ |             |
| TabNonDamagingOutflowQ | rndq.txt    | non-damaging outflow | $[m^3]$ |             |


When you create the map with the reservoir sites, pay special attention to the following: if a reservoir is on the most downstream cell (i.e. the outflow point, see Figure below), the reservoir routine may produce erroneous output. In particular, the mass balance errors cannot be calculated correctly in that case. The same applies if you simulate only a sub-catchment of a larger map (by selecting the subcatchment in the mask map). This situation can usually be avoided by extending the mask map by one cell in downstream direction.

![reservoirPlacementNew](https://ec-jrc.github.io/lisflood_manual/media/image42.png){:height="203px" width="456px"} 

***Figure:*** *Placement of the reservoirs: reservoirs on the outflow point (left) result in erroneous behavior of the reservoir routine.*



**Preparation of settings file**

All in- and output files need to be defined in the settings file. If you are using a default LISFLOOD settings template, all file definitions are already defined in the 'lfbinding' element. Just make sure that the map with the reservoir locations is in the "maps" directory, and all tables in the 'tables" directory. If this is the case, you only have to specify the time-step used for the reservoir calculations and the initial reservoir filling level (expressed as a fraction of the storage capacity). Both are defined in the 'lfuser' element of the settingsfile. For the reservoir time step (DtSecReservoirs) it is recommended to start with a value of 14400 (4 hours), and try smaller values if the simulated reservoir outflow shows large oscillations. ReservoirInitialFillValue can be either a map or a value (between 0and 1). So we add this to the 'lfuser' element (if it is not there already):

```xml
	<group>                                                             
	<comment>                                                           
	**************************************************************               
	RESERVOIR OPTION                                                      
	**************************************************************               
	</comment>                                                          
	<textvar name="DtSecReservoirs" value="14400">                  
	<comment>                                                           
	Sub time step used for reservoir simulation [s]. Within the model,  
	the smallest out of DtSecReservoirs and DtSec is used.                
	</comment>                                                          
	</textvar>                                                          
	<textvar name="ReservoirInitialFillValue" value="-9999">        
	<comment>                                                           
	Initial reservoir fill fraction                                       	
	-9999 sets initial fill to normal storage limit                       
	if you're not using the reservoir option, enter some bogus value     
	</comment>                                                          
	</textvar>                                                          
	</group>                                                            
```

The value -9999 tells the model to set the initial reservoir fill to the normal storage limit. Note that this value is completely arbitrary. However, if no other information is available this may be a reasonable
starting point.

Finally, you have to tell LISFLOOD that you want to simulate reservoirs! To do this, add the following statement to the 'lfoptions' element:

```xml
	<setoption name="simulateReservoirs" choice="1" />
```

Now you are ready to run the model. If you want to compare the model results both with and without the inclusion of reservoirs, you can switch off the simulation of reservoirs either by:

1.  Removing the 'simulateReservoirs' statement from the 'lfoptions element, or
2.  changing it into \<setoption name="simulateReservoirs" choice="0" /\> 

Both have exactly the same effect. You don't need to change anything in either 'lfuser' or 'lfbinding'; all file definitions here are simply ignored during the execution of the model.



**Reservoir output files**

The reservoir routine produces 3 additional time series and one map, as listed in the following table:

***Table:***  *Output of reservoir routine.*                    

| **Maps / Time series** | **Default name** | **Description**                       | **Units**       | **Remarks** |
| ---------------------- | ---------------- | ------------------------------------- | --------------- | ----------- |
| ReservoirFillState     | rsfilxxx.xxx     | reservoir fill at last time step[^10] | \-              |             |
| ReservoirInflowTS      | qresin.tss       | inflow into reservoirs                | $\frac{m^3}{s}$ |             |
| ReservoirOutflowTS     | qresout.tss      | outflow out of reservoirs             | $\frac{m^3}{s}$ |             |
| ReservoirFillTS        | resfill.tss      | reservoir fill                        | \-              |             |

​                                                      

Note that you can use the map with the reservoir fill at the last time step to define the initial conditions of a succeeding simulation, e.g.:

```xml
	<textvar name="ReservoirInitialFillValue" value="/mycatchment/rsfil000.730">
```

[🔝](#top)

