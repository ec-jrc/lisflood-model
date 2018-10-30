# Simulation of lakes


## Introduction

This pages describes the LISFLOOD lake routine, and how it is used. The simulation of lakes is *optional*, and it can be activated by adding the following line to the 'lfoptions' element in the LISFLOOD settings file:

```xml 
	<setoption name="simulateLakes" choice="1" />
```

Lakes can be simulated on channel pixels where kinematic wave routing is used. The routine does *not* work for channel stretches where the dynamic wave is used!



## Description of the lake routine

Lakes are simulated as points in the channel network. The Figure below shows all computed in- and outgoing fluxes. Lake inflow equals the channel flow upstream of the lake location. The flow out of the lake is computed using the following rating curve (e.g. Maidment, 1992):

$$
O_{lake} = A{(H - {H_0})^B}
$$

with:
   <br>$O_{lake}$:	  Lake outflow rate $[\frac{m^3} {s}]$
   <br>$H$:   Water level in lake $[m]$
   <br>$H_0$:	  Water level at which lake outflow is zero $[m]$
   <br>$A, B$:	  Constants \[-\]


![](../media/image45-resize.png)

***Figure:*** *Schematic overview of the simulation of lakes.* $H_0$ *is the water level at which the outflow is zero;* $H$ *is the water level in the lake and* $EW$ *is the evaporation from the lake*

Both $H$ and $H_0$ can be defined relative to an arbitrary reference level. Since the outflow is a function of the *difference* between both levels, the actual value of this reference level doesn't matter if $H > H_0$. However, it is advised to define both $H$ and $H_0$ relative to the *average bottom level* of the lake. This will result in more realistic simulations during severe drought spells, when the water level drops below $H_0$ (in which case lake outflow ceases). The value of constant *A* can be approximated by the width of the lake outlet in meters, and *B* is within the range 1.5-2 (<span style="color:red"> reference?</span>). Lake evaporation occurs at the potential evaporation rate of an open water surface.



### Initialisation of the lake routine

Because lakes (especially large ones) tend to produce a relatively slow response over time, it is important to make sure that the initial lake level is set to a more or less sensible value. Just as is the case with the initialisation of the lower groundwater zone, LISFLOOD has a special option that will compute a steady-state lake level and use this as the initial value. The steady-state level is computed from the water balance
of the lake. If $V_l$ is the total lake volume $[m^3]$, the rate of change of $V_l$ at any moment is given by the continuity equation:

$$
\frac{dV_l}{dt} = I(t) - O(t)
$$

where $I$ and $O$ are the in- and outflow rates, respectively. For a steady-state situation the storage remains constant, so:

$$
\frac{dV_l}{dt} = 0\quad \Leftrightarrow \quad I(t) - O(t) = 0
$$

Substituting all in- and outflow terms gives:

$$
I_l - EW_l - A(H - H_0)^B = 0
$$

where $I_l$ is the inflow into the lake and $EW_l$ the lake evaporation (both expressed in $\frac{m^3} {s}$). Re-arranging gives the steady-state lake level:

$$
H_{ss} = H_0 + (\frac{I_l - EW_l}{A})^{\frac{1}{B}}
$$

LISFLOOD calculates the steady-state lake level based on a user-defined average net inflow ($=I_l - EW_l$). The average net inflow can be estimated using measured discharge and evaporation records. If measured discharge is available just *downstream* of the lake (i.e. the *outflow*), the (long-term) average outflow can be used as the net inflow estimate (since, for a steady state situation, inflow equals outflow). If only inflow is available, all average inflows should be summed, and the average lake evaporation should be subtracted from this figure.

Here a worked example. Be aware that the calculation can be less straightforward for very large lakes with multiple inlets (which are not well represented by the current point approach anyway):



### EXAMPLE: Calculation of average net lake inflow

 Lake characteristics 
 - lake area: $215 \cdot 10^6\ m^2$                                            
 - mean annual discharge downstream of lake: $293\ \frac{m^3}{s}$             
 - mean annual discharge upstream of lake: $300\ \frac{m^3}{s}$               
 - mean annual evaporation: $1100\ \frac{mm}{yr}$ 
                                
 <u>METHOD 1: USING AVERAGE OUTFLOW</u>                                   
 Assuming lake is in quasi steady-state:                               
 	average net inflow = average net outflow = $293 \frac{m^3}{s}$                                                  

 <u>METHOD 2: USING AVERAGE INFLOW AND EVAPORATION</u>                    
 Only use this method if no outflow data are available                 

 1. Express lake evaporation in $m^3 s^{-1}$:                       

    $\frac{1100 \frac{mm}{yr}}{1000} = 1.1\ \frac{m}{yr}$           

    $1.1\ \frac{m}{yr} \cdot 215 \cdot 10^{6} m^2 = 2.37 \cdot 10^8 \frac{m^3}{yr}$     

    $\frac{2.37 \cdot 10^8 \frac{m^3}{yr}}{365\ days\ \cdot\ 86400 seconds} = 7.5 \frac{m^3}{s}$   


 2.  Compute net inflow:                                           
     net inflow = $300 \frac{m^3}{s}\ - 7.5\ \frac{m^3}{s}= 292.5\ \frac{m^3}{s}$




## Preparation of input data

The lake locations are defined on a (nominal) map called '*lakes.nc*'. It is important that all lakes are located on a channel pixel (you can verify this by displaying the lake map on top of the channel map). Also, since each lake receives its inflow from its upstream neighbouring channel pixel, you may want to check if each lake has any upstream channel pixels at all (if not, the lake will just gradually empty during a model run!). The lake characteristics are described by 4 tables. The following Table lists all required input:

***Table:***  *Input requirements lake routine.*                                                                              

| **Maps**    | **Default name** | **Description**                          | **Units** | **Remarks**                           |
| ----------- | ---------------- | ---------------------------------------- | --------- | ------------------------------------- |
| LakeSites   | lakes.map        | lake locations                           | -         | nominal                               |
| **Tables**  |                  |                                          |           |                                       |
| TabLakeArea | lakearea.txt     | lake surface area                        | $m^2$     |                                       |
| TabLakeH0   | lakeh0.txt       | water level at which lake outflowis zero | $m$       | relative to average lake bottom level |
| TabLakeA    | lakea.txt        | lake parameter A                         | -         | ≈ outlet width in meters              |
| TabLakeB    | lakeb.txt        | lake parameter B                         | -         | 1.5-2                                 |



<u>Note:</u> When you create the map with the lake locations, pay special attention to the following: if a lake is located on the most downstream cell (i.e. the outflow point, see Figure below), the lake routine may produce erroneous output. In particular, the mass balance errors cannot be calculated correctly in that case. The same applies if you simulate only a sub-catchment of a larger map (by selecting the subcatchment in the mask map). This situation can usually be avoided by extending the mask map by one cell in downstream direction.

![](../media/image42.png)

***Figure:***  *Placement of the lakes: lakes on the outflow point (left) result in erroneous behavior of the lake routine.*



## Preparation of settings file

All in- and output files need to be defined in the settings file. If you are using a default LISFLOOD settings template, all file definitions are already defined in the 'lfbinding' element. Just make sure that the map with the lake locations is in the "maps" directory, and all tables in the 'tables" directory. If this is the case, you only have to specify the initial lake level and --if you are using the steady-state option- the mean net lake inflow (make this a map if you're simulating multiple lakes simultaneously). Both can be set in the 'lfuser' element. *LakeInitialLevelValue* can be either a map or a single value. Setting *LakeInitialLevelValue* to *-9999* will cause LISFLOOD to calculate the steady-state level. So we add this to the 'lfuser' element (if it is not there already):

```xml
	<group>                                                             	
	<comment>                                                           	
	**************************************************************               	
	LAKE OPTION                                                           	
	**************************************************************               	
	</comment>                                                          	
	<textvar name="LakeInitialLevelValue" value="-9999">            	
	<comment>                                                           	
	Initial lake level [m]                                              	
	-9999 sets initial value to steady-state level                        	
	</comment>                                                          	
	</textvar>                                                          	
	<textvar name="LakeAvNetInflowEstimate" value="292.5">          	
	<comment>                                                           			
	Estimate of average net inflow into lake (=inflow -- evaporation)     	
	[cu m / s]                                                          	
	Used to calculated steady-state lake level in case                    	
	LakeInitialLevelValue                                                 	
	is set to -9999                                                       	
	</comment>                                                          	
	</textvar>                                                          	
	</group>                                                            	
```



Finally, you have to tell LISFLOOD that you want to simulate lakes! To do this, add the following statement to the 'lfoptions' element:

```xml
<setoption name="simulateLakes" choice="1" />
```



Now you are ready to run the model. If you want to compare the model results both with and without the inclusion of lakes, you can switch off the simulation of lakes either by:

- Removing the 'simulateLakes' statement from the 'lfoptions element, or
- changing it into \<setoption name="simulateLakes" choice="0" /\>

Both have exactly the same effect. You don't need to change anything in either 'lfuser' or 'lfbinding'; all file definitions here are simply ignored during the execution of the model.



## Lake output files

The lake routine produces 4 additional time series and one map (or stack), as listed in the following table:

**Table:**  *Output of lake routine.*

| Maps            | Default name | Description                    | Units           |
| --------------- | ------------ | ------------------------------ | --------------- |
| LakeLevelState  | lakhxxxx.xxx | lake level at last time step | $m$             |
| **Time series** |              |                                |                 |
| LakeInflowTS    | qLakeIn.tss  | inflow into lakes              | $\frac{m^3}{s}$ |
| LakeOutflowTS   | qLakeOut.tss | flow out of lakes              | $\frac{m^3}{s}$ |
| LakeEWTS        | EWLake.tss   | lake evaporation               | $mm$            |
| LakeLevelTS     | hLake.tss    | lake level                     | $m$             |

Note that you can use the map with the lake level at the last time step to define the initial conditions of a succeeding simulation, e.g.:

```xml
<textvar name="LakeInitialLevelValue" value="/mycatchment/lakh0000.730">
```

[🔝](#top)

