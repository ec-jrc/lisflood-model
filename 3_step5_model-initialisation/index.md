## Step 6: Running the model: Initialisation of LISFLOOD

Just as any other hydrological model, LISFLOOD needs to have some estimate of the initial state (i.e. amount of water stored) of its internal state variables. Two situations can occur:

1.  The initial state of all state variables is known (for example, the "end maps" of a daily water balance run are used to define the initial conditions of an hourly flood-event run)

2.  The initial state of all state variables is unknown

The second situation is the most common one, and this chapter presents an in-depth look at the initialisation of LISFLOOD. First the effect of the model's initial state on the results of a simulation is demonstrated using a simple example. Then, LISFLOOD's various initialisation options are discussed. Most of this chapter focuses on the initialisation of the lower groundwater zone, as this is the model storage component that is the most difficult to in initialise.

An example
----------

To better understand the impact of the initial model state on simulation  results, let's start with a simple example. The Figure below shows 3 LISFLOOD simulations of soil moisture for the upper soil layer. In the first simulation, it was assumed that the soil is initially completely saturated. In the second one, the soil was assumed to be completely dry (i.e. at residual moisture content). Finally, a third simulation was done where the initial soil moisture content was assumed to be in between these two extremes.

  ![](https://ec-jrc.github.io/lisflood_manual/media/image37.png){width="5.625in"
  height="3.6979166666666665in"}

  ***Figure 7.1** Simulation of soil moisture in upper soil layer for a soil that is initially at saturation (s), at residual moisture content (r) and in between (\[s+r\]/2) *

What is clear from the Figure is that the initial amount of moisture in the soil only has a marked effect on the start of each simulation; after a couple of months the three curves converge. In other words, the  "memory" of the upper soil layer only goes back a couple of months (or, more precisely, for time lags of more than about 8 months the autocorrelation in time is negligible).

In theory, this behaviour provides a convenient and simple way to initialise a model such as LISFLOOD. Suppose we want to do a simulation of the year 1995. We obviously don't know the state of the soil at the   beginning of that year. However, we can get around this by starting the simulation a bit earlier than 1995, say one year. In that case we use the year 1994 as a *warm-up* period, assuming that by the start of 1995  the influence of the initial conditions (i.e. 1-1-1994) is negligible. The very same technique can be applied to initialise LISFLOOD's other state variables, such as the amounts of water in the lower soil layer, the upper groundwater zone, the lower groundwater zone, and in the channel.

### Option1: Cold start (initial conditions unknown)

When setting up a model run that includes a warm-up period, most of the internal state variables can be simply set to 0 at the start of the run. This applies to the initial amount of water on the soil surface (*WaterDepthInitValue*), snow cover (*SnowCoverInitValue*), frost index (*FrostIndexInitValue*), interception storage (*CumIntInitValue*), and storage in the upper groundwater zone (*UZInitValue*). The initial value of the 'days since last rainfall event' (*DSLRInitValue*) is typically set to 1.

For the remaining state variables, initialisation is somewhat less straightforward. The amount of water in the channel (defined by *TotalCrossSectionAreaInitValue*) is highly spatially variable (and limited by the channel geometry). The amount of water that can be stored in the upper and lower soil layers (*ThetaInit1Value*, *ThetaInit2Value*) is limited by the soil's porosity. The lower groundwater zone poses special problems because of its overall slow response (discussed in a separate section below). Because of this, LISFLOOD provides the possibility to initialise these variables internally, and these special initialisation methods can be activated by setting the initial values of each of these variables to a special 'bogus' value of *-9999*. The following Tablesummarises these special initialisation methods:

***Table:*** *LISFLOOD special initialisation methods*$^1$ 

| **Variable**          | **Description**       | **Initialisation method**     |
|-------------------------------|-------------------------------|-------------------------------|
| ThetaInit1Value / <br> ThetaForestInit2Value    | initial soil moisture content<br> upper soil layer (V/V)| set to soil moisture content <br> at field capacity |
| ThetaInit2Value / <br> ThetaForestInit2Value    | initial soil moisture content <br> lower soil layer (V/V) | set to soil moisture content <br> at field capacity |
| LZInitValue / <br> LZForestInitValue       | initial water in lower <br>  groundwater zone (mm)    | set to steady-state storage |
| TotalCrossSectionArea <br> InitValue | initial cross-sectional area <br> of water in channels              | set to half of bankfull depth      |
| PrevDischarge         | Initial discharge     | set to half of bankfull depth       |

$^1$ These special initialisation methods are activated by setting the value of each respective variable to a 'bogus' value of "-9999"*     

Note that the "-9999" 'bogus' value can *only* be used with the variables in Table x.x; for all other variables they will produce nonsense results! The initialisation of the lower groundwater zone will be discussed in the next sections.

#### Initialisation of the lower groundwater zone

```R
# should this section be moved into the hydorological model documentation??
```

Even though the use of a sufficiently long warm-up period usually results in a correct initialisation, a complicating factor is that the time needed to initialise any storage component of the model is dependent on the average residence time of the water in it. For example, the moisture content of the upper soil layer tends to respond almost instantly to LISFLOOD's meteorological forcing variables (precipitation, evapo(transpi)ration). As a result, relatively short warm-up periods are sufficient to initialise this storage component. At the other extreme, the response of the lower groundwater zone is generally very slow (especially for large values of $T_{lz}$). Consequently, to avoid unrealistic trends in the simulations, very long warm-up periods may be needed. The Figure below shows a typical example for an 8-year simulation, in
which a decreasing trend in the lower groundwater zone is visible throughout the whole simulation period. Because the amount of water in the lower zone is directly proportional to the baseflow in the channel, this will obviously lead to an unrealistic long-term simulation of baseflow. Assuming the long-term climatic input is more or less constant, the baseflow (and thus the storage in the lower zone) should be free of any long-term trends (although some seasonal variation is normal). In order to avoid the need for excessive warm-up periods, LISFLOOD is capable of calculating a 'steady-state' storage amount for the lower groundwater zone. This *steady state* storage is very effective for reducing the lower zone's warm-up time. In the next sections the concept of *steady state* is first explained, and it is shown how it can be used to speed up the initialisation of a LISFLOOD run.

![](https://ec-jrc.github.io/lisflood_manual/media/image38.png){width="5.989583333333333in"
height="3.7083333333333335in"}

***Figure:*** *8-year simulation of lower zone storage. Note how the influence of the initial storage persists throughout the simulation period.*

#### Lower groundwater zone: steady state storage

The response of the lower groundwater zone is defined by two simple equations. First, we have the inflow into the lower zone, which occurs at the following rate \[mm day^-1^\]:

$$
{D_{uz,lz}} = \min (G{W_{perc}},\;\frac{UZ}{\Delta t})\
$$
Here, *GW~perc~* $[\frac{mm}{day}]$ is a user-defined value (calibration constant), and *UZ* is the amount of water available in the upper groundwater zone $[mm]$. The rate of flow out of the lower zone  $[\frac{mm}{day}]$ equals:

$$
{Q_{lz}} = \frac{1}{{{{\rm{T}}_{{\rm{lz}}}}}} \cdot LZ
$$
where $T_lz$ is a reservoir constant $[days]$, and *LZ* is the amount of water that is stored in the lower zone $[mm]$.

Now, let's do a simple numerical experiment: assuming that $D_{uz,lz}$ is a constant value, we can take some arbitrary initial value for *LZ* and then simulate (e.g. in a spreadsheet) the development over *LZ* over time. The Figure below shows the results of 2 such experiments. In the upper Figure, we start with a very high initial storage (1500 mm). The inflow rate is fairly small (0.2 $\frac{mm}{day}$), and $T_{lz}$ is quite small as well (which means a relatively short residence time of the water in the lower zone). What is interesting here is that, over time, the storage evolves asymptotically towards a constant state. In the lower Figure, we start
with a much smaller initial storage (50 mm), but the inflow rate is much higher here (1.5 mm/day) and so is $T_{lz}$ (1000 days). Here we see an upward trend, again towards a constant value. However, in this case the constant 'end' value is not reached within the simulation period, which is mainly because $T_{lz}$ is set to a value for which the response is very slow.

At this point it should be clear that what you see in these graphs is exactly the same behaviour that is also apparent in the 'real' LISFLOOD simulation in the Figure above. Being able to know the 'end' storages in the Figure below in advance would be very helpful, because it would eliminate any trends. As it happens, this can be done very easily from the model equations. A storage that is constant over time means that the in- and outflow terms balance each other out. This is known as a *steady state* situation, and the constant 'end' storage is in fact the *steady state storage*. The rate of change of the lower zone's storage at any moment is given by the continuity equation:

$$
\frac{{dLZ}}{{dt}} = I(t) - O(t)
$$
where $I$ is the (time dependent) inflow (i.e. groundwater recharge) and $O$ is the outflow rate. For a situation where the storage remains constant, we can write:

$$
\frac{{dLZ}}{{dt}} = 0 \quad \Leftrightarrow \quad I(t) - O(t) =0
$$
![](https://ec-jrc.github.io/lisflood_manual/media/image39.png){width="5.447916666666667in"
height="7.40625in"}

***Figure:*** *Two 10-year simulations of lower zone storage with constant inflow. Upper Figure: high initial storage, storage approaches steady-state storage (dashed) after about 1500 days. Lower Figure: low initial storage, storage doesn't reach steady-state within 10 years.*

This equation can be re-written as:

$$
I(t) - \frac{1}{{{{\rm{T}}_{{\rm{lz}}}}}} \cdot LZ = 0
$$
Solving this for *LZ* gives the steady state storage:

$$
L{Z_{ss}} = {{\rm{T}}_{{\rm{lz}}}} \cdot I(t)
$$
We can check this for our numerical examples:

| $T_{lz}$ | $I$  | $LZ_{ss}$ |
| -------- | ---- | --------- |
| 250      | 0.2  | 50        |
| 1000     | 1.5  | 1500      |

which corresponds exactly to the results of Figure above.

Steady-state storage in practice
--------------------------------

An actual LISFLOOD simulation differs from the previous example in 2 ways. First, in any real simulation the inflow into the lower zone is not constant, but varies in time. This is not really a problem, since $LZ_{ss}$ can be computed from the *average* recharge. However, this is something we do not know until the end of the simulation! Also, the inflow into the lower zone is controlled by the availability of water in the upper zone, which, in turn, depends on the supply of water from the soil. Hence, it is influenced by any calibration parameters that control behaviour of soil- and subsoil (e.g. $T_{uz}$, $GW_{perc}$, $b$, and so on). This means that --when calibrating the model- the average recharge will be different for every parameter set. Note, however, that it will *always* be smaller than the value of $GW_{perc}$, which is used as an upper limit in the model. Note that the pre-run procedures include a sufficiently long warm-up period.


#### Use pre-run to calculate average recharge

Here, we first do a "pre-run" that is used to calculate the average inflow into the lower zone. This average inflow can be reported as a map, which is then used in the actual run. This involves the following steps:

1.  Set all the initial conditions to either 0,1 or -9999

2.  Activate the "InitLisflood" option by setting it active in the 'lfoptions' in the settings file:

```xml
  <setoption choice="1" name="InitLisflood"/>
```
3.  Run the model for a longer period (if possible more than 3 years, best for the whole modelling period)

4.  Go back to the LISFLOOD settings file, and set the InitLisflood inactive:

```xml
  <setoption choice="0" name="InitLisflood"/>
```

5.  Run the model again using the modified settings file

In this case, the initial state of $LZ$ is computed for the correct average inflow, and the simulated storage in the lower zone throughout the simulation shouldl not show any systematic (long-term) trends. The obvious price to pay for this is that the pre-run increase the computational load. However the pre-run will use a simplified routing to decrease the computational run-time. As long as the simulation period for the actual run and the pre-run are identical, the procedure gives a 100% guarantee that the development of the lower zone storage will be free of any systematic bias. Since the computed recharge values are dependent on the model parameterisation used, in a calibration setting the whole procedure must be repeated for each parameter set!

### Checking the lower zone initialisation 

The presence of any initialisation problems of the lower zone can be checked by adding the following line to the 'lfoptions' element of the settings file:

```xml
  <setoption name=" repStateUpsGauges" choice="1"> </setoption\>
```

This tells the model to write the values of all state variables (averages, upstream of contributing area to each gauge) to time series files. The default name of the lower zone time series is 'lzUps.tss'. Figure below shows an example of an 8-year simulation that was done both without (dashed line) and with a pre-run. The simulation without the pre-run shows a steady decreasing trend throughout the 8-year period, whereas the simulation for which the pre-run was used doesn't show this long-term trend (although in this specific case a modest increasing trend is visible throughout the first 6 years of the simulation, but this is related to trends in the meteorological input).

![initLZDemo](https://ec-jrc.github.io/lisflood_manual/media/image40.png){width="5.770833333333333in"
height="3.2395833333333335in"}

***Figure:*** *Initialisation of lower groundwater zone with and without using a pre-run. Note the strong decreasing trend in the simulation without pre-run. *

### Option2: Warm start (Using a previous run)

At the end of each model run, LISFLOOD writes maps of all internal state variables at the last time step. You can use these maps as the initial conditions for a succeeding simulation. This is particularly useful if you are simulating individual flood events on a small time interval (e.g. hourly). For instance, to estimate the initial conditions just before the flood you can do a 'pre-run' on a *daily* time interval for the year before the flood. You can then use the 'end maps' as the initial conditions for the hourly simulation.

In any case, you should be aware that values of some internal state variables of the model (especially lower zone storage) are very much dependent on the parameterisation used. Hence, suppose we have 'end maps' that were created using some parameterisation of the model (let's say parameter set *A*), then these maps should **not** be used as initial conditions for a model run with another parameterisation (parameter set *B*). If you decide to do this anyway, you are likely to encounter serious initialisation problems (but these may not be immediately visible in the output!). If you do this while calibrating the model (i.e. parameter set *B* is the calibration set), this will render the calibration exercise pretty much useless (since the output is the result of a mix of different parameter sets). However, for *FrostIndexInitValue* and *DSLRInitValue* it is perfectly safe to use the 'end maps', since the values of these maps do not depend on any calibration parameters (that is, only if you do not calibrate on any of the frost-related parameters!). If you need to calibrate for individual events (i.e.hourly), you should apply *each* parameterisation on *both * the (daily) pre-run and the 'event' run! This may seem awkward, but there is no way of getting around this (except from avoiding event-based calibration at all, which may be a good idea anyway).

### Summary of LISFLOOD initialisation procedure

From the foregoing it is clear that the initialisation of LISFLOOD can be done in a number of ways. The Figure below provides an overview. As already stated in the introduction section, any LISFLOOD simulation will fall into either of the following two categories:

1. The initial state of all state variables is known and defined by the end state of a previous run. In this case you can use the 'end' maps of the previous run's state variables as the initial conditions of you current run. Note that this requires that both simulations are run using exactly the same parameter set! Mixing parameter sets here will introduce unwanted artefacts into your simulation results.

2. The initial state of all state variables is unknown. In this case you should run the model with a sufficient pre-run (if possible more than 3 years, best for the whole modelling period) and InitLisflood=1. The average recharge map that is generated from the pre-run can subsequently be used as the average lower zone inflow estimate (*LZAvInflowEstimate*) in the actual simulation, which will avoid any initialisation problems of the lower groundwater zone

3. Is it possible not to use the first year for further analysis of results, because this is the "warm-up" period for all the other variables like snow, vegetation, soil (see e.g. **figure 7.1** for soil moisture)?\
    Then leave or set all the initial conditions to either 0,1 or -9999 and run the model with InitLisflood=0

4. If you want to include the first year of modelling into your analysis, you have to do a "warm-up" run (one year will usually do) to initialize all the initial conditions. You have to set option repEndMaps=1 to report end maps. Best possible solution is to use the year before the actual modelling period. Second best is to use any one year period to set up the initial conditions. After that you will have the 'end' maps and you can proceed with 1. again

![](https://ec-jrc.github.io/lisflood_manual/media/image41.png){width="5.760416666666667in"
height="4.322916666666667in"}

***Figure:*** *LISFLOOD initialisation flowchart.*


### How to launch LISFLOOD

To run the model, start up a command prompt (Windows) or a console window (Linux) and type 'lisflood' followed by the name of the settings file, e.g.:

```unix
lisflood settings.xml

If everything goes well you should see something like this:

LISFLOOD version March 01 2013 PCR2009W2M095

Water balance and flood simulation model for large catchments

(C) Institute for Environment and Sustainability

Joint Research Centre of the European Commission

TP261, I-21020 Ispra (Va), Italy

Todo report checking within pcrcalc/newcalc

Created: /nahaUsers/burekpe/newVersion/CWstjlDpeO.tmp

pcrcalc version: Mar 22 2011 (linux/x86_64)

Executing timestep 1

The LISFLOOD version "March 01 2013 PCR2009W2M095" indicates the date of the source code (01/03/2013), the oldest PCRASTER version it works with (PCR2009), the version of XML wrapper (W2) and the model version (M095).

```
