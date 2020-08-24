# Introduction

## About LISFLOOD

LISFLOOD is a spatially distributed water resources model, developed by the Joint Research Centre (JRC) of the European Commission since 1997. 

LISFLOOD has been applied to a wide range of water resources applications such as simulating flood prevention and river regulation measures, 
flood forecasting, drought and soil moisture assessment and forecasting, the impacts of climate and land-use changes on water resources, 
and the impact of various water efficiency measures on water resources.
The current most prominent application of LISFLOOD is within the [European Flood Awareness System](https://www.efas.eu/) (EFAS).
LISFLOOD will also be used in the next release of the [Global Flood Awareness System](https://www.globalfloods.eu/general-information/about-glofas/) (GLOFAS) as detailed in [Alfieri et al. (2020)](https://www.sciencedirect.com/science/article/pii/S2589915519300331). Both EFAS and GLOFAS are operated under the [Copernicus Emergency Management System](http://emergency.copernicus.eu/) (EMS).

LISFLOOD's wide applicability is due to its modular structure as well as its temporal and spatial flexibility. 
The model can be extended with additional modules when the need arises, to satisfy the new target objective. 
In that sense it can be extended to include anything from a better representation of a particular hydrological flow to the implementation of anthropogenic-influenced processes. 

The model has also been designed to be applied across a wide range of spatial and temporal scales. LISFLOOD is grid-based, 
and applications to date have employed grid cells of as little as 100 metres (for medium-sized catchments), 
to 5000 metres for modelling the whole of Europe and 0.1° (around 11 km) and 0.5° (around 55 km) for modelling at the global scale. 
LISLFLOOD can simulate the long-term water balance (using daily or sub-daily time steps), as well as individual flood events (using hourly or even sub-hourly time intervals). 

Although LISFLOOD's primary output product is river discharge, all the internal rate and state variables (soil moisture, for example) can be written as output. 
All output can be written as maps covering the full computational domain, or time series at user-defined points or areas. 
The user has complete control on the saving of the output data, thus minimising any waste of disk space or CPU time.

LISFLOOD is implemented in the PCRaster Environmental Modelling Framework (Wesseling et al., 1996), wrapped in a Python- based interface. 
PCRaster is a raster GIS environment that has its own high-level computer language, which allows for the construction of iterative spatio-temporal environmental models. 
The Python wrapper of LISFLOOD enables the user to control the model inputs and outputs and the selection of the model modules. 
This approach combines the power, relative simplicity and maintainability of code written in the the PCRaster Environmental Modelling language and the flexibility of Python. 
LISFLOOD runs on any operating system for which Python and PCRaster are available.


[🔝](#top)
