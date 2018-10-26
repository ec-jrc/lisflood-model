## Routing of surface runoff to channel

**Surface runoff is routed to the nearest downstream channel using a 4-point implicit finite-difference  solution of the kinematic wave equations** (Chow, 1988). The basic equations used are the equations of
continuity and momentum. The continuity equation is:

$$
\frac{\partial {Q_{sr}}}{\partial x} + \frac{\partial{A_{sr}}}{\partial t} = {q_{sr}}
$$

where $Q_{sr}$ is the surface runoff $[\frac{m^3}{ s}]$, $A_{sr}$  is the cross-sectional area of the flow $[m^2]$ and $q_{sr}$ is the amount of lateral inflow per unit flow length $[\frac{m^2}{s}]$. The momentum equation is defined as:

$$
\rho \cdot g \cdot A_{sr} \cdot (S_0 - S_f) = 0
$$

where $\rho$ is the density of the flow $[\frac{kg}{m^3}]$, $g$ is the gravity acceleration $[\frac{m}{s^2}]$, $S_0$ is the topographical gradient and $S_f$ is the friction gradient. From the momentum equation it follows that $S_0~= S_f$, which means that for the kinematic wave equations it is assumed that the water surface is parallel to the topographical surface. The continuity equation can also be written in the following finite-difference form (please note that for the sake of readability the 'sr' subscripts are omitted here from *Q*, *A* and *q*):

$$
\frac{Q_{i + 1}^{j + 1} - Q_i^{j + 1}}{\Delta x} +\frac{A_{i + 1}^{j + 1} - A_{i + 1}^j}{\Delta t} =\frac{q_{i + 1}^{j + 1} - q_{i + 1}^j}{2}
$$

where *j* is a time index and *i* a space index (such that *i=1* for the most upstream cell, *i=2* for its downstream neighbor, etcetera). The momentum equation can also be expressed as (Chow et al., 1988):

$$
A_{sr} = \alpha_ {k,sr} \cdot Q_{sr}^{\beta _k}
$$

Substituting the right-hand side of this expression in the finite-difference form of the continuity equation gives a nonlinear implicit finite-difference solution of the kinematic wave:

$$
\frac{\Delta t}{\Delta x}\cdot Q_{i + 1}^{j + 1} \alpha _k \cdot (Q_{i + 1}^{j + 1})^{\beta _k} = \frac{\Delta t}{\Delta x} \cdot Q_i^{j + 1} \alpha _k \cdot (Q_{i + 1}^j)^{\beta_k}\Delta t \cdot (\frac{q_{i + 1}^{j + 1} + q_{i + 1}^j}{2})
$$

If $α_{k,sr}$ and $β_k$ are known, this non-linear equation can be solved for each pixel and during each time step using an iterative procedure. This numerical solution scheme is available as a built-in function in the PCRaster software. The coefficients $α_{k,sr}$ and $β_k$ are calculated by substituting Manning's equation in the right-hand side of Equation:

$$
A_{sr} = (\frac{n \cdot P_{sr}^{2/3}}{\sqrt{S_0}}) \cdot Q_{sr}^{3/5}
$$

where *n* is Manning's roughness coefficient and $P_{sr}$ is the wetted perimeter of a cross-section of the surface flow. Substituting the right-hand side of this equation for $A_{sr}$ in equation gives:

$$
\alpha _{k,sr} = (\frac{n \cdot P_{sr}^{2/3}}{\sqrt{S_0}})^{0.6} ; \beta_k=0.6
$$

At present, LISFLOOD uses values for $α_{k,sr}$ which are based on a static (reference) flow depth, and a flow width that equals the pixel size, $\Delta x$. For each time step, all runoff that is generated ($R_s$) is added as side-flow ($q_{sr}$). For each flowpath, the routing stops at the first downstream pixel that is part of the channel network. In other words, the routine only routes the surface runoff *to* the nearest channel; no runoff *through* the channel network is simulated at this stage (runoff- and channel routing are completely separated). 

[🔝](#top)
