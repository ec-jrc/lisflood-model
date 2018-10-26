## Infiltration capacity

The infiltration capacity of the soil is estimated using the widely-used Xinanjiang (also known as VIC/ARNO) model (e.g. Zhao & Lui, 1995; Todini, 1996). This approach assumes that the fraction of a grid cell that is contributing to surface runoff (read: saturated) is related to the total amount of soil moisture, and that this relationship can be described through a non-linear distribution function. For any grid cell, if $w_1$ is the total moisture storage in the upper soil layer and $w_s1$ is the maximum storage, the corresponding saturated fraction $A_s$ is approximated by the following distribution function:

$$
A_s = 1 - (1 - \frac{w_1}{w_{s1}})^b
$$

where $w_{s1}$ and $w_1$ are the maximum and actual amounts of moisture in the upper soil layer, respectively $[mm]$, and $b$ is an empirical shape parameter. In the LISFLOOD implementation of the Xinanjiang model, $A_s$ is defined as a fraction of the permeable fraction of each pixel (i.e. as a fraction of $(1-d_{rf})$). The infiltration capacity $INF_{pot} [mm]$ is a function of $w_s$ and $A_s$:

$$
INF_{pot}= \frac{w_{s1}}{b + 1} - \frac{w_{s1}}{b +1} \cdot [1 - (1 - A_s)^{\frac{b + 1}{b}}]
$$

Note that the shape parameter *b* is related to the heterogeneity within each grid cell. For a totally homogeneous grid cell *b* approaches zero, which reduces the above equations to a simple 'overflowing bucket' model. Before any water is draining from the soil to the groundwater zone the soil has to be completely filled up. See also red line in the Figure below: e.g. a soil of 60% soil moisture has 40% potential
infiltration capacity. A $b$ value of 1.0 (see black line) is comparable to a leaking bucket : e.g. a soil of 60% soil moisture has only 10% potential infiltration capacity while 30% is draining directly to groundwater. 

![](../media/image27.png)

***Figure:*** *Soil moisture and potential infiltration capacity relation.*

Increasing $b$ even further than 1 is comparable to a sieve (see figure below). Most of the water is going directly to groundwater and the potential infiltration capacity is going toward 0.

![](../media/image28.png)

***Figure:*** *Analogy picture of increasing Xinanjiang empirical shape parameter* $b$.



