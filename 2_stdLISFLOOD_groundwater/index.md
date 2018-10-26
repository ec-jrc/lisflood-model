## Groundwater

Groundwater storage and transport are modelled using two parallel linear reservoirs, similar to the approach used in the HBV-96 model (Lindström et al., 1997). The upper zone represents a quick runoff component, which includes fast groundwater and subsurface flow through macro-pores in the soil. The lower zone represents the slow groundwater component that generates the base flow. The outflow from the upper zone to the channel, $Q_{uz} [mm]$ equals:

$$
Q_{uz} = \frac{1}{T_{uz}} \cdot UZ \cdot \Delta t
$$

where $T_{uz}$ is a reservoir constant $[days]$ and $UZ$ is the amount of water that is stored in the upper zone $[mm]$. Similarly, the outflow from the lower zone is given by:

$$
Q_{lz} = \frac{1}{T_{lz}} \cdot LZ \cdot \Delta t
$$

Here, $T_{lz}$ is again a reservoir constant $[days]$, and $LZ$ is the amount of water that is stored in the lower zone $[mm]$. The values of both $T_{uz}$ and $T_{lz}$ are obtained by calibration. The upper zone also provides the inflow into the lower zone. For each time step, a fixed amount of water percolates from the upper to the lower zone:

$$
D_{uz,lz} = min (GW_{perc} \cdot \Delta t ,UZ)
$$

Here, $GW_{perc} \ [\frac{mm}{day}]$ is a user-defined value that can be used as a calibration constant. For many catchments it is quite reasonable to treat the lower groundwater zone as a system with a closed lower boundary (i.e. water is either stored, or added to the channel). However, in some cases the closed boundary assumption makes it impossible to obtain realistic simulations. Because of this, it is possible to percolate a fixed amount of water out of the lower zone, as a loss $D_{loss}$:

$$
D_{loss} = min(f_{loss} \cdot \Delta t,LZ)
$$

In the previous version of LISFLOOD $D_{loss}$, was calculated as a fixed fraction of $Q_{lz}$, but this leads to a high dependency of $D_{loss}$ from $GW_{perc}$ and $LZ$. For example if either $GW_{perc}$ or $LZ$ is quite low the parameter $D_{loss}$ turns out to be meaningless.

The loss fraction, $f_{loss}$ \[-\], equals 0 for a completely closed lower boundary. If $f_{loss}$ is set to 1, all outflow from the lower zone is treated as a loss. Water that flows out of the lower zone through $D_{loss}$ is quite literally 'lost' forever. Physically, the loss term could represent water that is either lost to deep groundwater systems (that do not necessarily follow catchment boundaries), or even groundwater extraction wells. When using the model, it is suggested to use $f_{loss}$ with some care; start with a value of zero, and only use any other value if it is impossible to get satisfactory results by adjusting the other calibration parameters. At each time step, the amounts of water in the upper and lower zone are updated for the in- and outgoing fluxes, i.e.:

$$
UZ_t = UZ_{t - 1} + D_{2,gw} - D_{uz,lz} - Q_{uz}
$$

$$
LZ_t = LZ_{t - 1} + D_{uz,lz} - Q_{lz} - D_{loss}
$$

Note that these equations are again valid for the permeable fraction of the pixel only: storage in the direct runoff fraction equals 0 for both $UZ$ and $LZ$.

[🔝](#top)
