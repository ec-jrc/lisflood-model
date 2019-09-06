# Transient land use change option


## Introduction

This page describes the LISFLOOD option for transient land use change.
This option allows to vary the land fractions over time.
The option can be activated adding the following line to the 'lfoption' element in the LISFLOOD settings file:

```xml 
	<setoption name="TransientLandUseChange" choice="1" />
```


## Description of the transient land use change option

If the option for transient land use change is activated, the model loads the different land fractions at each time step from a set of map stacks (one per fraction).
If one or more of the map stacks don't contain the exact time step, the most recent one is taken.

For each land type, the time-varying fractions loaded at every time step replace the static values loaded at the beginning of the simulation (the ones used if the option for transient land use change is not activated).

## Preparation of input data

In order to use the transient land use change option, the following map stacks need to be provided:

***Table:***  *Input requirements for transient land use change option.*                                                                              

| **Maps**                 | **Default name**    | **Description**                                           | **Units** | **Remarks**                                                           |
| ------------------------ | ------------------- | --------------------------------------------------------- | --------- | --------------------------------------------------------------------- |
| WaterFractionMaps        | fw or fracwater     | Map stack of water fractions at different times           | -         | Substitutes values in map WaterFraction (default: fracwater)          |
| OtherFractionMaps        | fo or fracother     | Map stack of other fractions at different times           | -         | Substitutes values in map OtherFraction (default: fracother)          |
| ForestFractionMaps       | ff or fracforest    | Map stack of forest fractions at different times          | -         | Substitutes values in map ForestFraction (default: fracforest)        |
| IrrigationFractionMaps   | fi or fracirrigated | Map stack of irrigated land fractions at different times  | -         | Substitutes values in map IrrigationFraction (default: fracirrigated) |
| RiceFractionMaps         | fr or fracrice      | Map stack of rice cultivated fractions at different times | -         | Substitutes values in map RiceFraction (default: fracrice)            |
| DirectRunoffFractionMaps | fs or fracsealed    | Map stack of direct runoff fractions at different times   | -         | Substitutes values in map DirectRunoffFraction (default: fracsealed)  |

<u>Note:</u> For each land type, two maps are loaded: the "static" map defined in *\*Landtypename\*Fraction* (eg *WaterFraction*, *ForestFraction*) and the "dynamic" one defined in *\*Landtypename\*FractionMaps* (eg *WaterFractionMaps*, *ForestFractionMaps*).
The former are loaded at the beginning of the simulation, the latter are loaded at every time step if the *TransientLandUseChange* option is on and their values replace the ones previously loaded.
Even if the values in the "static" maps loaded at the beginning of the simulation are never actually used as they are replaced in the first simulation step, they need to be defined in the settings file.
However, provided that the time defined in *CalendarDayStart* is one of the time steps of the "dynamic" map stacks, these can be used as input for both the "static" and the "dynamic" maps. In this case the model loads the map at time=*CalendarDayStart* at the beginning of the simulation, and replaces it at each subsequent time step with the map corresponding to that time step (or the most recent one available).

## Preparation of settings file

Using the transient land use change option involves two steps:

1. Replace in the LISFLOOD settings file under the 'lfuser' element the file paths/names by the ones you want to use.
The following is an example of a part of the 'lfuser' element that defines map inputs for land fractions. Note that two maps (the "static" and the "dynamic" ones described in the note above) are defined for each land fraction, in this example, the same maps tacks are used for both.

```xml
<textvar name="WaterFraction" value="$(PathMaps)/fracwater">
<comment>
water fraction of a pixel (0-1)
</comment>
</textvar>

<textvar name="WaterFractionMaps" value="$(PathMaps)/fracwater">
<comment>
alternatively: value="$(PathMaps)/fw"
stack of water fraction maps (0-1)
</comment>
</textvar>

<textvar name="OtherFraction" value="$(PathMaps)/fracother">
<comment>
other fraction of a pixel (0-1)
</comment>
</textvar>

<textvar name="OtherFractionMaps" value="$(PathMaps)/fracother">
<comment>
alternatively: value="$(PathMaps)/fo"
stack of other fraction maps (0-1)
</comment>
</textvar>

<textvar name="ForestFraction" value="$(PathMaps)/fracforest">
<comment>
forest fraction of a pixel (0-1)
</comment>
</textvar>

<textvar name="ForestFractionMaps" value="$(PathMaps)/fracforest">
<comment>
alternatively: value="$(PathMaps)/ff"
stack of forest fraction maps (0-1)
</comment>
</textvar>

<textvar name="IrrigationFraction" value="$(PathMaps)/fracirrigated">
<comment>
irrigated area fraction of a pixel (0-1)
</comment>
</textvar>

<textvar name="IrrigationFractionMaps" value="$(PathMaps)/fracirrigated">
<comment>
alternatively: value="$(PathMaps)/fi"
stack of irrigated land fraction maps (0-1)
</comment>
</textvar>

<textvar name="RiceFraction" value="$(PathMaps)/fracrice">
<comment>
rice fraction of a pixel (0-1)
</comment>
</textvar>

<textvar name="RiceFractionMaps" value="$(PathMaps)/fracrice">
<comment>
alternatively: value="$(PathMaps)/fr"
stack of rice fraction maps (0-1)
</comment>
</textvar>

<textvar name="DirectRunoffFraction" value="$(PathMaps)/fracsealed">
<comment>
direct runoff fraction of a pixel (0-1)
</comment>
</textvar>

<textvar name="DirectRunoffFractionMaps" value="$(PathMaps)/fracsealed">
<comment>
alternatively: value="$(PathMaps)/fs"
stack of direct runoff fraction maps (0-1)
</comment>
</textvar>
```

2. Activate the transient land use change option by adding the following line to the 'lfoptions' element:

```xml
<setoption name="TransientLandUseChange" choice="1" />
```

Now you are ready to run the model with the transient land use change option.
 

[🔝](#top)
