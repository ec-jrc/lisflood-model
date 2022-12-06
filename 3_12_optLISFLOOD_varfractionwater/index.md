## Variable water fraction option


### Introduction

This page describes the LISFLOOD option for variable water fraction.
This option allows to specify the seasonal variation of water fraction.
The option can be activated adding the following line to the `lfoption` element in the LISFLOOD settings file:

```xml 
<setoption choice="1" name="varfractionwater"/>
```

### Description of the variable water fraction option

If the variable water fraction option is activated, the water fraction varies seasonally.
In order to maintain the sum of land fraction constant (at 1), the fractions other than water need to be recalculated at each step to account for the extra amount of water.

In addition to defining the water fraction $F_{water}$, the variable water fraction requires the user to define a maximum fraction of water per pixel $f_{water,max}$ and a time-variable factor representing the relative positioning of the monthly value of water fraction between the two extremes $\delta f_{water,i}$ (with $i = 1,2,\ldots 12$).
Given these inputs, the differentail water fraction is determined by linear interpolation:

$$
\Delta f_{water,i} = \delta f_{water,i} \cdot \left ( f_{water,max} - f_{water} \right )
$$

$\Delta f_{water,i}$ represents the additional amount of water at month $i$ compared to the baseline in $f_{water}$ and it is the amount that needs to be removed from the other fractions in order to maintain the sum equal to 1.
This is done iteratively removing fractions in order (first $f_{other}$, then $f_{forest}$, $f_{irrig}$ and $f_{runoff}$)  until they reach $0$ or until $\Delta f_{water,i}$ runs out:
<br>$f_{other,i}=\max(f_{other} - \Delta f_{water,i}),0)$ and $e_{other,i}= \max(\Delta f_{water,i} - f_{other},0)$
<br>$f_{forest,i}=\max(f_{forest} - e_{other,i},0)$ and $e_{forest,i}=\max(e_{other,i} - f_{forest},0)$
<br>$f_{irrig,i}= \max(f_{irrig} - e_{forest,i},0) $ and $e_{irrig,i}= \max(e_{forest,i} - f_{irrig,0})$
<br>$f_{runoff,i}= \max(f_{runoff} - e_{irrig,i},0)$

Where, for each land type $k$:
   <br> $f_{k,i}$ is the fraction of land type $k$ at for month $i$;
   <br> $e_{k,i}$ is the remainder of $\Delta f_{water,i}$ still to be distributed after $f_{k,i}$ has been calculated.

### Preparation of input data

In order to use the transient land use change option, the following maps and map stacks need to be provided:

***Table:***  *Input requirements for variable water fraction option.*                                                                              

| **Maps**        | **Default name**  | **Description**                                   | **Units** | **Remarks**                                                   |
| ----------------| ----------------- | ------------------------------------------------- | --------- | ------------------------------------------------------------- |
| WaterFraction   | fracwater         | Map of water fraction in a pixel                  | -         | Already required, regardless of variable water fraction option|
| FracMaxWater    | fracmaxwater      | Map of maximum water fraction in a pixel          | -         |                                                               |
| WFractionMaps   | varW              | Map stack of seasonal variation of water fraction | -         | 12 maps, one per month.                                       |

> **_NOTE:_** The values in _WFractionMaps_ are in the range [0,1] and represent the relative monthly value of water fraction between the two extremes determined by the maps _WaterFraction_ and _FracMaxWater_. 
> * A _WFractionMaps_ value of 0 implies that, for that month, the water fraction is equal to the map _WaterFraction_.
> * A _WFractionMaps_ value of 1 implies that it is equal to _FracMaxWater_. 
> * Values in between are linearly interpolated.

### Preparation of settings file

All input files need to be defined in the settings file.
If you are using a default LISFLOOD settings template, all file definitions are already defined in the `lfbinding` element. Just make sure that the maps are in the directory indicated by *PathMaps*.

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
