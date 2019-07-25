## About this hydrological model documentation

This Github repository contains the most up-to-date and complete technical documentation of the LISFLOOD model. 
This includes the concepts and model equations of all the standard LISFLOOD processes, and all the optional modules.

The objective of this model documentation is to provide the interested user with a transparent picture of the hydrological model in order to understand what's behind it.

This document is **not a LISFLOOD user guide!** 

A LISFLOOD user guide can be found at the dedicated [Github Pages](https://ec-jrc.github.io/lisflood-code/) from lisflood-code repository. 
It is a step-by-step guide on what you need to do and know throughout the whole processing chain, from defining the system requirements to generating the LISFLOOD output. 

<<<<<<< HEAD
### Use cases / Test Basins
In order to apply this knowledge into practice we have created two use cases
=======
In order to apply this knowledge into practice we have created two use cases, one in [Italy (Po basin)](https://github.com/ec-jrc/lisflood-usecases/blob/master/README.md#usecase2) and one in [Canada (Fraser basin)](https://github.com/ec-jrc/lisflood-usecases/blob/master/README.md#usecase1), which should help you set up and test the model on your PC. Once you have mastered this step, you can check that the model has been installed and used by you correctly.
>>>>>>> ea88d2947accab99c8c907b9a3028a9073119d8d

1. The Po river basin, in Italy
2. The Fraser river basin, in Canada

which should help you set up and test the model on your machine. 
For details and instructions on how to execute tests, please visit the [LISFLOOD usecases repository](https://github.com/ec-jrc/lisflood-usecases). 

Once you are able to execute simulation for those use cases, you can confirm that the LISFLOOD model has been installed and configured correctly.

In order to help you prepare the set-up of your own catchment we have created another Github repository [lisflood-utilities](https://github.com/ec-jrc/lisflood-utilities) 
that contains all kinds of useful tools. Each tool is documented with an explanation of how to use it.

Lastly, we also share two other tools: 

1. [LISVAP](https://github.com/ec-jrc/lisflood-lisvap/), for the calculation of the potential evapotranspiration which is a required input parameter for LISFLOOD and 
2. a [calibration tool](https://github.com/ec-jrc/lisflood-calibration/) allows to calibrate the catchments which were set up with LISFLOOD using observed discharge data.


[🔝](#top)
