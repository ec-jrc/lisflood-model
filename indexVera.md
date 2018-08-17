
![](media/image2.png)

### Disclaimer
<span style="color:red">Not sure that it should stay here or if we should put the Disclaimer in the overall description of the LISFLOOD documentation OR at the end of this document ... I don't like it very much at the beginning</span>
Both the program code and this manual have been carefully inspected before printing. However, no  warranties, either expressed or implied, are made concerning the accuracy, completeness, reliability, usability, performance, or fitness for any particular purpose of the information contained in this manual, to the software described in this manual, and to other material supplied in connection therewith. The material  is provided \"as is\". The entire risk as to its quality and performance is with the user.



# Introduction
<span style="color:red">Needs to be revised. A link to the "LISFLOOD model description" (separate document) is essential</span>
The LISFLOOD model is a hydrological rainfall-runoff model that is capable of simulating the hydrological processes that occur in a catchment. LISFLOOD has been developed by the floods group of the Natural Hazards Project of the Joint Research Centre (JRC) of the European Commission. The specific development objective was to produce a tool that can be used in large and trans-national catchments for a variety of applications, including:

- Flood forecasting
- Assessing the effects of river regulation measures, of land-use change and of climate change

Although a wide variety of existing hydrological models are available that are suitable for *each* of these individual tasks, few *single* models are capable of doing *all* these jobs. Besides this, our objective requires a model that is spatially distributed and, at least to a certain extent, physically-based. Also, the focus of our work is on European catchments. Since several databases exist that contain pan-European information on soils (King *et al.*, 1997; Wösten *et al.*, 1999), land cover (CEC, 1993), topography (Hiederer & de Roo, 2003) and meteorology (Rijks *et al.*, 1998), it would be advantageous to have a model that makes the best possible use of these data. Finally, the wide scope of our objective implies that changes and extensions to the model will be required from time to time. Therefore, it is essential to have a model code that can be easily  maintained and modified. LISFLOOD has been specifically developed to satisfy these requirements. The model is designed to be applied across a wide range of spatial and temporal scales. LISFLOOD is grid-based, and applications so far have employed grid cells of as little as 100 metres for medium-sized catchments, to 5000 metres for modelling the whole of Europe and up to 0.1° (around 10 km) for modelling globally. Long-term water balance can be simulated (using a daily time step), as well as individual flood events (using hourly time intervals, or even smaller). The output of a "water balance run" can be used to provide the initial conditions of a "flood run". Although the model's primary output product is channel discharge, all internal rate and state variables (soil moisture, for example) can be written as output as well. In addition, all output can be written as grids, or time series at user-defined points or areas. The user has complete control over how output is written, thus minimising any waste of disk space or CPU time.

[:top:](#top)

# About LISFLOOD and this user guide

The __LISFLOOD__ model is implemented in the PCRaster Environmental Modelling language Version 3.0.0 (Wesseling et al., 1996), wrapped in a Python based interface. PCRaster is a raster GIS environment that has its own high-level computer language, which allows the construction of iterative spatio-temporal environmental models. The Python wrapper of LISFLOOD enables the user to control the model inputs and outputs and the selection of the model modules. This approach combines the power, relative simplicity and maintainability of code written in the the PCRaster Environmental Modelling language and the flexibility of Python.
LISFLOOD runs on any operating for which Python and PCRaster are available. Currently these include 32-bits Windows (e.g. Windows XP, Vista, 7) and a number of Linux distributions.

<span style="color:red">Needs to be revised. A link to the "LISFLOOD model description" (separate document) is essential</span>
This revised __User Manual__ documents LISFLOOD version December 1 2013, and replaces all previous documentation of the model (e.g. van der Knijff & de Roo, 2008; de Roo *et. al.*, 2003). The scope of this document is to give model users all the information that is needed for successfully using LISFLOOD.
Chapter 2 explains the theory behind the model, including all model equations and the changes to the previous version. The remaining chapters cover all practical aspects of working with LISFLOOD. Chapter 3 to 8 explains how to setup LISFLOOD, how to modify the settings and the outputs.
A series of Annexes at the end of this document describe some optional features that can be activated  when running the model. Most model users will not need these features (which are disabled by default), and for the sake of clarity we therefore decided to keep their description out of the main text. The  current document does not cover the calculation of the potential evapo (transpi)ration rates that are  needed as input to the model. A separate pre-processor (LISVAP) exists that calculates these variables  from standard (gridded) meteorological observations. LISVAP is documented in a separate volume (van  der Knijff, 2006). 

[:top:](#top)



# Step-by-step user guide

## Step1 : System requirements

Currently LISFLOOD is available on both 64-bit Linux and 32-bit Windows systems. Either way, the model requires that a recent version of the PCRaster software is available, or at least PCRaster's 'pcrcalc' application and all associated libraries. LISFLOOD require 'pcrcalc' version November 30, 2009, or more recent. Older 'pcrcalc' versions will either not work at all, or they might produce erroneous results. Unless
you are using a 'sealed' version of LISFLOOD (i.e. a version in which the source code is made unreadable), you will also need a licensed version of 'pcrcalc'. For details on how to install PCRaster we refer to
the PCRaster documentation.

## Step 2: Installation of the LISFLOOD model

### On Windows systems

For Windows users the installation involves two steps:

1.  Unzip the contents of 'lisflood\_win32.zip' to an empty folder on your PC (e.g. 'lisflood')

2.  Open the file 'config.xml' in a text editor. This file contains the full path to all files and applications that are used by LISFLOOD. The items in the file are:

    - *Pcrcalc application* : this is the name of the pcrcalc application, including the full path

    - *LISFLOOD Master Code* (optional). This item is usually omitted, and LISFLOOD assumes that the master code is called 'lisflood.xml', and that it is located in the root of the 'lisflood' directory (i.e. the directory that contains  'lisflood.exe' and all libraries). If --for whatever reason- you want to overrule this behaviour, you can add a 'mastercode' element, e.g.:

    ```
    <mastercode\>d:\\Lisflood\\mastercode\\lisflood.xml<\mastercode>
    ```

    The configuration file should look something like this:

    ```xml
    <?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>  
    <!-- Lisflood configuration file, JvdK, 8 July 2004 -->
    <!-- !! This file MUST be in the same directory as lisflood.exe -->
    <!-- (or lisflood) !!! -->
    <lfconfig>
    <!-- location of pcrcalc application -->
    <pcrcalcapp>C:\pcraster\apps\pcrcalc.exe</pcrcalcapp>
    </lfconfig>
    ```



The lisflood executable is a command-line application which can be called from the command prompt ('DOS' prompt). To make life easier you may include the full path to 'lisflood.exe' in the 'Path' environment
variable. In Windows XP you can do this by selecting 'settings' from the 'Start' menu; then go to 'control panel'/'system' and go to the 'advanced' tab. Click on the 'environment variables' button. Finally, locate the 'Path' variable in the 'system variables' window and click on 'Edit' (this requires local Administrator privileges).

[[🔝](#top)](#top)

### On Linux systems

Under Linux LISFLOOD requires that the Python interpreter (version 2.7 or more recent) is installed on the system. Most Linux distributions already have Python pre-installed. If needed you can download Python free of any charge from the following location:

*http://www.python.org/*

The installation process is largely identical to the Windows procedure:

unzip the contents of 'lisflood\_llinux.zip' to an empty directory.
Check if the file 'lisflood' is executable. If not, make it executable using:

chmod 755 lisflood

Then update the paths in the configuration file. The configuration file will look something like this:

```
<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?\>
<!\-- Lisflood configuration file, JvdK, 8 July 2004 \--\>
<!\-- !! This file MUST be in the same directory as lisflood.exe \--\>
<!\-- (or lisflood) !!! \--\><lfconfig\><!\-- location of pcrcalc application \--\><pcrcalcapp\>/software/PCRaster/bin/pcrcalc\</pcrcalcapp\></lfconfig\>

```



[[🔝](#top)](#top)

Running the model
-----------------

Type 'lisflood' at the command prompt. You should see something like this:

LISFLOOD version March 24 2008

Water balance and flood simulation model for large catchments \(C) Institute for Environment and Sustainability

Joint Research Centre of the European Commission

TP261, I-21020 Ispra (Va), Italy

usage (1): lisflood \[switches\] \<InputFile\>

usage (2): lisflood \--listoptions (show options only)

InputFile : LISFLOOD input file (see documentation for description of format)

switches:

-s : keep temporary script after simulation

You can run LISFLOOD by typing 'lisflood' followed by a specially-formatted settings file. The layout of this file is described in Chapters 4 and 5. Chapter 3 explains all other input files.

[[🔝](#top)](#top)

## Model setup: input files

In the current version of LISFLOOD, all model input is provided as either maps (grid files in PCRaster format) or tables. This chapter describes all the data that are required to run the model. Files that are specific to *optional* LISFLOOD features (e.g. inflow hydrographs, reservoirs) are not listed here; they are described in the documentation for each option.

Input maps
----------

PCRaster requires that all maps must have *identical* location attributes (number of rows, columns, cellsize, upper x and y coordinate!

All input maps roughly fall into any of the following six categories:

-   maps related to topography

-   maps related to land cover -- fraction of land cover

-   maps related to land cover and soil

-   maps related to soil texture (soil hydraulic properties)

-   maps related to channel geometry

-   maps related to the meteorological conditions

-   maps related to the development of vegetation over time

-   maps that define at which locations output is generated as time series

All maps that are needed to run the model are listed in the table of Annex 12.

### Role of "mask" and "channels" maps 

The mask map (i.e. "area.map") defines the model domain. In order to avoid unexpected results, **it is vital that all maps that are related to topography, land use and soil are defined** (i.e. don't contain a missing value) for each pixel that is "true" (has a Boolean 1 value) on the mask map. The same applies for all meteorological input and the Leaf Area Index maps. Similarly, all pixels that are "true" on the
channels map must have some valid (non-missing) value on each of the channel parameter maps. Undefined pixels can lead to unexpected behaviour of the model, output that is full of missing values, loss of mass balance and possibly even model crashes. Some maps needs to have values in a defined range e.g. gradient.map has to be greater than 0.

### Map location attributes and distance units

LISFLOOD needs to know the size properties of each grid cell (length, area) in order to calculate water *volumes* from meteorological forcing variables that are all defined as water *depths*. By default, LISFLOOD
obtains this information from the location attributes of the input maps. This will only work if all maps are in an "equal area" (equiareal) projection, and the map co-ordinates (and cell size) are defined in meters. For datasets that use, for example, a latitude-longitude system, neither of these conditions is met. In such cases you can still run LISFLOOD if you provide two additional maps that contain the length and area of each grid cell:

###### Table 4.1 Optional maps that define grid size

| **Map**               | **Default name**      | **Description**    |
|-----------------------|-----------------------|----------------------|
| PixelLengthUser       | pixleng.map           | Map with pixel length |
|                       |                       |                       |
|                       |                       | Unit: \[m\], *Range   |
|                       |                       | of values: map \> 0*  |
|-----------------------|-----------------------|-----------------------|
| PixelAreaUser         | pixarea.map           | Map with pixel area   |
|                       |                       |                       |
|                       |                       | *Unit:* \[m^2^\],    |
|                       |                       | *Range of values: map |
|                       |                       | \> 0*                 |
|-----------------------|-----------------------|-----------------------|

Both maps should be stored in the same directory where all other input maps are. The values on both maps may vary in space. A limitation is that a pixel is always represented as a square, so length and width are considered equal (no rectangles). In order to tell LISFLOOD to ignore the default location attributes and use the maps instead, you need to activate the special option "*gridSizeUserDefined*", which involves adding the following line to the LISFLOOD settings file:

```
<setoption choice="1" name="gridSizeUserDefined" \>
```

LISFLOOD settings files and the use of options are explained in detail in Chapter 5 of this document.

### Naming of meteorological variable maps

The meteorological forcing variables (and Leaf Area Index) are defined in *map stacks*. A *map stack* is simply a series of maps, where each map represents the value of a variable at an individual time step. The name of each map is made up of a total of 11 characters: 8 characters, a dot and a 3-character suffix. Each map name starts with a *prefix*, and ends with the time step number. All character positions in between are
filled with zeros ("0"). Take for example a stack of precipitation maps. Table 4.1 shows that the default prefix for precipitation is "pr", which produces the following file names:

```
pr000000.007   : at time step 7
...
pr000035.260   : at time step 35260
```

LISFLOOD can handle two types of stacks. First, there are regular stacks, in which a map is defined for each time step. For instance, the following 10-step stack is a regular stack:

```
  t        map name
  1        pr000000.001
  2        pr000000.002
  3        pr000000.003
  4        pr000000.004
  5        pr000000.005
  6        pr000000.006
  7        pr000000.007
  8        pr000000.008
  9        pr000000.009
  10       pr000000.010
```

In addition to regular stacks, it is also possible to define sparse stacks. A *sparse* stack is a stack in which maps are not defined for all time steps, for instance:

```
1        pr000000.001
2        -
3        -
4        pr000000.004
5        -
6        -
7        pr000000.007
8        -
9        -
10       -
```

Here, maps are defined only for time steps 1, 4 and 7. In this case, LISFLOOD will use the map values of *pr000000.001* during time steps 1, 2 and 3, those of *pr000000.004* during time steps 4, 5 and 6, and those
of *pr000000.007* during time steps 7, 8, 9 and 10. Since both regular and sparse stacks can be combined within one single run, sparse stacks can be very useful to save disk space. For instance, LISFLOOD always needs the *average daily* temperature, even when the model is run on an hourly time step. So, instead of defining 24 identical maps for each hour, you can simply define 1 for the first hour of each day and leave out the rest, for instance:

```
1        ta000000.001
2        -
:        :
:        :
25       ta000000.025
:        :
:        :
49       ta000000.049
:        :
```

Similarly, potential evapo(transpi)ration is usually calculated on a daily basis. So for hourly model runs it is often convenient to define $E0, ES0$ and $ET0$ in sparse stacks as well. Leaf Area Index (*LAI*) is a variable that changes relatively slowly over time, and as a result it is usually advantageous to define *LAI* in a sparse map stack.



Leaf area index maps 
---------------------

Because Leaf area index maps follow a yearly circle, only a map stack of
one year is necessary which is then used again and again for the  following years (this approach can be used for all input maps following
a yearly circle e.g. water use). LAI is therefore defined as sparse map
stack with a map every 10 days or a month, for example for a monthly
changing LAI:


| t      | map name     |
|--------|--------------|
| 1      | lai00000.001 |
|--------|--------------|
| 2      | lai00000.032 |
|--------|--------------|
| 3      | lai00000.060 |
|--------|--------------|
| 4      | lai00000.091 |
|--------|--------------|
| 5      | lai00000.121 |
|--------|--------------|
| 6      | lai00000.152 |
|--------|--------------|
| 7      | lai00000.182 |
|--------|--------------|
| 8      | lai00000.213 |
|--------|--------------|
| 9      | lai00000.244 |
|--------|--------------|
| 10     | lai00000.274 |
|--------|--------------|
| 11     | lai00000.305 |
|--------|--------------|
| 12     | lai00000.335 |


After one year the first map is taken again for simulation. For example
the simulation started on the 5^th^ March 2010 and the first LAI is
lai00000.060. On the 1^st^ March 2011 the map lai00000.060 is taken
again as LAI input. To let LISFLLOD know which map has to be used at
which day a lookup table (LaiOfDay.txt) is necessary.

Input tables
------------

In the previous version of LISFLOOD a number of model parameters are
read through tables that are linked to the classes on the land use and
soil (texture) maps. Those tables are replaced by maps (e.g. soil
hydraulic property maps) in order to include the sub-grid variability of
each parameter. Therefore only one table is used in the standard
LISFLOOD setting (without lake or reservoir option)

The following table gives an overview:

+-----------------------+-----------------------+-----------------------+
| ***Table 4.3**        |
| LISFLOOD input        |
| tables*               |
+=======================+=======================+=======================+
| **LAND USE**          |
+-----------------------+-----------------------+-----------------------+
| **Table**             | **Default name**      | **Description**       |
+-----------------------+-----------------------+-----------------------+
| Day of the year -\>   | LaiOfDay.txt          | Lookup table: Day of  |
| LAI                   |                       | the year -\> LAI map  |
+-----------------------+-----------------------+-----------------------+

Organisation of input data
--------------------------

It is up to the user how the input data are organised. However, it is
advised to keep the base maps, meteorological maps and tables separated
(i.e. store them in separate directories). For practical reasons the
following input structure is suggested:

-   all base maps are in one directory (e.g. 'maps')

    -   fraction maps in a subfolder (e.g. 'fraction')

    -   soil hydraulic properties in a subfolder (e.g.'soilhyd')

    -   land cover depending maps in a subfolder (e.g.'table2map')

-   all tables are in one directory (e.g. 'tables')

-   all meteorological input maps are in one directory (e.g. 'meteo')

-   a folder Leaf Area Index (e.g. 'lai')

    -   all Leaf Area Index for forest in a subfolder (e.g.'forest')

    -   all Leaf Area Index for other in a subfolder (e.g.'other')

-   all output goes to one directory (e.g. 'out')

The following Figure illustrates this:

![](media/media/image36.emf){width="5.802083333333333in"
height="4.541666666666667in"}

*Figure 4.1 Suggested file structure for LISFLOOD*

Generating input base maps
--------------------------

At the time of writing this document, complete sets of LISFLOOD base
maps covering the whole of Europe have been compiled at 1- and 5-km
pixel resolution. A number of automated procedures have been written
that allow you to generate sub-sets of these for pre-defined areas
(using either existing mask maps or co-ordinates of catchment outlets).

 5. LISFLOOD setup: the settings file
    =====================================

In LISFLOOD, all file and parameter specifications are defined in a
settings file. The purpose of the settings file is to link variables and
parameters in the model to in- and output files (maps, time series,
tables) and numerical values. In addition, the settings file can be used
to specify several *options*. The settings file has a special (XML)
structure. In the next sections the general layout of the settings file
is explained. Although the file layout is not particularly complex, a
basic understanding of the general principles explained here is
essential for doing any successful model runs.

The settings file has an XML ('E**x**tensible **M**arkup **L**anguage')
structure. You can edit it using any text editor (e.g. Notepad, Editpad,
Emacs, vi). Alternatively, you can also use a dedicated XML editor such
as XMLSpy.

Layout of the settings file
---------------------------

A LISFLOOD settings file is made up of 4 elements, each of which has a
specific function. The general structure of the file is described using
XML-tags. XML stands for 'E**x**tensible **M**arkup **L**anguage', and
it is really nothing more than a way to describe data in a file. It
works by putting information that goes into a (text) file between tags,
and this makes it very easy add structure. For a LISFLOOD settings file,
the basic structure looks like this:

  **\<lfsettings\>**   Start of settings element
-------------------- ----------------------------------------------

  **\<lfuser\>**       Start of element with user-defined variables
                       
  **\</lfuser\>**      End of element with user-defined variables
                       
  **\<lfoptions\>**    Start of element with options
                       
  **\</lfoptions\>**   End of element with options
                       
  **\<lfbinding\>**    Start of element with 'binding' variables
                       
  **\</lfbinding\>**   End of element with 'binding' variables
                       
  **\<prolog\>**       Start of prolog
                       
  **\</prolog\>**      End of prolog
                       
  **\<lfsettings\>**   End of settings element

From this you can see the following things:

-   The settings file is made up of the elements 'lfuser', 'lfoptions'
    and 'lfbinding'; in addition, there is a 'prolog' element (but this
    will ultimately disappear in future LISFLOOD versions)

-   The start of each element is indicated by the element's name wrapped
    in square brackets, e.g. \<element\>

-   The end of each element is indicated by a forward slash followed by
    the element's name, all wrapped in square brackets, e.g.
    \</element\>

-   All elements are part of a 'root' element called '\<lfsettings\>'.

In brief, the main function of each element is:

  *lfuser*      : definition of paths to all in- and output files, and main model parameters (calibration + time-related)
------------- -----------------------------------------------------------------------------------------------------------
  *lfbinding*   : definition of all individual in- and output files, and model parameters
  *lfoptions*   : switches to turn specific components of the model on or off

The following sections explain the function of each element in more
detail. This is mainly to illustrate the main concepts and how it all
fits together. A detailed description of all the variables that are
relevant for setting up and running LISFLOOD is given in Chapter 6.

### lfuser and and lfbinding elements

The 'lfbinding' element provides a very low-level way to define all
model parameter values as well as all in- and output maps, time series
and tables. The 'lfuser' element is used to define (user-defined) text
variables. These text variables can be used to substitute repeatedly
used expressions in the binding element. This greatly reduces the amount
of work that is needed to prepare the settings file. Each variable is
defined as a 'textvar' element within 'lfuser'/'lfbinding'. Each
'textvar' element has the attributes 'name' and 'value'. The following
example demonstrates the main principle (note that in the examples below
the prolog element is left out, but you will never need to edit this
anyway) :

+-----------------------------------------------------------------------+
| \<?xml version=\"1.0\" encoding=\"UTF-8\"?\>                          |
|                                                                       |
| \<!DOCTYPE lfsettings SYSTEM \"lisflood.dtd\"\>                       |
|                                                                       |
| **\<lfsettings\>**                                                    |
|                                                                       |
| **\<lfuser\>**                                                        |
|                                                                       |
| \<textvar name=\"PathMaps\"                                           |
| value=\"//cllx01/floods2/knijfjo/test/maps\"\>                        |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| **\</lfuser\>**                                                       |
|                                                                       |
| **\<lfoptions\>**                                                     |
|                                                                       |
| **\</lfoptions\>**                                                    |
|                                                                       |
| **\<lfbinding\>**                                                     |
|                                                                       |
| \<textvar name=\"LandUse\" value=\"\$(PathMaps)/landuse.map\"\>       |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"SoilDepth\" value=\"\$(PathMaps)/soildep.map\"\>     |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| **\</lfbinding\>**                                                    |
|                                                                       |
| **\</lfsettings\>**                                                   |
+-----------------------------------------------------------------------+

In the example two input files (maps) are defined. Both maps are in the
same directory. Instead of entering the full file path for every map, we
define a variable called *PathMaps* in the 'lfuser' element. This
variable can then be used in the 'lfbinding' element. Note that in the
'lfbinding' element you should always wrap user-defined variables in
brackets and add a leading dollar sign, e.g. *\$(PathMaps)*. Since the
names of the in- and output files are usually the same for each model
run, the use of user-defined variables greatly simplifies setting up the
model for new catchments. In general, it is a good idea to use
user-defined variables for *everything* that needs to be changed on a
regular basis (paths to input maps, tables, meteorological data,
parameter values). This way you only have to deal with the variables in
the 'lfuser' element, without having to worry about anything in
'lfbinding' at all.

Now for a somewhat more realistic example:

+-----------------------------------------------------------------------+
| \<?xml version=\"1.0\" encoding=\"UTF-8\"?\>                          |
|                                                                       |
| \<!DOCTYPE lfsettings SYSTEM \"lisflood.dtd\"\>                       |
|                                                                       |
| **\<lfsettings\>**                                                    |
|                                                                       |
| **\<lfuser\>**                                                        |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| CALIBRATION PARAMETERS                                                |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"UpperZoneTimeConstant\" value=\"10\"\>               |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Time constant for water in upper zone \[days\*mm\^GwAlpha\]           |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| FILE PATHS                                                            |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"PathMeteo\"                                          |
| value=\"//cllx01/floods2/knijfjo/test/meteo\"\>                       |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Meteo path                                                            |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| PREFIXES OF METEO VARIABLES                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"PrefixPrecipitation\" value=\"pr\"\>                 |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| prefix precipitation maps                                             |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| **\</lfuser\>**                                                       |
|                                                                       |
| **\<lfoptions\> \</lfoptions\>**                                      |
|                                                                       |
| **\<lfbinding\>**                                                     |
|                                                                       |
| \<textvar name=\"UpperZoneTimeConstant\"                              |
| value=\"\$(UpperZoneTimeConstant)\"\>                                 |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Time constant for water in upper zone \[days\*mm\^GwAlpha\]           |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PrecipitationMaps\"                                  |
| value=\"\$(PathMeteo)/\$(PrefixPrecipitation)\"\>                     |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| precipitation \[mm/day\]                                              |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| **\</lfbinding\>**                                                    |
|                                                                       |
| **\</lfsettings\>**                                                   |
+-----------------------------------------------------------------------+

From this example, note that *anything* can be defined with 'lfuser'
variables, whether it be paths, file prefixes or parameter value. At
first sight it might seem odd to define model parameter like
*UpperZoneTimeConstant* as a text variable when it is already defined in
the 'lfbinding' element. However, in practice it is much easier to have
all the important variables defined in the same element: in total the
model needs around 200 variables, parameters and file names. By
specifying each of those in the 'lfbinding' element you need to specify
each of them separately. Using the 'lfuser' variables this can be
reduced to about 50, which greatly simplifies things. You should think
of the 'lfbinding' element as a low-level way of describing the model
in- and output structure: anything can be changed and any file can be in
any given location, but the price to pay for this flexibility is that
the definition of the input structure will take a lot of work. By using
the 'lfuser' variables in a smart way, custom template settings files
can be created for specific model applications (calibration, scenario
modelling, operational flood forecasting). Typically, each of these
applications requires its own input structure, and you can use the
'lfuser' variables to define this structure. Also, note that the both
the *name* and *value* of each variable must be wrapped in (single or
double) quotes. Dedicated XML-editors like XmlSpy take care of this
automatically, so you won't usually have to worry about this.

**[NOTES:]{.underline}**

1.  It is important to remember that the *only* function of the 'lfuser'
    element is to *define* text variables; you can not *use* any of
    these text variables within the 'lfuser' element. For example, the
    following 'lfuser' element is *wrong* and *will not work*:

+-----------------------------------------------------------------------+
| **\<lfuser\>**                                                        |
|                                                                       |
| \<textvar name=\"PathInit\"                                           |
| value=\"//cllx01/floods2/knijfjo/test/init\"\>                        |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Path to initial conditions maps                                       |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"LZInit\" value=\"\$(PathInit)/lzInit.map)\"\>        |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Initial lower zone storage                                            |
|                                                                       |
| \*\* USE OF USER VARIABLE WITHIN LFUSER                               |
|                                                                       |
| \*\* IS NOT ALLOWED, SO THIS EXAMPLE WILL NOT WORK!!                  |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| **\</lfuser\>**                                                       |
+-----------------------------------------------------------------------+

2.  It *is* possible to define *everything* directly in the 'lfbinding'
    element without using any text variables at all! In that case the
    'lfuser' element can remain empty, even though it *has* to be
    present (i.e. \<lfuser\> \</lfuser\>). In general this is not
    recommended.

3.  Within the *lfuser* and *lfbinding* elements, model variables are
    organised into *groups*. This is just to make navigation in an xml
    editor easier.

### Variables in the lfbinding element

The variables that are defined in the 'lfbinding' element fall in either
of the following categories:

1.  **Single map**

> Example:
>
> \<textvar name=\"LandUse\" value=\"\$(PathMaps)/landuse.map\"\>
>
> \<comment\>
>
> Land Use Classes
>
> \</comment\>
>
> \</textvar\>

2.  **Table**

> Example:
>
> \<textvar name=\"TabKSat1\" value=\"\$(PathTables)/ksat1.txt\"\>
>
> \<comment\>
>
> Saturated conductivity \[cm/day\]
>
> \</comment\>
>
> \</textvar\>

3.  **Stack of maps**

> Example:
>
> \<textvar name=\"PrecipitationMaps\"
>
> value=\"\$(PathMeteo)/\$(PrefixPrecipitation)\"\>
>
> \<comment\>
>
> precipitation \[mm/day\]
>
> \</comment\>
>
> \</textvar\>

**[Note:]{.underline}**

> Taking -as an example- a prefix that equals "*pr*", the name of each
> map in the stack starts with "*pr*", and ends with the number of the
> time step. The name of each map is made up of a total of 11
> characters: 8 characters, a dot and a 3-character suffix. For
> instance:

  pr000000.007   : at time step 7
-------------- ----------------------
  pr000035.260   : at time step 35260

> To avoid unexpected behaviour, do **not** use numbers in the prefix!
> For example:
>
> \<textvar name=\"PrecipitationMaps\"
>
> value=\"\$(PathMeteo)/pr10 \"\>
>
> \<comment\>
>
> precipitation \[mm/day\]
>
> \</comment\>
>
> \</textvar\>
>
> For the first time step this yields the following file name:

-------------- --
  pr100000.001   
-------------- --

> But this is actually interpreted as time step 100,000,001!

4.  **Time series file**

> Example:

\<textvar name=\"DisTS\" value=\"\$(PathOut)/dis.tss\"\>

\<comment\>

Reported discharge \[cu m/s\]

\</comment\>

\</textvar\>

5.  **Single parameter value**

> Example:
>
> \<textvar name=\"UpperZoneTimeConstant\"
> value=\"\$(UpperZoneTimeConstant)\"\>
>
> \<comment\>
>
> Time constant for water in upper zone \[days\]
>
> \</comment\>
>
> \</textvar\>

### Variables in the lfuser element

As said before the variables in the 'lfuser' elements are all text
variables, and they are used simply to substitute text in the
'lfbinding' element. In practice it is sometimes convenient to use the
same name for a text variable that is defined in the 'lfuser' element
and a 'lfbinding' variable. For example:

+-----------------------------------------------------------------------+
| **\<lfuser\>**                                                        |
|                                                                       |
| \<textvar name=\"UpperZoneTimeConstant\" value=\"10\"\>               |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Time constant for water in upper zone \[days\]                        |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| **\</lfuser\>**                                                       |
|                                                                       |
| **\<lfbinding\>**                                                     |
|                                                                       |
| \<textvar name=\"UpperZoneTimeConstant\"                              |
| value=\"\$(UpperZoneTimeConstant)\"\>                                 |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Time constant for water in upper zone \[days\]                        |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| **\</lfbinding\>**                                                    |
+-----------------------------------------------------------------------+

In this case 'UpperZoneTimeConstant' in the 'lfuser' element (just a
text variable) is something different from 'UpperZoneTimeConstant' in
the 'lfbinding' element!

### 

### lfoption element

The 'lfoption' element effectively allows you to switch certain parts of
the model on or off. Within LISFLOOD, there are two categories of
options:

1.  Options to activate the reporting of additional output maps and time
    series (e.g. soil moisture maps)

2.  Options that activate special LISFLOOD features, such as inflow
    hydrographs and the simulation of reservoirs

### Viewing available options

You can view all options by running LISFLOOD with the *\--listoptions*
flag. For each option, the following information is listed:

OptionName Choices DefaultValue

'OptionName' -as you might have guessed already- simply is the name of
the option. 'Choices' indicates the possible values of the option, and
'DefaultValue' describes the default behaviour. For instance, if you
look at the reservoir option:

simulateReservoirs choices=(1,0) default=0

you see that the value of this option is either 0 (off) or 1 (on), and
that the default value is 0 (off, i.e. do not simulate any reservoirs).

The information on the reporting options is a little bit different (and
slightly confusing). Looking at the option for reporting discharge maps:

repDischargeMaps choices=(1) noDefault

By default, discharge maps are not reported, so you would expect
something like "default=0". However, due to the way options are defined
internally in the model, in this case we have no default value, which
means it is switched off.[^4] Report options that are switched *on* by
default look like this:

repStateMaps choices=(1) default=1

To minimise the confusion, you should:

1.  Ignore the "Choices" item

2.  Interpret "noDefault" as "default=0"

This is all a bit confusing, and the displaying of option information
may well change in future LISFLOOD versions.

### Defining options

Within the 'lfoptions' element of the settings file, each option is
defined using a 'setoption' element, which has the attributes 'name' and
'choice' (i.e. the actual value). For example:

+----------------------------------------------+
| **\<lfoptions\>**                            |
|                                              |
| \<setoption choice=\"1\" name=\"inflow\" /\> |
|                                              |
| **\</lfoptions\>**                           |
+----------------------------------------------+

You are not obliged to use any options: if you leave the 'lfoptions'
element empty, LISFLOOD will simply run using the default values (i.e.
run model without optional modules; only report most basic output
files). However, the 'lfoptions' element itself (i.e. \<lfoptions\>
\</lfoptions\>) *has* to be present, even if empty!

6. Preparing the settings file
  ==============================

This chapter describes how to prepare your own settings file. Instead of
writing the settings file completely from scratch, we suggest to use the
settings template that is provided with LISFLOOD as a starting point. In
order to use the template, you should make sure the following
requirements are met:

-   All input maps and tables are named according to default file names
    (see Chapter 4 and Annex 12)

-   All base maps are in the right directories

-   All tables are in one directory

-   All meteo input is in one directory

-   All Leaf Area Index input is in the right directories

-   An (empty) directory where all model data can be written exists

If this is all true, the settings file can be prepared very quickly by
editing the items in the 'lfuser' element. The following is a detailed
description of the different sections of the 'lfuser' element. The
present LISFLOOD version contains process-related parameters (not taking
into account the parameters that are defined through the maps). These
are all defined in the 'lfuser' element, and default values are given
for each of them. Even though *any* of these parameters can be treated
as calibration constants, doing so for *all* of them would lead to
serious over-parameterisation problems. In the description of these
parameters we will therefore provide some suggestions as to which
parameters should be used for calibration, and which one are better left
untouched.

Time-related constants
----------------------

The 'lfuser' section starts with a number of constants that are related
to the simulation period and the time interval used. These are all
defined as single values.

+-----------------------------------------------------------------------+
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| TIME-RELATED CONSTANTS                                                |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"CalendarDayStart\" value=\"01/01/1990\"\>            |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Calendar day of 1st day in model run                                  |
|                                                                       |
| Day of the year of first map (e.g. xx0.001) even if the model start   |
| from map e.g. 500                                                     |
|                                                                       |
| e.g. 1st of January: 1; 1st of June 151 (or 152 in leap year)         |
|                                                                       |
| Needed to read out LAI tables correctly                               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"DtSec\" value=\"86400\"\>                            |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| timestep \[seconds\]                                                  |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"DtSecChannel\" value=\"86400\"\>                     |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Sub time step used for kinematic wave channel routing \[seconds\]     |
|                                                                       |
| Within the model,the smallest out of DtSecChannel and DtSec is used   |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"StepStart\" value=\"1\"\>                            |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Number of first time step in simulation                               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"StepEnd\" value=\"10\"\>                             |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Number of last time step in simulation                                |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"ReportSteps\" value=\"endtime\"\>                    |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Time steps at which to write model state maps (i.e. only              |
|                                                                       |
| those maps that would be needed to define initial conditions          |
|                                                                       |
| for succeeding model run)                                             |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
+-----------------------------------------------------------------------+

> *CalendarDayStart* is the calendar day of the first map in a map stack
> e.g. pr000000.001. Even if you start the model from time step 500,
> this has to be set to the calendar day of the 001 map in your map
> stacks.\
> Format can be a number:
>
> *Value="1" = 1^st^ January, Value="151" = 1^st^ June*
>
> Or date (in different format):
>
> *Value="01/01/1990" = 1^st^ January 1990, Value="05.07.1990" = 5th
> June 1990,*
>
> *Value="15-11-1990" = 15^th^ November 1990*
>
> *DtSec* is the simulation time interval in seconds. It has a value of
> 86400 for a daily time interval, 3600 for an hourly interval, etcetera
>
> *DtSecChannel* is the simulation time interval used by the kinematic
> wave channel routing (in seconds). Using a value that is smaller than
> *DtSec* may result in a better simulation of the overall shape the
> calculated hydrograph (at the expense of requiring more computing
> time)
>
> *StepStart* is the number of the first time step in your simulation.
> It is normally set to 1. Other (larger) values can be used if you want
> to run LISFLOOD for only a part of the time period for which you have
> meteo and LAI maps.
>
> *StepEnd* is the number of the last time step in your simulation.
>
> *ReportSteps* defines the time step number(s) at which the model state
> (i.e. all maps that you would need to define the initial conditions of
> a succeeding model run) is written. You can define this parameter as a
> (comma separated) list of time steps. For example:
>
> \<textvar name=\"ReportSteps\" value=\"10,20,40\"\>
>
> will result in state maps being written at time steps 10, 20 and 40.
> For the *last* time step of a model run you can use the special
> 'endtime' keyword, e.g.:
>
> \<textvar name=\"ReportSteps\" value=\"endtime\"\>
>
> Alternatively, in some cases you may need the state maps at regular
> intervals. In that case you can use the following syntax:
>
> \<textvar name=\"ReportSteps\" value=\"start+increment..end\"\>
>
> For instance, in the following example state maps are written every
> 5^th^ time step, starting at time step 10, until the last time step:
>
> \<textvar name=\"ReportSteps\" value=\"10+5..endtime\"\>

Parameters related to evapo(transpi)ration and interception
-----------------------------------------------------------

The following parameters are all related to the simulation of
evapo(transpi)ration and rainfall interception. Although they can all be
defined as either a single value or as a map, we recommend using the
single values that are included in the template. We do not recommend
using any of these parameters as calibration constants.

+-----------------------------------------------------------------------+
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| PARAMETERS RELATED TO EVAPO(TRANSPI)RATION AND INTERCEPTION           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"PrScaling\" value=\"1\"\>                            |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Multiplier applied to potential precipitation rates                   |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"CalEvaporation\" value=\"1\"\>                       |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Multiplier applied to potential evapo(transpi)ration rates            |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"LeafDrainageTimeConstant\" value=\"1\"\>             |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Time constant for water in interception store \[days\]                |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"kdf\" value=\"0.72\"\>                               |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Average extinction coefficient for the diffuse radiation flux         |
|                                                                       |
| varies with crop from 0.4 to 1.1 (Goudriaan (1977))                   |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"AvWaterRateThreshold\" value=\"5\"\>                 |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Critical amount of available water (expressed in \[mm/day\]!), above  |
| which \'Days Since Last Rain\' parameter is set to 1                  |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"SMaxSealed\" value=\"1.0\"\>                         |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| maximum depression storage for water on impervious surface            |
|                                                                       |
| which is not immediatly causing surface runoff \[mm\]                 |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
+-----------------------------------------------------------------------+

> *PrScaling* is a multiplier that is applied to precipitation input
> (pr) \[-\]
>
> *CalEvaporation* is a multiplier that is applied to the potential
> evapo(transpi)ration input (*ET0*, *EW0* and *ES0*) \[-\]
>
> *LeafDrainageTimeConstant* (*T~int~* in Eq 2-11) is the time constant
> for the interception store \[days\]
>
> *kdf* is the average extinction for the diffuse radiation flux
> (Goudriaan, 1977). it is used to calculate the extinction coefficient
> for global radiation, *κ~gb~* ,which is used in Equations 2-9, 2-14
> and 2-19 \[-\]
>
> *AvWaterRateThreshold* defines a critical amount of water that is used
> as a threshold for resetting the variable *D~slr~* in Eq 2-20. Because
> the equation was originally developed for daily timesteps only, the
> threshold is currently defined (somewhat confusingly) as an equivalent
> *intensity* in \[mm day^-1^\]
>
> *SMaxSealed* is the maximum depression storage on impervious surface
> \[mm\]. This storage is emptied by evaporation (EW0).

Parameters related to snow and frost
------------------------------------

The following parameters are all related to the simulation of snow
accumulation, snowmelt and frost. All these parameters can be defined as
either single values or maps. We recommend to start out by leaving them
all at their default values. If prior data suggest major under- or
overcatch problems in the observed snowfall, *SnowFactor* can be
adjusted accordingly. *SnowMeltCoef* may be used as a calibration
constant, but since snow observations are typically associated with
large uncertainty bands, the calibration may effectively just be
compensating for these input errors.

+-----------------------------------------------------------------------+
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| SNOW AND FROST RELATED PARAMETERS                                     |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"SnowFactor\" value=\"1\"\>                           |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Multiplier applied to precipitation that falls as snow                |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"SnowSeasonAdj\" value=\"1.0\"\>                      |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| range \[mm C-1 d-1\] of the seasonal variation                        |
|                                                                       |
| SnowMeltCoef is the average value                                     |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"SnowMeltCoef\" value=\"4.5\"\>                       |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Snowmelt coefficient \[mm/deg C /day\]                                |
|                                                                       |
| See also Martinec et al., 1998.                                       |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"TempMelt\" value=\"0.0\"\>                           |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Average temperature at which snow melts                               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"TempSnow\" value=\"1.0\"\>                           |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Average temperature below which precipitation is snow                 |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"TemperatureLapseRate\" value=\"0.0065\"\>            |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Temperature lapse rate with altitude \[deg C / m\]                    |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"Afrost\" value=\"0.97\"\>                            |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Daily decay coefficient, (Handbook of Hydrology, p. 7.28)             |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"Kfrost\" value=\"0.57\"\>                            |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Snow depth reduction coefficient, \[cm-1\], (HH, p. 7.28)             |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"SnowWaterEquivalent\" value=\"0.45\"\>               |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Snow water equivalent, (based on snow density of 450 kg/m3) (e.g.     |
| Tarboton and Luce, 1996)                                              |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"FrostIndexThreshold\" value=\"56\"\>                 |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Degree Days Frost Threshold (stops infiltration, percolation and      |
| capillary rise)                                                       |
|                                                                       |
| Molnau and Bissel found a value 56-85 for NW USA.                     |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
+-----------------------------------------------------------------------+

> *SnowFactor* is a multiplier that is applied to the rate of
> precipitation in case the precipitation falls as snow. Since snow is
> commonly underestimated in meteorological observation data, setting
> this multiplier to some value greater than 1 can counteract for this
> \[-\]
>
> *SnowSeasonAdj* is the range \[mm C-1 d-1\] of the seasonal variation
> of snow melt. SnowMeltCoef is the average value.
>
> *SnowMeltCoef* (*C~m~* in Eq 2-3) is the degree-day factor that
> controls the rate of snowmelt \[mm °C^-1^ day^-1^\]
>
> *TempMelt* (*T~m~* in Eq 2-3) is the average temperature above which
> snow starts to melt \[°C\]
>
> *TempSnow* is the average temperature below which precipitation is
> assumed to be snow \[°C\]
>
> *TemperatureLapseRate* (*L* in Figure 2.2) is the temperature lapse
> rate that is used to estimate average temperature at the centroid of
> each pixel's elevation zones \[°C m^-1^\]
>
> *Afrost* (*A* in Eq 2-4) is the frost index decay coefficient
> \[day^-1^\]. It has a value in the range 0-1.
>
> *Kfrost* (*K* in Eq 2-4) is a snow depth reduction coefficient
> \[cm^-1^\]
>
> *SnowWaterEquivalent* (*we~s~* in Eq 2-4) is the equivalent water
> depth of a given snow cover, expressed as a fraction \[-\]
>
> *FrostIndexThreshold* is the critical value of the frost index (Eq
> 2-5) above which the soil is considered frozen \[°C day^-1^\]

Infiltration parameters 
------------------------

The following two parameters control the simulation of infiltration and
preferential flow. Both are empirical parameters that are treated as
calibration constants, and both can be defined as single values or maps.

+-----------------------------------------------------------------------+
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| INFILTRATION PARAMETERS                                               |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"b\_Xinanjiang\" value=\"0.1\"\>                      |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Power in Xinanjiang distribution function                             |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PowerPrefFlow\" value=\"3\"\>                        |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Power that controls increase of proportion of preferential            |
|                                                                       |
| flow with increased soil moisture storage                             |
+-----------------------------------------------------------------------+

> *b\_Xinanjiang* (*b* in Eq 2-23) is the power in the infiltration
> equation \[-\]
>
> *PowerPrefFlow* (*c~pref~* in Eq 2-25) is the power in the
> preferential flow equation \[-\]

Groundwater parameters 
-----------------------

The following parameters control the simulation shallow and deeper
groundwater. *GwLossFraction* should be kept at 0 unless prior
information clearly indicates that groundwater is lost beyond the
catchment boundaries (or to deep groundwater systems). The other
parameters are treated as calibration constants. All these parameters
can be defined as single values or maps.

+-----------------------------------------------------------------------+
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| GROUNDWATER RELATED PARAMETERS                                        |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"UpperZoneTimeConstant\" value=\"10\"\>               |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Time constant for water in upper zone \[days\]                        |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"LowerZoneTimeConstant\" value=\"1000\"\>             |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Time constant for water in lower zone \[days\]                        |
|                                                                       |
| This is the average time a water \'particle\' remains in the          |
| reservoir                                                             |
|                                                                       |
| if we had a stationary system (average inflow=average outflow)        |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"GwPercValue\" value=\"0.5\"\>                        |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Maximum rate of percolation going from the Upper to the Lower         |
|                                                                       |
| response box \[mm/day\]                                               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"GwLoss\" value=\"0\"\>                               |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Maximum rate of percolation from the Lower response box (groundwater  |
| loss) \[mm/day\].                                                     |
|                                                                       |
| A value of 0 (closed lower boundary) is recommended as a starting     |
| value                                                                 |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
+-----------------------------------------------------------------------+

> *UpperZoneTimeConstant* (*T~uz~* in Eq 2-42) is the time constant for
> the upper groundwater zone \[days\]
>
> *LowerZoneTimeConstant* (*T~lz~* in Eq 2-43) is the time constant for
> the lower groundwater zone \[days\]
>
> *GwPercValue* (*GW~perc~* in Eq 2-44) is the maximum rate of
> percolation going from the upper to the lower groundwater zone \[mm
> day^-1^\]
>
> *GwLoss* (*f~loss~* in Eq 2-45) is the maximum rate of percolation
> from the lower groundwater zone (groundwater loss) zone \[mm
> day^-1^\]. A value of 0 (closed lower boundary) is recommended as a
> starting value.

Routing parameters 
-------------------

These parameters are all related to the routing of water in the channels
as well as the routing of surface runoff. The multiplier *CalChanMan*
can be used to fine-tune the timing of the channel routing, and it may
be defined as either a single value or a map. All other parameters
should be kept at their default values.

+-----------------------------------------------------------------------+
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| ROUTING PARAMETERS                                                    |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"CalChanMan\" value=\"1\"\>                           |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Multiplier applied to Channel Manning\'s n                            |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"beta\" value=\"0.6\"\>                               |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| kinematic wave parameter: 0.6 is for broad sheet flow                 |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"OFDepRef\" value=\"5\"\>                             |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Reference depth of overland flow \[mm\], used to compute              |
|                                                                       |
| overland flow Alpha for kin. wave                                     |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"GradMin\" value=\"0.001\"\>                          |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Minimum slope gradient (for kin. wave: slope cannot be 0)             |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"ChanGradMin\" value=\"0.0001\"\>                     |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Minimum channel gradient (for kin. wave: slope cannot be 0)           |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
+-----------------------------------------------------------------------+

> *CalChanMan* is a multiplier that is applied to the Manning's
> roughness maps of the channel system \[-\]
>
> *beta* is routing coefficient *β~k~* in Equations 2-51, 2-52, 2-54 and
> 2-57 \[-\]
>
> *OFDepRef* is a reference flow depth from which the flow velocity of
> the surface runoff is calculated \[mm\]
>
> *GradMin* is a lower limit for the slope gradient used in the
> calculation of the surface runoff flow velocity \[m m^-1^\]
>
> *ChanGradMin* is a lower limit for the channel gradient used in the
> calculation of the channel flow velocity \[m m^-1^\]

Parameters related to numerics
------------------------------

This category only contains one parameter at the moment, which can only
be a single value. We strongly recommend keeping this parameter at its
default value.

+-----------------------------------------------------------------------+
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| PARAMETERS RELATED TO NUMERICS                                        |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"CourantCrit\" value=\"0.4\"\>                        |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Minimum value for Courant condition in soil moisture routine          |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
+-----------------------------------------------------------------------+

> *CourantCrit* (*C~crit~* in Eq 2-36) is the critical Courant number
> which controls the numerical accuracy of the simulated soil moisture
> fluxes \[-\]. Any value between 0 and 1 can be used, but using values
> that are too high can lead to unrealistic "jumps" in the simulated
> soil moisture, whereas very low values result in reduced computational
> performance (because many iterations will be necessary to obtain the
> required accuracy). Values above 1 should never be used, as they will
> result in a loss of mass balance. In most cases the default value of
> 0.4 results in sufficiently realistic simulations using just a few
> iterations.

File paths
----------

Here you can specify where all the input files are located, and where
output should be written. Note that you can use both forward and
backward slashes on both Windows and Linux-based systems without any
problem (when LISFLOOD reads the settings file it automatically formats
these paths according to the conventions used by the operating system
used). The default settings template contains relative paths, which in
most cases allows you to run the model directly without changing these
settings (assuming that you execute LISFLOOD from the root directory of
your catchment).

+-----------------------------------------------------------------------+
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| FILE PATHS                                                            |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"PathOut\" value=\"./out\"\>                          |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Output path                                                           |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PathInit\" value=\"./out\"\>                         |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Path of the initial value maps e.g. lzavin.map                        |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PathMaps\" value=\"./maps\"\>                        |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Maps path                                                             |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PathSoilHyd\" value=\"./maps/soilhyd\"\>             |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Maps instead tables for soil hydraulics path                          |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PathMapsFraction\" value=\"./maps/fraction\"\>       |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Maps of fraction of land cover (forest, water, sealed,other)          |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar                                                            |
|                                                                       |
| \<textvar name=\"PathMapsTables\" value=\"./maps/table2map\"\>        |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Maps which replaced tables e.g. CropCoeff                             |
|                                                                       |
| /comment\>                                                            |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PathTables\" value=\"./tables\"\>                    |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Tables path                                                           |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PathMeteo\" value=\"./meteo\"\>                      |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Meteo path                                                            |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PathLAI\" value=\"./lai\"\>                          |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Leaf Area Index maps path                                             |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PathWaterUse\" value=\"./wateruse\"\>                |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Water use maps path                                                   |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
+-----------------------------------------------------------------------+

> *PathOut* is the directory where all output files are written. It must
> be an existing directory (if not you will get an error message -- not
> immediately but after 256 timesteps, when the time series are written
> for the first time)
>
> *PathInit* is the directory where the initial files are located, to
> initialize a "warm" start. It can be also the PathOut directory
>
> *PathMaps* is the directory where all input base maps are located
>
> *PathSoilHyd* is the directory where the soil hydraulic property maps
> are located
>
> *PathMapsFraction* is the directory where the land cover fraction maps
> are located
>
> *PathMapsTables* is the directory where maps are located which were
> calculated from lookup tables in the previous version (e.g. cropcoeff)
>
> *PathTables* is the directory where all input tables are located
>
> *PathMeteo* is the directory where all maps with meteorological input
> are located (rain, evapo(transpi)ration, temperature)
>
> *PathLAI* is the directory where you Leaf Area Index maps are located
>
> *PathWaterUse* is the directory where water use maps are located
> (optional)

Prefixes of meteo and vegetation related variables
--------------------------------------------------

Here you can define the prefix that is used for each meteorological
variable (and LAI and water use).

+-----------------------------------------------------------------------+
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| PREFIXES OF METEO AND VEGETATION RELATED VARIABLES                    |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"PrefixPrecipitation\" value=\"pr\"\>                 |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| prefix precipitation maps                                             |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PrefixTavg\" value=\"ta\"\>                          |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| prefix average temperature maps                                       |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PrefixE0\" value=\"e\"\>                             |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| prefix E0 maps                                                        |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PrefixES0\" value=\"es\"\>                           |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| prefix ES0 maps                                                       |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PrefixET0\" value=\"et\"\>                           |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| prefix ET0 maps                                                       |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PrefixLAI\" value=\"olai\"\>                         |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| prefix LAI maps                                                       |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PrefixLAIForest\" value=\"flai\"\>                   |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| prefix forest LAI maps                                                |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PrefixWaterUse\" value=\"wuse\"\>                    |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| prefix water use maps                                                 |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
+-----------------------------------------------------------------------+

> Each variable is read as a stack of maps. The name of each map starts
> with prefix, and ends with the number of the time step. All characters
> in between are filled with zeroes. The name of each map is made up of
> a total of 11 characters: 8 characters, a dot and a 3-character
> suffix. For instance, using a prefix 'pr' we get:

  pr000000.007   : at time step 7
-------------- ----------------------
  pr000035.260   : at time step 35260

> To avoid unexpected behaviour, **never** use numbers in the prefix!
> For example:
>
> PrefixRain=pr10
>
> For the first time step this yields the following file name:

-------------- --
  pr100000.001   
-------------- --

> But this is actually interpreted as time step 100,000,001!
> **Therefore, do not use numbers in the prefix!**
>
> The corresponding part of the settings file is pretty
> self-explanatory:
>
> *PrefixPrecipitation* is the prefix of the precipitation maps
>
> *PrefixTavg* is the prefix of the daily average temperature maps
>
> *PrefixE0* is the prefix of the potential open-water evaporation maps
>
> *PrefixES0* is the prefix of the potential bare-soil evaporation maps
>
> *PrefixET0* is the prefix of the potential (reference)
> evapotranspiration maps
>
> *PrefixLAI* is the prefix of the Leaf Area Index maps
>
> *PrefixLAIForest* is the prefix of the forest Leaf Area Index maps
>
> *PrefixWaterUse* is the prefix of the water use maps (optional)

Initial conditions
------------------

As with the calibration parameters you can use both maps and single
values to define the catchment conditions at the start of a simulation.
Note that a couple of variables can be initialized internally in the
model (explained below). Also, be aware that the initial conditions
define the state of the model at *t=(StepStart -1)*. As long as
*StepStart* equals 1 this corresponds to *t=0*, but for larger values of
*StepStart* this is (obviously) not the case!

+-----------------------------------------------------------------------+
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| INITIAL CONDITIONS                                                    |
|                                                                       |
| (maps or single values)                                               |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"WaterDepthInitValue\" value=\"0\"\>                  |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| initial overland flow water depth \[mm\]                              |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"SnowCoverAInitValue\" value=\"0\"\>                  |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| initial snow depth in snow zone A \[mm\]                              |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"SnowCoverBInitValue\" value=\"0\"\>                  |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| initial snow depth in snow zone B \[mm\]                              |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"SnowCoverCInitValue\" value=\"0\"\>                  |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| initial snow depth in snow zone C \[mm\]                              |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"FrostIndexInitValue\" value=\"0\"\>                  |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| initial Frost Index value                                             |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"CumIntInitValue\" value=\"0\"\>                      |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| cumulative interception \[mm\]                                        |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"UZInitValue\" value=\"0\"\>                          |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| water in upper store \[mm\]                                           |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"DSLRInitValue\" value=\"1\"\>                        |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| days since last rainfall                                              |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"CumIntSealedInitValue\" value=\"0\"\>                |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| cumulative depression storage \[mm\]                                  |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| The following variables can also be initialized in the model          |
|                                                                       |
| internally. if you want this to happen set them to bogus value of     |
| -9999                                                                 |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"LZInitValue\" value=\"-9999\"\>                      |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| water in lower store \[mm\]                                           |
|                                                                       |
| -9999: use steady-state storage                                       |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"TotalCrossSectionAreaInitValue\" value=\"-9999\"\>   |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| initial cross-sectional area of flow in channel\[m2\]                 |
|                                                                       |
| -9999: use half bankfull                                              |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"ThetaInit1Value\" value=\"-9999\"\>                  |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| initial soil moisture content layer 1                                 |
|                                                                       |
| -9999: use field capacity values                                      |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"ThetaInit2Value\" value=\"-9999\"\>                  |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| initial soil moisture content layer 2                                 |
|                                                                       |
| -9999: use field capacity values                                      |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PrevDischarge\" value=\"-9999\"\>                    |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| initial discharge from previous run for lakes, reservoirs and         |
| transmission loss                                                     |
|                                                                       |
| only needed for lakes reservoirs and transmission loss                |
|                                                                       |
| -9999: use discharge of half bankfull                                 |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
+-----------------------------------------------------------------------+

> *WaterDepthInitValue* is the initial amount of water on the soil
> surface \[mm\]
>
> *SnowCoverInitAValue* is the initial snow cover on the soil surface in
> elevation zone *A* \[mm\]
>
> *SnowCoverInitBValue* is the initial snow cover on the soil surface in
> elevation zone *B* \[mm\]
>
> *SnowCoverInitCValue* is the initial snow cover on the soil surface in
> elevation zone *C* \[mm\]
>
> *FrostIndexInitValue* (*F* in Eq 2-5) initial value of the frost index
> \[°C day^-1^\]
>
> *CumIntInitValue* is the initial interception storage \[mm\]
>
> *UZInitValue* is the initial storage in the upper groundwater zone
> \[mm\]
>
> *DSLRInitValue* (*D~slr~* in Eq 2-20) is the initial number of days
> since the last rainfall event \[days\]
>
> *CumIntSealedInitValue* is the initial value of the depression storage
> for the sealed part of a pixel \[mm\]
>
> *LZInitValue* is the initial storage in the lower groundwater zone
> \[mm\]. In order to avoid initialization problems it is possible to
> let the model calculate a 'steady state' storage that will usually
> minimize any initialization problems. This feature is described in
> detail in Chapter 7 of this User Manual. To activate it, set *the*
> lfoptions element InitLisflood to 1.
>
> *TotalCrossSectionAreaInitValue* is the initial cross-sectional area
> \[m^2^\] of the water in the river channels (a substitute for initial
> discharge, which is directly dependent on this). A value of *-9999*
> sets the initial amount of water in the channel to half bankfull.
>
> *ThetaInit1Value* is the initial moisture content \[mm^3^ mm^-3^\] of
> the upper soil layer. A value of -*9999* will set the initial soil
> moisture content to field capacity.
>
> *ThetaInit2Value* is the initial moisture content \[mm^3^ mm^-3^\] of
> the lower soil layer. A value of -*9999* will set the initial soil
> moisture content to field capacity
>
> *PrevDischarge* is the initial discharge from previous run
> \[m^3^s^-1^\] used for lakes, reservoirs and transmission loss (only
> needed if option is on for lakes or reservoirs or transmission loss).
> Note that PrevDischarge is discharge as an average over the time step
> (a flux) . A value of *-9999* sets the initial amount of discharge to
> equivalent of half bankfull.

+-----------------------------------------------------------------------+
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| INITIAL CONDITIONS FOREST                                             |
|                                                                       |
| (maps or single values)                                               |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"CumIntForestInitValue\" value=\"0\"\>                |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| cumulative interception \[mm\]                                        |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"UZForestInitValue\" value=\"0\"\>                    |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| water in upper store \[mm\]                                           |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"DSLRForestInitValue\" value=\"1\"\>                  |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| days since last rainfall                                              |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"LZForestInitValue\" value=\"-9999\"\>                |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| water in lower store \[mm\]                                           |
|                                                                       |
| -9999: use steady-state storage                                       |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"ThetaForestInit1Value\" value=\"-9999\"\>            |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| initial soil moisture content layer 1                                 |
|                                                                       |
| -9999: use field capacity values                                      |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"ThetaForestInit2Value\" value=\"-9999\"\>            |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| initial soil moisture content layer 2                                 |
|                                                                       |
| -9999: use field capacity values                                      |
|                                                                       |
| \</comment\>                                                          |
+-----------------------------------------------------------------------+

> *CumIntForestInitValue, UZForestInitValue, DSLRForestInitValue,*
> *LZForestInitValue,* *ThetaForestInit1Value, ThetaForestInit2Value
> are* the initial value for the forest part of a pixel

Running the model
-----------------

To run the model, start up a command prompt (Windows) or a console
window (Linux) and type 'lisflood' followed by the name of the settings
file, e.g.:

lisflood settings.xml

If everything goes well you should see something like this:

LISFLOOD version March 01 2013 **PCR2009W2M095**

Water balance and flood simulation model for large catchments

\(C) Institute for Environment and Sustainability

Joint Research Centre of the European Commission

TP261, I-21020 Ispra (Va), Italy

Todo report checking within pcrcalc/newcalc

Created: /nahaUsers/burekpe/newVersion/CWstjlDpeO.tmp

pcrcalc version: Mar 22 2011 (linux/x86\_64)

Executing timestep 1

The LISFLOOD version "March 01 2013 PCR2009W2M095" indicates the date of
the source code (01/03/2013), the oldest PCRASTER version it works with
(PCR2009), the version of XML wrapper (W2) and the model version (M095).

Using options
-------------

As explained in Chapter 5, the 'lfoptions' element gives you additional
control over what LISFLOOD is doing. Using options it is possible to
switch certain parts of the model on or off. This way you can tell the
model exactly which output files are reported and which ones aren't.
Also, they can be used to activate a number of additional model
features, such as the simulation of reservoirs and inflow hydrographs.

The table in Annex 11 lists all currently implemented options and their
corresponding defaults. All currently implemented options are switches
(1= on, 0=off). You can set as many options as you want (or none at
all). Annex 11 lists all currently implemented options. Note that each
option generally requires additional items in the settings file. For
instance, using the inflow hydrograph option requires an input map and
time series, which have to be specified in the settings file. If you
want to report discharge maps at each time step, you will first have to
specify under which name they will be written. The template settings
file that is provided with LISFLOOD always contains file definitions for
all optional output maps and time series. The use of the *output*
options is described in detail in Chapter 8.

Within the 'lfoptions' element of the settings file, each option is
defined using a 'setoption' element, which has the attributes 'name' and
'choice' (i.e. the actual value). For example:

+----------------------------------------------+
| **\<lfoptions\>**                            |
|                                              |
| \<setoption choice=\"1\" name=\"inflow\" /\> |
|                                              |
| **\</lfoptions\>**                           |
+----------------------------------------------+

 7. Initialisation of LISFLOOD
    ==============================

Introduction
------------

Just as any other hydrological model, LISFLOOD needs to have some
estimate of the initial state (i.e. amount of water stored) of its
internal state variables. Two situations can occur:

1.  The initial state of all state variables is known (for example, the
    "end maps" of a daily water balance run are used to define the
    initial conditions of an hourly flood-event run)

2.  The initial state of all state variables is unknown

The second situation is the most common one, and this chapter presents
an in-depth look at the initialisation of LISFLOOD. First the effect of
the model's initial state on the results of a simulation is demonstrated
using a simple example. Then, LISFLOOD's various initialisation options
are discussed. Most of this chapter focuses on the initialisation of the
lower groundwater zone, as this is the model storage component that is
the most difficult to in initialise.

An example
----------

To better understand the impact of the initial model state on simulation
results, let's start with a simple example. Figure 7.1 shows 3 LISFLOOD
simulations of soil moisture for the upper soil layer. In the first
simulation, it was assumed that the soil is initially completely
saturated. In the second one, the soil was assumed to be completely dry
(i.e. at residual moisture content). Finally, a third simulation was
done where the initial soil moisture content was assumed to be in
between these two extremes.

![](media/media/image37.emf){width="5.625in"
height="3.6979166666666665in"}

***Figure 7.1** Simulation of soil moisture in upper soil layer for a
soil that is initially at saturation (s), at residual moisture content
(r) and in between (\[s+r\]/2) *

What is clear from the Figure is that the initial amount of moisture in
the soil only has a marked effect on the start of each simulation; after
a couple of months the three curves converge. In other words, the
"memory" of the upper soil layer only goes back a couple of months (or,
more precisely, for time lags of more than about 8 months the
autocorrelation in time is negligible).

In theory, this behaviour provides a convenient and simple way to
initialise a model such as LISFLOOD. Suppose we want to do a simulation
of the year 1995. We obviously don't know the state of the soil at the
beginning of that year. However, we can get around this by starting the
simulation a bit earlier than 1995, say one year. In that case we use
the year 1994 as a *warm-up* period, assuming that by the start of 1995
the influence of the initial conditions (i.e. 1-1-1994) is negligible.
The very same technique can be applied to initialise LISFLOOD's other
state variables, such as the amounts of water in the lower soil layer,
the upper groundwater zone, the lower groundwater zone, and in the
channel.

Setting up a LISFLOOD run (cold start)
--------------------------------------

When setting up a model run that includes a warm-up period, most of the
internal state variables can be simply set to 0 at the start of the run.
This applies to the initial amount of water on the soil surface
(*WaterDepthInitValue*), snow cover (*SnowCoverInitValue*), frost index
(*FrostIndexInitValue*), interception storage (*CumIntInitValue*), and
storage in the upper groundwater zone (*UZInitValue*). The initial value
of the 'days since last rainfall event' (*DSLRInitValue*) is typically
set to 1.

For the remaining state variables, initialisation is somewhat less
straightforward. The amount of water in the channel (defined by
*TotalCrossSectionAreaInitValue*) is highly spatially variable (and
limited by the channel geometry). The amount of water that can be stored
in the upper and lower soil layers (*ThetaInit1Value*,
*ThetaInit2Value*) is limited by the soil's porosity. The lower
groundwater zone poses special problems because of its overall slow
response (discussed in a separate section below). Because of this,
LISFLOOD provides the possibility to initialise these variables
internally, and these special initialisation methods can be activated by
setting the initial values of each of these variables to a special
'bogus' value of *-9999*. Table 7.1 summarises these special
initialisation methods:

+-----------------------+-----------------------+-----------------------+
| ***Table 7.1**        |
| LISFLOOD special      |
| initialisation        |
| methods^1^*           |
+=======================+=======================+=======================+
| **Variable**          | **Description**       | **Initialisation      |
|                       |                       | method**              |
+-----------------------+-----------------------+-----------------------+
| ThetaInit1Value /     | initial soil moisture | set to soil moisture  |
|                       | content upper soil    | content at field      |
| ThetaForestInit2Value | layer (V/V)           | capacity              |
+-----------------------+-----------------------+-----------------------+
| ThetaInit2Value /     | initial soil moisture | set to soil moisture  |
| ThetaForestInit2Value | content lower soil    | content at field      |
|                       | layer (V/V)           | capacity              |
+-----------------------+-----------------------+-----------------------+
| LZInitValue /         | initial water in      | set to steady-state   |
|                       | lower groundwater     | storage               |
| LZForestInitValue     | zone (mm)             |                       |
+-----------------------+-----------------------+-----------------------+
| TotalCrossSectionArea | initial               | set to half of        |
| InitValue             | cross-sectional area  | bankfull depth        |
|                       | of water in channels  |                       |
+-----------------------+-----------------------+-----------------------+
| PrevDischarge         | Initial discharge     | set to half of        |
|                       |                       | bankfull depth        |
+-----------------------+-----------------------+-----------------------+
| *^1^) These special   |
| initialisation        |
| methods are activated |
| by setting the value  |
| of each respective    |
| variable to a 'bogus' |
| value of "-9999"*     |
+-----------------------+-----------------------+-----------------------+

Note that the "-9999" 'bogus' value can *only* be used with the
variables in Table 7.1; for all other variables they will produce
nonsense results! The initialisation of the lower groundwater zone will
be discussed in the next sections.

Initialisation of the lower groundwater zone
--------------------------------------------

Even though the use of a sufficiently long warm-up period usually
results in a correct initialisation, a complicating factor is that the
time needed to initialise any storage component of the model is
dependent on the average residence time of the water in it. For example,
the moisture content of the upper soil layer tends to respond almost
instantly to LISFLOOD's meteorological forcing variables (precipitation,
evapo(transpi)ration). As a result, relatively short warm-up periods are
sufficient to initialise this storage component. At the other extreme,
the response of the lower groundwater zone is generally very slow
(especially for large values of *T~lz~*). Consequently, to avoid
unrealistic trends in the simulations, very long warm-up periods may be
needed. Figure 7.2 shows a typical example for an 8-year simulation, in
which a decreasing trend in the lower groundwater zone is visible
throughout the whole simulation period. Because the amount of water in
the lower zone is directly proportional to the baseflow in the channel,
this will obviously lead to an unrealistic long-term simulation of
baseflow. Assuming the long-term climatic input is more or less
constant, the baseflow (and thus the storage in the lower zone) should
be free of any long-term trends (although some seasonal variation is
normal). In order to avoid the need for excessive warm-up periods,
LISFLOOD is capable of calculating a 'steady-state' storage amount for
the lower groundwater zone. This *steady state* storage is very
effective for reducing the lower zone's warm-up time. In the next
sections the concept of *steady state* is first explained, and it is
shown how it can be used to speed up the initialisation of a LISFLOOD
run.

![](media/media/image38.emf){width="5.989583333333333in"
height="3.7083333333333335in"}

***Figure 7.2** 8-year simulation of lower zone storage. Note how the
influence of the initial storage persists throughout the simulation
period. *

Lower groundwater zone: steady state storage
--------------------------------------------

The response of the lower groundwater zone is defined by two simple
equations. First, we have the inflow into the lower zone, which occurs
at the following rate \[mm day^-1^\]:

\${D\_{uz,lz}} = \\min (G{W\_{perc}},\\;UZ/\\Delta t)\$ (7-1)

Here, *GW~perc~* \[mm day^-1^\] is a user-defined value (calibration
constant), and *UZ* is the amount of water available in the upper
groundwater zone \[mm\]. The rate of flow out of the lower zone \[mm
day^-1^\] equals:

\${Q\_{lz}} = \\frac{1}{{{{\\rm{T}}\_{{\\rm{lz}}}}}} \\cdot LZ\$ (7-2)

where *T~lz~* is a reservoir constant \[days\], and *LZ* is the amount
of water that is stored in the lower zone \[mm\].

Now, let's do a simple numerical experiment: assuming that *D~uz,lz~* is
a constant value, we can take some arbitrary initial value for *LZ* and
then simulate (e.g. in a spreadsheet) the development over *LZ* over
time. Figure 7.3 shows the results of 2 such experiments. In the upper
Figure, we start with a very high initial storage (1500 mm). The inflow
rate is fairly small (0.2 mm/day), and *T~lz~* is quite small as well
(which means a relatively short residence time of the water in the lower
zone). What is interesting here is that, over time, the storage evolves
asymptotically towards a constant state. In the lower Figure, we start
with a much smaller initial storage (50 mm), but the inflow rate is much
higher here (1.5 mm/day) and so is *T~lz~* (1000 days). Here we see an
upward trend, again towards a constant value. However, in this case the
constant 'end' value is not reached within the simulation period, which
is mainly because *T~lz~* is set to a value for which the response is
very slow.

At this point it should be clear that what you see in these graphs is
exactly the same behaviour that is also apparent in the 'real' LISFLOOD
simulation in Figure 7.2. Being able to know the 'end' storages in
Figure 7.3 in advance would be very helpful, because it would eliminate
any trends. As it happens, this can be done very easily from the model
equations. A storage that is constant over time means that the in- and
outflow terms balance each other out. This is known as a *steady state*
situation, and the constant 'end' storage is in fact the *steady state
storage*. The rate of change of the lower zone's storage at any moment
is given by the continuity equation:

\$\\frac{{dLZ}}{{dt}} = I(t) - O(t)\$ (7-3)

where *I* is the (time dependent) inflow (i.e. groundwater recharge) and
*O* is the outflow rate. For a situation where the storage remains
constant, we can write:

\$\\frac{{dLZ}}{{dt}} = 0\\quad \\Leftrightarrow \\quad I(t) - O(t) =
0\$ (7-4)

![](media/media/image39.emf){width="5.447916666666667in"
height="7.40625in"}

***Figure 7.3** Two 10-year simulations of lower zone storage with
constant inflow. Upper Figure: high initial storage, storage approaches
steady-state storage (dashed) after about 1500 days. Lower Figure: low
initial storage, storage doesn't reach steady-state within 10 years.*

This equation can be re-written as:

\$I(t) - \\frac{1}{{{{\\rm{T}}\_{{\\rm{lz}}}}}} \\cdot LZ = 0\$ (7-5)

Solving this for *LZ* gives the steady state storage:

\$L{Z\_{ss}} = {{\\rm{T}}\_{{\\rm{lz}}}} \\cdot I(t)\$ (7-6)

We can check this for our numerical examples:

  *T~lz~*   *I*   *LZ~ss~*
--------- ----- ----------
  250       0.2   50
  1000      1.5   1500

which corresponds exactly to the results of Figure 7.3.

Steady-state storage in practice
--------------------------------

An actual LISFLOOD simulation differs from the previous example in 2
ways. First, in any real simulation the inflow into the lower zone is
not constant, but varies in time. This is not really a problem, since
*LZ~ss~* can be computed from the *average* recharge. However, this is
something we do not know until the end of the simulation! Also, the
inflow into the lower zone is controlled by the availability of water in
the upper zone, which, in turn, depends on the supply of water from the
soil. Hence, it is influenced by any calibration parameters that control
behaviour of soil- and subsoil (e.g. *T~uz~*, *GW~perc~*, *b*, and so
on). This means that --when calibrating the model- the average recharge
will be different for every parameter set. Note, however, that it will
*always* be smaller than the value of *GW~perc~*, which is used as an
upper limit in the model.. Note that the pre-run procedures include a
sufficiently long warm-up period.

### 

### Use pre-run to calculate average recharge

Here, we first do a "pre-run" that is used to calculate the average
inflow into the lower zone. This average inflow can be reported as a
map, which is then used in the actual run. This involves the following
steps:

1.  Set all the initial conditions to either 0,1 or -9999

2.  Activate the "InitLisflood" option by setting it active in the
    'lfoptions' in the settings file:

> \<setoption choice=\"1\" name=\"InitLisflood\"/\>

3.  Run the model for a longer period (if possible more than 3 years,
    best for the whole modelling period)

4.  Go back to the LISFLOOD settings file, and set the InitLisflood
    inactive:

> \<setoption choice=\"0\" name=\"InitLisflood\"/\>

5.  Run the model again using the modified settings file

In this case, the initial state of *LZ* is computed for the correct
average inflow, and the simulated storage in the lower zone throughout
the simulation shouldl not show any systematic (long-term) trends. The
obvious price to pay for this is that the pre-run increase the
computational load. However the pre-run will use a simplified routing to
decrease the computational run-time. As long as the simulation period
for the actual run and the pre-run are identical, the procedure gives a
100% guarantee that the development of the lower zone storage will be
free of any systematic bias. Since the computed recharge values are
dependent on the model parameterisation used, in a calibration setting
the whole procedure must be repeated for each parameter set!

### Checking the lower zone initialisation 

The presence of any initialisation problems of the lower zone can be
checked by adding the following line to the 'lfoptions' element of the
settings file:

> \<setoption name=\" repStateUpsGauges\" choice=\"1\"\>\</setoption\>

This tells the model to write the values of all state variables
(averages, upstream of contributing area to each gauge) to time series
files. The default name of the lower zone time series is 'lzUps.tss'.
Figure 7.4 shows an example of an 8-year simulation that was done both
without (dashed line) and with a pre-run. The simulation without the
pre-run shows a steady decreasing trend throughout the 8-year period,
whereas the simulation for which the pre-run was used doesn't show this
long-term trend (although in this specific case a modest increasing
trend is visible throughout the first 6 years of the simulation, but
this is related to trends in the meteorological input).

![initLZDemo](media/media/image40.png){width="5.770833333333333in"
height="3.2395833333333335in"}

***Figure 7.4** Initialisation of lower groundwater zone with and
without using a pre-run. Note the strong decreasing trend in the
simulation without pre-run. *

Using a previous run (warm start)
---------------------------------

At the end of each model run, LISFLOOD writes maps of all internal state
variables at the last time step. You can use these maps as the initial
conditions for a succeeding simulation. This is particularly useful if
you are simulating individual flood events on a small time interval
(e.g. hourly). For instance, to estimate the initial conditions just
before the flood you can do a 'pre-run' on a *daily* time interval for
the year before the flood. You can then use the 'end maps' as the
initial conditions for the hourly simulation.

In any case, you should be aware that values of some internal state
variables of the model (especially lower zone storage) are very much
dependent on the parameterisation used. Hence, suppose we have 'end
maps' that were created using some parameterisation of the model (let's
say parameter set *A*), then these maps should *not* be used as initial
conditions for a model run with another parameterisation (parameter set
*B*). If you decide to do this anyway, you are likely to encounter
serious initialisation problems (but these may not be immediately
visible in the output!). If you do this while calibrating the model
(i.e. parameter set *B* is the calibration set), this will render the
calibration exercise pretty much useless (since the output is the result
of a mix of different parameter sets). However, for
*FrostIndexInitValue* and *DSLRInitValue* it is perfectly safe to use
the 'end maps', since the values of these maps do not depend on any
calibration parameters (that is, only if you do not calibrate on any of
the frost-related parameters!). If you need to calibrate for individual
events (i.e.hourly), you should apply *each* parameterisation on *both*
the (daily) pre-run and the 'event' run! This may seem awkward, but
there is no way of getting around this (except from avoiding event-based
calibration at all, which may be a good idea anyway).

Summary of LISFLOOD initialisation procedure
--------------------------------------------

From the foregoing it is clear that the initialisation of LISFLOOD can
be done in a number of ways. Figure 7.5 gives an overview. As already
stated in the introduction section, any LISFLOOD simulation will fall
into either of the following two categories:

1. The initial state of all state variables is known and defined by the
    end state of a previous run. In this case you can use the 'end' maps
    of the previous run's state variables as the initial conditions of
    you current run. Note that this requires that both simulations are
    run using exactly the same parameter set! Mixing parameter sets here
    will introduce unwanted artefacts into your simulation results.

2. The initial state of all state variables is unknown. In this case
    > you should run the model with a sufficient pre-run (if possible
    > more than 3 years, best for the whole modelling period) and
    > InitLisflood=1. The average recharge map that is generated from
    > the pre-run can subsequently be used as the average lower zone
    > inflow estimate (*LZAvInflowEstimate*) in the actual simulation,
    > which will avoid any initialisation problems of the lower
    > groundwater zone

3. Is it possible not to use the first year for further analysis of
    > results, because this is the "warm-up" period for all the other
    > variables like snow, vegetation, soil (see e.g. figure 7.1 for
    > soil moisture)?\
    > Then leave or set all the initial conditions to either 0,1 or
    > -9999 and run the model with InitLisflood=0

4. If you want to include the first year of modelling into your
    analysis, you have to do a "warm-up" run (one year will usually do)
    to initialize all the initial conditions. You have to set option
    repEndMaps=1 to report end maps. Best possible solution is to use
    the year before the actual modelling period. Second best is to use
    any one year period to set up the initial conditions. After that you
    will have the 'end' maps and you can proceed with 1. again

![](media/media/image41.emf){width="5.760416666666667in"
height="4.322916666666667in"}

***Figure 7.5** LISFLOOD initialisation flowchart *

*\
*

 8. Output generated by LISFLOOD
    ================================

Default LISFLOOD output
-----------------------

LISFLOOD can generate a wide variety of output. Output is generated as
either maps or time series (PCRaster format, which can be visualised
with PCRaster's 'aguila' application). Reporting of output files can be
switched on and off using options in the LISFLOOD settings file. Also, a
number of output files are specific to other optional modules, such as
the simulation of reservoirs. The following table lists all the output
time series that are reported by default (note that the file names can
always be changed by the user, although this is not recommended):

+-----------------------+-----------------------+-----------------------+
| ***Table 8.1**        |
| LISFLOOD default      |
| output time series*   |
+-----------------------+-----------------------+-----------------------+
| **RATE VARIABLES AT   |                       |                       |
| GAUGES**              |                       |                       |
+-----------------------+-----------------------+-----------------------+
| **Description**       | **Units**             | **File name**         |
+-----------------------+-----------------------+-----------------------+
| **^1,2^** channel     | m^3^ s^-1^            | dis.tss               |
| discharge             |                       |                       |
+-----------------------+-----------------------+-----------------------+
| **NUMERICAL CHECKS**  |                       |                       |
+-----------------------+-----------------------+-----------------------+
| **Description**       | **Units**             | **File name**         |
+-----------------------+-----------------------+-----------------------+
| **^2^** cumulative    | m^3^                  | mbError.tss           |
| mass balance error    |                       |                       |
+-----------------------+-----------------------+-----------------------+
| **^2^** cumulative    | mm                    | mbErrorMm.tss         |
| mass balance error,   |                       |                       |
| expressed as mm water |                       |                       |
| slice (average over   |                       |                       |
| catchment)            |                       |                       |
+-----------------------+-----------------------+-----------------------+
| **^2^** number of     | \-                    | NoSubStepsChannel.tss |
| sub-steps needed for  |                       |                       |
| channel routing       |                       |                       |
+-----------------------+-----------------------+-----------------------+
| **^2^** number of     | \-                    | steps.tss             |
| sub-steps needed for  |                       |                       |
| gravity-based soil    |                       |                       |
| moisture routine      |                       |                       |
+-----------------------+-----------------------+-----------------------+
| **^1^** Output only   |
| if option             |
| 'InitLisflood' = 1    |
| (pre-run)             |
|                       |
| **^2^** Output only   |
| if option             |
| 'InitLisflood' = 0    |
+-----------------------+-----------------------+-----------------------+

To speed up the pre-run and to prevent that results are taken from the
pre-run, all additional output is disabled if option 'InitLisflood' = 1
is chosen. With 'InitLisflood' = 1 the output is limited to *dis.tss,
lzavin.map, lzavin\_forest.map* and some other initial maps if
additional option like e.g. the double kinematic wave is chosen.

In addition to these time series, by default LISFLOOD reports maps of
all state variables at the last timestep of a simulation[^5]. These maps
can be used to define the initial conditions of a succeeding simulation.
For instance, you can do a 1-year simulation on a daily time step, and
use the 'end maps' of this simulation to simulate a flood event using an
hourly time step. Table 8.2 and Annex 13 list all these maps. Note that
some state variables are valid for the whole pixel, whereas others are
only valid for a sub-domain of each pixel. This is indicated in the last
column of the table.

+-----------------+-----------------+-----------------+-----------------+
| ***Table 8.2**  |
| LISFLOOD        |
| default state   |
| variable output |
| maps. These     |
| maps can be     |
| used to define  |
| the initial     |
| conditions of   |
| another         |
| simulation*     |
+-----------------+-----------------+-----------------+-----------------+
| **AVERAGE       |
| RECHARGE MAP    |
| (for lower      |
| groundwater     |
| zone)** (option |
| InitLisflood)   |
+-----------------+-----------------+-----------------+-----------------+
| **Description** | **Units**       | **File name**   | **Domain**      |
+-----------------+-----------------+-----------------+-----------------+
| **^1^** average | mm timestep^-1^ | lzavin.map      | other fraction  |
| inflow to lower |                 |                 |                 |
| zone            |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^1^** average | mm timestep^-1^ | lzavin\_forest. | forest fraction |
| inflow to lower |                 | map             |                 |
| zone (forest)   |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **INITIAL       |
| CONDITION MAPS  |
| at defined time |
| steps**[^8]     |
| (option         |
| *repStateMaps*) |
+-----------------+-----------------+-----------------+-----------------+
| **Description** | **Units**       | **File          | **Domain**      |
|                 |                 | name**[^9]      |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^**         | mm              | wdepth00.xxx    | whole pixel     |
| waterdepth      |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** channel | m^2^            | chcro000.xxx    | channel         |
| cross-sectional |                 |                 |                 |
| area            |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** days    | days            | dslr0000.xxx    | other pixel     |
| since last rain |                 |                 |                 |
| variable        |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** snow    | mm              | scova000.xxx    | snow zone A     |
| cover zone *A*  |                 |                 | (1/3^rd^ pixel) |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** snow    | mm              | scovb000.xxx    | snow zone B     |
| cover zone *B*  |                 |                 | (1/3^rd^ pixel) |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** snow    | mm              | scovc000.xxx    | snow zone C     |
| cover zone *C*  |                 |                 | (1/3^rd^ pixel) |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** frost   | °C days^-1^     | frost000.xxx    | other pixel     |
| index           |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^**         | mm              | cumi0000.xxx    | other pixel     |
| cumulative      |                 |                 |                 |
| interception    |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** soil    | mm^3^ mm^-3^    | thtop000.xxx    | other fraction  |
| moisture upper  |                 |                 |                 |
| layer           |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** soil    | mm^3^ mm^-3^    | thsub000.xxx    | other fraction  |
| moisture lower  |                 |                 |                 |
| layer           |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** water   | mm              | lz000000.xxx    | other fraction  |
| in lower zone   |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** water   | mm              | uz000000.xxx    | other fraction  |
| in upper zone   |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** days    | days            | dslF0000.xxx    | forest pixel    |
| since last rain |                 |                 |                 |
| variable        |                 |                 |                 |
| (forest)        |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^**         | mm              | cumF0000.xxx    | forest pixel    |
| cumulative      |                 |                 |                 |
| interception    |                 |                 |                 |
| (forest)        |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** soil    | mm^3^ mm^-3^    | thFt0000.xxx    | forest fraction |
| moisture upper  |                 |                 |                 |
| layer (forest)  |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** soil    | mm^3^ mm^-3^    | thFs0000.xxx    | forest fraction |
| moisture lower  |                 |                 |                 |
| layer (forest)  |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** water   | mm              | lzF00000.xxx    | forest fraction |
| in lower zone   |                 |                 |                 |
| (forest)        |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** water   | mm              | uzF00000.xxx    | forest fraction |
| in upper zone   |                 |                 |                 |
| (forest)        |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** water   | mm              | cseal000.xxx    | sealed fraction |
| in depression   |                 |                 |                 |
| storage         |                 |                 |                 |
| (sealed)        |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^1^** Output  |
| only if option  |
| 'InitLisflood'  |
| = 1 (pre-run)   |
|                 |
| **^2^** Output  |
| only if option  |
| 'InitLisflood'  |
| = 0             |
+-----------------+-----------------+-----------------+-----------------+

Additional output
-----------------

Apart from the default output, the model can --optionally- generate some
additional time series and maps. Roughly this additional output falls in
either of the following categories:

**Time series**

1.  Time series with values of model state variables at user-defined
    locations (sites); reporting of these time series can be activated
    using the option *repStateSites=1.* Note that 'sites' can be either
    individual pixels or larger areas (e.g. catchments, administrative
    areas, and so on). In case of larger areas the model reports the
    average value for each respective area.

2.  Time series with values of model rate variables at user-defined
    locations (sites); reporting of these time series can be activated
    using the option *repRateSites=1*

3.  Time series with values of meteorological input variables, averaged
    over the area upstream of each gauge location; reporting of these
    time series can be activated using the option *repMeteoUpsGauges=1*

4.  Time series with values of model state variables, averaged over area
    upstream of each gauge location; reporting of these time series can
    be activated using the option *repStateUpsGauges=1*

5.  Time series with values of model rate variables, averaged over area
    upstream of each gauge location; reporting of these time series can
    be activated using the option *repRateUpsGauges=1*

6.  Time series that are specific to other options (e.g. simulation of
    reservoirs).

**Maps**

1.  Maps of discharge at each time step; reporting of these maps can be
    activated using the option *repDischargeMaps=1*

2.  Maps with values of driving meteorological values at each time step

3.  Maps with values of model rate variables at each time step

4.  Maps that are specific to other options (e.g. simulation of
    reservoirs).

In addition, some additional maps and time series may be reported for
debugging purposes. In general these are not of any interest to the
LISFLOOD user, so they remain undocumented here.

Note that the options *repStateUpsGauges*, *repRateUpsGauges* and
*repDischargeMaps* tend to slow down the execution of the model quite
dramatically. For applications of the model where performance is
critical (e.g. automated calibration runs), we advise to keep them
switched off, if possible. The additional time series are listed in the
Annex 13. Note again the domains for which variables are valid: all
*rate variables* are reported as pixel-average values. Soil moisture and
groundwater storage are reported for the permeable fraction of each
pixel only. The reported snow cover is the average of the snow depths in
snow zones A, B and C.

By default, the names of the reported discharge maps start with the
prefix '*dis*' and end with the time step number (the naming conventions
are identical to the ones used for the input maps with meteorological
variables, which is explained in Chapter 4). Annex 13 summarises all
options to report additional output maps. The previous remarks related
to the domains for which the state variable values are valid also apply
to the maps listed in Annex 13.

 References
===========

Anderson, 2006Anderson, E., 2006. *Snow Accumulation and Ablation Model
-- SNOW-17*. Technical report.

Aston, A.R., 1979. Rainfall interception by eight small trees. Journal
of Hydrology 42, 383-396.

Bódis, 2009Bódis, K., 2009. *Development of a data set for continental
hydrologic modelling*. Technical Report EUR 24087 EN JRC Catalogue
number: LB-NA-24087-EN-C, Institute for Environment and Sustainability,
Joint Research Centre of the European Commission Land Management and
Natural Hazards Unit Action FLOOD. Input layers related to topography,
channel geometry, land cover and soil characteristics of European and
African river basins.

Chow, V.T., Maidment, D.R., Mays, L.M., 1988. Applied Hydrology,
McGraw-Hill, Singapore, 572 pp.

De Roo, A., Thielen, J., Gouweleeuw, B., 2003. LISFLOOD, a Distributed
Water-Balance, Flood Simulation, and Flood Inundation Model, User Manual
version 1.2. Internal report, Joint Research Center of the European
Communities, Ispra, Italy, 74 pp.

Fröhlich, W., 1996. Wasserstandsvorhersage mit dem Prgramm ELBA.
Wasserwirtschaft Wassertechnik, ISSN: 0043-0986, Nr. 7, 1996, 34-37.

Goudriaan, J., 1977. Crop micrometeorology: a simulation study.
Simulation Monographs. Pudoc, Wageningen.

Hock, 2003Hock, R., 2003. Temperature index melt modelling in mountain
areas. *Journal of Hydrology*, 282(1-4), 104--115.

Lindström, G., Johansson, B., Persson, M., Gardelin, M., Bergström, S.,
1997. Development and test of the distributed HBV-96 hydrological model.
     Journal of Hydrology 201, 272-288.

Maidment, D.R. (ed.), 1993. Handbook of Hydrology, McGraw-Hill.

Martinec, J., Rango, A., Roberts, R.T., 1998. Snowmelt Runoff Model
(SRM) User\'s Manual (Updated Edition 1998, Version 4.0). Geographica
Bernensia, Department of Geography - University of Bern, 1999. 84pp.

Merriam, R.A., 1960. A note on the interception loss equation. Journal
of Geophysical Research 65, 3850-3851.

Molnau, M., Bissell, V.C., 1983. A continuous frozen ground index for
flood forecasting. In: Proceedings 51^st^ Annual Meeting Western Snow
Conference, 109-119.

Rao, C.X. and Maurer, E.P., 1996. A simplified model for predicting
daily transmission losses in a stream channel. Water Resources Bulletin,
Vol. 31, No. 6., 1139-1146.

Speers, D.D. , Versteeg, J.D., 1979. Runoff forecasting for reservoir
operations -- the past and the future. In: Proceedings 52^nd^ Western
Snow Conference, 149-156.

Stroosnijder, L., 1982. Simulation of the soil water balance. In:
Penning de Vries, F.W.T., Van Laar, H.H. (eds), Simulation of Plant
Growth and Crop Production, Simulation Monographs, Pudoc, Wageningen,
pp. 175-193.

Stroosnijder, L., 1987. Soil evaporation: test of a practical approach
under semi-arid conditions. Netherlands Journal of Agricultural Science
35, 417-426.

Supit I., A.A. Hooijer, C.A. van Diepen (eds.), 1994. System Description
of the WOFOST 6.0 Crop Simulation Model Implemented in CGMS. Volume 1:
Theory and Algorithms. EUR 15956, Office for Official Publications of
the European Communities, Luxembourg.

Supit, I. , van der Goot, E. (eds.), 2003. Updated System Description of
the WOFOST Crop Growth Simulation Model as Implemented in the Crop
Growth Monitoring System Applied by the European Commission, Treemail,
Heelsum, The Netherlands, 120 pp.

Todini, E., 1996. The ARNO rainfall----runoff model. Journal of
Hydrology 175, 339-382.

Van Der Knijff, J., De Roo, A., 2006. LISFLOOD -- Distributed Water
Balance and Flood Simulation Model, User Manual. EUR 22166 EN, Office
for Official Publications of the European Communities, Luxembourg, 88
pp.

Van der Knijff, J., 2008. LISVAP-- Evaporation Pre-Processor for the
LISFLOOD Water Balance and Flood Simulation Model, Revised User Manual.
EUR 22639 EN/2, Office for Official Publications of the European
Communities, Luxembourg, 31 pp.

Van Der Knijff, J., De Roo, A., 2008. LISFLOOD -- Distributed Water
Balance and Flood Simulation Model, Revised User Manual. EUR 22166 EN/2,
Office for Official Publications of the European Communities,
Luxembourg, 109 pp.

van der Knijff, J. M., Younis, J. and de Roo, A. P. J.: LISFLOOD: A
GIS-based distributed model for river basin scale water balance and
flood simulation, Int. J. Geogr. Inf. Sci., 24(2), 189--212, 2010.

Van Genuchten, M.Th., 1980. A closed-form equation for predicting the
hydraulic conductivity of unsaturated soils. Soil Science Society of
America Journal 44, 892-898.

Viviroli et al., 2009Viviroli, D., Zappa, M., Gurtz, J., & Weingartner,
R., 2009. An introduction to the hydrological modelling system PREVAH
and its pre- and post-processing-tools. *Environmental Modelling &
Software*, 24(10), 1209--1222.

Vogt et al., 2007Vogt, J., Soille, P., de Jager, A., Rimaviciute, E.,
Mehl, W., Foisneau, S., Bodis, K., Dusart, M., Parachini, M., Hasstrup,
P.,2007. *A pan-European River and Catchment Database*. JRC Reference
Report EUR 22920 EN, Institute for Environment and Sustainability, Joint
Research Centre of the European Commission.

Von Hoyningen-Huene, J., 1981. Die Interzeption des Niederschlags in
landwirtschaftlichen Pflanzenbeständen (Rainfall interception in
agricultural plant stands). In: Arbeitsbericht Deutscher Verband für
Wasserwirtschaft und Kulturbau, DVWK, Braunschweig, p.63.

Wesseling, C.G., Karssenberg, D., Burrough, P.A. , Van Deursen, W.P.A.,
1996. Integrating dynamic environmental models in GIS: The development
     of a Dynamic Modelling language. Transactions in GIS 1, 40-48.

World Meteorological Organization, 1986. Intercomparison of models of
snowmelt runoff. Operational Hydrology Report No. 23.

Young, G.J. (ed), 1985. Techniques for prediction of runoff from
glacierized areas. IAHS Publication 149, Institute of Hydrology,
Wallingford.

Zhao, R.J., Liu, X.R., 1995. The Xinanjiang model. In: Singh, V.P.
(ed.), Computer Models of Watershed Hydrology, pp. 215-232.

Annex 1: Simulation of reservoirs
=================================

Introduction
------------

This annex describes the LISFLOOD reservoirs routine, and how it is
used. The simulation of reservoirs is *optional*, and it can be
activated by adding the following line to the 'lfoptions' element:

\<setoption name=\"simulateReservoirs\" choice=\"1\" /\>

Reservoirs can be simulated on channel pixels where kinematic wave
routing is used. The routine does *not* work for channel stretches where
the dynamic wave is used!

Description of the reservoir routine 
-------------------------------------

Reservoirs are simulated as points in the channel network. The inflow
into each reservoir equals the channel flow upstream of the reservoir.
The outflow behaviour is described by a number of parameters. First,
each reservoir has a total storage capacity *S* \[m^3^\]. The relative
filling of a reservoir, *F*, is a fraction between 0 and 1. There are
three 'special' filling levels. First, each reservoir has a 'dead
storage' fraction, since reservoirs never empty completely. The
corresponding filling fraction is the 'conservative storage limit',
*L~c~*. For safety reasons a reservoir is never filled to the full
storage capacity. The 'flood storage limit' (*L~f~*) represents this
maximum allowed storage fraction. The buffering capacity of a reservoir
is the storage available between the 'flood storage limit' and the
'normal storage limit' (*L~n~*). Three additional parameters define the
way the outflow of a reservoir is regulated. For e.g. ecological reasons
each reservoir has a 'minimum outflow' (*O~min~*, \[m^3^ s^-1^\]). For
high discharge situations, the 'non-damaging outflow' (*O~nd~*, \[m^3^
s^-1^\]) is the maximum possible outflow that will not cause problems
downstream. The 'normal outflow' (*O~norm~*, \[m^3^ s^-1^\]) is valid
once the reservoir reaches its 'normal storage' filling level.

Depending on the relative filling of the reservoir, outflow ($O_{res},[\frac{m^3}{s}]$) is calculated as:

$O_{res} = min (O_{min} ,\frac{1}{\Delta t} {\cdot F\cdot S) \ ; F \le 2 \cdot L_c}$

$O_{res} = O_{min } + (O_{norm} - O_{min}) \cdot \frac{(F - 2L_c)}{(L_n - 2L_c)}    ; L_n \ge F \gt 2L_c$

$O_{res} = O_{norm} + \frac{(F - L_n)}{(L_f - L_n)} \cdot \max((I_{res} - O_{norm}),(O_{nd} - O_{norm})); L_f \ge F \gt L_n$

$O_{res} = \max (\frac{(F - L_f)}{\Delta t} \cdot S,O_{nd}) ; F \gt L_f$

with:

  S         : Reservoir storage capacity $[m^3]$
  F         : Reservoir fill (fraction, 1 at total storage capacity) \[-\]
  L~c~      : Conservative storage limit \[-\]
  L~n~      : Normal storage limit \[-\]
  L~f~      : Flood storage limit \[-\]
  O~min~    : Minimum outflow \[m^3^ s^-1^\]
  O~norm~   : Normal outflow \[m^3^ s^-1^\]
  O~nd~     : Non-damaging outflow \[m^3^ s^-1^\]
  I~res~    : Reservoir inflow \[m^3^ s^-1^\]

In order to prevent numerical problems, the reservoir outflow is
calculated using a user-defined time interval (or *Δt*, if it is smaller
than this value).

Preparation of input data 
--------------------------

For the simulation of reservoirs a number of addition input files are
necessary. First, the locations of the reservoirs are defined on a
(nominal) map called '*res.map*'. It is important that all reservoirs
are located on a channel pixel (you can verify this by displaying the
reservoirs map on top of the channel map). Also, since each reservoir
receives its inflow from its upstream neighbouring channel pixel, you
may want to check if each reservoir has any upstream channel pixels at
all (if not, the reservoir will gradually empty during a model run!).
The management of the reservoirs is described by 7 tables. The following
table lists all required input:

+-------------+-------------+-------------+-------------+-------------+
| ***Table    |
| A1.1**      |
| Input       |
| requirement |
| s           |
| reservoir   |
| routine*    |
+-------------+-------------+-------------+-------------+-------------+
| **Maps**    | **Default   | **Descripti | **Units**   | **Remarks** |
|             | name**      | on**        |             |             |
+-------------+-------------+-------------+-------------+-------------+
| ReservoirSi | res.map     | reservoir   | \-          | nominal     |
| tes         |             | locations   |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| **Tables**  | **Default   | **Descripti | **Units**   | **Remarks** |
|             | name**      | on**        |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabTotStora | rtstor.txt  | reservoir   | m^3^        |             |
| ge          |             | storage     |             |             |
|             |             | capacity    |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabConserva | rclim.txt   | conservativ | \-          | fraction of |
| tiveStorage |             | e           |             |             |
| Limit       |             | storage     |             | storage     |
|             |             | limit       |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabNormalSt | rnlim.txt   | normal      | \-          | capacity    |
| orageLimit  |             | storage     |             |             |
|             |             | limit       |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabFloodSto | rflim.txt   | flood       | \-          |             |
| rageLimit   |             | storage     |             |             |
|             |             | limit       |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabMinOutfl | rminq.txt   | minimum     | m^3^/s      |             |
| owQ         |             | outflow     |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabNormalOu | rnormq.txt  | normal      | m^3^/s      |             |
| tflowQ      |             | outflow     |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabNonDamag | rndq.txt    | non-damagin | m^3^/s      |             |
| ingOutflowQ |             | g           |             |             |
|             |             | outflow     |             |             |
+-------------+-------------+-------------+-------------+-------------+

When you create the map with the reservoir sites, pay special attention
to the following: if a reservoir is on the most downstream cell (i.e.
the outflow point, see Figure A1.1), the reservoir routine may produce
erroneous output. In particular, the mass balance errors cannot be
calculated correctly in that case. The same applies if you simulate only
a sub-catchment of a larger map (by selecting the subcatchment in the
mask map). This situation can usually be avoided by extending the mask
map by one cell in downstream direction.

![reservoirPlacementNew](media/media/image42.png){width="4.75in"
height="2.125in"}

*Figure A1.1 Placement of the reservoirs: reservoirs on the outflow
point (left) result in erroneous behavior of the reservoir routine.*

Preparation of settings file
----------------------------

All in- and output files need to be defined in the settings file. If you
are using a default LISFLOOD settings template, all file definitions are
already defined in the 'lfbinding' element. Just make sure that the map
with the reservoir locations is in the "maps" directory, and all tables
in the 'tables" directory. If this is the case, you only have to specify
the time-step used for the reservoir calculations and the initial
reservoir filling level (expressed as a fraction of the storage
capacity). Both are defined in the 'lfuser' element of the settings
file. For the reservoir time step (*DtSecReservoirs*) it is recommended
to start with a value of 14400 (4 hours), and try smaller values if the
simulated reservoir outflow shows large oscillations.
*ReservoirInitialFillValue* can be either a map or a value (between 0
and 1). So we add this to the 'lfuser' element (if it is not there
already):

+-----------------------------------------------------------------------+
| \<group\>                                                             |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| RESERVOIR OPTION                                                      |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"DtSecReservoirs\" value=\"14400\"\>                  |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Sub time step used for reservoir simulation \[s\]. Within the model,  |
|                                                                       |
| the smallest out of DtSecReservoirs and DtSec is used.                |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"ReservoirInitialFillValue\" value=\"-9999\"\>        |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Initial reservoir fill fraction                                       |
|                                                                       |
| -9999 sets initial fill to normal storage limit                       |
|                                                                       |
| if you\'re not using the reservoir option, enter some bogus value     |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \</group\>                                                            |
+-----------------------------------------------------------------------+

The value -9999 tells the model to set the initial reservoir fill to the
normal storage limit. Note that this value is completely arbitrary.
However, if no other information is available this may be a reasonable
starting point.

Finally, you have to tell LISFLOOD that you want to simulate reservoirs!
To do this, add the following statement to the 'lfoptions' element:

\<setoption name=\"simulateReservoirs\" choice=\"1\" /\>

Now you are ready to run the model. If you want to compare the model
results both with and without the inclusion of reservoirs, you can
switch off the simulation of reservoirs either by:

1.  Removing the 'simulateReservoirs' statement from the 'lfoptions
    element, or

2.  changing it into \<setoption name=\"simulateReservoirs\"
    choice=\"0\" /\>

Both have exactly the same effect. You don't need to change anything in
either 'lfuser' or 'lfbinding'; all file definitions here are simply
ignored during the execution of the model.

Reservoir output files
----------------------

The reservoir routine produces 3 additional time series and one map, as
listed in the following table:

---------------------------------------------- ------------------ --------------------------------------- ----------- -------------
  ***Table A1.2** Output of reservoir routine*                                                                          
  **Maps**                                       **Default name**   **Description**                         **Units**   **Remarks**
  ReservoirFillState                             rsfilxxx.xxx       reservoir fill at last time step[^10]   \-          
                                                                                                                        
  **Time series**                                **Default name**   **Description**                         **Units**   **Remarks**
  ReservoirInflowTS                              qresin.tss         inflow into reservoirs                  m^3^/s      
  ReservoirOutflowTS                             qresout.tss        outflow out of reservoirs               m^3^/s      
  ReservoirFillTS                                resfill.tss        reservoir fill                          \-          
---------------------------------------------- ------------------ --------------------------------------- ----------- -------------

Note that you can use the map with the reservoir fill at the last time
step to define the initial conditions of a succeeding simulation, e.g.:

\<textvar name=\"ReservoirInitialFillValue\"
value=\"/mycatchment/rsfil000.730\"\>

Annex 2: Polder option 
=======================

Introduction
------------

This annex describes the LISFLOOD polder routine, and how it is used.
The simulation of polders is *optional*, and it can be activated by
adding the following line to the 'lfoptions' element:

\<setoption name=\"simulatePolders\" choice=\"1\" /\>

Polders can be simulated on channel pixels where dynamic wave routing is
used. The routine does *not* work for channel stretches where the
kinematic wave is used!

Description of the polder routine 
----------------------------------

Polders are simulated as points in the channel network. The polder
routine is adapted from Förster et. al (2004), and based on the weir
equation of Poleni (Bollrich & Preißler, 1992). The flow rates from the
channel to the polder area and vice versa are calculated by balancing
out the water levels in the channel and in the polder, as shown in
Figure A2.1.

![polders](media/image43.png)

*Figure A2.1 Schematic overview of the simulation of polders.* pb *is the polder bottom level (above the channel bottom);* w~c~ *is the water level in the channel;* h~c~ *and* h~p~ *are the water levels above the
polder in- / outflow, respectively*



From the Figure, it is easy to see that there can be three situations:

1.  ***h~c~* \> *h~p~***: water flows out of the channel, into the polder. The flow rate, *q~c,p~*, is calculated using:

> $\begin{array}{|} q_{c,p} = \mu \cdot c \cdot b \cdot  \sqrt{2g} \cdot h_c^{3/2} \\ c = \sqrt{1 - [\frac{h_p}{h_c}]^{16}}\end{array}$ (A2.1)
>
> where *b* is the outflow width \[m\], *g* is the acceleration due to gravity (9.81 m s^-2^) and *μ* is a weir constant which has a value of 0.49. Furthermore *q~c,p~* is in \[m^3^ s^-1^\].

2.  ***h~c~* \< *h~p~***: water flows out of the polder back into the
    channel. The flow rate, *q~p,c~*, is now calculated using:

> $\begin{array}{|} q_{p,c} = \mu \cdot c \cdot b\sqrt{2g} \cdot h_p^{3/2} \\  c = \sqrt {1 - [\frac{h_c}{h_p}]^{16}}\end{array}$ (A2.2)
>

3.  ***h~c~* = *h~p~***: no water flowing into either direction (note here that the minimum value of *h~c~* is zero). In this case both *q~c,p~* and *q~p,c~* are zero.

Regulated and unregulated polders
---------------------------------

The above equations are valid for *unregulated* polders. It is also
possible to simulated *regulated* polders, which is illustrated in
Figure A2.2. Regulated polders are opened at a user-defined time
(typically during the rising limb of a flood peak). The polder closes
automatically once it is full. Subsequently, the polder is opened again
to release the stored water back into the channel, which also occurs at
a user-defined time. The opening- and release times for each polder are
defined in two lookup tables (see Table 2.1). In order to simulate the
polders in *unregulated* mode these times should both be set to a bogus
value of -9999. *Only* if *both* opening- and release time are set to
some other value, LISFLOOD will simulate a polder in regulated mode.
Since LISFLOOD only supports *one* single regulated open-close-release
cycle per simulation, you should use regulated mode *only* for single
flood events. For continuous simulations (e.g. long-tem waterbalance
runs) you should only run the polders in unregulated mode.

![poldersRegulated](media/media/image44.png){width="5.395833333333333in"
height="3.3958333333333335in"}

*Figure A2.2 Simulation of a regulated polder. Polder is closed
(inactive) until user-defined opening time, after which it fills up to
its capacity (flow rate according to Eq A2.1). Water stays in polder
until user-defined release time, after which water is released back to
the channel (flow rate according to Eq A2.2). *

Preparation of input data 
--------------------------

The locations of the reservoirs are defined on a (nominal) map called
'*polders.map*'. Any polders that are *not* on a channel pixel are
ignored by LISFLOOD, so you may want to check the polder locations
before running the model (you can do this by displaying the reservoirs
map on top of the channel map). The current implementation of the polder
routine may result in numerical instabilities for kinematic wave pixels,
so for the moment it is recommended to define polders *only* on channels
where the dynamic wave is used. Furthermore, the properties of each
polder are described using a number of tables. All required input is
listed in the following table:

+-------------+-------------+-------------+-------------+-------------+
| ***Table    |
| A2.1**      |
| Input       |
| requirement |
| s           |
| polder      |
| routine*    |
+-------------+-------------+-------------+-------------+-------------+
| **Maps**    | **Default   | **Descripti | **Units**   | **Remarks** |
|             | name**      | on**        |             |             |
+-------------+-------------+-------------+-------------+-------------+
| PolderSites | polders.map | polder      | \-          | nominal     |
|             |             | locations   |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| **Tables**  | **Default   | **Descripti | **Units**   | **Remarks** |
|             | name**      | on**        |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabPolderAr | poldarea.tx | polder area | m^2^        |             |
| ea          | t           |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabPolderOF | poldofw.txt | polder in-  | m           |             |
| Width       |             | and outflow |             |             |
|             |             | width       |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabPolderTo | poldcap.txt | polder      | m^3^        |             |
| talCapacity |             | storage     |             |             |
|             |             | capacity    |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabPolderBo | poldblevel. | Bottom      | m           |             |
| ttomLevel   | txt         | level of    |             |             |
|             |             | polder,     |             |             |
|             |             | measured    |             |             |
|             |             | from        |             |             |
|             |             | channel     |             |             |
|             |             | bottom      |             |             |
|             |             | level (see  |             |             |
|             |             | also Figure |             |             |
|             |             | A4.1)       |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabPolderOp | poldtopen.t | Time at     | time        |             |
| eningTime   | xt          | which       |             |             |
|             |             | polder is   | step        |             |
|             |             | opened      |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabPolderRe | poldtreleas | Time at     | time        |             |
| leaseTime   | e.txt       | which water |             |             |
|             |             | stored in   | step        |             |
|             |             | polder is   |             |             |
|             |             | released    |             |             |
|             |             | again       |             |             |
+-------------+-------------+-------------+-------------+-------------+

Note that the polder opening- and release times are both defined a *time
step* numbers (*not* days or hours!!). For *unregulated* polders, set
both parameters to a bogus value of -9999, i.e.:

+----------+
| 10 -9999 |
|          |
| 15 -9999 |
|          |
| 16 -9999 |
|          |
| 17 -9999 |
+----------+

Preparation of settings file
----------------------------

All in- and output files need to be defined in the settings file. If you
are using a default LISFLOOD settings template, all file definitions are
already defined in the 'lfbinding' element. Just make sure that the map
with the polder locations is in the "maps" directory, and all tables in
the 'tables" directory. If this is the case, you only have to specify
the initial reservoir water level in the polders.
*PolderInitialLevelValue* is defined in the 'lfuser' element of the
settings file, and it can be either a map or a value. The value of the
weir constant *μ* is also defined here, although you should not change
its default value. So we add this to the 'lfuser' element (if it is not
there already):

+-----------------------------------------------------------------------+
| \<group\>                                                             |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| POLDER OPTION                                                         |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"mu\" value=\"0.49\"\>                                |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Weir constant \[-\] (Do not change!)                                  |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PolderInitialLevelValue\" value=\"0\"\>              |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Initial water level in polder \[m\]                                   |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \</group\>                                                            |
+-----------------------------------------------------------------------+

To switch on the polder routine, add the following line to the
'lfoptions' element:

\<setoption name=\"simulatePolders\" choice=\"1\" /\>

Now you are ready to run the model. If you want to compare the model
results both with and without the inclusion of polders, you can switch
off the simulation of polders either by:

3.  Removing the 'simulatePolders' statement from the 'lfoptions
    element, or

4.  changing it into \<setoption name=\"simulatePolders\" choice=\"0\"
    /\>

Both have exactly the same effect. You don't need to change anything in
either 'lfuser' or 'lfbinding'; all file definitions here are simply
ignored during the execution of the model.

Polder output files
-------------------

The polder routine produces 2 additional time series and one map (or
stack of maps, depending on the value of LISFLOOD variable
*ReportSteps*), as listed in the following table:

------------------------------------------- ------------------ ------------------------------------------------------------------------------------------------------------------ ----------- -------------
  ***Table A2.2** Output of polder routine*                                                                                                                                                     
  **Maps**                                    **Default name**   **Description**                                                                                                    **Units**   **Remarks**
  PolderLevelState                            hpolxxxx.xxx       water level in polder at last time step[^11]                                                                       m           
                                                                                                                                                                                                
  **Time series**                             **Default name**   **Description**                                                                                                    **Units**   **Remarks**
  PolderLevelTS                               hPolder.tss        water level in polder (at polder locations)                                                                        m           
  PolderFluxTS                                qPolder.tss        Flux into and out of polder (positive for flow from channel to polder, negative for flow from polder to channel)   m^3^/s      
------------------------------------------- ------------------ ------------------------------------------------------------------------------------------------------------------ ----------- -------------

Note that you can use the map with the polder level at the last time
step to define the initial conditions of a succeeding simulation, e.g.:

\<textvar name=\"PolderInitialLevelValue\"
value=\"/mycatchment/hpol0000.730\"\>

Limitations
-----------

For the moment, polders can be simulated on channel pixels where dynamic
wave routing is used. For channels where the kinematic wave is used, the
routine will not work and may lead to numerical instabilities or even
model crashes. This limitation may be resolved in future model versions.

Annex 3: Simulation of lakes
============================

Introduction
------------

This annex describes the LISFLOOD lake routine, and how it is used. The
simulation of lakes is *optional*, and it can be activated by adding the
following line to the 'lfoptions' element:

\<setoption name=\"simulateLakes\" choice=\"1\" /\>

Lakes can be simulated on channel pixels where kinematic wave routing is
used. The routine does *not* work for channel stretches where the
dynamic wave is used!

Description of the lake routine 
--------------------------------

Lakes are simulated as points in the channel network. Figure A3.1 shows
all computed in- and outgoing fluxes. Lake inflow equals the channel
flow upstream of the lake location. The flow out of the lake is computed
using the following rating curve (e.g. Maidment, 1992):

\${O\_{lake}} = A{(H - {H\_0})\^B}\$

  O~lake~   : Lake outflow rate \[m^3^ s^-1^\]
--------- ---------------------------------------------------
  H         : Water level in lake \[m\]
  H~0~      : Water level at which lake outflow is zero \[m\]
  A, B      : Constants \[-\]

![lakes](media/media/image45.png){width="5.375in"
height="3.5104166666666665in"}

*Figure A3.1 Schematic overview of the simulation of lakes.* H~0~ *is
the water level at which the outflow is zero;* H *is the water level in
the lake and* EW *is the evaporation from the lake*

Both *H* and *H~0~* can be defined relative to an arbitrary reference
level. Since the outflow is a function of the *difference* between both
levels, the actual value of this reference level doesn't matter if *H*
\> *H~0~*. However, it is advised to define both *H* and *H~0~* relative
to the *average bottom level* of the lake. This will result in more
realistic simulations during severe drought spells, when the water level
drops below *H~0~* (in which case lake outflow ceases). The value of
constant *A* can be approximated by the width of the lake outlet in
meters, and *B* is within the range 1.5-2 (reference?). Lake evaporation
occurs at the potential evaporation rate of an open water surface.

Initialisation of the lake routine
----------------------------------

Because lakes (especially large ones) tend to produce a relatively slow
response over time, it is important to make sure that the initial lake
level is set to a more or less sensible value. Just as is the case with
the initialisation of the lower groundwater zone, LISFLOOD has a special
option that will compute a steady-state lake level and use this as the
initial value. The steady-state level is computed from the water balance
of the lake. If *V~l~* is the total lake volume \[m^3^\], the rate of
change of *V~l~* at any moment is given by the continuity equation:

\$\\frac{{d{V\_l}}}{{dt}} = I(t) - O(t)\$

where *I* and *O* are the in- and outflow rates, respectively. For a
steady-state situation the storage remains constant, so:

\$\\frac{{d{V\_l}}}{{dt}} = 0\\quad \\Leftrightarrow \\quad I(t) - O(t)
= 0\$

Substituting all in- and outflow terms gives:

$I_l - EW_l - A \cdot (H - H_0)^B = 0$

where *I~l~* is the inflow into the lake and *EW~l~* the lake
evaporation (both expressed in m^3^ s^-1^). Re-arranging gives the
steady-state lake level:

$H_{ss} = H_0 + \frac{I_l - EW_l}{A}^{1/B}$

LISFLOOD calculates the steady-state lake level based on a user-defined
average net inflow (=*I~l~* -- *EW~l~*). The average net inflow can be
estimated using measured discharge and evaporation records. If measured
discharge is available just *downstream* of the lake (i.e. the
*outflow*), the (long-term) average outflow can be used as the net
inflow estimate (since, for a steady state situation, inflow equals
outflow). If only inflow is available, all average inflows should be
summed, and the average lake evaporation should be subtracted from this
figure. Table A3.1 gives a worked example. Be aware that the calculation
can be less straightforward for very large lakes with multiple inlets
(which are not well represented by the current point approach anyway).

+-----------------------------------------------------------------------+
| **Table A3.1: Calculation of average net lake inflow **               |
|                                                                       |
| *Lake characteristics*                                                |
|                                                                       |
| lake area: 215•10^6^ m^2^                                             |
|                                                                       |
| mean annual discharge downstream of lake: 293 m^3^ s^-1^              |
|                                                                       |
| mean annual discharge upstream of lake: 300 m^3^ s^-1^                |
|                                                                       |
| mean annual evaporation: 1100 mm yr^-1^                               |
|                                                                       |
| *Calculation of average net inflow*                                   |
|                                                                       |
| **METHOD 1: USING AVERAGE OUTFLOW**                                   |
|                                                                       |
| assuming lake is in quasi steady-state:                               |
|                                                                       |
| > average net inflow = average net outflow = [293 m^3^                |
| > s^-1^]{.underline}                                                  |
|                                                                       |
| **METHOD 2: USING AVERAGE INFLOW AND EVAPORATION**                    |
|                                                                       |
| Only use this method if no outflow data are available                 |
|                                                                       |
| 1.  **Express lake evaporation in m^3^ s^-1^:**                       |
|                                                                       |
| > 1100 mm yr^-1^ / 1000 = 1.1 m yr^-1^                                |
| >                                                                     |
| > 1.1 m yr^-1^ x 215•10^6^ m^2^ = 2.37•10^8^ m^3^ yr^-1^              |
| >                                                                     |
| > 2.37•10^8^ m^3^ yr^-1^ / (365 days x 86400 seconds) = [7.5 m^3^     |
| > s^-1^]{.underline}                                                  |
|                                                                       |
| 2.  **Compute net inflow:**                                           |
|                                                                       |
| > net inflow = 300 m^3^ s^-1^ -- 7.5 m^3^ s^-1^ = [292.5 m^3^         |
| > s^-1^]{.underline}                                                  |
+-----------------------------------------------------------------------+

Preparation of input data 
--------------------------

The lake locations defined on a (nominal) map called '*lakes.map*'. It
is important that all reservoirs are located on a channel pixel (you can
verify this by displaying the reservoirs map on top of the channel map).
Also, since each lake receives its inflow from its upstream neighbouring
channel pixel, you may want to check if each lake has any upstream
channel pixels at all (if not, the lake will just gradually empty during
a model run!). The lake characteristics are described by 4 tables. Table
3.2 lists all required input.

When you create the map with the lake locations, pay special attention
to the following: if a lake is located on the most downstream cell (i.e.
the outflow point, see Figure A3.2), the lake routine may produce
erroneous output. In particular, the mass balance errors cannot be
calculated correctly in that case. The same applies if you simulate only
a sub-catchment of a larger map (by selecting the subcatchment in the
mask map). This situation can usually be avoided by extending the mask
map by one cell in downstream direction.

-------------------------------------------------- ------------------ ------------------------------------------- ----------- ---------------------------------------
  ***Table A3.2** Input requirements lake routine*                                                                              
  **Maps**                                           **Default name**   **Description**                             **Units**   **Remarks**
  LakeSites                                          lakes.map          lake locations                              \-          nominal
                                                                                                                                
  **Tables**                                         **Default name**   **Description**                             **Units**   **Remarks**
  TabLakeArea                                        lakearea.txt       lake surface area                           m^2^        
  TabLakeH0                                          lakeh0.txt         water level at which lake outflow is zero   m           relative to average lake bottom level
  TabLakeA                                           lakea.txt          lake parameter A                            \-          ≈ outlet width in meters
  TabLakeB                                           lakeb.txt          lake parameter B                            \-          1.5-2
-------------------------------------------------- ------------------ ------------------------------------------- ----------- ---------------------------------------

![reservoirPlacementNew](media/media/image42.png){width="4.75in"
height="2.125in"}

*Figure A3.2 Placement of the lakes: lakes on the outflow point (left)
result in erroneous behavior of the lake routine.*

Preparation of settings file
----------------------------

All in- and output files need to be defined in the settings file. If you
are using a default LISFLOOD settings template, all file definitions are
already defined in the 'lfbinding' element. Just make sure that the map
with the lake locations is in the "maps" directory, and all tables in
the 'tables" directory. If this is the case, you only have to specify
the initial lake level and --if you are using the steady-state option-
the mean net lake inflow (make this a map if you're simulating multiple
lakes simultaneously). Both can be set in the 'lfuser' element.
*LakeInitialLevelValue* can be either a map or a single value. Setting
*LakeInitialLevelValue* to *-9999* will cause LISFLOOD to calculate the
steady-state level. So we add this to the 'lfuser' element (if it is not
there already):

+-----------------------------------------------------------------------+
| \<group\>                                                             |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| LAKE OPTION                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"LakeInitialLevelValue\" value=\"-9999\"\>            |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Initial lake level \[m\]                                              |
|                                                                       |
| -9999 sets initial value to steady-state level                        |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"LakeAvNetInflowEstimate\" value=\"292.5\"\>          |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Estimate of average net inflow into lake (=inflow -- evaporation)     |
| \[cu m / s\]                                                          |
|                                                                       |
| Used to calculated steady-state lake level in case                    |
| LakeInitialLevelValue                                                 |
|                                                                       |
| is set to -9999                                                       |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \</group\>                                                            |
+-----------------------------------------------------------------------+

Finally, you have to tell LISFLOOD that you want to simulate lakes! To
do this, add the following statement to the 'lfoptions' element:

\<setoption name=\"simulateLakes\" choice=\"1\" /\>

Now you are ready to run the model. If you want to compare the model
results both with and without the inclusion of lakes, you can switch off
the simulation of lakes either by:

5.  Removing the 'simulateLakes' statement from the 'lfoptions element,
    or

6.  changing it into \<setoption name=\"simulateLakes\" choice=\"0\" /\>

Both have exactly the same effect. You don't need to change anything in
either 'lfuser' or 'lfbinding'; all file definitions here are simply
ignored during the execution of the model.

Lake output files
-----------------

The lake routine produces 4 additional time series and one map (or
stack), as listed in the following table:

----------------------------------------- ------------------ ----------------------------------- ----------- -------------
  ***Table A3.3** Output of lake routine*                                                                      
  **Maps**                                  **Default name**   **Description**                     **Units**   **Remarks**
  LakeLevelState                            lakhxxxx.xxx       lake level at last time step[^12]   m           
                                                                                                               
  **Time series**                           **Default name**   **Description**                     **Units**   **Remarks**
  LakeInflowTS                              qLakeIn.tss        inflow into lakes                   m^3^/s      
  LakeOutflowTS                             qLakeOut.tss       flow out of lakes                   m^3^/s      
  LakeEWTS                                  EWLake.tss         lake evaporation                    mm          
  LakeLevelTS                               hLake.tss          lake level                          m           
----------------------------------------- ------------------ ----------------------------------- ----------- -------------

Note that you can use the map with the lake level at the last time step
to define the initial conditions of a succeeding simulation, e.g.:

\<textvar name=\"LakeInitialLevelValue\"
value=\"/mycatchment/lakh0000.730\"\>

[]{#_Toc353538887 .anchor}**Annex 4: Inflow hydrograph option**

Introduction
------------

This annex describes the LISFLOOD inflow hydrograph routine, and how it
is used. Inflow hydrographs are *optional*, and can be activated by
adding the following line to the 'lfoptions' element:

\<setoption name=\"inflow\" choice=\"1\" /\>

Description of the inflow hydrograph routine
--------------------------------------------

When using the inflow hydrograph option, time series of discharge
\[m^3^/s\] are added at some user-defined location(s) on the channel
network. The inflow is added as side-flow in the channel routing
equations (this works for both kinematic and dynamic wave). *Negative*
inflows (i.e. outflows) are also possible, but large outflow rates may
sometimes result in numerical problems in the routing equations. If you
use a negative inflow rate, we advise to carefully inspect the model
output for any signs of numerical problems (i.e. strange oscillations in
simulated discharge, generation of missing values). Also check the mass
balance time series after your simulation (numerical problems often
result in unusually large mass balance errors).

Using inflow hydrographs 
-------------------------

The table below lists the input requirements for the inflow hydrograph
option. All you need is a map that defines where you want to add the
inflow, and a time series with the corresponding inflow rates.

--------------------------------------------------------------- ------------------ ---------------------------------- ----------- -------------
  ***Table A4.1** Input requirements inflow hydrograph routine*                                                                     
  **Maps**                                                        **Default name**   **Description**                    **Units**   **Remarks**
  InflowPoints                                                    \-                 locations for inflow hydrographs   \-          nominal
                                                                                                                                    
  **Time series**                                                 **Default name**   **Description**                    **Units**   **Remarks**
  QInTS                                                           \-                 inflow hydrograph(s)               m^3^/s      
--------------------------------------------------------------- ------------------ ---------------------------------- ----------- -------------

Using the inflow hydrograph option involves four steps:

1.  Create a (nominal) PCRaster map with unique identifiers that point
    to the location(s) where you want to insert the inflow hydrograph(s)

2.  Save the inflow hydrograph(s) in PCRaster time series format; inflow
    hydrographs need to be given in \[m^3^ s^-1^\]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  **IMPORTANT**: PCRaster assumes that the first data series in the time series file (i.e. the second column, since the first column contains the time step number) corresponds to unique identifier 1 on the *InflowPoints* map; the second series to unique identifier 2, and so on. So, even if your *InflowPoints* map only contains (as an example) identifiers 3 and 4, you *still need to include the columns for identifiers 1 and 2*!! The best thing to do in such a case is to fill any unused columns with zeroes (0). Also, your inflow hydrograph time series should always start at *t=1*, even if you set *StepStart* to some higher value. For more info on time series files please have a look at the PCRaster documentation.
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

3.  Make sure that the names of the map and time series are defined in
    the settings file

In the 'lfuser' element (replace the file paths/names by the ones you
want to use):

+-----------------------------------------------------------------------+
| \<group\>                                                             |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| INFLOW HYDROGRAPH (OPTIONAL)                                          |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"InflowPoints\"                                       |
|                                                                       |
| value=\"/floods2/yourhomedir/yourcatchment/maps/inlets.map\"\>        |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| OPTIONAL: nominal map with locations of (measured)                    |
|                                                                       |
| inflow hydrographs \[cu m / s\]                                       |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"QInTS\"                                              |
|                                                                       |
| value=\"/floods2/yourhomedir/yourcatchment/inflow/inflow.tss\"\>      |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| OPTIONAL: observed or simulated input hydrographs as                  |
|                                                                       |
| time series \[cu m / s\]                                              |
|                                                                       |
| Note that identifiers in time series correspond to                    |
|                                                                       |
| InflowPoints map (also optional)                                      |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \</group\>                                                            |
+-----------------------------------------------------------------------+

4.  Activate the inflow hydrograph option

Add the following line to the 'lfoptions' element:

\<setoption name=\"inflow\" choice=\"1\" /\>

Now you are ready to run the model with the inflow hydrograph.

Substituting subcatchments with measured inflow hydrographs
-----------------------------------------------------------

One of the most common uses of the inflow hydrograph option is this:
suppose we have a catchment where we only want to simulate the
downstream part. If measured time series of discharge are available for
the upstream catchment(s), we can use these to represent the inflow into
the more downstream part. Figure A4.1 shows an example, where we have
measured discharge of subcatchment *A* (just before it enters the main
river). In this case it is important to pay special attention to two
issues.

### Exclude subcatchments from MaskMap 

First, make sure that subcatchment *A* is *excluded* (i.e. have
boolean(0) or missing value) on LISFLOOD's *MaskMap* (which defines
which pixels are included in the calculations and which are not). If you
include it, LISFLOOD will first *simulate* discharge coming out of
subcatchment *A*, and then *add* the (measured) inflow on top of it! Of
course this doesn't make any sense, so always be careful which areas are
included in your simulation and which are not.

![](media/media/image46.emf){width="6.0in" height="4.333333333333333in"}

*Figure A4.1 Using the inflow hydrograph using measured discharge of
subcatchment A. MaskMap must have boolean(0) (or missing value) for
subcatchment A, see text for explanation.*

### Make sure your inflow points are where you need them

If you already have all gauge locations on a PCRaster map, these mostly
cannot be used directly as inflow hydrograph locations. The reason is
simple: suppose --in our previous example-- we know the outflow point of
subcatchment *A*. This point is the most downstream point within that
subcatchment. However, the flow out of subcatchment *A* is actually
added to the main river one cell downstream! Also, if we exclude
subcatchment *A* from our simulation (as explained in the foregoing),
this means we also exclude the outflow point of that subcatchment.
Because of this, *inflow* points into the main river are usually located
one pixel downstream of the *outflow* points of the corresponding
subcatchment. If you already have a (nominal) map of of your
subcatchments, a PCRaster script exists that automatically calculates
the corresponding out- and inflow points.

[]{#_Toc353538894 .anchor}**Annex 5: Double kinematic wave option**

Introduction
------------

This annex describes the LISFLOOD double kinematic wave routine, and how
it is used. Double kinematic wave routing is *optional*, and can be
activated by adding the following line to the 'lfoptions' element:

\<setoption name=\"SplitRouting\" choice=\"1\" /\>

Background
----------

The flow routing is done by the kinematic wave approach. Therefore two
equations have to be solved:

\$\\frac{{\\partial Q}}{{\\partial x}} + \\frac{{\\partial
A}}{{\\partial t}} = q\$ \$\\rho {\\kern 1pt} gA({S\_0} - {S\_f}) = 0\$
where \$A = \\alpha \\cdot {Q\^\\beta }\$

continuity equation momentum equation as expressed by Chow et al. 1988

Which decreasing inflow the peaks of the resulting outflow will be later
in time (see figure A5.1 for a simple kinematic wave calculation). The
wave propagation slows down because of more friction on the boundaries.

![](media/media/image47.emf){width="5.864583333333333in"
height="2.75in"}

**Figure A5.1** Simulated outflow for different amount of inflow\
wave propagation gets slower

This is realistic if your channel looks like in figure A5.2:

![](media/media/image48.emf){width="2.05in"
height="1.5270833333333333in"}![](media/media/image49.emf){width="1.9465277777777779in"
height="1.45in"}

**Figure A5.2** Schematic cross section of a channel with different
water level

But a natural channel looks more like this:

![](media/media/image50.emf){width="4.033333333333333in"
height="1.617361111111111in"}

**Figure A5.3** Schematic cross section of a natural channel

Which means, opposite to the kinematic wave theory, the wave propagation
gets slower as the discharge is increasing, because friction is going up
on floodplains with shrubs, trees, bridges. Some of the water is even
stored in the floodplains (e.g. retention areas, seepage retention). As
a result of this, a single kinematic wave cannot cover these different
characteristics of floods and floodplains.

Double kinematic wave approach
------------------------------

The double kinematic approach splits up the channel in two parts (see
figure A5.4):

1\. bankful routing

2\. over bankful routing

![](media/media/image54.emf){width="3.142361111111111in"
height="1.3833333333333333in"}![](media/media/image55.emf){width="1.95in"
height="1.375in"}

F**igure A5.4** Channel is split in a bankful and over bankful routing

Similar methods are used since the 1970s e.g. as multiple linear or non
linear storage cascade (Chow, 1988). The former forecasting model for
the River Elbe (ELBA) used a three stages approach depending on
discharge (Fröhlich, 1996).

Using double kinematic wave 
----------------------------

No additional maps or tables are needed for initializing the double
kinematic wave. A normal run ('InitLisflood'=0) requires an additional
map derived from the prerun ('InitLisflood'=1). A 'warm' start (using
initial values from a previous run) requires two additional maps with
state variables for the second (over 'bankful' routing).

+-------------+-------------+-------------+-------------+-------------+
| ***Table    |
| A5.1**      |
| Input/outpu |
| t           |
| double      |
| kinematic   |
| wave*       |
+-------------+-------------+-------------+-------------+-------------+
| **Maps**    | **Default   | **Descripti | **Units**   | **Remarks** |
|             | name**      | on**        |             |             |
+-------------+-------------+-------------+-------------+-------------+
| Average     | avgdis.map  | Average     | m^3^/s      | Produced by |
| discharge   |             | discharge   |             | prerun      |
+-------------+-------------+-------------+-------------+-------------+
| CrossSectio | ch2cr000.xx | channel     | m^2^        | Produced by |
| n2Area\     | x           | crosssectio |             | option      |
| InitValue   |             | n           |             |             |
|             |             | for 2nd     |             | 'repStateMa |
|             |             | routing     |             | ps'         |
|             |             | channel     |             | or          |
|             |             |             |             |             |
|             |             |             |             | 'repEndMaps |
|             |             |             |             | '           |
+-------------+-------------+-------------+-------------+-------------+
| PrevSideflo | chside00.xx | sideflow    | mm          |             |
| wInitValue  | x           | into the    |             |             |
|             |             | channel     |             |             |
+-------------+-------------+-------------+-------------+-------------+

Using the double kinematic wave approach option involves three steps:

1.  In the 'lfuser' element (replace the file paths/names by the ones
    you want to use):

+------------------------------------------------------------------------+
| \</textvar\>                                                           |
|                                                                        |
| \<textvar name=\"CalChanMan2\" value=\"8.5\"\>                         |
|                                                                        |
| \<comment\>                                                            |
|                                                                        |
| Channel Manning\'s n for second line of routing                        |
|                                                                        |
| \</comment\>                                                           |
|                                                                        |
| \</textvar\>                                                           |
|                                                                        |
| \<textvar name=\"QSplitMult\" value=\"2.0\"\>                          |
|                                                                        |
| \<comment\>                                                            |
|                                                                        |
| Multiplier applied to average Q to split into a second line of routing |
|                                                                        |
| \</comment\>                                                           |
|                                                                        |
| \</textvar\>                                                           |
+------------------------------------------------------------------------+

> *CalChanMan2* is a multiplier that is applied to the Manning's
> roughness maps of the over bankful routing \[-\]
>
> *QSplitMult* is a factor to the average discharge to determine the
> bankful discharge. The average discharge map is produced in the
> initial run (the initial run is already needed to get the groundwater
> storage) . Standard is set to 2.0 (assuming over bankful discharge
> starts at 2.0·average discharge).

2.  Activate the transmission loss option

Add the following line to the 'lfoptions' element:

\<setoption name=\"SplitRouting\" choice=\"1\" /\>

3. Run LISFLOOD first with

    \<setoption name=\"InitLisflood\" choice=\"1\" /\>

and it will produce a map of average discharge \[m^3^/s\] in the initial
folder. This map is used together with the QSplitMult factor to set the
value for the second line of routing to start.

For a 'warm start' these initial values are needed (see also table A5.1)

+-----------------------------------------------------------------+
| \<textvar name=\"CrossSection2AreaInitValue\" value=\"-9999\"\> |
|                                                                 |
| \<comment\>                                                     |
|                                                                 |
| initial channel crosssection for 2nd routing channel            |
|                                                                 |
| -9999: use 0                                                    |
|                                                                 |
| \</comment\>                                                    |
|                                                                 |
| \</textvar\>                                                    |
|                                                                 |
| \<textvar name=\"PrevSideflowInitValue\" value=\"-9999\"\>      |
|                                                                 |
| \<comment\>                                                     |
|                                                                 |
| initial sideflow for 2nd routing channel                        |
|                                                                 |
| -9999: use 0                                                    |
|                                                                 |
| \</comment\>                                                    |
|                                                                 |
| \</textvar\>                                                    |
+-----------------------------------------------------------------+

> *CrossSection2AreaInitValue* is the initial cross-sectional area
> \[m^2^\] of the water in the river channels (a substitute for initial
> discharge, which is directly dependent on this). A value of *-9999*
> sets the initial amount of water in the channel to 0.
>
> *PrevSideflowInitValue* is the initial inflow from each pixel to the
> channel \[mm\]. A value of *-9999* sets the initial amount of sideflow
> to the channel to 0.

Automatic change of the number of sub steps (optional)
------------------------------------------------------

For the new method the kinematic wave has to be applied two times.

The calculation of kinematic wave is the most time consuming part in a
LISFLOOD run (in general but also depending on the catchment). The use
of the double kinematic wave makes it necessary to calculate the
kinematic wave two times and increasing the computing time. To
counteract this, an option is put in place to change automatically the
number of sub steps for channel routing.

Double kinematic wave routing is *optional*, and can be activated by
adding the following line to the 'lfoptions' element:

\<setoption name=\"VarNoSubStepChannel\" choice=\"1\" /\>

This will calculate the number of sub steps for the kinematic wave
according to the discharge. Less number of steps for low and average
flow condition, more sub steps for flooding condition because the higher
velocity of water.

Activating this option needs to be done before the prerun
('InitLisflood'=1) because the maximum celerity of wave propagation
(chanckinmax.map) is created as another initial map and used in the
'normal' runs.

The minimum and maximum number of sub steps can be set in the settings
file:

+-----------------------------------------------------------------------+
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| Variable Channel NoSubStepChannel                                     |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"UpLimit\" value=\"1.0E+9\"\>                         |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Upstream area do be included in max. celerity                         |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"MinNoStep\" value=\"5\"\>                            |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| minimum number of sub steps for channel                               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"ChanA\" value=\"30\"\>                               |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| max. NoSubStepsChannel = ChanA-ChanB                                  |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"ChanB\" value=\"10\"\>                               |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| For calculating the min. No. of substeps                              |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
+-----------------------------------------------------------------------+

> *UpLimit* is the minimum upstream area do be included in the
> calculation of the maximum celerity of wave propagation \[m^2^\]
>
> *MinNoStep* is the absolute minimum number of sub steps for channel
> routing \[-\]
>
> *ChanA* for calculating the maximum number of sub steps for channel
> routing \[-\]
>
> *ChanB* for calculating the minimum number of sub steps for channel
> routing \[-\]

[]{#_Toc353538900 .anchor}**Annex 6: Dynamic wave option**

Introduction
------------

This annex describes the LISFLOOD dynamic wave routine, and how it is
used. The current implementation of the dynamic wave function in
PCRaster is not a complete dynamic wave formulation according to the
summary of the Saint Venant equations as discussed in Chow (1988). The
implementation currently consists of the friction force term, the
gravity force term and the pressure force term and should therefore be
correctly characterised as a diffusion wave formulation. The equations
are solved as an explicit, finite forward difference scheme. A
straightforward iteration using an Euler solution scheme is used to
solve these equations. Dynamic wave routing is *optional*, and can be
activated by adding the following line to the 'lfoptions' element:

\<setoption name=\"dynamicWave\" choice=\"1\" /\>

Time step selection
-------------------

The current dynamic wave implementation requires that all equations are
solved using a time step that is much smaller (order of magnitude:
seconds-minutes) than the typical overall time step used by LISFLOOD
(order of magnitude: hours-day). More specifically, during one (sub)
time step no water should be allowed to travel more than 1 cell
downstream, i.e.:

\$\\Delta \'{t\_{dyn}} \\le \\frac{{\\Delta x}}{{V + {c\_d}}}\$

where *∆'t~dyn~* is the sub-step for the dynamic wave \[seconds\], *∆x*
is the length of one channel element (pixel) \[m\], *V* is the flow
velocity \[m s^-1^\] and *c~d~* is dynamic wave celerity \[m s^-1^\].
The dynamic wave celerity can be calculated as (Chow, 1988):

\${c\_d} = \\sqrt {gy} \$

where *g* is the acceleration by gravity \[m s^-2^\] and *y* is the
depth of flow \[m\]. For a cross-section of a regular geometric shape,
*y* can be calculated from the channel dimensions. Since the current
dynamic wave routine uses irregularly shaped cross-section data, we
simply assume than *y* equals the water level above the channel bed. The
flow velocity is simply:

\$V = {Q\_{ch}}/A\$

where *Q~ch~* is the discharge in the channel \[m^3^ s^-1^\], and *A*
the cross-sectional area \[m^2^\].

The Courant number for the dynamic wave, *C~dyn~*, can now be computed
as:

$C_{dyn} = \frac{(V + c_d)\Delta t}{\Delta x}$

where *∆t* is the overall model time step \[s\]. The number of sub-steps
is then given by:

$SubSteps = \max (1,roundup(\frac{C_{dyn}}{C_{dyn,crit}}))$

where *C~dyn,crit~* is the critical Courant number. The maximum value of
the critical Courant number is 1; in practice it is safer to use a
somewhat smaller value (although if you make it too small the model
becomes excessively slow). It is recommended to stick to the default
value (0.4) that is used the settings file template.

Input data 
-----------

A number of addition input files are necessary to use the dynamic wave
option. First, the channel stretches for which the dynamic wave is to be
used are defined on a Boolean map. Next, a cross-section identifier map
is needed that links the (dynamic wave) channel pixels to the
cross-section table (see further on). A channel bottom level map
describes the bottom level of the channel (relative to sea level).
Finally, a cross-section table describes the relationship between water
height (*H*), channel cross-sectional area (*A*) and wetted perimeter
(*P*) for a succession of *H* levels.

The following table lists all required input:

+-------------+-------------+-------------+-------------+-------------+
| ***Table    |
| A6.1**      |
| Input       |
| requirement |
| s           |
| dynamic     |
| wave        |
| routine*    |
+-------------+-------------+-------------+-------------+-------------+
| **Maps**    | **Default   | **Descripti | **Units**   | **Remarks** |
|             | name**      | on**        |             |             |
+-------------+-------------+-------------+-------------+-------------+
| ChannelsDyn | chandyn.map | dynamic     | \-          | Boolean     |
| amic        |             | wave        |             |             |
|             |             | channels    |             |             |
|             |             | (1,0)       |             |             |
+-------------+-------------+-------------+-------------+-------------+
| ChanCrossSe | chanxsect.m | channel     | \-          | nominal     |
| ctions      | ap          | cross       |             |             |
|             |             | section IDs |             |             |
+-------------+-------------+-------------+-------------+-------------+
| ChanBottomL | chblevel.ma | channel     | \[m\]       |             |
| evel        | p           | bottom      |             |             |
|             |             | level       |             |             |
+-------------+-------------+-------------+-------------+-------------+
|             |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| **Tables**  | **Default   | **Descripti | **Units**   | **Remarks** |
|             | name**      | on**        |             |             |
+-------------+-------------+-------------+-------------+-------------+
| TabCrossSec | chanxsect.t | cross       | H:\[m\]     |             |
| tions       | xt          | section     |             |             |
|             |             | parameter   | A:\[m^2^\]  |             |
|             |             | table       |             |             |
|             |             | (H,A,P)     | P:\[m\]     |             |
+-------------+-------------+-------------+-------------+-------------+

Layout of the cross-section parameter table
-------------------------------------------

The cross-section parameter table is a text file that contains --for
each cross-section- a sequence of water levels (*H*) with their
corresponding cross-sectional area (*A*) and wetted perimeter (*P*). The
format of each line is as follows:

> ID H A P

As an example:

+---------------------------------+
| ID H A P                        |
|                                 |
| 167 0 0 0                       |
|                                 |
| 167 1.507 103.044 114.183       |
|                                 |
| 167 3.015 362.28 302.652        |
|                                 |
| 167 4.522 902.288 448.206       |
|                                 |
| 167 6.03 1709.097 600.382       |
|                                 |
| 167 6.217 1821.849 609.433      |
|                                 |
| 167 6.591 2049.726 615.835      |
|                                 |
| 167 6.778 2164.351 618.012      |
|                                 |
| 167 6.965 2279.355 620.14       |
|                                 |
| 167 7.152 2395.037 626.183      |
|                                 |
| 167 7.526 2629.098 631.759      |
|                                 |
| 167 7.713 2746.569 634.07       |
|                                 |
| 167 7.9 2864.589 636.93         |
|                                 |
| 167 307.9 192201.4874 5225.1652 |
+=================================+
|                                 |
+---------------------------------+

Note here that the first *H*-level is always 0, for which *A* and *P*
are (of course) 0 as well. For the last line for each cross-section it
is recommended to use some very (i.e. unrealistically) high *H*-level.
The reason for doing this is that the dynamic wave routine will crash if
during a simulation a water level (or cross-sectional area) is simulated
which is beyond the range of the table. This can occur due to a number
of reasons (e.g. if the measured cross-section is incomplete, or during
calibration of the model). To estimate the corresponding values of *A*
and *P* one could for example calculate *dA/dH* and *dP/dH* over the
last two 'real' (i.e. measured) *H*-levels, and extrapolate the results
to a very high *H*-level.

The number of H/A/P combinations that are used for each cross section is
user-defined. LISFLOOD automatically interpolates in between the table
values.

Using the dynamic wave
----------------------

The 'lfuser' element contains two parameters that can be set by the
user: *CourantDynamicCrit* (which should always be smaller than 1) and a
parameter called *DynWaveConstantHeadBoundary*, which defines the
boundary condition at the most downstream cell. All remaining
dynamic-wave related input is defined in the 'lfbinding' element, and
doesn't require any changes from the user (provided that all default
names are used, all maps are in the standard 'maps' directory and the
profile table is in the 'tables' directory). In 'lfuser' this will look
like this:

+-----------------------------------------------------------------------+
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| DYNAMIC WAVE OPTION                                                   |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"CourantDynamicCrit\" value=\"0.5\"\>                 |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Critical Courant number for dynamic wave                              |
|                                                                       |
| value between 0-1 (smaller values result in greater numerical         |
| accuracy,                                                             |
|                                                                       |
| but also increase computational time)                                 |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"DynWaveConstantHeadBoundary\" value=\"0\"\>          |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Constant head \[m\] at most downstream pixel (relative to altitude    |
|                                                                       |
| at most downstream pixel)                                             |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
+-----------------------------------------------------------------------+

Annex 7: Using the transmission loss option
===========================================

Introduction
------------

This annex describes the LISFLOOD transmission loss routine, and how it
is used.

The term 'transmission loss' originate from electronic or communication
science and stands for: "The loss of power or voltage of a transmitted
wave or current in passing along a transmission line or path or through
a circuit device". In river systems, particularly in semi-arid and arid
region a similar effect can be observed: The loss of water along channel
reaches mainly especially during low and average flow periods. Main
reasons for this loss might be:

-   Evaporation of water inside the channel reach

-   Use of water for domestic, industrial or agricultural use

-   Leaching to lower groundwater zones

A simplified approach to model this effect has been chosen from Rao and
Maurer (1996), without the need of additional data and with only three
parameters, making calibration relatively simple.

Transmission loss is *optional*, and can be activated by adding the
following line to the 'lfoptions' element:

\<setoption name=\"TransLoss\" choice=\"1\" /\>

Description of the transmission loss approach
---------------------------------------------

The approach by Rao and Maurer 1996 builds a one-parameter relationship
between the seepage ofa channel with the depth of flow. A power
relationship is then utilized for the stage-discharge relationship,
which is coupled with the seepage relationship.

> \$Outflow = {\\left( {Inflo{w\^{\\frac{1}{{TransPower}}}} - TransSub}
> \\right)\^{TransPower}}\$
>
> with: Outflow: discharge at the outflow
>
> Inflow: discharge at the Inflow (upstream)
>
> TransPower: Parameter given by the rating curve
>
> TransSub: Parameter which is to calibrate

As a main difference to the Rao and Maurer 1996, the TransPower
parameter is not calculated by using a rating curve but is estimated
(calibrated) as the parameter TransSub. Transmission loss takes place
where the channel gets bigger with more influence of river-aquifer
interaction and also with more river-floodplain interaction. Therefore a
minimum upstream area is defined where transmission loss starts to get
important.

Using transmission loss 
------------------------

No additional maps or tables are needed. Using the transmission loss
option involves two steps:

1.  In the 'lfuser' element (replace the file paths/names by the ones
    you want to use):

+-----------------------------------------------------------------------+
| \<group\>                                                             |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| TRANSMISSION LOSS PARAMETERS                                          |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| Suggested parameterisation strategy:                                  |
|                                                                       |
| Use TransSub as calibration constant leave all other parameters at\   |
| default values                                                        |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"TransSub\" value=\"0.3\"\>                           |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Transmission loss function parameter                                  |
|                                                                       |
| Standard: 0.3 Range: 0.1 - 0.6                                        |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"TransPower1\" value=\"2.0\"\>                        |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Transmission loss function parameter                                  |
|                                                                       |
| Standard: 2.0 Range 1.3 -- 2.0                                        |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"TransArea\" value=\"5.0E+10\"\>                      |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| downstream area taking into account for transmission loss             |
|                                                                       |
| Standard: 5.0E+10 Range: 1.0E+10 -- 1.0E+11                           |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \</group\>                                                            |
+-----------------------------------------------------------------------+

> *TransSub* is the linear transmission loss parameter. Standard is set
> to 0.3 and the range should be between 01. -- 0.6 (higher values lead
> to more loss)
>
> *TransPower* is the power transmission loss parameter. Standard is set
> to 2.0 and the range should be between 1.3 and 2.0 (higher values lead
> to more loss)
>
> *TransArea* is the downstream area which is taken into account for
> transmission loss. Standard is 5.0E+10 km^2^ and range should be
> 1.0E+10 km2 to 1.0E+11 km^2^ (higher values lead to less loss as less
> area is taken into account)

2.  Activate the transmission loss option

Add the following line to the 'lfoptions' element:

\<setoption name=\"TransLoss\" choice=\"1\" /\>

Now you are ready to run the model with the transmission loss option

Transmission loss output file
-----------------------------

The transmission option can produce an additional time series as listed
in the following table:

------------------------------------------------------------------------------------ -------------------- ---------------------------------- -----------
  ***Table A7.3** Output of transmission loss routine -- Average upstream of gauges*                                                           
  **Time series**                                                                      **Default name**     **Description**                    **Units**
  TransLossAvUps                                                                       TransLossAvUps.tss   Transmission loss in the channel   mm
------------------------------------------------------------------------------------ -------------------- ---------------------------------- -----------

Annex 8: Including water use
============================

Introduction
------------

This annex describes the LISFLOOD water use routine, and how it is used.

The water use routine can be used to assess the effect of water
withdrawal from different sectors to the water balance. Sectors can be
public, industrial, agricultural or energy water withdrawal. As input
LISFLOOD needs a stack of maps for one representative year of total
water withdrawal demand. According to the available water LISFLOOD
calculates if this demand can be fulfilled and removes the possible
amount of withdrawal water from the river system. Water use is
*optional*, and can be activated by adding the following line to the
'lfoptions' element:

\<setoption name=\"wateruse\" choice=\"1\" /\>

Calculation of water use
------------------------

The water is withdrawn only from discharge in the river network but not
from soil, groundwater or directly from precipitation.

-   For each single day a total demand of withdrawal water is loaded
    from a sparse stack of maps

-   Water use is taken from the discharge in the river network. First
    the water use is taken from the same grid cell (see figure A8.1 --
    pixel No. 1)

-   If the amount of water withdrawal is larger than the water available
    in this grid cell water is taken from downstream moving along the
    local drain direction. This is done by implementing a loop
    substracting the remaining water from the next downstream cell till
    all the water for water use is taken or a predefined number of
    iteration is reached (see figure A8.1 -- pixel No. 2 to 5)

![](media/media/image56.emf){width="4.0869564741907265in"
height="2.134514435695538in"}

**Figure A8.1** Water withdrawal assessing demand and availability along
the flow path

In the settings.xml you can define:

-   the percentage of water that must remain in a grid cell and is not
    withdrawn by water use (WUsePercRemain)

-   the maximum number of loops (= distance to the water demand cell).
    For example in figure 8.1: maxNoWateruse = 5

Preparation of input data 
--------------------------

Table A8.1 gives an overview about the maps and table needed for the
water use option.

----------------------------------------------- ------------------ --------------------------------------------------------- ----------- --
  ***Table A8.1** Input requirements water use*                                                                                            
  **Maps**                                        **Default name**   **Description**                                           **Units**   
  Yearly stack of water use maps                  wuse0000.xxx       Total water withdrawal                                    m^3^/s      
                                                                                                                                           
  **Table**                                       **Default name**   **Description**                                           **Units**   
  WUseofDay                                       WUseofDays.txt     Assignment of day of the year to map stack of water use   \-          
----------------------------------------------- ------------------ --------------------------------------------------------- ----------- --

A sparse map stack of one year of total water withdrawal \[m^3^/s\] with
a map every 10 days or a month is needed. Because it is assumed that
water use follows a yearly circle, this map stack is used again and
again for the following years. For example:

+--------+--------------+
| **t ** | **map name** |
+========+==============+
| 1      | wuse0000.001 |
+--------+--------------+
| 2      | wuse0000.032 |
+--------+--------------+
| 3      | wuse0000.060 |
+--------+--------------+
| 4      | wuse0000.091 |
+--------+--------------+
| 5      | wuse0000.121 |
+--------+--------------+
| 6      | wuse0000.152 |
+--------+--------------+
| 7      | wuse0000.182 |
+--------+--------------+
| 8      | wuse0000.213 |
+--------+--------------+
| 9      | wuse0000.244 |
+--------+--------------+
| 10     | wuse0000.274 |
|        |              |
| 11     | wuse0000.305 |
|        |              |
| 12     | wuse0000.335 |
+--------+--------------+

To assign each day of simulation the right map a lookup table
(WUseOfDay.txt) is necessary:

+-----------------+
| \<,0.5\> 335    |
|                 |
| \[0.5,32\> 1    |
|                 |
| \[32,60\> 32    |
|                 |
| \[60,91\> 60    |
|                 |
| \[91,121\> 91   |
|                 |
| \[121,152\> 121 |
|                 |
| \[152,182\> 152 |
|                 |
| \[182,213\> 182 |
|                 |
| \[213,244\> 213 |
|                 |
| \[244,274\> 244 |
|                 |
| \[274,305\> 274 |
|                 |
| \[305,335\> 305 |
|                 |
| \[335,\> 335    |
+-----------------+

Preparation of settings file
----------------------------

All in- and output files need to be defined in the settings file. If you
are using a default LISFLOOD settings template, all file definitions are
already defined in the 'lfbinding' element.

+-----------------------------------------------------------------------+
| \<textvar name=\"PathWaterUse\" value=\"./wateruse\"\>                |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Water use maps path                                                   |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"PrefixWaterUse\" value=\"wuse\"\>                    |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| prefix water use maps                                                 |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<group\>                                                             |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| INPUT WATER USE MAPS AND PARAMETERS                                   |
|                                                                       |
| \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\ |
| *\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \<textvar name=\"WaterUseMaps\" value=\"\$(PathOut)/wuse\"\>          |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Reported water use \[cu m/s\], depending on the availability of       |
| discharge                                                             |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"WaterUseTS\" value=\"\$(PathOut)/wateruseUps.tss\"\> |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Time series of upstream water use at gauging stations                 |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"StepsWaterUseTS\"                                    |
| value=\"\$(PathOut)/stepsWaterUse.tss\"\>                             |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| Number of loops needed for water use                                  |
|                                                                       |
| routine                                                               |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"maxNoWateruse\" value=\"5\"\>                        |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| maximum number of loops for calculating the use of water              |
|                                                                       |
| = distance water is taken for water consuption                        |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \<textvar name=\"WUsePercRemain\" value=\"0.2\"\>                     |
|                                                                       |
| \<comment\>                                                           |
|                                                                       |
| percentage of water which remains in the channel                      |
|                                                                       |
| e.g. 0.2 -\> 20 percent of discharge is not taken out                 |
|                                                                       |
| \</comment\>                                                          |
|                                                                       |
| \</textvar\>                                                          |
|                                                                       |
| \</group\>                                                            |
+-----------------------------------------------------------------------+

> *PathWaterUse* is the path to the map stack of water use
>
> *PrefixWaterUse* is the prefix of the water use maps
>
> *WaterUseMaps* is the path and prefix of the reported water use
> \[m^3^/s\] as a result of demand and availability
>
> *WaterUseTS* are time series of upstream water use \[m^3^/s\] at
> gauging stations
>
> *StepsWaterUseTS* is the number of loops needed for water use \[-\]
>
> *maxNoWateruse* is maximum number of loops for calculating the use of
> water (distance water is taken for water consumption)
>
> *WUsePercRemain* is the percentage of water which remains in the
> channel
>
> (e.g. 0.2 -\> 20 percent of discharge is not taken out)

Finally, you have to tell LISFLOOD that you want to simulate water use.
To do this, add the following statement to the 'lfoptions' element:

\<setoption name=\"wateruse\" choice=\"1\" /\>

Water use output files
----------------------

The water use routine can produce 2 additional time series and one map
(or stack), as listed in the following table:

---------------------------------------------- ------------------- ----------------- ----------- -------------
  ***Table A8.3** Output of water use routine*                                                     
  **Maps**                                       **Default name**    **Option**        **Units**   **Remarks**
  WaterUseMaps                                   wusexxxx.xxx        repwateruseMaps   m^3^/s      
                                                                                                   
  **Time series**                                **Default name**    **Option**        **Units**   **Remarks**
  Number of loops                                stepsWaterUse.tss                     \-          
  WaterUseTS                                     wateruseUps.tss     repwateruseTS     m^3^/s      
---------------------------------------------- ------------------- ----------------- ----------- -------------

Annex 9: Simulation and reporting of water levels
=================================================

Introduction
------------

Within LISFLOOD it is possible to simulate and report water levels in
the channel. The simulation of water levels is *optional*, and it can be
activated by adding the following line to the 'lfoptions' element:

\<setoption name=\"simulateWaterLevels\" choice=\"1\" /\>

If the option is switched on, water levels are calculated for channel
pixels where either kinematic or dynamic wave routing is used. Using
this option does *not* influence the actual model results in any way,
and it is included only to allow the model user to report water levels.
The actual *reporting* of the simulated water levels (as time series or
maps) can be activated using two separate options.

Calculation of water levels
---------------------------

For channel stretches that are simulated using the dynamic wave, the
water level in the channel is simply the difference between the channel
head and the channel bottom level. For kinematic wave stretches, only
approximate water levels can be estimated from the cross-sectional
(wetted) channel area, *A~ch~* for each time step. Since the channel
cross-section is described as a trapezoid, water levels follow directly
from *A~ch~* , channel bottom width, side slope and bankfull level. If
*A~ch~* exceeds the bankfull cross-sectional area (*A~bf~*), the surplus
is distributed evenly over the (rectangular) floodplain, and the depth
of water on the floodplain is added to the (bankfull) channel depth.
Figure A9.1 below further illustrates the cross-section geometry. All
water levels are relative to channel bottom level (*z~bot~* in the
Figure).

![chanDims](media/media/image57.png){width="5.770833333333333in"
height="2.1145833333333335in"}

*Figure A9.1 Geometry of channel cross-section in kinematic wave
routing.* W~b~*: channel bottom width;* W~u~*: channel upper width;*
z~bot~*: channel bottom level;* z~fp~*: floodplain bottom level;* s*:
channel side slope;* W~fp~*: floodplain width;* A~bf~*: channel
cross-sectional area at bankfull;* A~fp~*: floodplain cross-sectional
area;* D~bf~*:* *bankfull channel depth,* D~fp~*: depth of water on the
floodplain*

In order to calculate water levels, LISFLOOD needs a map with the with
of the floodplain in \[m\], which is defined by 'lfbinding' variable
*FloodPlainWidth* (the default name of this map is *chanfpln.map*).

Reporting of water levels
-------------------------

Water levels can be reported as time series (at the gauge locations that
are also used for reporting discharge), or as maps.

To generate a time series, add the following line to the 'lfoptions'
element of your settings file:

\<setoption name=\"repWaterLevelTs\" choice=\"1\" /\>

For maps, use the following line instead:

\<setoption name=\"repWaterLevelMaps\" choice=\"1\" /\>

In either case, the reporting options should be used *in addition* to
the 'simulateWaterLevels' option. If you do not include the
'simulateWaterLevels' option, there will be nothing to report and
LISFLOOD will exit with an error message.

Preparation of settings file
----------------------------

The naming of the reported water level time series and maps is defined
in the settings file. If you are using a default LISFLOOD settings
template, all file definitions are already defined in the 'lfbinding'
element.

Time series:

+------------------------------------------------------------------------+
| \<textvar name=\"WaterLevelTS\" value=\"\$(PathOut)/waterLevel.tss\"\> |
|                                                                        |
| \<comment\>                                                            |
|                                                                        |
| Reported water level \[m\]                                             |
|                                                                        |
| \</comment\>                                                           |
|                                                                        |
| \</textvar\>                                                           |
+------------------------------------------------------------------------+

Map stack:

+--------------------------------------------------------------+
| \<textvar name=\"WaterLevelMaps\" value=\"\$(PathOut)/wl\"\> |
|                                                              |
| \<comment\>                                                  |
|                                                              |
| Reported water level \[m\]                                   |
|                                                              |
| \</comment\>                                                 |
|                                                              |
| \</textvar\>                                                 |
+--------------------------------------------------------------+

Annex 10: Simulation and reporting of soil moisture as pF values
================================================================

Introduction
------------

LISFLOOD offers the possibility to calculate pF values from the moisture
content of both soil layers. The calculation of pF values is *optional*,
and it can be activated by adding the following line to the 'lfoptions'
element:

\<setoption name=\"simulatePF\" choice=\"1\" /\>

Using this option does *not* influence the actual model results in any
way, and it is included only to allow the model user to report pF time
series or maps. The actual *reporting* of the computed pF values (as
time series or maps) can be activated using separate options (which are
discussed further on).

Calculation of pF
-----------------

A soil's pF is calculated as the logarithm of the capillary suction
head, *h*:

$pF = \log_{10}(h)$

with *h* in \[cm\] (positive upwards). Values of pF are typically within
the range 1.0 (very wet) to 5.0 (very dry). The relationship between
soil moisture status and capillary suction head is described by the Van
Genuchten equation (here again re-written in terms of mm water slice,
instead of volume fractions):

$h = \frac{1}{\alpha}[(\frac{w_s - w_r}{w - w_r} )^{1/m} - 1}]^{1/n}$

where *h* is the suction head \[cm\], and *w*, *w~r~* and *w~s~* are the
actual, residual and maximum amounts of moisture in the soil
respectively (all in \[mm\]). Parameter *α* is related to soil texture.
Parameters *m* and *n* are calculated from the pore-size index, *λ*
(which is related to soil texture as well):

\$m = \\frac{\\lambda }{{\\lambda + 1}}\$

\$n = \\lambda + 1\$

If the soil contains no moisture at all (*w*=0), *h* is set to a fixed
(arbitrary) value of 1∙10^7^ cm.

 Reporting of pF
----------------

pF can be reported as time series (at the locations defined on the
"sites" map or as average values upstream each gauge location), or as
maps. To generate time series at the "sites", add the following line to
the 'lfoptions' element of your settings file:

\<setoption name=\"repPFTs\" choice=\"1\" /\>

For maps, use the following lines instead (for the upper and lower soil
layer, respectively):

\<setoption name=\"repPF1Maps\" choice=\"1\" /\>

\<setoption name=\"repPF2Maps\" choice=\"1\" /\>

In either case, the reporting options should be used *in addition* to
the 'simulatePF' option. If you do not include the 'simulatePF' option,
there will be nothing to report and LISFLOOD will exit with an error
message.

Preparation of settings file
----------------------------

The naming of the reported time series and maps is defined in the
settings file. Tables A7.1 and A7.2 list the settings variables default
output names. If you are using a default LISFLOOD settings template, all
file definitions are already defined in the 'lfbinding' element.

Time series:

+--------------------------------------------------------------------+
| \<comment\>                                                        |
|                                                                    |
| PF TIMESERIES, VALUES AT SITES                                     |
|                                                                    |
| \</comment\>                                                       |
|                                                                    |
| \<textvar name=\"PF1TS\" value=\"\$(PathOut)/pFTop.tss\"\>         |
|                                                                    |
| \<comment\>                                                        |
|                                                                    |
| Reported pF upper soil layer \[-\]                                 |
|                                                                    |
| \</comment\>                                                       |
|                                                                    |
| \</textvar\>                                                       |
|                                                                    |
| \<textvar name=\"PF2TS\" value=\"\$(PathOut)/pFSub.tss\"\>         |
|                                                                    |
| \<comment\>                                                        |
|                                                                    |
| Reported pF lower soil layer \[-\]                                 |
|                                                                    |
| \</comment\>                                                       |
|                                                                    |
| \</textvar\>                                                       |
|                                                                    |
| \<comment\>                                                        |
|                                                                    |
| PF TIMESERIES, AVERAGE VALUES UPSTREAM OF GAUGES                   |
|                                                                    |
| \</comment\>                                                       |
|                                                                    |
| \<textvar name=\"PF1AvUpsTS\" value=\"\$(PathOut)/pFTopUps.tss\"\> |
|                                                                    |
| \<comment\>                                                        |
|                                                                    |
| Reported pF upper soil layer \[-\]                                 |
|                                                                    |
| \</comment\>                                                       |
|                                                                    |
| \</textvar\>                                                       |
|                                                                    |
| \<textvar name=\"PF2AvUpsTS\" value=\"\$(PathOut)/pFSubUps.tss\"\> |
|                                                                    |
| \<comment\>                                                        |
|                                                                    |
| Reported pF lower soil layer \[-\]                                 |
|                                                                    |
| \</comment\>                                                       |
|                                                                    |
| \</textvar\>                                                       |
+--------------------------------------------------------------------+

Map stacks:

+----------------------------------------------------------+
| \<comment\>                                              |
|                                                          |
| PF MAPS                                                  |
|                                                          |
| \</comment\>                                             |
|                                                          |
| \<textvar name=\"PF1Maps\" value=\"\$(PathOut)/pftop\"\> |
|                                                          |
| \<comment\>                                              |
|                                                          |
| Reported pF upper soil layer \[-\]                       |
|                                                          |
| \</comment\>                                             |
|                                                          |
| \</textvar\>                                             |
|                                                          |
| \<textvar name=\"PF2Maps\" value=\"\$(PathOut)/pfsub\"\> |
|                                                          |
| \<comment\>                                              |
|                                                          |
| Reported pF lower soil layer \[-\]                       |
|                                                          |
| \</comment\>                                             |
|                                                          |
| \</textvar\>                                             |
+----------------------------------------------------------+

  ***Table A10.1** pF map output*                                             
--------------------------------- ----------------- ----------------------- --------------------
  **Description**                   **Option name**   **Settings variable**   **Default prefix**
  pF upper layer                    repPF1Maps        PF1Maps                 pftop
  pF lower layer                    repPF2Maps        PF2Maps                 pfsub

-------------------------------------------------------------- ----------------------- ------------------
  ***Table A10.2** pF timeseries output*                                                 
  **pF at sites (option *repPFSites*)**                                                  
  **Description**                                                **Settings variable**   **Default name**
  pF upper layer                                                 PF1TS                   pFTop.tss
  pF lower layer                                                 PF2TS                   pFSub.tss
                                                                                         
  **pF, average upstream of gauges (option *repPFUpsGauges*)**                           
  **Description**                                                **Settings variable**   **Default name**
  pF upper layer                                                 PF1AvUpsTS              pFTopUps.tss
  pF lower layer                                                 PF2AvUpsTS              pFSubUps.tss
-------------------------------------------------------------- ----------------------- ------------------

Annex 11: LISFLOOD options
==========================

As explained in Chapter 5, the 'lfoptions' element gives you additional
control over what LISFLOOD is doing. Using options it is possible to
switch certain parts of the model on or off. This way you can tell the
model exactly which output files are reported and which ones aren't.
Also, they can be used to activate a number of additional model
features, such as the simulation of reservoirs and inflow hydrographs.

The table below lists all currently implemented options and their
corresponding defaults. All currently implemented options are switches
(1= on, 0=off). You can set as many options as you want (or none at
all). Table 10.1 lists all currently implemented options[^13]. Note that
each option generally requires additional items in the settings file.
For instance, using the inflow hydrograph option requires an input map
and time series, which have to be specified in the settings file. If you
want to report discharge maps at each time step, you will first have to
specify under which name they will be written. The template settings
file that is provided with LISFLOOD always contains file definitions for
all optional output maps and time series. The use of the *output*
options is described in detail in Chapter 8.

------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------- -------------
  ***Table A11.1** LISFLOOD options (continued on next page)*                                                                                                                        
                                                                                                                                                                                     
  **SIMULATION OPTIONS**                                                                                                                                                             
  **Option**                                                    **Description**                                                                                                      **Default**
  gridSizeUserDefined                                           Get grid size attributes (length, area) from user-defined maps (instead of using map location attributes directly)   0
  simulateReservoirs                                            Simulate retention and hydropower reservoirs (kin. wave only)                                                        0
  simulateLakes                                                 Simulate unregulated lakes (kin. wave only)                                                                          0
  simulatePolders                                               Simulate flood protection polders (dyn. wave only)                                                                   0
  inflow                                                        Use inflow hydrographs                                                                                               0
  dynamicWave                                                   Perform dynamic wave channel routing                                                                                 0
  simulateWaterLevels                                           Simulate water levels in channel                                                                                     0
  TransLoss                                                     Simulate transmission loss                                                                                           0
  SplitRouting                                                  Simulate double kinematic wave                                                                                       0
  VarNoSubStepChannel                                           Use variable number of sub step for channel routing                                                                  0
  wateruse                                                      Simulate water use                                                                                                   0
                                                                                                                                                                                     
  **OUTPUT, TIME SERIES**                                                                                                                                                            
  **Option**                                                    **Description**                                                                                                      **Default**
  repDischargeTs                                                Report timeseries of discharge at gauge locations                                                                    1
  repWaterLevelTs                                               Report timeseries of water level at gauge locations[^14]                                                             0
  repStateSites                                                 Report timeseries of all intermediate state variables at \'sites\'                                                   0
  repRateSites                                                  Report timeseries of all intermediate rate variables at \'sites\'                                                    0
  repMeteoUpsGauges                                             Report timeseries of meteorological input, averaged over contributing area of each gauging station                   0
  repStateUpsGauges                                             Report timeseries of model state variables, averaged over contributing area of each gauging station                  0
  repRateUpsGauges                                              Report timeseries of model rate variables, averaged over contributing area of each gauging station                   0
                                                                                                                                                                                     
  **OUTPUT, MASS BALANCE**                                                                                                                                                           
  **Option**                                                    **Description**                                                                                                      **Default**
  repMBTs                                                       Report timeseries of absolute cumulative mass balance error                                                          1
  repMBMMTs                                                     Report timeseries of cumulative mass balance error expressed as mm water slice                                       1
                                                                                                                                                                                     
------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------- -------------

+-----------------------+-----------------------+-----------------------+
| ***Table A11.1**      |
| LISFLOOD options      |
| (continued from       |
| previous page)*       |
+-----------------------+-----------------------+-----------------------+
| **OUTPUT, MAPS,       |
| DISCHARGE**           |
+-----------------------+-----------------------+-----------------------+
| **Option**            | **Description**       | **Default**           |
+-----------------------+-----------------------+-----------------------+
| repDischargeMaps      | Report maps of        | 0                     |
|                       | discharge (for each   |                       |
|                       | time step)            |                       |
+-----------------------+-----------------------+-----------------------+
| repWaterLevelMaps[^17 | Report maps of water  | 0                     |
| ]                     | level in channel (for |                       |
|                       | each time step)       |                       |
+-----------------------+-----------------------+-----------------------+
|                       |
+-----------------------+-----------------------+-----------------------+
| **OUTPUT, MAPS, STATE |
| VARIABLES (all, at    |
| selected time         |
| steps)**              |
+-----------------------+-----------------------+-----------------------+
| **Option**            | **Description**       | **Default**           |
+-----------------------+-----------------------+-----------------------+
| repStateMaps          | Report maps of model  | 1                     |
|                       | state variables (as   |                       |
|                       | defined by            |                       |
|                       | \"ReportSteps\"       |                       |
|                       | variable)             |                       |
+-----------------------+-----------------------+-----------------------+
| repEndMaps[^18]       | Report maps of model  | 0                     |
|                       | state variables (at   |                       |
|                       | last time step)       |                       |
+-----------------------+-----------------------+-----------------------+
|                       |
+-----------------------+-----------------------+-----------------------+
| **OUTPUT, MAPS, STATE |
| VARIABLES**           |
+-----------------------+-----------------------+-----------------------+
| **Option**            | **Description**       | **Default**           |
+-----------------------+-----------------------+-----------------------+
| repDSLRMaps           | Report maps of days   | 0                     |
|                       | since last rain (for  |                       |
|                       | each time step)       |                       |
+-----------------------+-----------------------+-----------------------+
| repFrostIndexMaps     | Report maps of frost  | 0                     |
|                       | index (for each time  |                       |
|                       | step)                 |                       |
+-----------------------+-----------------------+-----------------------+
| repWaterDepthMaps     | Report maps of depth  | 0                     |
|                       | of water layer on     |                       |
|                       | soil surface (for     |                       |
|                       | each time step)       |                       |
+-----------------------+-----------------------+-----------------------+
| repSnowCoverMaps      | Report maps of snow   | 0                     |
|                       | cover (for each time  |                       |
|                       | step)                 |                       |
+-----------------------+-----------------------+-----------------------+
| repCumInterceptionMap | Report maps of        | 0                     |
| s                     | interception storage  |                       |
|                       | (for each time step)  |                       |
+-----------------------+-----------------------+-----------------------+
| repTheta1Maps         | Report maps of soil   | 0                     |
|                       | moisture layer 1(for  |                       |
|                       | each time step)       |                       |
+-----------------------+-----------------------+-----------------------+
| repTheta2Maps         | Report maps of soil   | 0                     |
|                       | moisture layer 2 (for |                       |
|                       | each time step)       |                       |
+-----------------------+-----------------------+-----------------------+
| repUZMaps             | Report maps of upper  | 0                     |
|                       | zone storage (for     |                       |
|                       | each time step)       |                       |
+-----------------------+-----------------------+-----------------------+
| repLZMaps             | Report maps of lower  | 0                     |
|                       | zone storage (for     |                       |
|                       | each time step)       |                       |
+-----------------------+-----------------------+-----------------------+
| repChanCrossSection   | Report maps of        | 0                     |
|                       | channel               |                       |
| Maps                  | cross-sectional area  |                       |
|                       | (for each time step)  |                       |
+-----------------------+-----------------------+-----------------------+
|                       |
+-----------------------+-----------------------+-----------------------+
| **OUTPUT, MAPS,       |
| METEOROLOGICAL        |
| FORCING VARIABLES**   |
+-----------------------+-----------------------+-----------------------+
| **Option**            | **Description**       | **Default**           |
+-----------------------+-----------------------+-----------------------+
| repPrecipitationMaps  | Report maps of        | 0                     |
|                       | precipitation (for    |                       |
|                       | each time step)       |                       |
+-----------------------+-----------------------+-----------------------+
| repTavgMaps           | Report maps of        | 0                     |
|                       | average temperature   |                       |
|                       | (for each time step)  |                       |
+-----------------------+-----------------------+-----------------------+
| repETRefMaps          | Report maps of        | 0                     |
|                       | potential reference   |                       |
|                       | evapotranspiration    |                       |
|                       | (for each time step)  |                       |
+-----------------------+-----------------------+-----------------------+
| repESRefMaps          | Report maps of        | 0                     |
|                       | potential soil        |                       |
|                       | evaporation (for each |                       |
|                       | time step)            |                       |
+-----------------------+-----------------------+-----------------------+
| repEWRefMaps          | Report maps of        | 0                     |
|                       | potential open water  |                       |
|                       | evaporation (for each |                       |
|                       | time step)            |                       |
+-----------------------+-----------------------+-----------------------+
|                       |
+-----------------------+-----------------------+-----------------------+

------------------------------------------------------------------- ----------------------------------------------------------------------------------------------------------------------- -------------
  ***Table A11.1** LISFLOOD options (continued from previous page)*                                                                                                                           
  **OUTPUT, MAPS, RATE VARIABLES**                                                                                                                                                            
  **Option**                                                          **Description**                                                                                                         **Default**
  repRainMaps                                                         Report maps of rain (excluding snow!) (for each time step)                                                              0
  repSnowMaps                                                         Report maps of snow (for each time step)                                                                                0
  repSnowMeltMaps                                                     Report maps of snowmelt (for each time step)                                                                            0
  repInterceptionMaps                                                 Report maps of interception (for each time step)                                                                        0
  repLeafDrainageMaps                                                 Report maps of leaf drainage (for each time step)                                                                       0
  repTaMaps                                                           Report maps of actual transpiration (for each time step)                                                                0
  repESActMaps                                                        Report maps of actual soil evaporation (for each time step)                                                             0
  repEWIntMaps                                                        Report maps of actual evaporation of intercepted water (for each time step)                                             0
  repInfiltrationMaps                                                 Report maps of infiltration (for each time step)                                                                        0
  repPrefFlowMaps                                                     Report maps of preferential flow (for each time step)                                                                   0
  repPercolationMaps                                                  Report maps of percolation from upper to lower soil layer (for each time step)                                          0
  repSeepSubToGWMaps                                                  Report maps of seepage from lower soil layer to ground water (for each time step)                                       0
  repGwPercUZLZMaps                                                   Report maps of percolation from upper to lower ground water zone (for each time step)                                   0
  repGwLossMaps                                                       Report maps of loss from lower ground water zone (for each time step)                                                   0
  repSurfaceRunoffMaps                                                Report maps of surface runoff (for each time step)                                                                      0
  repUZOutflowMaps                                                    Report maps of upper zone outflow (for each time step)                                                                  0
  repLZOutflowMaps                                                    Report maps of lower zone outflow (for each time step)                                                                  0
  repTotalRunoffMaps                                                  Report maps of total runoff (surface + upper + lower zone) (for each time step)                                         0
                                                                                                                                                                                              
  **OUTPUT, MAPS (MISCELLANEOUS)**                                                                                                                                                            
  **Option**                                                          **Description**                                                                                                         **Default**
  repLZAvInflowMap                                                    Report computed average inflow rate into lower zone (map, at last time step)                                            0
  repLZAvInflowSites                                                  Report computed average inflow rate into lower zone (time series, at points defined on sites map)                       0
  repLZAvInflowUpsGauges                                              Report computed average inflow rate into lower zone (time series, averaged over upstream area of each gauge location)   0
------------------------------------------------------------------- ----------------------------------------------------------------------------------------------------------------------- -------------

 Annex 12: LISFLOOD input maps and tables
=========================================

Maps
----

+-----------------+-----------------+-----------------+-----------------+
| ***Table        |
| A12.1**         |
| LISFLOOD input  |
| maps (continued |
| on next pages)* |
+=================+=================+=================+=================+
| **GENERAL**     |
+-----------------+-----------------+-----------------+-----------------+
| **Map**         | **Default       | **Units,        | **Description** |
|                 | name**[^20]     | range**         |                 |
+-----------------+-----------------+-----------------+-----------------+
| MaskMap         | area.map        | Unit: -         | *Boolean* map   |
|                 |                 |                 | that defines    |
|                 |                 | Range: 0 or 1   | model           |
|                 |                 |                 | boundaries      |
+-----------------+-----------------+-----------------+-----------------+
| **TOPOGRAPHY**  |
+-----------------+-----------------+-----------------+-----------------+
| **Map**         | **Default       | **Units,        | **Description** |
|                 | name**          | range**         |                 |
+-----------------+-----------------+-----------------+-----------------+
| Ldd             | ldd.map         | U.: flow\       | local drain     |
|                 |                 | directions      | direction map   |
|                 |                 |                 | (with value     |
|                 |                 | R.: 1 ≤ map ≤ 9 | 1-9); this file |
|                 |                 |                 | contains flow   |
|                 |                 |                 | directions from |
|                 |                 |                 | each cell to    |
|                 |                 |                 | its steepest    |
|                 |                 |                 | downslope       |
|                 |                 |                 | neighbour. Ldd  |
|                 |                 |                 | directions are  |
|                 |                 |                 | coded according |
|                 |                 |                 | to the          |
|                 |                 |                 | following       |
|                 |                 |                 | diagram:        |
|                 |                 |                 |                 |
|                 |                 |                 | ![ldd](media/me |
|                 |                 |                 | dia/image58.png |
|                 |                 |                 | ){width="1.8229 |
|                 |                 |                 | 166666666667in" |
|                 |                 |                 | height="1.84375 |
|                 |                 |                 | in"}            |
|                 |                 |                 |                 |
|                 |                 |                 | This resembles  |
|                 |                 |                 | the numeric key |
|                 |                 |                 | pad of your     |
|                 |                 |                 | PC's keyboard,  |
|                 |                 |                 | except for the  |
|                 |                 |                 | value 5, which  |
|                 |                 |                 | defines a cell  |
|                 |                 |                 | without local   |
|                 |                 |                 | drain direction |
|                 |                 |                 | (pit). The pit  |
|                 |                 |                 | cell at the end |
|                 |                 |                 | of the path is  |
|                 |                 |                 | the outlet      |
|                 |                 |                 | point of a      |
|                 |                 |                 | catchment.      |
+-----------------+-----------------+-----------------+-----------------+
| Grad            | gradient.map    | U.: \[m m^-1^\] | Slope gradient  |
|                 |                 |                 |                 |
|                 |                 | R.: map \> 0    |                 |
|                 |                 | **!!!**         |                 |
+-----------------+-----------------+-----------------+-----------------+
| Elevation Stdev | elvstd.map      | U.: \[m\]\      | Standard        |
|                 |                 | R.: map ≥ 0     | deviation of    |
|                 |                 |                 | elevation       |
+-----------------+-----------------+-----------------+-----------------+

+-----------------+-----------------+-----------------+-----------------+
| ***Table        |
| A12.1**         |
| LISFLOOD input  |
| maps (continued |
| from previous   |
| page)*          |
+=================+=================+=================+=================+
| **LAND USE --   |
| fraction maps** |
+-----------------+-----------------+-----------------+-----------------+
| **Map**         | **Default       | **Units,        | **Description** |
|                 | name**          | range**         |                 |
+-----------------+-----------------+-----------------+-----------------+
| Fraction of     | fracwater.map   | U.: \[-\]       | Fraction of     |
| water           |                 |                 | inland water    |
|                 |                 | R.: 0 ≤ map ≤ 1 | for each cell.  |
|                 |                 |                 | Values range    |
|                 |                 |                 | from 0 (no      |
|                 |                 |                 | water at all)   |
|                 |                 |                 | to 1 (pixel is  |
|                 |                 |                 | 100% water)     |
+-----------------+-----------------+-----------------+-----------------+
| Fraction of     | fracsealed.map  | U.: \[-         | Fraction of     |
| sealed surface  |                 |                 | impermeable     |
|                 |                 | R.: 0 ≤ map ≤ 1 | surface for     |
|                 |                 |                 | each cell.      |
|                 |                 |                 | Values range    |
|                 |                 |                 | from 0 (100%    |
|                 |                 |                 | permeable       |
|                 |                 |                 | surface -- no   |
|                 |                 |                 | urban at all)   |
|                 |                 |                 | to 1 (100%      |
|                 |                 |                 | impermeable     |
|                 |                 |                 | surface).       |
+-----------------+-----------------+-----------------+-----------------+
| Fraction of     | fracforest.map  | U.:\[-\]        | Forest fraction |
| forest          |                 |                 | for each cell.  |
|                 |                 | R.: 0 ≤ map ≤ 1 | Values range    |
|                 |                 |                 | from 0 (no      |
|                 |                 |                 | forest at all)  |
|                 |                 |                 | to 1 (pixel is  |
|                 |                 |                 | 100% forest)    |
+-----------------+-----------------+-----------------+-----------------+
| Fraction of     | fracother.map   | U.: \[\]        | Other           |
| other land      |                 |                 | (agricultural   |
| cover           |                 | R.: 0 ≤ map ≤ 1 | areas,          |
|                 |                 |                 | non-forested    |
|                 |                 |                 | natural area,   |
|                 |                 |                 | pervious        |
|                 |                 |                 | surface of      |
|                 |                 |                 | urban areas)    |
|                 |                 |                 | fraction for    |
|                 |                 |                 | each cell.      |
+-----------------+-----------------+-----------------+-----------------+
| **LAND COVER    |
| depending       |
| maps**          |
+-----------------+-----------------+-----------------+-----------------+
| **Map**         | **Default       | **Units,        | **Description** |
|                 | name**          | range**         |                 |
+-----------------+-----------------+-----------------+-----------------+
| Crop coef. for  | cropcoef\_\     | U.: \[-\]       | Crop            |
| forest          | forest.map      |                 | coefficient for |
|                 |                 | R.: 0.8≤ map ≤  | forest          |
|                 |                 | 1.2             |                 |
+-----------------+-----------------+-----------------+-----------------+
| Crop coef. for  | cropcoef\_\     | U.: \[-\]       | Crop            |
| other           | other.map       |                 | coefficient for |
|                 |                 | R.: 0.8≤ map ≤  | other           |
|                 |                 | 1.2             |                 |
+-----------------+-----------------+-----------------+-----------------+
| Crop group      | crgrnum\_\      | U.: \[-\]       | Crop group      |
| number for      | forest.map      |                 | number for      |
| forest          |                 | R.: 1 ≤ map ≤ 5 | forest          |
+-----------------+-----------------+-----------------+-----------------+
| Crop group      | crgrnum\_\      | U.: \[-\]       | Crop group      |
| number for      | other.map       |                 | number for      |
| forest          |                 | R.: 1 ≤ map ≤ 5 | other           |
+-----------------+-----------------+-----------------+-----------------+
| Manning for     | mannings\_\     | U.: \[-\]       | Manning's       |
| forest          | forest.map      |                 | roughness for   |
|                 |                 | R.: 0.2≤ map ≤  | forest          |
|                 |                 | 0.4             |                 |
+-----------------+-----------------+-----------------+-----------------+
| Manning for     | mannings\_\     | U.: \[-\]       | Manning's       |
| other           | other.map       |                 | roughness for   |
|                 |                 | R.: 0.01≤ map   | other           |
|                 |                 | ≤0.3            |                 |
+-----------------+-----------------+-----------------+-----------------+
| Soil depth for  | soildep1\_\     | U.: \[mm\]      | Forest soil     |
| forest for      | forest.map      |                 | depth for soil  |
| layer1          |                 | R.: map ≥ 50    | layer 1         |
|                 |                 |                 | (rooting depth) |
+-----------------+-----------------+-----------------+-----------------+
| Soil depth for  | soildep1\_\     | U.: \[mm\]      | Other soil      |
| other for       | other.map       |                 | depth for soil  |
| layer2          |                 | R.: map ≥ 50    | layer 1         |
|                 |                 |                 | (rooting depth) |
+-----------------+-----------------+-----------------+-----------------+
| Soil depth for  | Soildep2\_\     | U.: \[mm\]      | Forest soil     |
| forest for      | forest.map      |                 | depth for soil  |
| layer2          |                 | R.: map ≥ 50    | layer 2         |
+-----------------+-----------------+-----------------+-----------------+
| Soil depth for  | Soildep2\_\     | U.: \[mm\]      | Other soil      |
| other for       | other.map       |                 | depth for soil  |
| layer2          |                 | R.: map ≥ 50    | layer 2         |
+-----------------+-----------------+-----------------+-----------------+

+-----------------+-----------------+-----------------+-----------------+
| ***Table        |
| A12.1**         |
| LISFLOOD input  |
| maps (continued |
| from previous   |
| page)*          |
+=================+=================+=================+=================+
| **SOIL          |
| HYDRAULIC       |
| PROPERTIES      |
| (depending on   |
| soil texture)** |
+-----------------+-----------------+-----------------+-----------------+
| **Map**         | **Default       | **Units,        | **Description** |
|                 | name**          | range**         |                 |
+-----------------+-----------------+-----------------+-----------------+
| ThetaSat1 for   | thetas1\_\      | U.: \[-\]       | Saturated       |
| forest          | forest.map      |                 | volumetric soil |
|                 |                 | R.: 0 \< map \< | moisture        |
|                 |                 | 1               | content layer 1 |
+-----------------+-----------------+-----------------+-----------------+
| ThetaSat1 for   | thetas1\_\      | U.: \[-\]       | Saturated       |
| other           | other.map       |                 | volumetric soil |
|                 |                 | R.: 0 \< map \< | moisture        |
|                 |                 | 1               | content layer 1 |
+-----------------+-----------------+-----------------+-----------------+
| ThetaSat2 for   | thetas2.map     | U.: \[-\]       | Saturated       |
| forest and      |                 |                 | volumetric soil |
| other           |                 | R.: 0 \< map \< | moisture        |
|                 |                 | 1               | content layer 2 |
+-----------------+-----------------+-----------------+-----------------+
| ThetaRes1 for   | thetar1\_\      | U.: \[-\]       | Residual        |
| forest          | forest.map      |                 | volumetric soil |
|                 |                 | R.: 0 \< map \< | moisture        |
|                 |                 | 1               | content layer 1 |
+-----------------+-----------------+-----------------+-----------------+
| ThetaRes1 for   | thetar1\_\      | U.: \[-\]       | Residual        |
| other           | other.map       |                 | volumetric soil |
|                 |                 | R.: 0 \< map \< | moisture        |
|                 |                 | 1               | content layer 1 |
+-----------------+-----------------+-----------------+-----------------+
| ThetaRes2 for   | thetar2.map     | U.: \[-\]       | Residual        |
| forest and      |                 |                 | volumetric soil |
| other           |                 | R.: 0 \< map \< | moisture        |
|                 |                 | 1               | content layer 2 |
+-----------------+-----------------+-----------------+-----------------+
| Lambda1 for     | lambda1\_\      | U.: \[-\]       | Pore size index |
| forest          | forest.map      |                 | (λ) layer 1     |
|                 |                 | R.: 0 \< map \< |                 |
|                 |                 | 1               |                 |
+-----------------+-----------------+-----------------+-----------------+
| Lambda1 for     | lambda1\_\      | U.: \[-\]       | Pore size index |
| other           | other.map       |                 | (λ) layer 1     |
|                 |                 | R.: 0 \< map \< |                 |
|                 |                 | 1               |                 |
+-----------------+-----------------+-----------------+-----------------+
| Lambda2 for     | lambda2.map     | U.: \[-\]       | Pore size index |
| forest and      |                 |                 | (λ) layer 2     |
| other           |                 | R.: 0 \< map \< |                 |
|                 |                 | 1               |                 |
+-----------------+-----------------+-----------------+-----------------+
| GenuAlpha1 for  | alpha1\_\       | U.: \[-\]       | Van Genuchten   |
| forest          | forest.map      |                 | parameter α     |
|                 |                 | R.: 0 \< map \< | layer 1         |
|                 |                 | 1               |                 |
+-----------------+-----------------+-----------------+-----------------+
| GenuAlpha1 for  | alpha1\_\       | U.: \[-\]       | Van Genuchten   |
| other           | other.map       |                 | parameter α     |
|                 |                 | R.: 0 \< map \< | layer 1         |
|                 |                 | 1               |                 |
+-----------------+-----------------+-----------------+-----------------+
| GenuAlpha2 for  | alpha2.map      | U.: \[-\]       | Van Genuchten   |
| forest and      |                 |                 | parameter α     |
| other           |                 | R.: 0 \< map \< | layer 2         |
|                 |                 | 1               |                 |
+-----------------+-----------------+-----------------+-----------------+
| Sat1 for forest | ksat1\_\        | U.: \[cm        | Saturated       |
|                 | forest.map      | day^-1^\]       | conductivity    |
|                 |                 |                 | layer 1         |
|                 |                 | R.: 1 ≤ map ≤   |                 |
|                 |                 | 100             |                 |
+-----------------+-----------------+-----------------+-----------------+
| Sat1 for other  | ksat1\_\        | U.: \[cm        | Saturated       |
|                 | other.map       | day^-1^\]       | conductivity    |
|                 |                 |                 | layer 1         |
|                 |                 | R.: 1 ≤ map ≤   |                 |
|                 |                 | 100             |                 |
+-----------------+-----------------+-----------------+-----------------+
| Sat2 for forest | ksat2.map       | U.: \[cm        | Saturated       |
| and other       |                 | day^-1^\]       | conductivity    |
|                 |                 |                 | layer 2         |
|                 |                 | R.: 1 ≤ map ≤   |                 |
|                 |                 | 100             |                 |
+-----------------+-----------------+-----------------+-----------------+

+-----------------+-----------------+-----------------+-----------------+
| ***Table        |
| A12.1**         |
| LISFLOOD input  |
| maps (continued |
| from previous   |
| page)*          |
+=================+=================+=================+=================+
| **CHANNEL       |
| GEOMETRY**      |
+-----------------+-----------------+-----------------+-----------------+
| **Map**         | **Default       | **Units,        | **Description** |
|                 | name**          | range**         |                 |
+-----------------+-----------------+-----------------+-----------------+
| Channels        | chan.map        | U.: \[-\]       | Map with        |
|                 |                 |                 | Boolean 1 for   |
|                 |                 | R.: 0 or 1      | all channel     |
|                 |                 |                 | pixels, and     |
|                 |                 |                 | Boolean 0 for   |
|                 |                 |                 | all other       |
|                 |                 |                 | pixels on       |
|                 |                 |                 | MaskMap         |
+-----------------+-----------------+-----------------+-----------------+
| ChanGrad        | changrad.map    | U.: \[m m^-1^\] | Channel         |
|                 |                 |                 | gradient        |
|                 |                 | R.: map \> 0    |                 |
|                 |                 | **!!!**         |                 |
+-----------------+-----------------+-----------------+-----------------+
| ChanMan         | chanman.map     | U.: \[-\]       | Manning's       |
|                 |                 |                 | roughness       |
|                 |                 | R.: map \> 0    | coefficient for |
|                 |                 |                 | channels        |
+-----------------+-----------------+-----------------+-----------------+
| ChanLength      | chanleng.map    | U.: \[m\]       | Channel length  |
|                 |                 |                 | (can exceed     |
|                 |                 | R.: map \> 0    | grid size, to   |
|                 |                 |                 | account for     |
|                 |                 |                 | meandering      |
|                 |                 |                 | rivers)         |
+-----------------+-----------------+-----------------+-----------------+
| ChanBottomWidth | chanbw.map      | U.: \[m\]       | Channel bottom  |
|                 |                 |                 | width           |
|                 |                 | R.: map \> 0    |                 |
+-----------------+-----------------+-----------------+-----------------+
| ChanSdXdY       | chans.map       | U.: \[m m^-1^\] | Channel side    |
|                 |                 |                 | slope           |
|                 |                 | R.: map ≥ 0     | **Important:**  |
|                 |                 |                 | defined as      |
|                 |                 |                 | horizontal      |
|                 |                 |                 | divided by      |
|                 |                 |                 | vertical        |
|                 |                 |                 | distance        |
|                 |                 |                 | (dx/dy); this   |
|                 |                 |                 | may be          |
|                 |                 |                 | confusing       |
|                 |                 |                 | because slope   |
|                 |                 |                 | is usually      |
|                 |                 |                 | defined the     |
|                 |                 |                 | other way round |
|                 |                 |                 | (i.e. dy/dx)!   |
+-----------------+-----------------+-----------------+-----------------+
| ChanDepth\      | chanbnkf.map    | U.: \[m\]       | Bankfull        |
| Threshold       |                 |                 | channel depth   |
|                 |                 | R.: map \> 0    |                 |
+-----------------+-----------------+-----------------+-----------------+
| **METEOROLOGICA |
| L               |
| VARIABLES**     |
+-----------------+-----------------+-----------------+-----------------+
| **Map**         | **Default       | **Units,        | **Description** |
|                 | prefix**        | range**         |                 |
+-----------------+-----------------+-----------------+-----------------+
| Precipitation\  | pr              | U.: \[mm        | Precipitation   |
| Maps            |                 | day^-1^\]       | rate            |
|                 |                 |                 |                 |
|                 |                 | R.: map ≥ 0     |                 |
+-----------------+-----------------+-----------------+-----------------+
| TavgMaps        | ta              | U.: \[°C\]      | Average *daily* |
|                 |                 |                 | temperature\\   |
|                 |                 | R.:-50 ≤map ≤   |                 |
|                 |                 | +50             |                 |
+-----------------+-----------------+-----------------+-----------------+
| E0Maps          | e               | U.: \[mm        | Daily potential |
|                 |                 | day^-1^\]       | evaporation     |
|                 |                 |                 | rate, free      |
|                 |                 | R.: map ≥ 0     | water surface   |
+-----------------+-----------------+-----------------+-----------------+
| ES0Maps         | es              | U.: \[mm        | Daily potential |
|                 |                 | day^-1^\]       | evaporation     |
|                 |                 |                 | rate, bare soil |
|                 |                 | R.: map ≥ 0     |                 |
+-----------------+-----------------+-----------------+-----------------+
| ET0Maps         | et              | U.: \[mm        | Daily potential |
|                 |                 | day^-1^\]       | evapotranspirat |
|                 |                 |                 | ion             |
|                 |                 | R.: map ≥ 0     | rate, reference |
|                 |                 |                 | crop            |
+-----------------+-----------------+-----------------+-----------------+
| **DEVELOPMENT   |
| OF VEGETATION   |
| OVER TIME**     |
+-----------------+-----------------+-----------------+-----------------+
| **Map**         | **Default       | **Units,        | **Description** |
|                 | prefix**        | range**         |                 |
+-----------------+-----------------+-----------------+-----------------+
| LAIMaps\        | lai\_forest     | U.: \[m^2^      | Pixel-average   |
| for forest      |                 | m^-2^\]         | Leaf Area Index |
|                 |                 |                 | for forest      |
|                 |                 | R.: map ≥ 0     |                 |
+-----------------+-----------------+-----------------+-----------------+
| LAIMaps\        | lai\_other      | U.: \[m^2^      | Pixel-average   |
| for other       |                 | m^-2^\]         | Leaf Area Index |
|                 |                 |                 | for other       |
|                 |                 | R.: map ≥ 0     |                 |
+-----------------+-----------------+-----------------+-----------------+
| **DEFINITION OF |
| INPUT/OUTPUT    |
| TIMESERIES**    |
+-----------------+-----------------+-----------------+-----------------+
| **Map**         | **Default       | **Units,        | **Description** |
|                 | name**          | range**         |                 |
+-----------------+-----------------+-----------------+-----------------+
| Gauges          | outlets.map     | U.: \[-\]       | Nominal map     |
|                 |                 |                 | with locations  |
|                 |                 | R.: For each    | at which        |
|                 |                 | station an      | discharge       |
|                 |                 | individual      | timeseries are  |
|                 |                 | number          | reported        |
|                 |                 |                 | (usually        |
|                 |                 |                 | correspond to   |
|                 |                 |                 | gauging         |
|                 |                 |                 | stations)       |
+-----------------+-----------------+-----------------+-----------------+
| Sites           | sites.map       | U.: \[-\]       | Nominal map     |
|                 |                 |                 | with locations  |
|                 |                 | R.: For each    | (individual     |
|                 |                 | station an      | pixels or       |
|                 |                 | individual      | areas) at which |
|                 |                 | number          | timeseries of   |
|                 |                 |                 | intermediate    |
|                 |                 |                 | state and rate  |
|                 |                 |                 | variables are   |
|                 |                 |                 | reported (soil  |
|                 |                 |                 | moisture,       |
|                 |                 |                 | infiltration,   |
|                 |                 |                 | snow, etcetera) |
+-----------------+-----------------+-----------------+-----------------+

+-----------------+-----------------+-----------------+-----------------+
| ***Table        |
| A12.2**         |
| Optional maps   |
| that define     |
| grid size*      |
+=================+=================+=================+=================+
|                 |
+-----------------+-----------------+-----------------+-----------------+
| **Map**         | **Default       | **Units,        | **Description** |
|                 | name**          | range**         |                 |
+-----------------+-----------------+-----------------+-----------------+
| PixelLengthUser | pixleng.map     | U.: \[m\]       | Map with pixel  |
|                 |                 |                 | length          |
|                 |                 | R.: map \> 0    |                 |
+-----------------+-----------------+-----------------+-----------------+
| PixelAreaUser   | pixarea.map     | U.: \[m\]       | Map with pixel  |
|                 |                 |                 | area            |
|                 |                 | R.: map \> 0    |                 |
+-----------------+-----------------+-----------------+-----------------+

Tables
------

In the previous version of LISFLOOD a number of model parameters are
read through tables that are linked to the classes on the land use and
soil (texture) maps. Those tables are replaced by maps (e.g. soil
hydraulic property maps) in order to include the sub-grid variability of
each parameter. Therefore only one default table is used in the standard
LISFLOOD setting

The following table gives an overview:

  ***Table A12.3** LISFLOOD input tables*                      
----------------------------------------- ------------------ -------------------------------------------
  **LAND USE**                                                 
  **Table**                                 **Default name**   **Description**
  Day of the year -\> LAI                   LaiOfDay.txt       Lookup table: Day of the year -\> LAI map

Annex 13: LISFLOOD output
=========================

Time series
-----------

+-----------------+-----------------+-----------------+-----------------+
| ***Table        |
| A13.1**         |
| LISFLOOD        |
| default output  |
| time series*    |
+-----------------+-----------------+-----------------+-----------------+
| **RATE          |
| VARIABLES AT    |
| GAUGES**        |
+-----------------+-----------------+-----------------+-----------------+
| **Description** | **Units**       | **Settings      | **File name**   |
|                 |                 | variable**      |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^1,2^**       | m^3^ s^-1^      | disTS           | dis.tss         |
| channel         |                 |                 |                 |
| discharge       |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **NUMERICAL     |                 |                 |                 |
| CHECKS**        |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **Description** | **Units**       |                 | **File name**   |
+-----------------+-----------------+-----------------+-----------------+
| **^2^**         | m^3^            | WaterMassBalanc | mbError.tss     |
| cumulative mass |                 | eTSS            |                 |
| balance error   |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^**         | mm              | MassBalanceMM\  | mbErrorMm.tss   |
| cumulative mass |                 | TSS             |                 |
| balance error,  |                 |                 |                 |
| expressed as mm |                 |                 |                 |
| water slice     |                 |                 |                 |
| (average over   |                 |                 |                 |
| catchment)      |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** number  | \-              | NoSubStepsChan  | NoSubStepsChann |
| of sub-steps    |                 |                 | el.tss          |
| needed for      |                 |                 |                 |
| channel routing |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** number  | \-              | StepsSoilTS     | steps.tss       |
| of sub-steps    |                 |                 |                 |
| needed for      |                 |                 |                 |
| gravity-based   |                 |                 |                 |
| soil moisture   |                 |                 |                 |
| routine         |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^1^** Output  |
| only if option  |
| 'InitLisflood'  |
| = 1 (pre-run)   |
|                 |
| **^2^** Output  |
| only if option  |
| 'InitLisflood'  |
| = 0             |
+-----------------+-----------------+-----------------+-----------------+

+-----------------+-----------------+-----------------+-----------------+
| ***Table        |
| A13.2**         |
| LISFLOOD        |
| optional output |
| time series     |
| (*only          |
| 'InitLisflood'  |
| = 0)            |
|                 |
| *(continued on  |
| next pages)*    |
+-----------------+-----------------+-----------------+-----------------+
| **STATE         |
| VARIABLES AT    |
| SITES (option   |
| *repStateSites* |
| )**[^22]        |
+-----------------+-----------------+-----------------+-----------------+
| **Description** | **Units**       | **Settings      | **Default       |
|                 |                 | variable**      | name**          |
+-----------------+-----------------+-----------------+-----------------+
| depth of water  | mm              | WaterDepthTS    | wDepth.tss      |
| on soil surface |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| depth of snow   | mm              | SnowCoverTS     | snowCover.tss   |
| cover on soil   |                 |                 |                 |
| surface         |                 |                 |                 |
| (pixel-average) |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| depth of        | mm              | CumInterception | cumInt.tss      |
| interception    |                 | TS              |                 |
| storage         |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| soil moisture   | mm^3^ / mm^3^   | Theta1TS        | thTop.tss       |
| content upper   |                 |                 |                 |
| layer           |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| soil moisture   | mm^3^ / mm^3^   | Theta2TS        | thSub.tss       |
| content lower   |                 |                 |                 |
| layer           |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| storage in      | mm              | UZTS            | uz.tss          |
| upper           |                 |                 |                 |
| groundwater     |                 |                 |                 |
| zone            |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| storage in      | mm              | LZTS            | lz.tss          |
| lower           |                 |                 |                 |
| groundwater     |                 |                 |                 |
| zone            |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| number of days  | days            | DSLRTS          | dslr.tss        |
| since last rain |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| frost index     | °C days^-1^     | FrostIndexTS    | frost.tss       |
+-----------------+-----------------+-----------------+-----------------+

--------------------------------------------------------------------------------------- ------------- ----------------------- -------------------
  ***Table A13.2** LISFLOOD optional output time series (continued from previous page)*                                         
  **RATE VARIABLES AT SITES (option *repRateSites*)**[^23]                                                                      
  **Description**                                                                         **Units**     **Settings variable**   **Default name**
  rain (excluding snow)                                                                   mm/timestep   RainTS                  rain.tss
  Snow                                                                                    mm/timestep   SnowTS                  snow.tss
  snow melt                                                                               mm/timestep   SnowmeltTS              snowMelt.tss
  actual evaporation                                                                      mm/timestep   ESActTS                 esAct.tss
  actual transpiration                                                                    mm/timestep   TaTS                    tAct.tss
  rainfall interception                                                                   mm/timestep   InterceptionTS          interception.tss
  evaporation of intercepted water                                                        mm/timestep   EWIntTS                 ewIntAct.tss
  leaf drainage                                                                           mm/timestep   LeafDrainageTS          leafDrainage.tss
  infiltration                                                                            mm/timestep   InfiltrationTS          infiltration.tss
  preferential (bypass) flow                                                              mm/timestep   PrefFlowTS              prefFlow.tss
  percolation upper to lower soil layer                                                   mm/timestep   PercolationTS           dTopToSub.tss
  percolation lower soil layer to subsoil                                                 mm/timestep   SeepSubToGWTS           dSubToUz.tss
  surface runoff                                                                          mm/timestep   SurfaceRunoffTS         surfaceRunoff.tss
  outflow from upper zone                                                                 mm/timestep   UZOutflowTS             qUz.tss
  outflow from lower zone                                                                 mm/timestep   LZOutflowTS             qLz.tss
  total runoff                                                                            mm/timestep   TotalRunoffTS           totalRunoff.tss
  percolation from upper to lower zone                                                    mm/timestep   GwPercUZLZTS            percUZLZ.tss
  loss from lower zone                                                                    mm/timestep   GwLossTS                loss.tss
--------------------------------------------------------------------------------------- ------------- ----------------------- -------------------

+-----------------+-----------------+-----------------+-----------------+
| TIME SERIES,    |
| AVERAGE         |
| UPSTREAM OF     |
| GAUGES          |
+-----------------+-----------------+-----------------+-----------------+
| **METEOROLOGICA |
| L               |
| INPUT VARIABLES |
| (option         |
| *repMeteoUpsGau |
| ges*)**         |
+-----------------+-----------------+-----------------+-----------------+
| **Description** | **Units**       | **Settings      | **Default       |
|                 |                 | variable**      | name**          |
+-----------------+-----------------+-----------------+-----------------+
| precipitation   | mm/timestep     | PrecipitationAv | precipUps.tss   |
|                 |                 | UpsTS           |                 |
+-----------------+-----------------+-----------------+-----------------+
| potential       | mm/timestep     | ETRefAvUpsTS    | etUps.tss       |
| reference       |                 |                 |                 |
| evapotranspirat |                 |                 |                 |
| ion             |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| potential       | mm/timestep     | ESRefAvUpsTS    | esUps.tss       |
| evaporation     |                 |                 |                 |
| from soil       |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| potential open  | mm/timestep     | EWRefAvUpsTS    | ewUps.tss       |
| water           |                 |                 |                 |
| evaporation     |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| average daily   | °C              | TavgAvUpsTS     | tAvgUps.tss     |
| temperature     |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| ***Table        |
| A13.2**         |
| LISFLOOD        |
| optional output |
| time series     |
| (continued from |
| previous page)* |
+-----------------+-----------------+-----------------+-----------------+
| **STATE         |
| VARIABLES       |
| (option         |
| *repStateUpsGau |
| ges*)**         |
+-----------------+-----------------+-----------------+-----------------+
| **Description** | **Units**       | **Settings      | **Default       |
|                 |                 | variable**      | name**          |
+-----------------+-----------------+-----------------+-----------------+
| depth of water  | mm              | WaterDepthAvUps | wdepthUps.tss   |
| on soil surface |                 | TS              |                 |
+-----------------+-----------------+-----------------+-----------------+
| depth of snow   | mm              | SnowCoverAvUpsT | snowCoverUps.ts |
| cover on        |                 | S               | s               |
+-----------------+-----------------+-----------------+-----------------+
| depth of        | mm              | CumInterception | cumInterception |
| interception    |                 | AvUpsTS         | Ups.tss         |
| storage         |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| soil moisture   | mm^3^ / mm^3^   | Theta1AvUpsTS   | thTopUps.tss    |
| upper layer     |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| soil moisture   | mm^3^ / mm^3^   | Theta2AvUpsTS   | thSubUps.tss    |
| lower layer     |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| groundwater     | mm              | UZAvUpsTS       | uzUps.tss       |
| upper zone      |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| groundwater     | mm              | LZAvUpsTS       | lzUps.tss       |
| lower zone      |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| number of days  | Days            | DSLRAvUpsTS     | dslrUps.tss     |
| since last rain |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| frost index     | °C days^-1^     | FrostIndexAvUps | frostUps.tss    |
|                 |                 | TS              |                 |
+-----------------+-----------------+-----------------+-----------------+
| ***Table        |
| A13.2**         |
| LISFLOOD        |
| optional output |
| time series     |
| (continued from |
| previous page)* |
+-----------------+-----------------+-----------------+-----------------+
| **RATE          |
| VARIABLES       |
| (option         |
| *repRateUpsGaug |
| es*)**          |
+-----------------+-----------------+-----------------+-----------------+
| **Description** | **Units**       | **Settings      | **Default       |
|                 |                 | variable**      | name**          |
+-----------------+-----------------+-----------------+-----------------+
| rain (excluding | mm/timestep     | RainAvUpsTS     | rainUps.tss     |
| snow)           |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| snow            | mm/timestep     | SnowAvUpsTS     | snowUps.tss     |
+-----------------+-----------------+-----------------+-----------------+
| snow melt       | mm/timestep     | SnowmeltAvUpsTS | snowMeltUps.tss |
+-----------------+-----------------+-----------------+-----------------+
| actual          | mm/timestep     | ESActAvUpsTS    | esActUps.tss    |
| evaporation     |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| actual          | mm/timestep     | TaAvUpsTS       | tActUps.tss     |
| transpiration   |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| rainfall        | mm/timestep     | InterceptionAvU | interceptionUps |
| interception    |                 | psTS            | .tss            |
+-----------------+-----------------+-----------------+-----------------+
| evaporation of  | mm/timestep     | EWIntAvUpsTS    | ewIntActUps.tss |
| intercepted     |                 |                 |                 |
| water           |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| leaf drainage   | mm/timestep     | LeafDrainageAvU | leafDrainageUps |
|                 |                 | psTS            | .tss            |
+-----------------+-----------------+-----------------+-----------------+
| infiltration    | mm/timestep     | InfiltrationAvU | infiltrationUps |
|                 |                 | psTS            | .tss            |
+-----------------+-----------------+-----------------+-----------------+
| preferential    | mm/timestep     | PrefFlowAvUpsTS | prefFlowUps.tss |
| (bypass) flow   |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| percolation     | mm/timestep     | PercolationAvUp | dTopToSubUps.ts |
| upper to lower  |                 | sTS             | s               |
|                 |                 |                 |                 |
| soil layer      |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| percolation     | mm/timestep     | SeepSubToGWAvUp | dSubToUzUps.tss |
| lower soil      |                 | sTS             |                 |
| layer           |                 |                 |                 |
|                 |                 |                 |                 |
| to subsoil      |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| surface runoff  | mm/timestep     | SurfaceRunoffAv | surfaceRunoffUp |
|                 |                 | UpsTS           | s.tss           |
+-----------------+-----------------+-----------------+-----------------+
| outflow from    | mm/timestep     | UZOutflowAvUpsT | qUzUps.tss      |
| upper zone      |                 | S               |                 |
+-----------------+-----------------+-----------------+-----------------+
| outflow from    | mm/timestep     | LZOutflowAvUpsT | qLzUps.tss      |
| lower zone      |                 | S               |                 |
+-----------------+-----------------+-----------------+-----------------+
| total runoff    | mm/timestep     | TotalRunoffAvUp | totalRunoffUps. |
|                 |                 | sTS             | tss             |
+-----------------+-----------------+-----------------+-----------------+
| percolation     | mm/timestep     | GwPercUZLZAvUps | percUZLZUps.tss |
| upper to lower  |                 | TS              |                 |
| zone            |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| loss from lower | mm/timestep     | GwLossTS        | lossUps.tss     |
| zone            |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+

------------------------------------------------------- -------------------------- ----------------------- ------------------
  **WATER LEVEL IN CHANNEL (option *repWaterLevelTs*)**                                                      
  **Description**                                         **Units**                  **Settings variable**   **Default name**
  water level in channel                                  m (above channel bottom)   WaterLevelTS            waterLevel.tss
------------------------------------------------------- -------------------------- ----------------------- ------------------

Finally, some additional output options exist that don't fit in any of
the above categories.

------------------------------------------------- ------------------------ ------------ ----------------------- ------------------
  **OUTPUT RELATED TO LOWER ZONE INITIALISATION**                                                                 
  **Description**                                   **Option**                            **Settings variable**   **Default name**
  average inflow into lower zone                    repLZAvInflowSites       mm day^-1^   LZAvInflowTS            lzAvIn.tss
  average inflow into lower zone                    repLZAvInflowUpsGauges   mm day^-1^   LZAvInflowAvUpsTS       lzAvInUps.tss
------------------------------------------------- ------------------------ ------------ ----------------------- ------------------

 Maps
-----

+-----------------+-----------------+-----------------+-----------------+
| ***Table        |
| A13.3**         |
| LISFLOOD        |
| default output  |
| maps*           |
+-----------------+-----------------+-----------------+-----------------+
| **AVERAGE       |
| RECHARGE MAP    |
| (for lower      |
| groundwater     |
| zone)** (option |
| InitLisflood)   |
+-----------------+-----------------+-----------------+-----------------+
| **Description** | **Units**       | **File name**   | **Domain**      |
+-----------------+-----------------+-----------------+-----------------+
| **^1^** average | mm day^-1^      | lzavin.map      | other fraction  |
| inflow to lower |                 |                 |                 |
| zone            |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^1^** average | mm day^-1^      | lzavin\_forest. | forest fraction |
| inflow to lower |                 | map             |                 |
| zone (forest)   |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **INITIAL       |
| CONDITION MAPS  |
| at defined time |
| steps**[^26]    |
| (option         |
| *repStateMaps*) |
+-----------------+-----------------+-----------------+-----------------+
| **Description** | **Units**       | **File          | **Domain**      |
|                 |                 | name**[^27]     |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^**         | mm              | wdepth00.xxx    | whole pixel     |
| waterdepth      |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** channel | m^2^            | chcro000.xxx    | channel         |
| cross-sectional |                 |                 |                 |
| area            |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** days    | days            | dslr0000.xxx    | other pixel     |
| since last rain |                 |                 |                 |
| variable        |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** snow    | mm              | scova000.xxx    | snow zone A     |
| cover zone *A*  |                 |                 | (1/3^rd^ pixel) |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** snow    | mm              | scovb000.xxx    | snow zone B     |
| cover zone *B*  |                 |                 | (1/3^rd^ pixel) |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** snow    | mm              | scovc000.xxx    | snow zone C     |
| cover zone *C*  |                 |                 | (1/3^rd^ pixel) |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** frost   | °C days^-1^     | frost000.xxx    | other pixel     |
| index           |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^**         | mm              | cumi0000.xxx    | other pixel     |
| cumulative      |                 |                 |                 |
| interception    |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** soil    | mm^3^/mm^3^     | thtop000.xxx    | other fraction  |
| moisture upper  |                 |                 |                 |
| layer           |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** soil    | mm^3^/mm^3^     | thsub000.xxx    | other fraction  |
| moisture lower  |                 |                 |                 |
| layer           |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** water   | mm              | lz000000.xxx    | other fraction  |
| in lower zone   |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** water   | mm              | uz000000.xxx    | other fraction  |
| in upper zone   |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** days    | days            | dslF0000.xxx    | forest pixel    |
| since last rain |                 |                 |                 |
| variable        |                 |                 |                 |
| (forest)        |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^**         | mm              | cumF0000.xxx    | forest pixel    |
| cumulative      |                 |                 |                 |
| interception    |                 |                 |                 |
| (forest)        |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** soil    | mm^3^/mm^3^     | thFt0000.xxx    | forest fraction |
| moisture upper  |                 |                 |                 |
| layer (forest)  |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** soil    | mm^3^/mm^3^     | thFs0000.xxx    | forest fraction |
| moisture lower  |                 |                 |                 |
| layer (forest)  |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** water   | mm              | lzF00000.xxx    | forest fraction |
| in lower zone   |                 |                 |                 |
| (forest)        |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** water   | mm              | uzF00000.xxx    | forest fraction |
| in upper zone   |                 |                 |                 |
| (forest)        |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^2^** water   | mm              | cseal000.xxx    | sealed fraction |
| in depression   |                 |                 |                 |
| storage         |                 |                 |                 |
| (sealed)        |                 |                 |                 |
+-----------------+-----------------+-----------------+-----------------+
| **^1^** Output  |
| only if option  |
| 'InitLisflood'  |
| = 1 (pre-run)   |
|                 |
| **^2^** Output  |
| only if option  |
| 'InitLisflood'  |
| = 0             |
+-----------------+-----------------+-----------------+-----------------+

+-------------+-------------+-------------+-------------+-------------+
| **\         |
| *Table      |
| A13.4***    |
| *LISFLOOD   |
| optional    |
| output maps |
| (*only      |
| 'InitLisflo |
| od'         |
| = 0)        |
|             |
| *(continued |
| on next     |
| page)*      |
+-------------+-------------+-------------+-------------+-------------+
| **DISCHARGE |
| AND WATER   |
| LEVEL**     |
+-------------+-------------+-------------+-------------+-------------+
| **Descripti | **Option**  | **Units**   | **Settings  | **Prefix**  |
| on**        |             |             | variable**  |             |
+-------------+-------------+-------------+-------------+-------------+
| discharge   | repDischarg | m^3^s^-1^   | DischargeMa | dis         |
|             | eMaps       |             | ps          |             |
+-------------+-------------+-------------+-------------+-------------+
| water level | repWaterLev | m (above    | WaterLevelM | wl          |
|             | elMaps      | channel     | aps         |             |
|             |             | bottom)     |             |             |
+-------------+-------------+-------------+-------------+-------------+
| **METEOROLO |
| GICAL       |
| INPUT       |
| VARIABLES** |
+-------------+-------------+-------------+-------------+-------------+
| **Descripti | **Option**  |             | **Settings  | **Prefix**  |
| on**        |             |             | variable**  |             |
+-------------+-------------+-------------+-------------+-------------+
| precipitati | repPrecipit | mm          | Precipitati | pr          |
| on          | ationMaps   |             | onMaps      |             |
+-------------+-------------+-------------+-------------+-------------+
| potential   | repETRefMap | mm          | ETRefMaps   | et          |
| reference   | s           |             |             |             |
| evapotransp |             |             |             |             |
| iration     |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| potential   | repESRefMap | mm          | ESRefMaps   | es          |
| evaporation | s           |             |             |             |
| from soil   |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| potential   | repEWRefMap | mm          | EWRefMaps   | ew          |
| open water  | s           |             |             |             |
| evaporation |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| average     | repTavgMaps | mm          | TavgMaps    | tav         |
| daily       |             |             |             |             |
| temperature |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| **STATE     |
| VARIABLES** |
| [^30]       |
+-------------+-------------+-------------+-------------+-------------+
| **Descripti | **Option**  |             | **Settings  | **Prefix**  |
| on**        |             |             | variable**  |             |
+-------------+-------------+-------------+-------------+-------------+
| depth of    | repWaterDep | mm          | WaterDepthM | wdep        |
| water on    | thMaps      |             | aps         |             |
| soil        |             |             |             |             |
| surface     |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| depth of    | repSnowCove | mm          | SnowCoverMa | scov        |
| snow cover  | rMaps       |             | ps          |             |
| on soil     |             |             |             |             |
| surface     |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| depth of    | repCumInter | mm          | CumIntercep | cumi        |
| interceptio | ceptionMaps |             | tionMaps    |             |
| n           |             |             |             | cumF        |
| storage     |             |             | CumIntercep |             |
|             |             |             | tionForestM |             |
|             |             |             | aps         |             |
+-------------+-------------+-------------+-------------+-------------+
| soil        | repTheta1Ma | mm^3^       | Theta1Maps  | thtop       |
| moisture    | ps          | /mm^3^      |             |             |
| content     |             |             | Theta1Fores | thFt        |
| upper layer |             |             | tMaps       |             |
+-------------+-------------+-------------+-------------+-------------+
| soil        | repTheta2Ma | mm^3^       | Theta2Maps  | thsub       |
| moisture    | ps          | /mm^3^      |             |             |
| content     |             |             | Theta2Fores | thFs        |
| lower layer |             |             | tMaps       |             |
+-------------+-------------+-------------+-------------+-------------+
| storage in  | repUZMaps   | mm          | UZMaps      | uz          |
| upper       |             |             |             |             |
| groundwater |             |             | UZForestMap | uzF         |
| zone        |             |             | s           |             |
+-------------+-------------+-------------+-------------+-------------+
| storage in  | repLZMaps   | mm          | LZMaps      | lz          |
| lower       |             |             |             |             |
| groundwater |             |             | LZForestMap | lzF         |
| zone        |             |             | s           |             |
+-------------+-------------+-------------+-------------+-------------+
| number of   | repDSLRMaps | days        | DSLRMaps    | dslr        |
| days since  |             |             |             |             |
| last rain   |             |             | DSLRForestM | dslF        |
|             |             |             | aps         |             |
+-------------+-------------+-------------+-------------+-------------+
| frost index | repFrostInd | °C days^-1^ | FrostIndexM | frost       |
|             | exMaps      |             | aps         |             |
+-------------+-------------+-------------+-------------+-------------+
| **RATE      |
| VARIABLES** |
| [^31]       |
+-------------+-------------+-------------+-------------+-------------+
| **Descripti | **Option**  |             | **Settings  | **Prefix**  |
| on**        |             |             | variable**  |             |
+-------------+-------------+-------------+-------------+-------------+
| rain        | repRainMaps | mm/timestep | RainMaps    | rain        |
| (excluding  |             |             |             |             |
| snow)       |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| snow        | repSnowMaps | mm/timestep | SnowMaps    | snow        |
+-------------+-------------+-------------+-------------+-------------+
| snow melt   | repSnowMelt | mm/timestep | SnowMeltMap | smelt       |
|             | Maps        |             | s           |             |
+-------------+-------------+-------------+-------------+-------------+
| actual      | repESActMap | mm/timestep | ESActMaps   | esact       |
| evaporation | s           |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| actual      | repTaMaps   | mm/timestep | TaMaps      | tact        |
| transpirati |             |             |             |             |
| on          |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| rainfall    | repIntercep | mm/timestep | Interceptio | int         |
| interceptio | tionMaps    |             | nMaps       |             |
| n           |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| evaporation | repEWIntMap | mm/timestep | EWIntMaps   | ewint       |
| of          | s           |             |             |             |
| intercepted |             |             |             |             |
| water       |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| leaf        | repLeafDrai | mm/timestep | LeafDrainag | ldra        |
| drainage    | nageMaps    |             | eMaps       |             |
+-------------+-------------+-------------+-------------+-------------+
| infiltratio | repInfiltra | mm/timestep | Infiltratio | inf         |
| n           | tionMaps    |             | nMaps       |             |
+-------------+-------------+-------------+-------------+-------------+
| preferentia | repPrefFlow | mm/timestep | PrefFlowMap | pflow       |
| l           | Maps        |             | s           |             |
| (bypass)    |             |             |             |             |
| flow        |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| percolation | repPercolat | mm/timestep | Percolation | to2su       |
| upper to    | ionMaps     |             | Maps        |             |
| lower soil  |             |             |             |             |
| layer       |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| ***Table    |
| 12.4**      |
| LISFLOOD    |
| optional    |
| output maps |
| (continued  |
| from        |
| previous    |
| page)*      |
+-------------+-------------+-------------+-------------+-------------+
| percolation | repSeepSubT | mm/timestep | SeepSubToGW | su2gw       |
| lower soil  | oGWMaps     |             | Maps        |             |
| layer to    |             |             |             |             |
| subsoil     |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| surface     | repSurfaceR | mm/timestep | SurfaceRuno | srun        |
| runoff      | unoffMaps   |             | ffMaps      |             |
+-------------+-------------+-------------+-------------+-------------+
| outflow     | repUZOutflo | mm/timestep | UZOutflowMa | quz         |
| from upper  | wMaps       |             | ps          |             |
| zone        |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| outflow     | repLZOutflo | mm/timestep | LZOutflowMa | qlz         |
| from lower  | wMaps       |             | ps          |             |
| zone        |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| total       | repTotalRun | mm/timestep | TotalRunoff | trun        |
| runoff      | offMaps     |             | Maps        |             |
+-------------+-------------+-------------+-------------+-------------+
| percolation | repGwPercUZ | mm/timestep | GwPercUZLZM | uz2lz       |
| upper to    | LZMaps      |             | aps         |             |
| lower zone  |             |             |             |             |
+-------------+-------------+-------------+-------------+-------------+
| loss from   | rep         | mm/timestep | GwLossMaps  | loss        |
| lower zone  | GwLossMaps  |             |             |             |
+-------------+-------------+-------------+-------------+-------------+

Index
=====

Actual infiltration, 19Additional output, 74AvWaterRateThreshold,
48b\_Xinanjiang, 51CalChanMan, 52CalendarDayStart, 46CalEvaporation,
48Channel routing, 25cold start, 63crop coefficient, 14Default LISFLOOD
output, 73degree-day factor, 5Direct evaporation, 16direct runoff
fraction', 10Double kinematic, 101DtSec, 46DtSecChannel, 46Dynamic wave,
107Evaporation, 13evapotranspiration, 5Frost index,
8FrostIndexThreshold, 50Groundwater, 22GwLoss, 52GwPercValue, 51icemelt,
7Impervious surface, 11Infiltration capacity, 17Inflow hydrograph,
97Initial conditions, 56Initialisation, 62Input maps, 29Input tables,
32Interception, 12kdf, 48kinematic wave equations, 25Lakes, 91Leaf Area
Index, 12Leaf area index maps, 32LeafDrainageTimeConstant, 48lfbinding,
36lfoption, 42lfuser, 36LISVAP, 5LowerZoneTimeConstant, 51map stack,
30mask map, 29number of days since the last rain, 16PathMaps, 54PathOut,
54PathTables, 54PCRaster, 1pF values, 121Polder, 85PowerPrefFlow,
51Precipitation, 5Preferential bypass flow, 18Prefixes, 55pre-run,
68PrScaling, 48QSplitMult, 103Rain, 5Reduction of transpiration in case
of water, 15ReportSteps, 46reservoirs, 79Routing of surface runoff,
23seasonal variable melt factor, 6settings file, 35SMaxSealed, 48snow,
5SnowFactor, 50SnowMeltCoef, 50SnowSeasonAdj, 50SnowWaterEquivalent,
50Soil moisture redistribution, 20StepEnd, 46StepStart, 46sub-grid
variability, 9temperature lapse rate, 7TemperatureLapseRate, 50TempMelt,
50TempSnow, 50transmission loss, 111transpiration,
14UpperZoneTimeConstant, 51Using options, 61warm start, 70water
fraction, 10water levels, 119Water uptake by plant roots, 14water use,
115Xinanjiang model, 17

![](media/media/image59.jpeg){width="1.3152777777777778in"
height="1.0847222222222221in"}![](media/media/image60.png){width="1.5930555555555554in"
height="0.7534722222222222in"}![](media/media/image61.png){width="8.266666666666667in"
height="1.476388888888889in"}z

[^1]: Note that the model needs *daily* average temperature values, even
    if the model is run on a smaller time interval (e.g. hourly). This
    is because the routines for snowmelt and soil freezing are use
    empirical relations which are based on daily temperature data. Just
    as an example, feeding hourly temperature data into the snowmelt
    routine can result in a gross overestimation of snowmelt. This is
    because even on a day on which the average temperature is below
    *T~m~* (no snowmelt), the instantaneous (or hourly) temperature may
    be higher for a part of the day, leading to unrealistically high
    simulated snowmelt rates.

[^2]: In the LISFLOOD settings file this critical amount is currently
    expressed as an *intensity* \[mm day^-1^\]. This is because the
    equation was originally designed for a daily time step only. Because
    the current implementation will likely lead to *DSLR* being reset
    too frequently, the exact formulation may change in future versions
    (e.g. by keeping track of the accumulated available water of the
    last 24 hours).

[^3]: The file names listed in the table are not obligatory. However, it
    is suggested to stick to the default names suggested in the table.
    This will make both setting up the model for new catchments as well
    as upgrading to possible future LISFLOOD versions much easier.

[^4]: The reason why *--listoptions* produces "default=0" for the
    reservoirs option, is that --internally within the model- the
    reservoir option consists of two blocks of code: one block is the
    actual reservoir code, and another one is some dummy code that is
    activated if the reservoirs option is switched off (the dummy code
    is needed because some internal model variables that are associated
    with reservoirs need to be defined, even if no reservoirs are
    simulated). Both blocks are associated with "*simulateReservoirs=1*"
    and "*simulateReservoirs=0*", respectively, where the
    "*simulateReservoirs=0*" block is marked as the default choice. In
    case of the "*repDischargeMaps*" option, there *is* no block of code
    that is associated with "*repDischargeMaps=0*", hence formally there
    is no default value.

[^5]: Can be disabled by either option *repStateMaps=0 or setting
    ReportSteps to a high value e.g. \<textvar name=\"ReportSteps\"
    value=\"99999\"\>*

[^6]: Output time steps are defined with ReportSteps in the settings
    file (see chapter 5) or only for the last time step with option
    'repEndMaps'

[^7]: xxx represents the number of the last time step; e.g. or a
    730-step simulation the end map of 'waterdepth' will be
    'wdepth00.730', and so on.

[^8]: Output time steps are defined with ReportSteps in the settings
    file (see chapter 5) or only for the last time step with option
    'repEndMaps'

[^9]: xxx represents the number of the last time step; e.g. or a
    730-step simulation the end map of 'waterdepth' will be
    'wdepth00.730', and so on.

[^10]: xxx represents the number of the last time step; e.g. for a
    730-step simulation the name will be 'rsfil000.730', and so on.

[^11]: xxx represents the number of the last time step; e.g. for a
    730-step simulation the name will be 'hpol0000.730', and so on.

[^12]: xxx represents the number of the last time step; e.g. for a
    730-step simulation the name will be 'lakh0000.730', and so on.

[^13]: Actually, the --listoptions switch will show you a couple of
    options that are not listed in Table 6.1. These are either debugging
    options (which are irrelevant to the model user) or experimental
    features that may not be completely finalised (and thus remain
    undocumented here until they are)

[^14]: This option can only be used in combination with the
    'simulateWaterLevels' option!

[^15]: This option can only be used in combination with the
    'simulateWaterLevels' option!

[^16]: Deprecated; this feature may not be supported in forthcoming
    LISFLOOD releases. Use *repStateMaps* instead, which gives you the
    same maps with the added possibility to report them for any required
    time step(s).

[^17]: This option can only be used in combination with the
    'simulateWaterLevels' option!

[^18]: Deprecated; this feature may not be supported in forthcoming
    LISFLOOD releases. Use *repStateMaps* instead, which gives you the
    same maps with the added possibility to report them for any required
    time step(s).

[^19]: The file names listed in the table are not obligatory. However,
    it is suggested to stick to the default names suggested in the
    table. This will make both setting up the model for new catchments
    as well as upgrading to possible future LISFLOOD versions much
    easier.

[^20]: The file names listed in the table are not obligatory. However,
    it is suggested to stick to the default names suggested in the
    table. This will make both setting up the model for new catchments
    as well as upgrading to possible future LISFLOOD versions much
    easier.

[^21]: State variables represents the state of a variable at the end of
    a time step (or beginning of the next time step (e.g. Hiking
    analogy: walked kilometer till the first break)

[^22]: State variables represents the state of a variable at the end of
    a time step (or beginning of the next time step (e.g. Hiking
    analogy: walked kilometer till the first break)

[^23]: Rate variable represents the average flux between beginning and
    end of a time step (e.g. hiking analogy: speed of walking during the
    first part)

[^24]: Output time steps are defined with ReportSteps in the settings
    file (see chapter 5) or only for the last time step with option
    'repEndMaps'

[^25]: xxx represents the number of the last time step; e.g. or a
    730-step simulation the end map of 'waterdepth' will be
    'wdepth00.730', and so on.

[^26]: Output time steps are defined with ReportSteps in the settings
    file (see chapter 5) or only for the last time step with option
    'repEndMaps'

[^27]: xxx represents the number of the last time step; e.g. or a
    730-step simulation the end map of 'waterdepth' will be
    'wdepth00.730', and so on.

[^28]: State variables represents the state of a variable at the end of
    a time step (or beginning of the next time step (e.g. Hiking
    analogy: walked kilometer till the first break)

[^29]: Rate variable represents the average flux between beginning and
    end of a time step (e.g. hiking analogy: speed of walking during the
    first part)

[^30]: State variables represents the state of a variable at the end of
    a time step (or beginning of the next time step (e.g. Hiking
    analogy: walked kilometer till the first break)

[^31]: Rate variable represents the average flux between beginning and
    end of a time step (e.g. hiking analogy: speed of walking during the
    first part)
