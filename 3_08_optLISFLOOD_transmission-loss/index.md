## Transmission loss option


### Introduction

Note AdR: The Transition loss option should not be used anymore and gradually deleted from the code and the manual. Water abstractions are dealt within a seperated routine. Open water evaporation in rivers is dealt with by the 'water fraction'. Losses to deeper groundwater are dealt with differently now, using the GroundwaterThresholdValue.

The term 'transmission loss' originate from electronic or communication science and stands for: "The loss of power or voltage of a transmitted wave or current in passing along a transmission line or path or through a circuit device". In river systems, particularly in semi-arid and arid region a similar effect can be observed: The loss of water along river channel especially during low and average flow periods. Main reasons for this loss might be:

-   Evaporation of water inside the channel reach

-   Use of water for domestic, industrial or agricultural use

-   Infiltration to lower groundwater zones

A simplified approach to model this effect has been chosen from Rao and Maurer (1996), without the need of additional data and with only three parameters, making calibration relatively simple.

Transmission loss is *optional*, and can be activated by adding the following line to the 'lfoptions' element:

```xml
	<setoption name="TransLoss" choice="1" />
```



### Description of the transmission loss approach

The approach by Rao and Maurer 1996 builds a one-parameter relationship between the seepage of a channel with the depth of flow. 
A power relationship is then utilized for the stage-discharge relationship, which is coupled with the seepage relationship.


$$
Outflow = xxx
$$

with: 
   <br> $Outflow$:		discharge at the outflow
   <br> $Inflow$:		discharge at the Inflow (upstream)
   <br> $TransPower$: 	Parameter given by the rating curve
   <br> $TransSub$:		Parameter which is to calibrate

As a main difference to the Rao and Maurer 1996, the $TransPower$ parameter is not calculated by using a rating curve but is estimated (calibrated) as the parameter $TransSub$. Transmission loss takes place where the channel gets bigger with more influence of river-aquifer interaction and also with more river-floodplain interaction. Therefore a minimum upstream area is defined where transmission loss starts to get important.



### Using transmission loss 

No additional maps or tables are needed. Using the transmission loss option involves two steps:

1)  In the 'lfuser' element (replace the file paths/names by the ones you want to use):

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
	downstream area taking into account for transmission loss             
	Standard: 5.0E+10 Range: 1.0E+10 -- 1.0E+11                           
	</comment>                                                          
	</textvar>                                                          
	</group>                                                            
```

**TransSub** is the linear transmission loss parameter. Standard is set to 0.3 and the range should be between 0.1 -- 0.6 (higher values lead to more loss) 

**TransPower** is the power transmission loss parameter. Standard is set to 2.0 and the range should be between 1.3 and 2.0 (higher values lead to more loss) 

**TransArea** is the downstream area which is taken into account for transmission loss. Standard is $5.0E+10 km^2$ and range should be $1.0E+10 km^2$ to $1.0E+11 km^2$ (higher values lead to less loss as less area is taken into account)



2)  Activate the transmission loss option

Add the following line to the 'lfoptions' element:

```xml
	<setoption name="TransLoss" choice="1" />
```

Now you are ready to run the model with the transmission loss option



### Transmission loss output file

The transmission option can produce an additional time series as listed in the following table:

***Table:*** *Output of transmission loss routine -- Average upstream of gauges.*                                                           

| Time series    | Default name       | Description                      | Units |
| -------------- | ------------------ | -------------------------------- | ----- |
| TransLossAvUps | TransLossAvUps.tss | Transmission loss in the channel | $mm$  |

[🔝](#top)


