## Interception

Interception is estimated using the following storage-based equation (Aston, 1978, Merriam, 1960):

$$
Int = S_{max} \cdot [1 - e ^{\frac{- k \cdot R \cdot \Delta t} {S_{max}}}]
$$

where $Int [mm]$ is the interception per time step, $S_{max} [mm]$ is the maximum interception, $R$ is the rainfall intensity $[\frac{mm}{day}]$ and the factor $k$ accounts for the density of the vegetation. 

$S_{max}$ is calculated using an empirical equation (Von Hoyningen-Huene, 1981):

$$
\begin{cases} S_{max} = 0.935 + 0.498 \cdot LAI - 0.00575 \cdot LAI^2 &[LAI \gt 0.1]\\ S_{max } = 0 & [LAI \le 0.1]\end{cases}
$$

where $LAI$ is the average Leaf Area Index $[\frac{m^2}{ m^{2}}]$ of each model element (pixel). It is noted that, according to the empirical formulation above, $S_{max}$ increases as $LAI$ values increase from $0.1$ to $43.3$ $[\frac{m^2}{ m^{2}}]$. When $LAI$ is $43.3$ $[\frac{m^2}{ m^{2}}]$, $S_{max}$ is $11.718$ $[mm]$. The latter value is assumed as the upper boundary value of $S_{max}$ (it is also recommended to carefully verify large $LAI$ values).

$k$ is estimated as:

$$
k = 0.046 \cdot LAI
$$


Clearly, at each computational time step, $Int$ cannot exceed the rainfall amount. Moreover, the value of $Int$ can never exceed the interception storage capacity, which is defined as the difference between $S_{max}$ and the accumulated amount of water that is stored as interception, $Int_{cum}$. 
