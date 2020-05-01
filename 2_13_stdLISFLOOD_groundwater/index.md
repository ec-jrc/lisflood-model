## Groundwater

Groundwater storage and transport are modelled using two parallel linear reservoirs, similar to the approach used in the HBV-96 model (Lindström et al., 1997). The upper zone represents a quick runoff component, which includes fast groundwater and subsurface flow through macro-pores in the soil. The lower zone represents the slow groundwater component that generates the base flow. The **outflow from the upper zone to the channel**, $Q_{uz} [mm]$ equals:

$$
Q_{uz} = \frac{1}{T_{uz}} \cdot UZ \cdot \Delta t
$$

where $T_{uz}$ is a reservoir constant $[days]$ and $UZ$ is the amount of water that is stored in the upper zone $[mm]$. Similarly, the **outflow from the lower zone** is given by:

$$
Q_{lz} = \frac{1}{T_{lz}} \cdot LZ \cdot \Delta t
$$

Here, $T_{lz}$ is again a reservoir constant $[days]$, and $LZ$ is the amount of water that is stored in the lower zone $[mm]$. The values of both $T_{uz}$ and $T_{lz}$ are obtained by calibration. The upper zone also provides the inflow into the lower zone. For each time step, a fixed amount of **water percolates from the upper to the lower zone**:

$$
D_{uz,lz} = min (GW_{perc} \cdot \Delta t ,UZ)
$$

Here, $GW_{perc} \ [\frac{mm}{day}]$ is a user-defined value that is determined during calibration. 
Note that these equations are again valid for the permeable fraction of the pixel only: storage in the direct runoff fraction equals 0 for both $UZ$ and $LZ$.


## Groundwater abstractions

LISFLOOD includes the option of groundwater abstraction for irrigation and other usage purposes (see water use chapter). LISFLOOD checks if the amount of demanded water that is supposed to be abstracted from a source, is actually available. 

Groundwater abstraction = the total water demand * fracgwused

In the current LISFLOOD version, groundwater is abstracted for a 100%, so no addtional losses are accounted for, by which more would need to be abstracted to meet the demand. Also, in the current LISFLOOD version, no limits are set for groundwater abstraction.

LISFLOOD subtracts groundwater from the Lower Zone (LZ). Groundwater depletion can thus be examined by monitoring the LZ levels between the start and the end of a simulation. Given the intra- and inter-annual fluctuations of LZ, it is advisable to monitor more on decadal periods.

If the Lower Zone groundwater amount decreases below the 'LZThreshold" - a groundwater threshold value -, the baseflow from the LZ to the nearby rivers is zero. When sufficient recharge is added again to raise the LZ levels above the threshold, baseflow will start again. This mimicks the behaviour of some river basins in very dry episodes, where aquifers temporarily lose their connection to major rivers and baseflow is reduced.

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


[🔝](#top)
