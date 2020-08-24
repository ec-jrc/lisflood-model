## Actual infiltration and surface runoff

The actual infiltration $INF_{act} \  [mm]$ is now calculated as:

$$
INF_{act} = min (INF_{pot}, W_{av} - D_{pref,gw})
$$

where $INF_{pot}$ is the potential infiltration capacity of the layers 1a and 1b; $W_{av}$ is the available water for infiltartion; $D_{pref,gw})$ is the preferential bypass flow. All these quantities are expresses in $[mm]$.

$INF_{act}$ is added to the superficial and upper soil layers (1a and 1b, respectively). First, the actual infiltration is added to the superficial soil layer 1a, until reaching its maximum storage capacity ($w_{s,1a}$). The remainder amount of water is added to the upper soil layer 1b. This distribution of 
$INF_{act}$ within the layers 1a and 1b is necessary because the infiltration potential is computed considering both the layers. The amount of moisture in the superficial and upper soil layers is updated as follows:
<br>$w_{1a} = \min ( w_{s,1a} , w_{1a} + INF_{act} )$
<br>$w_{1b} = w_{1b} + \max ( (w_{1a} + INF_{act}) - w_{s,1a} , 0 )$
<br>$w_1 = w_{1a} + w_{1b}$

Finally, the surface runoff $R_s \ [mm]$ is calculated as:

$$
R_s = R_d + (1 - f_{dr}) \cdot (W_{av} - D_{pref,gw} - INF_{act})
$$

where $R_d$ is the direct runoff (generated in the pixel's 'direct runoff fraction'). If the soil is frozen (*F* \> critical threshold) no infiltration takes place. 


