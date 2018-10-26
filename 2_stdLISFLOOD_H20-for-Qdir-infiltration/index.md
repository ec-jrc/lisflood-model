## Water available for infiltration and direct runoff

In the permeable fraction of each pixel $(1- f_{dr})$, the amount of water that is available for infiltration, $W_{av}$ $[mm]$ equals (Supit *et al.*,1994):

$$
W_{av} = R \cdot \Delta t + M + D_{int} - Int
$$

where:

  $R$: 		Rainfall $[\frac{mm}{day}]$
  $M$: 	Snow melt $[mm]$
  $D_{int}$: 	Leaf drainage $[mm]$
  $Int$: 	Interception $[mm]$
  $\Delta t$: 	time step $[days]$

Since no infiltration can take place in each pixel's 'direct runoff fraction', direct runoff is calculated as:

$$
R_d = f_{dr} \cdot W_{av}
$$

where $R_d$ is in $mm$ per time step. Note here that $W_{av}$ is valid for the permeable fraction only, whereas $R_d$ is valid for the direct runoff fraction.

