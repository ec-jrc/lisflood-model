## Variable water fraction option


### Introduction

This page describes the LISFLOOD option for variable water fraction.
This option allows to specify the seasonal variation of water fraction.
The option can be activated adding the following line to the 'lfoption' element in the LISFLOOD settings file:

```xml 
<setoption name="varfractionwater" choice="1" />
```


### Description of the variable water fraction option

If the variable water fraction option is activated, the water fraction varies seasonally.
In order to maintain the sun of land fraction constant (at 1), the fractions other than water need to be recalculated at each step to account for the extra amount of water.

In addition to defining the water fraction $F_{water}$, the variable water fraction requires the user to define a maximum fraction of water per pixel $f_{water,max}$ and a time-variable factor representing the relative positioning of the monthly value of water fraction between the two extremes $\delta f_{water,i}$ (with $i = 1,2,\ldots 12$).
Given these inputs, the differentail water fraction is determined by linear interpolation:

$$
\Delta f_{water,i} = \delta f_{water,i} \cdot \left ( f_{water,max} - f_{water} \right )
$$

$\Delta f_{water,1}$ represents the additional amount of water at month $i$ compared to the baseline in $f_{water}$ and it is the amount that needs to be removed from the other fractions in order to maintain the sum equal to 1.
This is done iteratively removing fractions in order (first $f_{other}$, then $f_{forest}$, $f_{irrigation}$ and $f_{runoff}$)  until they reach $0$ or until $\Delta f_{water,i}$ runs out:

$$
\begin{array}{rlrl}
f_{other,i}=&\!\!\! \max\left(f_{other} - \Delta f_{water,i}\right),& \epsilon_{other,i}=&\!\!\! \max(\Delta f_{water,i} - f_{other},0)\\
f_{forest,i}=&\!\!\! \max\left(f_{forest} - \epsilon_{other,i}\right),& \epsilon_{forest,i}=&\!\!\! \max(\epsilon_{other,i} - f_{forest},0)\\
f_{irrigation,i}=&\!\!\! \max\left(f_{irrigation} - \epsilon_{forest,i}\right),& \epsilon_{irrigation,i}=&\!\!\! \max(\epsilon_{forest,i} - f_{irrigation},0)\\ 
f_{runoff,i}=&\!\!\! \max\left(f_{runoff} - \epsilon_{irrigation,i}\right),&&
\end{array}
$$

Where, for each land type $k$:
   <br> $f_{k,i}$ is the fraction of land type $k$ at for month $i$;
   <br> $\epsilon_{k,i}$ is the remainder of $\Delta f_{water,i}$ still to be distributed after $f_{k,i} has been calculated.


### Preparation of input data

In order to use the transient land use change option, the following maps and map stacks need to be provided:

***Table:***  *Input requirements for variable water fraction option.*                                                                              

| **Maps**        | **Default name**  | **Description**                                   | **Units** | **Remarks**                                                   |
| ----------------| ----------------- | ------------------------------------------------- | --------- | ------------------------------------------------------------- |
| WaterFraction   | fracwater         | Map of water fraction in a pixel                  | -         | Already required, regardless of variable water fraction option|
| FracMaxWater    | fracmaxwater      | Map of maximum water fraction in a pixel          | -         |                                                               |
| WFractionMaps   | varW              | Map stack of seasonal variation of water fraction | -         | 12 maps, one per month.                                       |

<u>Note:</u> The values in WFractionMaps are in the range [0,1] and represent the relative positioning of the monthly value of water fraction between the two extremes determined by the maps WaterFraction and FracMaxWater. WFractionMaps = 0 implies that for that month, the water fraction is equal to the value in the map WaterFraction; while WFractionMaps = 1 implies that it is equal to FracMaxWater. Values in between are linearly interpolated.

### Preparation of settings file

All input files need to be defined in the settings file.
If you are using a default LISFLOOD settings template, all file definitions are already defined in the 'lfbinding' element.
Just make sure that the maps are in the "maps" directory.

```xml
<textvar name="WaterFraction" value="$(PathMaps)/fracwater">
<comment>
$(PathMapsLanduse)/fracwater.map
Water fraction of a pixel (0-1)
</comment>
</textvar>

<textvar name="FracMaxWater" value="$(PathMaps)/fracmaxwater">
<comment>
Fraction of maximum extend of water (0-1)
</comment>
</textvar>

<textvar name="WFractionMaps" value="$(PathMaps)/varW">
<comment>
Map stack of seasonal variation of water fraction (0-1)
</comment>
</textvar>
```

[🔝](#top)
