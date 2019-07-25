## About LISFLOOD

LISFLOOD is a spatially distributed water resources model, developed by the Joint Research Centre (JRC) of the European Commission since 1997. 

LISFLOOD has been applied to a wide range of water resources applications such as simulating flood prevention and river regulation measures, 
flood forecasting, drought and soil moisture assessment and forecasting, the impacts of climate and land-use changes on water resources, 
and the impact of various water efficiency measures on water resources.
Its most prominent application is probably within the [European Flood Awareness System](https://www.efas.eu/) (EFAS) 
operated under the [Copernicus Emergency Management System](http://emergency.copernicus.eu/) (EMS).

LISFLOOD's wide applicability is due to its modular structure as well as its temporal and spatial flexibility. 
The model can be extended with additional modules wh4en the need arises, to satisfy the new target objective. 
In that sense it can be extended to include anything from a better representation of a particular hydrological flow to the implementation of anthropogenic-influenced processes. 

The model has also been designed to be applied across a wide range of spatial and temporal scales. LISFLOOD is grid-based, 
and applications to date have employed grid cells of as little as 100 metres (for medium-sized catchments), 
to 5000 metres for modelling the whole of Europe and 0.1° (around 11 km) and 0.5° (around 55 km) for modelling at the global scale. 
The long-term water balance can be simulated (using a daily time step), as can individual flood events (using hourly time intervals, or even smaller). 

Although LISFLOOD's primary output product is river discharge, all internal rate and state variables (soil moisture, for example) can also be written as output. 
All output can be written as grids, or time series at user-defined points or areas. 
The user has complete control over how output is written, thus minimising any waste of disk space or CPU time.

LISFLOOD is implemented in the PCRaster Environmental Modelling Framework (Wesseling et al., 1996), wrapped in a Python- based interface. 
PCRaster is a raster GIS environment that has its own high-level computer language, which allows for the construction of iterative spatio-temporal environmental models. 
The Python wrapper of LISFLOOD enables the user to control the model inputs and outputs and the selection of the model modules. 
This approach combines the power, relative simplicity and maintainability of code written in the the PCRaster Environmental Modelling language and the flexibility of Python. 
LISFLOOD runs on any operating system for which Python and PCRaster are available.


[🔝](#top)
