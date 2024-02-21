## Transmission loss option


### Introduction

> **Note Ad de Roo**. The transmission loss option should not be used anymore and be gradually deleted from the code and the manual. Water abstractions are modelled in a seperated routine. Open water evaporation in rivers is dealt with by the 'water fraction'. Losses to deeper groundwater are dealt with differently now, using the `GroundwaterThresholdValue`.

The term 'transmission loss' originates from electronic or communication science and stands for: "the loss of power or voltage of a transmitted wave or current in passing along a transmission line or path or through a circuit device". In river systems, particularly in semi-arid and arid region, a similar effect can be observed: a loss of water along river channel, especially during low and average flow periods. The main causes for this loss might be:

* Evaporation of water inside the channel reach.
* Use of water for domestic, industrial or agricultural use.
* Infiltration to lower groundwater zones.

A simplified approach to model this effect has been chosen from [Rao and Maurer (1996)](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1752-1688.1996.tb03484.x), without the need of additional data and with only three parameters, making calibration relatively simple.

The transmission loss module is *optional*, and can be activated by adding the following line to the `lfoptions` element:

```xml
    <setoption name="TransLoss" choice="1" />
```



### Description of the transmission loss approach

The approach by [Rao and Maurer (1996)](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1752-1688.1996.tb03484.x) builds a one-parameter relationship between the seepage of a channel with the depth of flow. 
A power relationship is then utilized for the stage-discharge relationship, which is coupled with the seepage relationship.

$$
\begin{aligned}
Outflow &= (Inflow^{TransPower^{-1}} - TransSub)^{TransPower} \\
TransLoss &= Inflow - Outflow
\end{aligned}
$$

with: 
       <br> $Outflow$: discharge after deduction of transmission losses.
       <br> $Inflow$: original discharge before deducting transmission losses.
       <br> $TransPower$: parameter given by the rating curve.
       <br> $TransSub$: parameter to be calibrated.
       <br> $TransLoss$: transmission losses.

The main difference to the approach by [Rao and Maurer (1996)](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1752-1688.1996.tb03484.x) is that the $TransPower$ parameter is not calculated using a rating curve, but is estimated (calibrated) as the parameter $TransSub$. 

Transmission loss takes place where the channel gets bigger, with more influence of river-aquifer interaction and also with more river-floodplain interaction. Therefore, transmission losses only affect river pixels that exceed a minimum upstream area.

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
            Standard: 0.3 Range: 0.1 - 0.6                                        
            </comment>                                                          
        </textvar>                                                          
        <textvar name="TransPower1" value="2.0">                        
            <comment>                                                           
            Transmission loss function parameter                                  
            Standard: 2.0 Range 1.3 -- 2.0                                        
            </comment>                                                          
        </textvar>                                                          
        <textvar name="TransArea" value="5.0E+10">                      
            <comment>                                                           
            mimimum upstream area from which transmission losses are computed             
            Standard: 5.0E+10 Range: 1.0E+10 -- 1.0E+11                           
            </comment>                                                          
        </textvar>                                                          
	</group>                                                            
```

* `TransSub` is the linear transmission loss parameter. By default, it is set to 0.3, but it may range between 0.1 and 0.6 (higher values lead larger losses).

* `TransPower` is the power transmission loss parameter. By default, it is set to 2.0, but it may range between 1.3 and 2.0 (higher values lead larger losses).

* `TransArea` is the minimum upstream area (in m²) from which river pixels are affected by transmission losses. The default value is $5.0 \cdot 10^{10}$, but it may range between $1.0 \cdot 10^{10}$ and $1.0 \cdot 10^{11}$ (higher values lead to lower losses as fewer river pixels are affected).


2. Activate the transmission loss option by adding this line to the `lfoptions` element:

```xml
	<setoption name="TransLoss" choice="1" />
```

Now you are ready to run the model with the transmission loss option.


### Transmission loss output file

The transmission loss module can put out an additional time series (TSS file) as listed in the following table:

***Table:*** *Output of transmission loss routine -- Average upstream of gauges.*                                                           

| Time series    | Default name       | Description                      | Units |
| -------------- | ------------------ | -------------------------------- | ----- |
| TransLossAvUps | TransLossAvUps.tss | Transmission loss in the channel | $mm$  |

[🔝](#top)


