## Frost index soil

When the soil surface is frozen, this affects the hydrological processes occurring near the soil surface. To estimate whether the soil surface is frozen or not, a frost index *F* is calculated. The equation is based on
Molnau & Bissell (1983, cited in Maidment 1993), and adjusted for variable time steps. The **rate at which the frost index changes** is given by:

$$
\frac{dF}{dt} = - (1 - {A_f})\cdot F - {T_{av}} \cdot {e^{ - 0.04 \cdot K \cdot {d_s}/w \cdot {e_s}}}
$$

$\frac{dF}{dt}$ is expressed in $[\frac{\circ C}{day} \cdot \frac{1}{day}]$.  $A_f$ is a decay coefficient $[\frac{1}{day}]$, $K$ is a a snow depth reduction coefficient $[\frac{1}{cm}]$, $d_s$ is the (pixel-average) depth of the snow cover (expressed as $mm$ equivalent water depth), and $w \cdot e_s$ is a parameter called snow water equivalent, which is the equivalent water depth water of a snow cover (Maidment, 1993). In LISFLOOD, $A_f$ and $K$ are set to 0.97 and 0.57 $[\frac{1}{cm}]$ respectively, and $w \cdot e_s$ is taken as 0.1, assuming an average snow density of 100 $\frac{kg}{m^3}$ (Maidment, 1993). **The soil is considered frozen when the frost index rises above a critical threshold of 56**. For each time step the value of $F$ $[\frac{\circ C}{ day}]$ is updated as:

$$
F(t) = F(t - 1) + \frac{dF}{dt}\Delta t
$$

>  Note: $F$ is not allowed to become less than 0.

When the frost index rises above a threshold of 56, every soil process is frozen and transpiration, evaporation, infiltration and water flows between the different soil layers and to the upper groundwater layer are set to zero.
Any rainfall is bypassing the soil and transformed into surface runoff till the frost index is equal or less than 56.
