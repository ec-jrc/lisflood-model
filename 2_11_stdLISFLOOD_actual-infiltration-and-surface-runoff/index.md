## Actual infiltration and surface runoff

The actual infiltration $INF_{act} \  [mm]$ is now calculated as:

$$
INF_{act} = min (INF_{pot},W_{av} - D_{pref,gw})
$$

Finally, the surface runoff $R_s \ [mm]$ is calculated as:

$$
R_s = R_d + (1 - f_{dr}) \cdot (W_{av} - D_{pref,gw} - INF_{act})
$$

where $R_d$ is the direct runoff (generated in the pixel's 'direct runoff fraction'). If the soil is frozen (*F* \> critical threshold) no infiltration takes place. The amount of moisture in the upper soil layer is updated after the infiltration calculations:

$$
w_1 = w_1 + INF_{act}
$$
