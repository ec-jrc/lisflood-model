# Simulation and reporting of soil moisture as pF values

## Introduction

LISFLOOD offers the possibility to calculate pF values from the moisture content of both soil layers. The calculation of pF values is *optional*, and it can be activated by adding the following line to the 'lfoptions' element in the LISFLOOD settings file (<span style="color:red"> add link </span>):

```xml
	<setoption name="simulatePF" choice="1" /> 
```



Using this option does *not* influence the actual model results in any way, and it is included only to allow the model user to report pF time series or maps. The actual *reporting* of the computed pF values (as time series or maps) can be activated using separate options (which are discussed further down).



## Calculation of pF

A soil's $pF$ is calculated as the logarithm of the capillary suction head, *h*:

$$
pF = \log_{10}(h)
$$

with $h$ in \[cm\] (positive upwards). Values of pF are typically within the range 1.0 (very wet) to 5.0 (very dry). The relationship between soil moisture status and capillary suction head is described by the Van Genuchten equation (here again re-written in terms of mm water slice, instead of volume fractions):

$$
h = \frac{1}{\alpha}[(\frac{w_s - w_r}{w - w_r} )^{{1/m} - 1}]^{1/n}
$$

where *h* is the suction head $[cm]$, and $w$, $w_r$ and $w_s$ are the actual, residual and maximum amounts of moisture in the soil respectively (all in $mm$). Parameter $α$ is related to soil texture. Parameters $m$ and $n$ are calculated from the pore-size index, $λ$ (which is related to soil texture as well):

$$
m = \frac{\lambda }{\lambda + 1}
$$

$$
n = \lambda + 1
$$

If the soil contains no moisture at all (*w*=0), *h* is set to a fixed (arbitrary) value of $1∙10^7$ cm.



## Reporting of pF

pF can be reported as time series (at the locations defined on the "sites" map or as average values upstream each gauge location), or as maps. To generate time series at the "sites", add the following line to the 'lfoptions' element of your settings file:

```xml
	<setoption name=\"repPFTs\" choice=\"1\" />
```

For maps, use the following lines instead (for the upper and lower soil layer, respectively):

```xml
	<setoption name=\"repPF1Maps\" choice=\"1\" />

	<setoption name=\"repPF2Maps\" choice=\"1\" />

```

In either case, the reporting options should be used *in addition* to the 'simulatePF' option. If you do not include the 'simulatePF' option, there will be nothing to report and LISFLOOD will exit with an error message.



## Preparation of settings file

The naming of the reported time series and maps is defined in the settings file. The two Tables at the end of this page list the settings variables default output names. If you are using a default LISFLOOD settings template, all file definitions are already defined in the 'lfbinding' element.

Time series:

```xml
	<comment>                                                        
	PF TIMESERIES, VALUES AT SITES                                     
	</comment>                                                       
	<textvar name="PF1TS" value="$(PathOut)/pFTop.tss">         
	<comment>                                                        
	Reported pF upper soil layer [-]                                 
	</comment>                                                       
	</textvar>                                                       
	<textvar name="PF2TS" value="$(PathOut)/pFSub.tss">         
	<comment>                                                        
	Reported pF lower soil layer [-]                                 
	</comment>                                                       
	</textvar>                                                       
	<comment>                                                        
	PF TIMESERIES, AVERAGE VALUES UPSTREAM OF GAUGES                   
	</comment>                                                       
	<textvar name="PF1AvUpsTS" value="$(PathOut)/pFTopUps.tss"> 
	<comment>                                                        
	Reported pF upper soil layer [-]                                 
	</comment>                                                       
	</textvar>                                                       
	<textvar name="PF2AvUpsTS" value="$(PathOut)/pFSubUps.tss"> 
	<comment>                                                        
	Reported pF lower soil layer [-]                                 
	</comment>                                                       
	</textvar>                                                       
```

Map stacks:

```xml
	<comment>                                              
	PF MAPS                                                  
	</comment>                                             
	<textvar name="PF1Maps" value="$(PathOut)/pftop"> 
	<comment>                                              
	Reported pF upper soil layer [-]                       
	</comment>                                             
	</textvar>                                             
	<textvar name="PF2Maps" value="$(PathOut)/pfsub"> 
	<comment>                                              
	Reported pF lower soil layer [-]                       
	</comment>                                             
	</textvar>                                             
```

***Table:*** *pF map output*                                             

| Description    | Option name | Settings variable | Default prefix |
| -------------- | ----------- | ----------------- | -------------- |
| pF upper layer | repPF1Maps  | PF1Maps           | pftop          |
| pF lower layer | repPF2Maps  | PF2Maps           | pfsub          |

  

***Table:***  *pF timeseries output*                                                 

| Description                                                | Settings variable | Default name |
| ---------------------------------------------------------- | ----------------- | ------------ |
| **pF at sites (option repPFSites)**                        |                   |              |
| pF upper layer                                             | PF1TS             | pFTop.tss    |
| pF lower layer                                             | PF2TS             | pFSub.tss    |
| **pF, average upstream of gauges (option repPFUpsGauges)** |                   |              |
| pF upper layer                                             | PF1AvUpsTS        | pFTopUps.tss |
| pF lower layer                                             | PF2AvUpsTS        | pFSubUps.tss |

[🔝](#top)

