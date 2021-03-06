## Water available for infiltration and direct runoff

In the permeable fraction of each pixel $(1- f_{dr})$, the **amount of water** that is **available for infiltration**, $W_{av}$ $[mm]$ equals (Supit *et al.*,1994):

$$
W_{av} = R \cdot \Delta t + M + D_{int} - Int
$$

where:
<br> - $R$: 		Rainfall $[\frac{mm}{day}]$,
<br> - $M$: 	Snow melt $[mm]$,
<br> - $D_{int}$: 	Leaf drainage $[mm]$,
<br> - $Int$: 	Interception $[mm]$, and
<br> - $\Delta t$: 	time step $[days]$.

Since no infiltration can take place in each pixel's 'direct runoff fraction', **direct runoff** is calculated as:

$$

R_d = f_{dr} \cdot (R \cdot \Delta t + M - IntercSealed) + WaterFraction \cdot (R \cdot \Delta t + M - EW0)
$$

where $R_d$ is in $mm$ per time step and $IntercSealed$ is the water in $mm$ retained by the depressions of the impervious surfaces and not immediately available to generate direct runoff. 
More specifically, $IntercSealed$ is equal to the total of raifall and snow melt until all the depressions have been filled, that is until the $AvailableStorageSealed$ is larger than 0. The computation is shown by the following equations:


$$
IntercSealed = R \cdot \Delta t + M
$$ 

when 

$$
AvailableStorageSealed= SMAXsealed - StorageSealed > 0
$$

where $SMAXsealed$ is the maximum depression storage in $mm$ (provided as input data), and $StorageSealed$ is the volume already filled by water in $mm$. The computation of the latter accounts for the volume already used at the initial time step ($StorageSealedInit$, provided as input data) and the water volume loss due to evaporation:

$$
StorageSealed = StorageSealedInit + IntercSealed - EW0
$$

Direct runoff $R_d$ is added to [surface runoff](https://ec-jrc.github.io/lisflood-model/2_14_stdLISFLOOD_surface-runnoff-routing/).  

Note here that $W_{av}$ is valid for the permeable fraction only, whereas $R_d$ is computed for the full pixel (permeable + direct runoff areas).

