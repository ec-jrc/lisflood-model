## Transmission loss option


### Introduction

Transmission losses are the loss in the flow volume of a river as water moves downstream ([Walters, 1990](https://ascelibrary.org/doi/10.1061/%28ASCE%290733-9429%281990%29116%3A1%28129%29)). 
Transmission losses can be caused by: evaporation, transpiration by macrophytes and riparian vegetation, as well as groundwater recharge ([McMahon and Nathan, 2021](https://wires.onlinelibrary.wiley.com/doi/10.1002/wat2.1527); [Di Ciacca et al., 2023](https://hess.copernicus.org/articles/27/703/2023/)). 
Losses from rivers to deep groudwater have been observed in arid areas, but not only (e.g. [Jasachko et al, 2021](https://www.nature.com/articles/s41586-021-03311-x), [Uchôa et al, 2024](https://www.nature.com/articles/s41467-024-54370-3)).

### Description of the transmission loss approach

OS LISFLOOD code implements the simplified approach proposed by [Rao and Maurer (1996)](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1752-1688.1996.tb03484.x). According to Rao and Muller, in the absence of water diversions, recharge of stream flow to groundwater and consumptive used by phreatophites are the most important factors contributing to the loss of flow from a stream reach. Their approach does not segregate the individual losses (e.g. deep percolation, use by phreatophites, evaporation), but provides an estimation of the combined, total loss. Stream bed infiltration trasnfers water from the surface system to the groundwater system. Ultimately, the infiltrated water will be either comsumed by phreatophites (evapotranspiration), lost to deeep acquifers, or pumped from the system, or it will return to the stream. Intensive groundwater pumping from wells hydraulically connected to the stream can increase or trigger transimission losses. 
The amount of water infiltrated from the channel to deep groundwater is expressed as a function of the river hydraulic conductivity (Harr, M. E., 1962. Groundwater and Seepage. McGraw-Hill Compa
ny) and the channel water depth (power stage-discharge rlationship).
The derived equation is reported below:

$$
\begin{aligned}
Outflow &= (IncomingFlow^{TransPower^{-1}} - TransSub)^{TransPower} \\
TransLoss &= IncomingFlow - Outflow
\end{aligned}
$$

with: 
       <br> $Outflow$: discharge after deduction of transmission losses.
       <br> $IncomingFlow$: original discharge before deducting transmission losses.
       <br> $TransPower$: parameter given by the rating curve.
       <br> $TransSub$: parameter to be calibrated.
       <br> $TransLoss$: transmission losses.

$TransSub$ is normally used as calibration parameter, while $TransPower$ is kept constant.

In some cases, transmission loss can be more relevant where the channel gets bigger, with more influence of river-aquifer interaction. OS LISFLOOD allows limiting the computation to areas exceeding a user defined upstream area threhold.

Finally, it is noted that in the current immplementation, the computed water volume is removed from the hydrological cycle (no return flow).

### Using transmission loss 

No additional maps or tables are needed. Using the transmission loss option involves two steps:

1. In the `lfuser` element, replace the file paths/names by those you want to use:

```xml
	<group>                                                             
        <comment>                                                           
        **************************************************************               
        TRANSMISSION LOSS PARAMETERS                                          
        **************************************************************               
        Suggested parameterisation strategy:                                  
        Use TransSub as calibration constant leave all other parameters at\   
        default values                                                        
        </comment>                                                          
        <textvar name="TransSub" value="0.3">                           
            <comment>                                                           
            Transmission loss function parameter                                  
            Standard: 0.0 Range: 0.0 - 0.15                                        
            </comment>                                                          
        </textvar>                                                          
        <textvar name="TransPower1" value="2.0">                        
            <comment>                                                           
            Transmission loss function parameter                                                                      
            </comment>                                                          
        </textvar>                                                          
        <textvar name="TransArea" value="0.0">                      
            <comment>                                                           
            mimimum upstream area from which transmission losses are computed             
            Standard: 0.0                     
            </comment>                                                          
        </textvar>                                                          
	</group>                                                            
```

* `TransSub` is the transmission loss parameter. By default, it is set to 0.0 (no transmission losses), but it may range between 0.0 and 0.15 (higher values lead larger losses; the maximum boundary was identified experimentally by OS LISFLOOD developers).

* `TransPower` is the power transmission loss parameter. By default, it is set to 2.0, but it may range between 1.3 and 2.0 (higher values lead larger losses).

* `TransArea` is the minimum upstream area (in m²) from which river pixels are affected by transmission losses. The default value is 0.0, higher values lead to lower losses as fewer river pixels are affected.


2. Activate the transmission loss option by adding this line to the `lfoptions` element:

```xml
	<setoption name="TransLoss" choice="1" />
```


### Transmission loss output file

The transmission loss module can put out an additional time series (TSS file) as listed in the following table:

***Table:*** *Output of transmission loss routine -- Average upstream of gauges.*                                                           

| Time series    | Default name       | Description                      | Units |
| -------------- | ------------------ | -------------------------------- | ----- |
| TransLossAvUps | TransLossAvUps.tss | Transmission loss in the channel | $mm$  |

[🔝](#top)


