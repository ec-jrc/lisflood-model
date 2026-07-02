## Transient land use change option


### Introduction

This page describes the LISFLOOD option for transient land use change. This option allows to vary the land fractions over time. It can be activated adding the following line to the `lfoption` element in the LISFLOOD settings file:

```xml 
<setoption choice="1" name="TransientLandUseChange"/>
```

### Description of the transient land use change option

If the option for transient land use change is activated, the model loads for each land type a map stack representing the evolution over time of the fraction of land covered by that land type. These tyme-varying fractions replace at every time setp the static values loaded at the beginning of the simulation (the ones used if the option for transient land use change is not activated). If one or more of the map stacks don't contain data for an exact time step, the most recent one is taken.

### Preparation of input data

In order to use the transient land use change option, the following map stacks need to be provided:

***Table:***  *Input requirements for transient land use change option.*                                                                              

| **Maps**                 | **Default name**    | **Description**                                           | **Units** | **Remarks**                                                           |
| ------------------------ | ------------------- | --------------------------------------------------------- | --------- | --------------------------------------------------------------------- |
| `WaterFractionMaps`        | _fw_ or _fracwater_     | Map stack of water fractions at different times           | -         | Substitutes values in map `WaterFraction` (default: _fracwater_)          |
| `OtherFractionMaps`        | _fo_ or _fracother_     | Map stack of other fractions at different times           | -         | Substitutes values in map `OtherFraction` (default: _fracother_)          |
| `ForestFractionMaps`       | _ff_ or _fracforest_    | Map stack of forest fractions at different times          | -         | Substitutes values in map `ForestFraction` (default: _fracforest_)        |
| `IrrigationFractionMaps`   | _fi_ or _fracirrigated_ | Map stack of irrigated land fractions at different times  | -         | Substitutes values in map `IrrigationFraction` (default: _fracirrigated_) |
| `RiceFractionMaps`         | _fr_ or _fracrice_     | Map stack of rice cultivated fractions at different times | -         | Substitutes values in map `RiceFraction` (default: _fracrice_)            |
| `DirectRunoffFractionMaps` | _fs_ or _fracsealed_    | Map stack of direct runoff fractions at different times   | -         | Substitutes values in map `DirectRunoffFraction` (default: _fracsealed_)  |

> ***NOTE:*** for each land type, two maps are loaded: the "static" map defined in *\<Landtypename\>Fraction* (eg *WaterFraction*, *ForestFraction*), and the "dynamic" map defined in *\<Landtypename\>FractionMaps* (eg *WaterFractionMaps*, *ForestFractionMaps*). 
The definition of the land use types can be found in the chapter [overview](https://ec-jrc.github.io/lisflood-model/2_01_stdLISFLOOD_overview/). 
The "static" maps are loaded at the beginning of the simulation, whereas the "dynamic" maps are loaded at every time step if the `TransientLandUseChange` option is on; their values replace the ones previously loaded.
Even if the values in the "static" maps loaded at the beginning of the simulation are never actually used, as they are replaced in the first simulation step, they need to be defined in the settings file.
However, provided that the time defined in `CalendarDayStart` is one of the time steps of the "dynamic" map stacks, these can be used as input for both the "static" and the "dynamic" maps. In this case, the model loads the map at time `CalendarDayStart` at the beginning of the simulation, and replaces it at each subsequent time step with the map corresponding to that time step (or the most recent one available).

### Preparation of settings file

Using the transient land use change option involves two steps:

1. **Define where the stack maps of land use change are located**. For that, you need to find in the `lfbinding` element of the settings file the variables shown in the code snippet below. Make sure that the internal variable `$(PathMaps)` points at the directory where your maps are located; you'll find the variable `PathMaps` in the `lfuser` section of the settings file. Note that two maps ("static" and "dynamic") are defined for each land fraction; in this example, the same maps stacks are used for both.

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

2. **Activate the transient land use change option** by adding the following line to the `lfoptions` element:

```xml
<setoption choice="1" name="TransientLandUseChange"/>
```

Now you are ready to run the model with the transient land use change option.
 

[🔝](#top)