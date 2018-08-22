
![](media/image2.png)

### Disclaimer
```R
  # Not sure that it should stay here or if we should put the Disclaimer in the overall description of the LISFLOOD documentation OR at the end of this document ... I don't like it very much at the beginning
  ```
Both the program code and this manual have been carefully inspected before printing. However, no  warranties, either expressed or implied, are made concerning the accuracy, completeness, reliability, usability, performance, or fitness for any particular purpose of the information contained in this manual, to the software described in this manual, and to other material supplied in connection therewith. The material  is provided \"as is\". The entire risk as to its quality and performance is with the user.


# Introduction
```R
  # Needs to be revised. A link to the "LISFLOOD model description" (separate document) is essential
  ```
The LISFLOOD model is a hydrological rainfall-runoff model that is capable of simulating the hydrological processes that occur in a catchment. LISFLOOD has been developed by the floods group of the Natural Hazards Project of the Joint Research Centre (JRC) of the European Commission. The specific development objective was to produce a tool that can be used in large and trans-national catchments for a variety of applications, including:

- Flood forecasting
- Assessing the effects of river regulation measures, of land-use change and of climate change

Although a wide variety of existing hydrological models are available that are suitable for *each* of these individual tasks, few *single* models are capable of doing *all* these jobs. Besides this, our objective requires a model that is spatially distributed and, at least to a certain extent, physically-based. Also, the focus of our work is on European catchments. Since several databases exist that contain pan-European information on soils (King *et al.*, 1997; Wösten *et al.*, 1999), land cover (CEC, 1993), topography (Hiederer & de Roo, 2003) and meteorology (Rijks *et al.*, 1998), it would be advantageous to have a model that makes the best possible use of these data. Finally, the wide scope of our objective implies that changes and extensions to the model will be required from time to time. Therefore, it is essential to have a model code that can be easily  maintained and modified. LISFLOOD has been specifically developed to satisfy these requirements. The model is designed to be applied across a wide range of spatial and temporal scales. LISFLOOD is grid-based, and applications so far have employed grid cells of as little as 100 metres for medium-sized catchments, to 5000 metres for modelling the whole of Europe and up to 0.1° (around 10 km) for modelling globally. Long-term water balance can be simulated (using a daily time step), as well as individual flood events (using hourly time intervals, or even smaller). The output of a "water balance run" can be used to provide the initial conditions of a "flood run". Although the model's primary output product is channel discharge, all internal rate and state variables (soil moisture, for example) can be written as output as well. In addition, all output can be written as grids, or time series at user-defined points or areas. The user has complete control over how output is written, thus minimising any waste of disk space or CPU time.

[:top:](#top)

# About LISFLOOD and this user guide

The __LISFLOOD__ model is implemented in the PCRaster Environmental Modelling language Version 3.0.0 (Wesseling et al., 1996), wrapped in a Python based interface. PCRaster is a raster GIS environment that has its own high-level computer language, which allows the construction of iterative spatio-temporal environmental models. The Python wrapper of LISFLOOD enables the user to control the model inputs and outputs and the selection of the model modules. This approach combines the power, relative simplicity and maintainability of code written in the the PCRaster Environmental Modelling language and the flexibility of Python.
LISFLOOD runs on any operating for which Python and PCRaster are available. Currently these include 32-bits Windows (e.g. Windows XP, Vista, 7) and a number of Linux distributions.

```R
  # Needs to be revised. A link to the "LISFLOOD model description" (separate document) is essential
  ```
This revised __User Manual__ documents LISFLOOD version December 1 2013, and replaces all previous documentation of the model (e.g. van der Knijff & de Roo, 2008; de Roo *et. al.*, 2003). The scope of this document is to give model users all the information that is needed for successfully using LISFLOOD.
Chapter 2 explains the theory behind the model, including all model equations and the changes to the previous version. The remaining chapters cover all practical aspects of working with LISFLOOD. Chapter 3 to 8 explains how to setup LISFLOOD, how to modify the settings and the outputs.
A series of Annexes at the end of this document describe some optional features that can be activated  when running the model. Most model users will not need these features (which are disabled by default), and for the sake of clarity we therefore decided to keep their description out of the main text. The  current document does not cover the calculation of the potential evapo (transpi)ration rates that are  needed as input to the model. A separate pre-processor (LISVAP) exists that calculates these variables  from standard (gridded) meteorological observations. LISVAP is documented in a separate volume (van  der Knijff, 2006). 

[:top:](#top)

# Explaining the essential files

## LISFLOOD settings file

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

### Layout of the settings file

A LISFLOOD settings file is made up of 4 elements, each of which has a
specific function. The general structure of the file is described using
XML-tags. XML stands for 'E**x**tensible **M**arkup **L**anguage', and
it is really nothing more than a way to describe data in a file. It
works by putting information that goes into a (text) file between tags,
and this makes it very easy add structure. For a LISFLOOD settings file,
the basic structure looks like this:

```xml
    <?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>  
    \<lfsettings>     Start of settings element
       \<lfuser>      Start of element with user-defined variables
       \</lfuser>     End of element with user-defined variables
       \<lfoptions>   Start of element with options
       \</lfoptions>  End of element with options
       \<lfbinding>   Start of element with 'binding' variables
       \</lfbinding>  End of element with 'binding' variables
       \<prolog>      Start of prolog
       \</prolog>     End of prolog
    \<lfsettings>     End of settings element
```

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

  *element*     | main function
  ------------- | -----------------------------------------------------------------------------------------------------------
  *lfuser*      | definition of **paths** to all in- and output files, and main model parameters (calibration + time-related)
  *lfbinding*   | definition of all **individual** in- and output **files**, and model **parameters**
  *lfoptions*   | **switches** to turn specific components of the model on or off

The following sections explain the function of each element in more
detail. This is mainly to illustrate the main concepts and how it all
fits together. A detailed description of all the variables that are
relevant for setting up and running LISFLOOD is given in Chapter 6.

#### lfuser and lfbinding elements

The 'lfbinding' element provides a very low-level way to define all
model parameter values as well as all in- and output maps, time series
and tables. 

The 'lfuser' element is used to define (user-defined) text
variables. These text variables can be used to substitute repeatedly
used expressions in the binding element. This greatly reduces the amount
of work that is needed to prepare the settings file. Each variable is
defined as a 'textvar' element within 'lfuser'/'lfbinding'. Each
'textvar' element has the attributes 'name' and 'value'. The following
example demonstrates the main principle (note that in the examples below
the prolog element is left out, but you will never need to edit this
anyway) :

```xml
    <?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>  
    <lfsettings>                                                    
    <lfuser>                                                        
    <textvar name="PathMaps"                                           
    value="//cllx01/floods2/knijfjo/test/maps">                        
    </textvar>                                                          
    </lfuser>                                                       
    <lfoptions>                                                     
    </lfoptions>                                                    
    <lfbinding>                                                     
    <textvar name="LandUse" value="\$(PathMaps)/landuse.map">       
    </textvar>                                                          
    <textvar name="SoilDepth" value="\$(PathMaps)/soildep.map">     
    </textvar>                                                          
    </lfbinding>                                                    
    </lfsettings>                                                   
```

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

```xml
   <?xml version=\"1.0\" encoding=\"UTF-8\"?\>  
   <!DOCTYPE lfsettings SYSTEM "lisflood.dtd">                       
   <lfsettings>                                                    
   <lfuser>                                                        
   <comment>                                                           

   **************************************************************               

   CALIBRATION PARAMETERS                                                

   **************************************************************               

   </comment>                                                          
   <textvar name="UpperZoneTimeConstant" value="10">               
   <comment>                                                           
   Time constant for water in upper zone [days*mm\^GwAlpha]           
   </comment>                                                          
   </textvar>                                                          
   <comment>                                                           

   **************************************************************               

   FILE PATHS                                                            

   **************************************************************               

   </comment>                                                          
   <textvar name="PathMeteo"                                          
   value="//cllx01/floods2/knijfjo/test/meteo">                       
   <comment>                                                           
   Meteo path                                                            
   </comment>                                                          
   </textvar>                                                          
   <comment>                                                           

   **************************************************************               

   PREFIXES OF METEO VARIABLES                                           

   **************************************************************               

   </comment>                                                          
   <textvar name="PrefixPrecipitation" value="pr">                 
   <comment>                                                           
   prefix precipitation maps                                             
   </comment>                                                          
   </textvar>                                                          
   </lfuser>                                                       
   <lfoptions> </lfoptions>                                      
   <lfbinding>                                                     
   <textvar name="UpperZoneTimeConstant"                              
   value="$(UpperZoneTimeConstant)">                                 
   <comment>                                                           
   Time constant for water in upper zone [days\*mm\^GwAlpha]           
   </comment>                                                          
   </textvar>                                                          
   <textvar name="PrecipitationMaps"                                  
   value="$(PathMeteo)/$(PrefixPrecipitation)">                     
   <comment>                                                           
   precipitation [mm/day]                                              
   </comment>                                                          
   </textvar>                                                          
   </lfbinding>                                                    
   </lfsettings>                                                   
```

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
'lfuser' variables to define this structure. Also, note that both
the *name* and *value* of each variable must be wrapped in (single or
double) quotes. Dedicated XML-editors like XmlSpy take care of this
automatically, so you won't usually have to worry about this.

__**NOTES:**__

1.  It is important to remember that the *only* function of the 'lfuser'
    element is to *define* text variables; you can not *use* any of
    these text variables within the 'lfuser' element. For example, the
    following 'lfuser' element is *wrong* and *will not work*:

```xml
  <lfuser>                                                        
  <textvar name="PathInit"                                           
  value="//cllx01/floods2/knijfjo/test/init">                        
  <comment>                                                           
   Path to initial conditions maps                                       
  </comment>                                                          
  </textvar>                                                          
  <textvar name="LZInit" value="$(PathInit)/lzInit.map)">        
  <comment>                                                           
  Initial lower zone storage                                            
  ** USE OF USER VARIABLE WITHIN LFUSER                               
  ** IS NOT ALLOWED, SO THIS EXAMPLE WILL NOT WORK!!                  
  </comment>                                                          
  </textvar>                                                          
  </lfuser>                                                       
```

2.  It *is* possible to define *everything* directly in the 'lfbinding'
    element without using any text variables at all! In that case the
    'lfuser' element can remain empty, even though it *has* to be
    present (i.e. <lfuser> </lfuser>). In general this is not
    recommended.

3.  Within the *lfuser* and *lfbinding* elements, model variables are
    organised into *groups*. This is just to make navigation in an xml
    editor easier.

#### Variables in the lfbinding element

The variables that are defined in the 'lfbinding' element fall in either
of the following categories:

1.  **Single map**

> Example:
>
> \<textvar name=\"LandUse\" value=\"\$(PathMaps)/landuse.map\"\>\
> \<comment\>\
> Land Use Classes\
> \</comment\>\
> \</textvar\>

2.  **Table**

> Example:
>
> \<textvar name=\"TabKSat1\" value=\"\$(PathTables)/ksat1.txt\"\>\
> \<comment\>\
> Saturated conductivity \[cm/day\]\
> \</comment\>\
> \</textvar\>

3.  **Stack of maps**

> Example:
>
> \<textvar name=\"PrecipitationMaps\"\
> value=\"\$(PathMeteo)/\$(PrefixPrecipitation)\"\>\
> \<comment\>\
> precipitation \[mm/day\]\
> \</comment\>\
> \</textvar\>


__**Note:**__

Taking -as an example- a prefix that equals "*pr*", the name of each
map in the stack starts with "*pr*", and ends with the number of the
time step. The name of each map is made up of a total of 11
characters: 8 characters, a dot and a 3-character suffix. For
instance:
 - pr000000.007   : at time step 7
 - pr000035.260   : at time step 35260

To avoid unexpected behaviour, do **not** use numbers in the prefix!

> Example:
>
> \<textvar name=\"PrecipitationMaps\"\
> value=\"\$(PathMeteo)/pr10 \"\>\
> \<comment\>\
> precipitation \[mm/day\]\
> \</comment\>\
> \</textvar\>

For the first time step this yields the following file name: pr100000.001   
But this is actually interpreted as time step 100,000,001!

4.  **Time series file**

> Example:
> 
> \<textvar name=\"DisTS\"\ 
> value=\"\$(PathOut)/dis.tss\"\>\
> \<comment\>\
> Reported discharge \[cu m/s\]\
> \</comment\>\
> \</textvar\>

5.  **Single parameter value**

> Example:
>
> \<textvar name=\"UpperZoneTimeConstant\"\
> value=\"\$(UpperZoneTimeConstant)\"\>\
> \<comment\>\
> Time constant for water in upper zone \[days\]\
> \</comment\>\
> \</textvar\>

[:top:](#top)

#### Variables in the lfuser element

As said before the variables in the 'lfuser' elements are all text
variables, and they are used simply to substitute text in the
'lfbinding' element. In practice it is sometimes convenient to use the
same name for a text variable that is defined in the 'lfuser' element
and a 'lfbinding' variable. For example:

> \<lfuser\>\                                                        
> \<textvar name=\"UpperZoneTimeConstant\" value=\"10\"\>\               
> \<comment\>\                                                           
> Time constant for water in upper zone \[days\]\                        
> \</comment\>\                                                          
> \</textvar\>\                                                          
> \</lfuser\>\                                                       
> \<lfbinding\>\                                                     
> \<textvar name=\"UpperZoneTimeConstant\"\                              
> value=\"\$(UpperZoneTimeConstant)\"\>\                                 
> \<comment\>\                                                           
> Time constant for water in upper zone \[days\]\                        
> \</comment\>\                                                          
> \</textvar\>\                                                          
> \</lfbinding\>                                                    

In this case 'UpperZoneTimeConstant' in the 'lfuser' element (just a
text variable) is something different from 'UpperZoneTimeConstant' in
the 'lfbinding' element!


#### lfoption element

The 'lfoption' element effectively allows you to switch certain parts of
the model on or off. Within LISFLOOD, there are **two categories** of
options:

1.  Options to activate the reporting of **additional output** maps and time
    series (e.g. soil moisture maps)

2.  Options that activate **special LISFLOOD modules**, such as inflow
    hydrographs and the simulation of reservoirs

##### Viewing available options

You can view all options by running LISFLOOD with the *\--listoptions*
flag. 
For each option, the following information is listed:

**OptionName Choices DefaultValue**

- 'OptionName' -as you might have guessed already- simply is the name of
the option. 
- 'Choices' indicates the possible values of the option, and
- 'DefaultValue' describes the default behaviour. 

For instance, if you look at the reservoir option:

  simulateReservoirs choices=(1,0) default=0

  - you see that the value of this option is either 0 (off) or 1 (on), and
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

##### Defining options

Within the 'lfoptions' element of the settings file, each option is
defined using a 'setoption' element, which has the attributes 'name' and
'choice' (i.e. the actual value). For example:

> \<lfoptions\>\                            
> \<setoption choice=\"1\" name=\"inflow\" /\>\ 
> \</lfoptions\>\                           

**You are not obliged to use any options**: if you leave the 'lfoptions'
element empty, LISFLOOD will simply run using the default values (i.e.
run model without optional modules; only report most basic output
files). However, the 'lfoptions' element itself (i.e. \<lfoptions\>
\</lfoptions\>) *has* to be present, even if empty!















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

Under Linux LISFLOOD requires that the Python interpreter (version 2.7 or more recent) is installed on the system. Most Linux distributions already have Python pre-installed. If needed you can download Python free of any charge from *http://www.python.org/*

The installation process is largely identical to the Windows procedure:

1.  unzip the contents of 'lisflood\_llinux.zip' to an empty directory.
2.  Check if the file 'lisflood' is executable. If not, make it executable using: "chmod 755 lisflood"
3.  Then update the paths in the configuration file. The configuration file will look something like this:

      ```xml
      <?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>  
      <!-- Lisflood configuration file, JvdK, 8 July 2004 -->
      <!-- !! This file MUST be in the same directory as lisflood.exe -->
      <!-- (or lisflood) !!! \--\><lfconfig\><!\-- location of pcrcalc application -->
      <pcrcalcapp>/software/PCRaster/bin/pcrcalc</pcrcalcapp>
      </lfconfig>
      ```


[[🔝](#top)](#top)


## Step 3: Preparing the Settings file

```R
  # Add more detail to all those steps!!
  ```

•	specify the file path
•	time related specifications
•	parameter options
•	chose optional model routines (which ones are available; what they do; and how to “activate” them)



This chapter describes how to prepare your own settings file. Instead of
writing the settings file completely from scratch, we suggest to use the
settings template that is provided with LISFLOOD as a starting point. In
order to use the template, you should make sure the following
requirements are met:

  -   All input maps and tables are named according to default file names (see Chapter 4 and Annex 12)
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

### Time-related constants

The 'lfuser' section starts with a number of constants that are related
to the simulation period and the time interval used. These are all
defined as single values.

```xml
	<comment>                                                           	
	**************************************************************               
	TIME-RELATED CONSTANTS                                                
	**************************************************************               
	</comment>                                                          
	<textvar name="CalendarDayStart" value="01/01/1990">            
	<comment>                                                           
	Calendar day of 1st day in model run                                  
	Day of the year of first map (e.g. xx0.001) even if the model start   
	from map e.g. 500                                                     
	e.g. 1st of January: 1; 1st of June 151 (or 152 in leap year)         
	Needed to read out LAI tables correctly                               
	</comment>                                                          
	</textvar>                                                          
	<textvar name="DtSec" value="86400">                            
	<comment>                                                           
	timestep [seconds]                                                  
	</comment>                                                          
	</textvar>                                                          
	<textvar name="DtSecChannel" value="86400">                     
	<comment>                                                           
	Sub time step used for kinematic wave channel routing [seconds]     
	Within the model,the smallest out of DtSecChannel and DtSec is used   
	</comment>                                                          
	</textvar>                                                          
	<textvar name="StepStart" value="1">                            
	<comment>                                                           
	Number of first time step in simulation                               
	</comment>                                                          
	</textvar>                                                          
	<textvar name="StepEnd" value="10">                             
	<comment>                                                           
	Number of last time step in simulation                                
	</comment>                                                          
	</textvar>                                                          
	<textvar name="ReportSteps" value="endtime">                    
	<comment>                                                           
	Time steps at which to write model state maps (i.e. only              
	those maps that would be needed to define initial conditions          
	for succeeding model run)                                             
	</comment>                                                          
	</textvar>                                                          
```


**CalendarDayStart** is the calendar day of the first map in a map stack
e.g. pr000000.001. Even if you start the model from time step 500,
this has to be set to the calendar day of the 001 map in your map
stacks. Format can be 
  a) a number:
    *Value="1" = 1<sup>st</sup> January* 
    *Value="151" = 1<sup>st</sup> June*
  Or b) a date (in different format):
    *Value="01/01/1990" = 1<sup>st</sup> January 1990* 
    *Value="05.07.1990" = 5<sup>th</sup> June 1990*
    *Value="15-11-1990" = 15<sup>th</sup> November 1990*

**DtSec** is the simulation time interval in seconds. It has a value of
86400 for a daily time interval, 3600 for an hourly interval, etcetera

**DtSecChannel** is the simulation time interval used by the kinematic
wave channel routing (in seconds). Using a value that is smaller than

**DtSec** may result in a better simulation of the overall shape the
calculated hydrograph (at the expense of requiring more computing
time)

**StepStart** is the number of the first time step in your simulation.
It is normally set to 1. Other (larger) values can be used if you want
to run LISFLOOD for only a part of the time period for which you have
meteo and LAI maps.

**StepEnd** is the number of the last time step in your simulation.

**ReportSteps** defines the time step number(s) at which the model state
(i.e. all maps that you would need to define the initial conditions of
a succeeding model run) is written. You can define this parameter in the following ways:

  1) **At specific time steps**. If you like to have the state maps being written at certain time steps you can define those in a (comma separated) list. For example if you like to have the state maps for the time steps 10, 20 and 40, you need to write:
```xml
    \<textvar name=\"ReportSteps\" value=\"10,20,40\"\
```

  2) If you like to have the state maps for the **last time step** of a model run you can use the special
    'endtime' keyword, e.g.:
```xml
    \<textvar name=\"ReportSteps\" value=\"endtime\"\
```

  3) Alternatively, in some cases you may need the state maps **at regular intervals**. In that case you can use the following syntax:
```xml
    \<textvar name=\"ReportSteps\" value=\"start+increment..end\"\
```

    For instance, in the following example state maps are written every
    5^th^ time step, starting at time step 10, until the last time step:

```xml
    \<textvar name=\"ReportSteps\" value=\"10+5..endtime\"\
```

### Parameters related to evapo(transpi)ration and interception

The following parameters are all related to the simulation of
evapo(transpi)ration and rainfall interception. Although they can all be
defined as either a single value or as a map, we recommend using the
single values that are included in the template. We do not recommend
using any of these parameters as calibration constants.

```xml
	<comment>                                                           
	**************************************************************               
	PARAMETERS RELATED TO EVAPO(TRANSPI)RATION AND INTERCEPTION           
	**************************************************************               
	</comment>                                                          
	<textvar name="PrScaling" value="1">                            
	<comment>                                                           
	Multiplier applied to potential precipitation rates                   
	</comment>                                                          
	</textvar>                                                          
	<textvar name="CalEvaporation" value="1">                       
	<comment>                                                           
	Multiplier applied to potential evapo(transpi)ration rates            
	</comment>                                                          
	</textvar>                                                          
	<textvar name="LeafDrainageTimeConstant" value="1">             
	<comment>                                                           
	Time constant for water in interception store [days]                
	</comment>                                                          
	</textvar>                                                          
	<textvar name="kdf" value="0.72">                               
	<comment>                                                           
	Average extinction coefficient for the diffuse radiation flux         
	varies with crop from 0.4 to 1.1 (Goudriaan (1977))                   
	</comment>                                                          
	</textvar>                                                          
	<textvar name="AvWaterRateThreshold" value="5">                 
	<comment>                                                           
	Critical amount of available water (expressed in [mm/day]!), above  
	which 'Days Since Last Rain' parameter is set to 1                  
	</comment>                                                          
	</textvar>                                                          
	<textvar name="SMaxSealed" value="1.0">                         
	<comment>                                                           
	maximum depression storage for water on impervious surface            
	which is not immediatly causing surface runoff [mm]                 
	</comment>                                                          
	</textvar>                                                          
```

**PrScaling** is a multiplier that is applied to precipitation input
(pr) [-]

**CalEvaporation** is a multiplier that is applied to the potential
evapo(transpi)ration input (**ET0**, **EW0** and **ES0**) [-]

**LeafDrainageTimeConstant** (**T<sub>int</sub>** in Eq 2-11) is the time constant
for the interception store [days]

**kdf** is the average extinction for the diffuse radiation flux
(Goudriaan, 1977). it is used to calculate the extinction coefficient
for global radiation, **κ<sub>gb</sub>** ,which is used in Equations 2-9, 2-14
and 2-19 [-]

**AvWaterRateThreshold** defines a critical amount of water that is used
as a threshold for resetting the variable **D<sub>slr</sub>** in Eq 2-20. Because
the equation was originally developed for daily timesteps only, the
threshold is currently defined (somewhat confusingly) as an equivalent
**intensity** in [mm day^-1^]

**SMaxSealed** is the maximum depression storage on impervious surface
[mm]. This storage is emptied by evaporation (EW0).


### Parameters related to snow and frost

The following parameters are all related to the simulation of snow
accumulation, snowmelt and frost. All these parameters can be defined as
either single values or maps. We recommend to start out by leaving them
all at their default values. If prior data suggest major under- or
overcatch problems in the observed snowfall, *SnowFactor* can be
adjusted accordingly. *SnowMeltCoef* may be used as a calibration
constant, but since snow observations are typically associated with
large uncertainty bands, the calibration may effectively just be
compensating for these input errors.

```xml
	**************************************************************               
	SNOW AND FROST RELATED PARAMETERS                                     	
	**************************************************************               
	</comment>                                                          
	<textvar name="SnowFactor" value="1">                           
	<comment>                                                           
	Multiplier applied to precipitation that falls as snow                
	</comment>                                                          
	</textvar>                                                          
	<textvar name="SnowSeasonAdj" value="1.0">                      
	<comment>                                                           
	range [mm C-1 d-1] of the seasonal variation                        
	SnowMeltCoef is the average value                                     
	</comment>                                                          
	</textvar>                                                          
	<textvar name="SnowMeltCoef" value="4.5">                       
	<comment>                                                           
	Snowmelt coefficient [mm/deg C /day]                                
	See also Martinec et al., 1998.                                       
	</comment>                                                          
	</textvar>                                                          
	<textvar name="TempMelt" value="0.0">                           
	<comment>                                                           
	Average temperature at which snow melts                               
	</comment>                                                          
	</textvar>                                                          
	<textvar name="TempSnow" value="1.0">                           
	<comment>                                                           
	Average temperature below which precipitation is snow                 
	</comment>                                                          
	</textvar>                                                          
	<textvar name="TemperatureLapseRate" value="0.0065">            
	<comment>                                                           
	Temperature lapse rate with altitude [deg C / m]                    
	</comment>                                                          
	</textvar>                                                          
	<textvar name="Afrost" value="0.97">                            
	<comment>                                                           
	Daily decay coefficient, (Handbook of Hydrology, p. 7.28)             
	</comment>                                                          
	</textvar>                                                          
	<textvar name="Kfrost" value="0.57">                            
	<comment>                                                           
	Snow depth reduction coefficient, [cm-1], (HH, p. 7.28)             
	</comment>                                                          
	</textvar>                                                          
	<textvar name="SnowWaterEquivalent" value="0.45">               
	<comment>                                                           
	Snow water equivalent, (based on snow density of 450 kg/m3) (e.g.     
	Tarboton and Luce, 1996)                                              
	</comment>                                                          
	</textvar>                                                          
	<textvar name="FrostIndexThreshold" value="56">                 
	<comment>                                                           
	Degree Days Frost Threshold (stops infiltration, percolation and      
	capillary rise)                                                       
	Molnau and Bissel found a value 56-85 for NW USA.                     
	</comment>                                                          
	</textvar>                                                          
```

**SnowFactor** is a multiplier that is applied to the rate of
precipitation in case the precipitation falls as snow. Since snow is
commonly underestimated in meteorological observation data, setting
this multiplier to some value greater than 1 can counteract for this
[-]

**SnowSeasonAdj** is the range [mm C-1 d-1] of the seasonal variation
of snow melt. SnowMeltCoef is the average value.

**SnowMeltCoef** (**C<sub>m</sub>** in Eq 2-3) is the degree-day factor that
controls the rate of snowmelt [mm °C^-1^ day^-1^]

**TempMelt** (**T<sub>m</sub>** in Eq 2-3) is the average temperature above which
snow starts to melt [°C]

**TempSnow** is the average temperature below which precipitation is
assumed to be snow [°C]

**TemperatureLapseRate** (**L** in Figure 2.2) is the temperature lapse
rate that is used to estimate average temperature at the centroid of
each pixel's elevation zones [°C m^-1^]

**Afrost** (**A** in Eq 2-4) is the frost index decay coefficient
[day^-1^]. It has a value in the range 0-1.

**Kfrost** (**K** in Eq 2-4) is a snow depth reduction coefficient
[cm^-1^]

**SnowWaterEquivalent** (**we<sub>s</sub>** in Eq 2-4) is the equivalent water
depth of a given snow cover, expressed as a fraction [-]

**FrostIndexThreshold** is the critical value of the frost index (Eq
2-5) above which the soil is considered frozen [°C day^-1^]


### Infiltration parameters

The following two parameters control the simulation of infiltration and
preferential flow. Both are empirical parameters that are treated as
calibration constants, and both can be defined as single values or maps.

```xml
	<comment>                                                           
	**************************************************************               
	INFILTRATION PARAMETERS                                               
	**************************************************************               
	</comment>                                                          
	<textvar name="b\_Xinanjiang" value="0.1">                      
	<comment>                                                           
	Power in Xinanjiang distribution function                             
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PowerPrefFlow" value="3">                        
	<comment>                                                           
	Power that controls increase of proportion of preferential            
	flow with increased soil moisture storage                             
	</comment>                                                          	
```

**b\_Xinanjiang** (**b** in Eq 2-23) is the power in the infiltration
equation [-]

**PowerPrefFlow** (**c<sub>pref</sub>** in Eq 2-25) is the power in the
preferential flow equation [-]


### Groundwater parameters

The following parameters control the simulation shallow and deeper
groundwater. *GwLossFraction* should be kept at 0 unless prior
information clearly indicates that groundwater is lost beyond the
catchment boundaries (or to deep groundwater systems). The other
parameters are treated as calibration constants. All these parameters
can be defined as single values or maps.

```xml
	<comment>                                                           
	**************************************************************               
	GROUNDWATER RELATED PARAMETERS                                        
	**************************************************************               
	</comment>                                                          	
	<textvar name="UpperZoneTimeConstant" value="10">               
	<comment>                                                           
	Time constant for water in upper zone [days]                        
	</comment>                                                          
	</textvar>                                                          
	<textvar name="LowerZoneTimeConstant" value="1000">             
	<comment>                                                           
	Time constant for water in lower zone [days]                        
	This is the average time a water \'particle\' remains in the          
	reservoir                                                             
	if we had a stationary system (average inflow=average outflow)        
	</comment>                                                          
	</textvar>                                                          
	<textvar name="GwPercValue" value="0.5">                        
	<comment>                                                           
	Maximum rate of percolation going from the Upper to the Lower         
	response box [mm/day]                                               
	</comment>                                                          
	</textvar>                                                          
	<textvar name="GwLoss" value="0">                               
	<comment>                                                           
	Maximum rate of percolation from the Lower response box (groundwater  
	loss) [mm/day].                                                     
	A value of 0 (closed lower boundary) is recommended as a starting     
	value                                                                 
	</comment>                                                          
	</textvar>                                                          
```

**UpperZoneTimeConstant** (**T<sub>uz</sub>** in Eq 2-42) is the time constant for
the upper groundwater zone [days]

**LowerZoneTimeConstant** (**T<sub>lz</sub>** in Eq 2-43) is the time constant for
the lower groundwater zone [days]

**GwPercValue** (**GW<sub>perc</sub>** in Eq 2-44) is the maximum rate of
percolation going from the upper to the lower groundwater zone [mm
day^-1^]

**GwLoss** (**f<sub>loss</sub>** in Eq 2-45) is the maximum rate of percolation
from the lower groundwater zone (groundwater loss) zone [mm
day^-1^]. A value of 0 (closed lower boundary) is recommended as a
starting value.


### Routing parameters 

These parameters are all related to the routing of water in the channels
as well as the routing of surface runoff. The multiplier *CalChanMan*
can be used to fine-tune the timing of the channel routing, and it may
be defined as either a single value or a map. All other parameters
should be kept at their default values.

```xml
	<comment>                                                           
	**************************************************************               
	ROUTING PARAMETERS                                                    
	**************************************************************               
	</comment>                                                          
	<textvar name="CalChanMan" value="1">                           
	<comment>                                                           
	Multiplier applied to Channel Manning's n                            
	</comment>                                                          
	</textvar>                                                          
	<textvar name="beta" value="0.6">                               
	<comment>                                                           
	kinematic wave parameter: 0.6 is for broad sheet flow                 
	</comment>                                                          
	</textvar>                                                          
	<textvar name="OFDepRef" value="5">                             
	<comment>                                                           
	Reference depth of overland flow [mm], used to compute              
	overland flow Alpha for kin. wave                                     
	</comment>                                                          
	</textvar>                                                          
	<textvar name="GradMin" value="0.001">                          
	<comment>                                                           
	Minimum slope gradient (for kin. wave: slope cannot be 0)             
	</comment>                                                          
	</textvar>                                                          
	<textvar name="ChanGradMin" value="0.0001">                     
	<comment>                                                           
	Minimum channel gradient (for kin. wave: slope cannot be 0)           
	</comment>                                                          
	</textvar>                                                          
```

**CalChanMan** is a multiplier that is applied to the Manning's
roughness maps of the channel system [-]

**beta** is routing coefficient **β<sub>k</sub>** in Equations 2-51, 2-52, 2-54 and
2-57 [-]

**OFDepRef** is a reference flow depth from which the flow velocity of
the surface runoff is calculated [mm]

**GradMin** is a lower limit for the slope gradient used in the
calculation of the surface runoff flow velocity [m m^-1^]

**ChanGradMin** is a lower limit for the channel gradient used in the
calculation of the channel flow velocity [m m^-1^]



### Parameters related to numerics 

This category only contains one parameter at the moment, which can only
be a single value. We strongly recommend keeping this parameter at its
default value.

```xml
	<comment>                                                           
	********************************** 
	****************************               
	PARAMETERS RELATED TO NUMERICS                                        
	********************************** 
	****************************               
	</comment>                                                          
	<textvar name="CourantCrit" value="0.4">                        
	<comment>                                                           
	Minimum value for Courant condition in soil moisture routine          
	</comment>                                                          	
	</textvar>                                                          
```

**CourantCrit** (**C<sub>crit</sub>** in Eq 2-36) is the critical Courant number
which controls the numerical accuracy of the simulated soil moisture
fluxes [-]. Any value between 0 and 1 can be used, but using values
that are too high can lead to unrealistic "jumps" in the simulated
soil moisture, whereas very low values result in reduced computational
performance (because many iterations will be necessary to obtain the
required accuracy). Values above 1 should never be used, as they will
result in a loss of mass balance. In most cases the default value of
0.4 results in sufficiently realistic simulations using just a few
iterations.


### File paths 

Here you can specify where all the input files are located, and where
output should be written. Note that you can use both forward and
backward slashes on both Windows and Linux-based systems without any
problem (when LISFLOOD reads the settings file it automatically formats
these paths according to the conventions used by the operating system
used). The default settings template contains relative paths, which in
most cases allows you to run the model directly without changing these
settings (assuming that you execute LISFLOOD from the root directory of
your catchment).

```xml
	<comment>                                                           
	**************************************************************               
	FILE PATHS                                                            
	**************************************************************               
	</comment>                                                          
	<textvar name="PathOut" value="./out">                          
	<comment>                                                           
	Output path                                                           
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PathInit" value="./out">                         
	<comment>                                                           
	Path of the initial value maps e.g. lzavin.map                        
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PathMaps" value="./maps">                        
	<comment>                                                           
	Maps path                                                             
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PathSoilHyd" value="./maps/soilhyd">             
	<comment>                                                           
	Maps instead tables for soil hydraulics path                          
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PathMapsFraction" value="./maps/fraction">       
	<comment>                                                           
	Maps of fraction of land cover (forest, water, sealed,other)          
	</comment>                                                          
	</textvar                                                            
	<textvar name="PathMapsTables" value="./maps/table2map">        
	<comment>                                                           
	Maps which replaced tables e.g. CropCoeff                             
	/comment>                                                            
	</textvar>                                                          
	<textvar name="PathTables" value="./tables">                    
	<comment>                                                           
	Tables path                                                           
	</comment>                                                          	
	</textvar>                                                          
	<textvar name="PathMeteo" value="./meteo">                      
	<comment>                                                           
	Meteo path                                                            
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PathLAI" value="./lai">                          
	<comment>                                                           
	Leaf Area Index maps path                                             
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PathWaterUse" value="./wateruse">                
	<comment>                                                           
	Water use maps path                                                   
	</comment>                                                          
	</textvar>                                                          
```

**PathOut** is the directory where all output files are written. It must
be an existing directory (if not you will get an error message -- not
immediately but after 256 timesteps, when the time series are written
for the first time)

**PathInit** is the directory where the initial files are located, to
initialize a "warm" start. It can be also the PathOut directory

**PathMaps** is the directory where all input base maps are located

**PathSoilHyd** is the directory where the soil hydraulic property maps
are located

**PathMapsFraction** is the directory where the land cover fraction maps
are located

**PathMapsTables** is the directory where maps are located which were
calculated from lookup tables in the previous version (e.g. cropcoeff)

**PathTables** is the directory where all input tables are located

**PathMeteo** is the directory where all maps with meteorological input
are located (rain, evapo(transpi)ration, temperature)

**PathLAI** is the directory where you Leaf Area Index maps are located

**PathWaterUse** is the directory where water use maps are located
(optional)


### Prefixes of meteo and vegetation related variables

Here you can define the prefix that is used for each meteorological
variable (and LAI and water use).

```xml
	<comment>                                                           
	**************************************************************               
	PREFIXES OF METEO AND VEGETATION RELATED VARIABLES                    
	**************************************************************               
	</comment>                                                          	
	<textvar name="PrefixPrecipitation" value="pr">                 
	<comment>                                                           
	prefix precipitation maps                                             
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PrefixTavg" value="ta">                          
	<comment>                                                           
	prefix average temperature maps                                       
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PrefixE0" value="e">                             
	<comment>                                                           
	prefix E0 maps                                                        
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PrefixES0" value="es">                           
	<comment>                                                           
	prefix ES0 maps                                                       
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PrefixET0" value="et">                           
	<comment>                                                           
	prefix ET0 maps                                                       
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PrefixLAI" value="olai">                         
	<comment>                                                           
	prefix LAI maps                                                       
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PrefixLAIForest" value="flai">                   
	<comment>                                                           
	prefix forest LAI maps                                                
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PrefixWaterUse" value="wuse">                    
	<comment>                                                           
	prefix water use maps                                                 
	</comment>                                                          
	</textvar>                                                          
```

Each variable is read as a stack of maps. The name of each map starts
with prefix, and ends with the number of the time step. All characters
in between are filled with zeroes. The name of each map is made up of
a total of 11 characters: 8 characters, a dot and a 3-character
suffix. For instance, using a prefix 'pr' we get:

  pr000000.007   : at time step 7
  pr000035.260   : at time step 35260

> To avoid unexpected behaviour, **never** use numbers in the prefix!\
> For example:
>
> PrefixRain=pr10
>
> For the first time step this yields the following file name:
>
>   pr100000.001   
>
> But this is actually interpreted as time step 100,000,001!\
> **Therefore, do not use numbers in the prefix!**

The corresponding part of the settings file is pretty
self-explanatory:

**PrefixPrecipitation** is the prefix of the precipitation maps

**PrefixTavg** is the prefix of the daily average temperature maps

**PrefixE0** is the prefix of the potential open-water evaporation maps

**PrefixES0** is the prefix of the potential bare-soil evaporation maps

**PrefixET0** is the prefix of the potential (reference)
evapotranspiration maps

**PrefixLAI** is the prefix of the Leaf Area Index maps

**PrefixLAIForest** is the prefix of the forest Leaf Area Index maps

**PrefixWaterUse** is the prefix of the water use maps (optional)


### Initial conditions

As with the calibration parameters you can use both maps and single
values to define the catchment conditions at the start of a simulation.
Note that a couple of variables can be initialized internally in the
model (explained below). Also, be aware that the initial conditions
define the state of the model at *t=(StepStart -1)*. As long as
*StepStart* equals 1 this corresponds to *t=0*, but for larger values of
*StepStart* this is (obviously) not the case!

```xml
	<comment>                                                           
	**************************************************************               
	INITIAL CONDITIONS                                                    
	(maps or single values)                                               
	**************************************************************               
	</comment>                                                          
	<textvar name="WaterDepthInitValue" value="0">                  	
	<comment>                                                           
	initial overland flow water depth [mm]                              
	</comment>                                                          
	</textvar>                                                          
	<textvar name="SnowCoverAInitValue" value="0">                  
	<comment>                                                           
	initial snow depth in snow zone A [mm]                              
	</comment>                                                          
	</textvar>                                                          
	<textvar name="SnowCoverBInitValue" value="0">                  
	<comment>                                                           
	initial snow depth in snow zone B [mm]                              
	</comment>                                                          
	</textvar>                                                          
	<textvar name="SnowCoverCInitValue" value="0">                  
	<comment>                                                           
	initial snow depth in snow zone C [mm]                              
	</comment>                                                          
	</textvar>                                                          
	<textvar name="FrostIndexInitValue" value="0">                  
	<comment>                                                           
	initial Frost Index value                                             
	</comment>                                                          
	</textvar>                                                          
	<textvar name="CumIntInitValue" value="0">                      
	<comment>                                                           
	cumulative interception [mm]                                        
	</comment>                                                          
	</textvar>                                                          
	<textvar name="UZInitValue" value="0">                          
	<comment>                                                           
	water in upper store [mm]                                           
	</comment>                                                          
	</textvar>                                                          
	<textvar name="DSLRInitValue" value="1">                        
	<comment>                                                           
	days since last rainfall                                              
	</comment>                                                          
	</textvar>                                                          
	<textvar name="CumIntSealedInitValue" value="0">                
	<comment>                                                           
	cumulative depression storage [mm]                                  
	</comment>                                                          
	</textvar>                                                          
	<comment>                                                           
	********************************** 
	****************************               
	The following variables can also be initialized in the model          
	internally. if you want this to happen set them to bogus value of     
	-9999                                                                 
	********************************** 
	****************************               
	</comment>                                                          
	<textvar name="LZInitValue" value="-9999">                      
	<comment>                                                           
	water in lower store [mm]                                           
	-9999: use steady-state storage                                       
	</comment>                                                          
	</textvar>                                                          
	<textvar name="TotalCrossSectionAreaInitValue" value="-9999">   
	<comment>                                                           
	initial cross-sectional area of flow in channel[m2]                 
	-9999: use half bankfull                                              
	</comment>                                                          
	</textvar>                                                          
	<textvar name="ThetaInit1Value" value="-9999">                  
	<comment>                                                           
	initial soil moisture content layer 1                                 
	-9999: use field capacity values                                      
	</comment>                                                          
	</textvar>                                                          
	<textvar name="ThetaInit2Value" value="-9999">                  
	<comment>                                                           
	initial soil moisture content layer 2                                 
	-9999: use field capacity values                                      
	</comment>                                                          
	</textvar>                                                          
	<textvar name="PrevDischarge" value="-9999">                    
	<comment>                                                           
	initial discharge from previous run for lakes, reservoirs and         
	transmission loss                                                     
	only needed for lakes reservoirs and transmission loss                
	-9999: use discharge of half bankfull                                 
	</comment>                                                          
	</textvar>                                                          
```

**WaterDepthInitValue** is the initial amount of water on the soil
surface [mm]

**SnowCoverInitAValue** is the initial snow cover on the soil surface in
elevation zone **A** [mm]

**SnowCoverInitBValue** is the initial snow cover on the soil surface in
elevation zone **B** [mm]

**SnowCoverInitCValue** is the initial snow cover on the soil surface in
elevation zone **C** [mm]

**FrostIndexInitValue** (**F** in Eq 2-5) initial value of the frost index
[°C day^-1^]

**CumIntInitValue** is the initial interception storage [mm]

**UZInitValue** is the initial storage in the upper groundwater zone
[mm]

**DSLRInitValue** (**D<sub>slr</sub>** in Eq 2-20) is the initial number of days
since the last rainfall event [days]

**CumIntSealedInitValue** is the initial value of the depression storage
for the sealed part of a pixel [mm]

**LZInitValue** is the initial storage in the lower groundwater zone
[mm]. In order to avoid initialization problems it is possible to
let the model calculate a 'steady state' storage that will usually
minimize any initialization problems. This feature is described in
detail in Chapter 7 of this User Manual. To activate it, set the
lfoptions element InitLisflood to 1.

**TotalCrossSectionAreaInitValue** is the initial cross-sectional area
[m^2^] of the water in the river channels (a substitute for initial
discharge, which is directly dependent on this). A value of **-9999**
sets the initial amount of water in the channel to half bankfull.

**ThetaInit1Value** is the initial moisture content [mm^3^ mm^-3^] of
the upper soil layer. A value of -**9999** will set the initial soil
moisture content to field capacity.

**ThetaInit2Value** is the initial moisture content [mm^3^ mm^-3^] of
the lower soil layer. A value of -**9999** will set the initial soil
moisture content to field capacity

**PrevDischarge** is the initial discharge from previous run
[m^3^s^-1^] used for lakes, reservoirs and transmission loss (only
needed if option is on for lakes or reservoirs or transmission loss).
Note that PrevDischarge is discharge as an average over the time step
(a flux) . A value of **-9999** sets the initial amount of discharge to
equivalent of half bankfull.

```xml
	<comment>                                                           
	**************************************************************               
	INITIAL CONDITIONS FOREST                                             
	(maps or single values)                                               
	**************************************************************               
	</comment>                                                          
	<textvar name="CumIntForestInitValue" value="0">                
	<comment>                                                           
	cumulative interception [mm]                                        
	</comment>                                                          
	</textvar>                                                          
	<textvar name="UZForestInitValue" value="0">                    
	<comment>                                                           
	water in upper store [mm]                                           
	</comment>                                                          
	</textvar>                                                          
	<textvar name="DSLRForestInitValue" value="1">                  
	<comment>                                                           
	days since last rainfall                                              
	</comment>                                                          
	</textvar>                                                          
	<textvar name="LZForestInitValue" value="-9999">                
	<comment>                                                           
	water in lower store [mm]                                           
	-9999: use steady-state storage                                       
	</comment>                                                          
	</textvar>                                                          
	<textvar name="ThetaForestInit1Value" value="-9999">            
	<comment>                                                           
	initial soil moisture content layer 1                                 
	-9999: use field capacity values                                      
	</comment>                                                          
	</textvar>                                                          
	<textvar name="ThetaForestInit2Value" value="-9999">            
	<comment>                                                           
	initial soil moisture content layer 2                                 
	-9999: use field capacity values                                      
	</comment>                                                          
```
CumIntForestInitValue, UZForestInitValue, DSLRForestInitValue,
LZForestInitValue, ThetaForestInit1Value, ThetaForestInit2Value
are the initial value for the forest part of a pixel


### Using options

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

```xml
	<lfoptions>                            
	<setoption choice="1" name="inflow" /> 
	</lfoptions>                           	
```
[:top:](#top)



















































## Step 4: Input files (maps and tables)

In the current version of LISFLOOD, all model input is provided as either maps (grid files in PCRaster format) or tables. This chapter describes all the data that are required to run the model. Files that are specific to *optional* LISFLOOD features (e.g. inflow hydrographs, reservoirs) are not listed here; they are described in the documentation for each option.

### Input maps

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

#### Role of "mask" and "channels" maps 

The mask map (i.e. "area.map") defines the model domain. In order to avoid unexpected results, **it is vital that all maps that are related to topography, land use and soil are defined** (i.e. don't contain a missing value) for each pixel that is "true" (has a Boolean 1 value) on the mask map. The same applies for all meteorological input and the Leaf Area Index maps. Similarly, all pixels that are "true" on the
channels map must have some valid (non-missing) value on each of the channel parameter maps. Undefined pixels can lead to unexpected behaviour of the model, output that is full of missing values, loss of mass balance and possibly even model crashes. Some maps needs to have values in a defined range e.g. gradient.map has to be greater than 0.

#### Map location attributes and distance units

LISFLOOD needs to know the size properties of each grid cell (length, area) in order to calculate water *volumes* from meteorological forcing variables that are all defined as water *depths*. By default, LISFLOOD
obtains this information from the location attributes of the input maps. This will only work if all maps are in an "equal area" (equiareal) projection, and the map co-ordinates (and cell size) are defined in meters. For datasets that use, for example, a latitude-longitude system, neither of these conditions is met. In such cases you can still run LISFLOOD if you provide two additional maps that contain the length and area of each grid cell

##### Table x.x Optional maps that define grid size

| **Map**               | **Default name**      | **Description**                         |
|-----------------------|-----------------------|-----------------------------------------|
| PixelLengthUser       | pixleng.map           | Map with pixel length<br><br> Unit: \[m\],<br> *Range *of values: map \> 0*|
| PixelAreaUser         | pixarea.map           | Map with pixel area<br><br>*Unit:* \[m^2^\],<br> *Range of values: map \> 0*| 

Both maps should be stored in the same directory where all other input maps are. The values on both maps may vary in space. A limitation is that a pixel is always represented as a square, so length and width are considered equal (no rectangles). In order to tell LISFLOOD to ignore the default location attributes and use the maps instead, you need to activate the special option "*gridSizeUserDefined*", which involves adding the following line to the LISFLOOD settings file:

```xml
<setoption choice="1" name="gridSizeUserDefined" \>
```

LISFLOOD settings files and the use of options are explained in detail in Chapter 5 of this document.

#### Naming of meteorological variable maps

The meteorological forcing variables (and Leaf Area Index) are defined in *map stacks*. A *map stack* is simply a series of maps, where each map represents the value of a variable at an individual time step. The name of each map is made up of a total of 11 characters: 8 characters, a dot and a 3-character suffix. Each map name starts with a *prefix*, and ends with the time step number. All character positions in between are
filled with zeros ("0"). Take for example a stack of precipitation maps. Table 4.1 shows that the default prefix for precipitation is "pr", which produces the following file names:

```
pr000000.007   : at time step 7
...
pr000035.260   : at time step 35260
```

LISFLOOD can handle two types of stacks. First, there are **regular stacks**, in which a map is defined for each time step. For instance, the following 10-step stack is a regular stack:

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

In addition to regular stacks, it is also possible to define **sparse stacks**. A *sparse* stack is a stack in which maps are not defined for all time steps, for instance:

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

Here, maps are defined only for time steps 1, 4 and 7. In this case, LISFLOOD will use the map values of *pr000000.001* during time steps 1, 2 and 3, those of *pr000000.004* during time steps 4, 5 and 6, and those of *pr000000.007* during time steps 7, 8, 9 and 10. 
Since both regular and sparse stacks can be combined within one single run, sparse stacks can be very useful to save disk space. For instance, LISFLOOD always needs the *average daily* temperature, even when the model is run on an hourly time step. So, instead of defining 24 identical maps for each hour, you can simply define 1 for the first hour of each day and leave out the rest, for instance:

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



#### Leaf area index maps 

Because Leaf area index maps follow a yearly circle, only a map stack of one year is necessary which is then used again and again for the  following years (this approach can be used for all input maps following a yearly circle e.g. water use). LAI is therefore defined as sparse map stack with a map every 10 days or a month, for example for a monthly changing LAI:


```
 1       lai00000.001 
 2       lai00000.032 
 3       lai00000.060 
 4       lai00000.091 
 5       lai00000.121 
 6       lai00000.152 
 7       lai00000.182 
 8       lai00000.213 
 9       lai00000.244 
 10      lai00000.274 
 11      lai00000.305 
 12      lai00000.335 
```

After one year the first map is taken again for simulation. For example
the simulation started on the 5<sup>th</sup> March 2010 and the first LAI is
lai00000.060. On the 1<sup>th</sup> March 2011 the map lai00000.060 is taken
again as LAI input. To let LISFLLOD know which map has to be used at
which day a lookup table (LaiOfDay.txt) is necessary.

### Input tables

In the previous version of LISFLOOD a number of model parameters are
read through tables that are linked to the classes on the land use and
soil (texture) maps. Those tables are replaced by maps (e.g. soil
hydraulic property maps) in order to include the sub-grid variability of
each parameter. Therefore only one table is used in the standard
LISFLOOD setting (without lake or reservoir option)

The following table gives an overview:

##### Table x.x LISFLOOD input tables

| **Table**             | **Default name**      | **Description**       |
|----------------------------|-----------------------|--------------------------|
| Day of the year -\> <br> LAI    | LaiOfDay.txt          | Lookup table: Day of <br> the year -\> LAI map |


### Organisation of input data

It is up to the user how the input data are organised. However, it is
advised to keep the base maps, meteorological maps and tables separated
(i.e. store them in separate directories). For practical reasons the
**following input structure is suggested**:

-   all **base maps** are in one directory (e.g. 'maps')

    -   fraction maps in a subfolder (e.g. 'fraction')

    -   soil hydraulic properties in a subfolder (e.g.'soilhyd')

    -   land cover depending maps in a subfolder (e.g.'table2map')

-   all **tables** are in one directory (e.g. 'tables')

-   all **meteorological input** maps are in one directory (e.g. 'meteo')

-   a folder **Leaf Area Index** (e.g. 'lai')

    -   all Leaf Area Index for forest in a subfolder (e.g.'forest')

    -   all Leaf Area Index for other in a subfolder (e.g.'other')

-   all **output** goes to one directory (e.g. 'out')

The following Figure illustrates this:

![](media/media/image36.emf){width="5.802083333333333in"
height="4.541666666666667in"}

*Figure 4.1 Suggested file structure for LISFLOOD*

### Generating input base maps

At the time of writing this document, complete sets of LISFLOOD base
maps covering the whole of Europe have been compiled at 1- and 5-km
pixel resolution. A number of automated procedures have been written
that allow you to generate sub-sets of these for pre-defined areas
(using either existing mask maps or co-ordinates of catchment outlets).

[:top:](#top)


## Step 6: Running the model: Initialisation of LISFLOOD

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

### Option1: Cold start (initial conditions unknown)

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

**Table x.x**: LISFLOOD special initialisation methods<sup>1<sup> 
 
| **Variable**          | **Description**       | **Initialisation method**     |
|-------------------------------|-------------------------------|-------------------------------|
| ThetaInit1Value / <br> ThetaForestInit2Value    | initial soil moisture content<br> upper soil layer (V/V)| set to soil moisture content <br> at field capacity |
| ThetaInit2Value / <br> ThetaForestInit2Value    | initial soil moisture content <br> lower soil layer (V/V) | set to soil moisture content <br> at field capacity |
| LZInitValue / <br> LZForestInitValue       | initial water in lower <br>  groundwater zone (mm)    | set to steady-state storage |
| TotalCrossSectionArea <br> InitValue | initial cross-sectional area <br> of water in channels              | set to half of bankfull depth      |
| PrevDischarge         | Initial discharge     | set to half of bankfull depth       |
 
<sup>1</sup>: These special initialisation methods are activated by setting the value of each respective variable to a 'bogus' value of "-9999"*     

Note that the "-9999" 'bogus' value can *only* be used with the
variables in Table x.x; for all other variables they will produce
nonsense results! The initialisation of the lower groundwater zone will
be discussed in the next sections.

#### Initialisation of the lower groundwater zone

```R
# should this section be moved into the hydorological model documentation??
```

Even though the use of a sufficiently long warm-up period usually
results in a correct initialisation, a complicating factor is that the
time needed to initialise any storage component of the model is
dependent on the average residence time of the water in it. For example,
the moisture content of the upper soil layer tends to respond almost
instantly to LISFLOOD's meteorological forcing variables (precipitation,
evapo(transpi)ration). As a result, relatively short warm-up periods are
sufficient to initialise this storage component. At the other extreme,
the response of the lower groundwater zone is generally very slow
(especially for large values of *T<sub>lz</sub>*). Consequently, to avoid
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

***Figure x.x** 8-year simulation of lower zone storage. Note how the
influence of the initial storage persists throughout the simulation
period. *

#### Lower groundwater zone: steady state storage

The response of the lower groundwater zone is defined by two simple
equations. First, we have the inflow into the lower zone, which occurs
at the following rate \[mm day^-1^\]:

\${D\_{uz,lz}} = \\min (G{W\_{perc}},\\;UZ/\\Delta t)\$ (7-1)

Here, *GW~perc~* \[mm day^-1^\] is a user-defined value (calibration
constant), and *UZ* is the amount of water available in the upper
groundwater zone \[mm\]. The rate of flow out of the lower zone \[mm
day^-1^\] equals:

\${Q\_{lz}} = \\frac{1}{{{{\\rm{T}}\_{{\\rm{lz}}}}}} \\cdot LZ\$ (7-2)

where *T<sub>lz</sub>* is a reservoir constant \[days\], and *LZ* is the amount
of water that is stored in the lower zone \[mm\].

Now, let's do a simple numerical experiment: assuming that *D<sub>uz,lz</sub>* is
a constant value, we can take some arbitrary initial value for *LZ* and
then simulate (e.g. in a spreadsheet) the development over *LZ* over
time. Figure 7.3 shows the results of 2 such experiments. In the upper
Figure, we start with a very high initial storage (1500 mm). The inflow
rate is fairly small (0.2 mm/day), and *T<sub>lz</sub>* is quite small as well
(which means a relatively short residence time of the water in the lower
zone). What is interesting here is that, over time, the storage evolves
asymptotically towards a constant state. In the lower Figure, we start
with a much smaller initial storage (50 mm), but the inflow rate is much
higher here (1.5 mm/day) and so is *T<sub>lz</sub>* (1000 days). Here we see an
upward trend, again towards a constant value. However, in this case the
constant 'end' value is not reached within the simulation period, which
is mainly because *T<sub>lz</sub>* is set to a value for which the response is
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

  *T<sub>lz</sub>*   *I*   *LZ<sub>ss</sub>*
--------- ----- ----------
  250       0.2   50
  1000      1.5   1500

which corresponds exactly to the results of Figure 7.3.

Steady-state storage in practice
--------------------------------

An actual LISFLOOD simulation differs from the previous example in 2
ways. First, in any real simulation the inflow into the lower zone is
not constant, but varies in time. This is not really a problem, since
*LZ<sub>ss</sub>* can be computed from the *average* recharge. However, this is
something we do not know until the end of the simulation! Also, the
inflow into the lower zone is controlled by the availability of water in
the upper zone, which, in turn, depends on the supply of water from the
soil. Hence, it is influenced by any calibration parameters that control
behaviour of soil- and subsoil (e.g. *T<sub>uz</sub>*, *GW<sub>perc</sub>*, *b*, and so
on). This means that --when calibrating the model- the average recharge
will be different for every parameter set. Note, however, that it will
*always* be smaller than the value of *GW<sub>perc</sub>*, which is used as an
upper limit in the model.. Note that the pre-run procedures include a
sufficiently long warm-up period.


#### Use pre-run to calculate average recharge

Here, we first do a "pre-run" that is used to calculate the average
inflow into the lower zone. This average inflow can be reported as a
map, which is then used in the actual run. This involves the following
steps:

1.  Set all the initial conditions to either 0,1 or -9999

2.  Activate the "InitLisflood" option by setting it active in the
    'lfoptions' in the settings file:

```xml
  <setoption choice="1" name="InitLisflood"/>
```
3.  Run the model for a longer period (if possible more than 3 years,
    best for the whole modelling period)

4.  Go back to the LISFLOOD settings file, and set the InitLisflood
    inactive:

```xml
  <setoption choice="0" name="InitLisflood"/>
```

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

```xml
  <setoption name=" repStateUpsGauges" choice="1"> </setoption\>
```

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

***Figure x.x** Initialisation of lower groundwater zone with and
without using a pre-run. Note the strong decreasing trend in the
simulation without pre-run. *

### Option2: Warm start (Using a previous run)

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
say parameter set *A*), then these maps should **not** be used as initial
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

### Summary of LISFLOOD initialisation procedure

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
    you should run the model with a sufficient pre-run (if possible
    more than 3 years, best for the whole modelling period) and
    InitLisflood=1. The average recharge map that is generated from
    the pre-run can subsequently be used as the average lower zone
    inflow estimate (*LZAvInflowEstimate*) in the actual simulation,
    which will avoid any initialisation problems of the lower
    groundwater zone

3. Is it possible not to use the first year for further analysis of
    results, because this is the "warm-up" period for all the other
    variables like snow, vegetation, soil (see e.g. figure 7.1 for
    soil moisture)?\
    Then leave or set all the initial conditions to either 0,1 or
    -9999 and run the model with InitLisflood=0

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


### How to launch LISFLOOD

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



## Step7: Model output 

### Default LISFLOOD output

LISFLOOD can generate a wide variety of output. Output is generated as
either maps or time series (PCRaster format, which can be visualised
with PCRaster's 'aguila' application). Reporting of output files can be
switched on and off using options in the LISFLOOD settings file. Also, a
number of output files are specific to other optional modules, such as
the simulation of reservoirs. The following table lists all the output
time series that are reported by default (note that the file names can
always be changed by the user, although this is not recommended):

**Table x.x**: LISFLOOD default output time series*   

| **File name**       | **Units**             | **Description**         |
|-----------------------|-----------------------|----------------------------------------------|
| **RATE VARIABLES AT GAUGES**  |                       |                       |
| dis.tss     | m<sup>3</sup> s<sup>-1</sup>            | <sup>1,2</sup> channel discharge              |
| **NUMERICAL CHECKS**  |                       |                       |
|  mbError.tss   | m<sup>3</sup>                  | <sup>2</sup> cumulative mass balance error          |
| mbErrorMm.tss    | mm                    | <sup>2</sup> cumulative mass balance error, expressed as <br> mm water slice (average over catchment) |
| NoSubStepsChannel.tss     | \-                    | <sup>2</sup> number of sub-steps needed for <br> channel routing |
| steps.tss     | \-                    | <sup>2</sup> number of sub-steps needed for <br> gravity-based soil moisture routine |

<sup>1</sup> Output only if option 'InitLisflood' = 1 (pre-run) \
<sup>2</sup> Output only if option'InitLisflood' = 0  

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

**Table 8.2** LISFLOOD default state variable output maps. These maps can be used to define the initial conditions of another simulation*     

| **File name**   | **Description** | **Units**       | **Domain**      |
|-----------------+--------------------------------+-----------------+--------------------------|
| **AVERAGE RECHARGE MAP (for lower groundwater zone)** (option InitLisflood)   |
|-----------------+--------------------------------+-----------------+--------------------------|
| lzavin.map      | **<sup>1</sup>** average inflow to lower zone| mm timestep<sup>-1</sup> | other fraction  |
| lzavin\_forest.map | **<sup>1</sup>** average inflow to lower zone (forest) | mm timestep<sup>-1</sup> | forest fraction |
| **INITIAL CONDITION MAPS at defined time steps**[^8] (option *repStateMaps*) |
| wdepth00.xxx    | **<sup>2</sup>** waterdepth        | mm              | whole pixel     |
| chcro000.xxx    | **<sup>2</sup>** channel cross-sectional area | m<sup>2</sup>            | channel         |
| dslr0000.xxx    | **<sup>2</sup>** days since last rain variable    | days            | other pixel     |
| scova000.xxx    | **<sup>2</sup>** snow cover zone *A*   | mm              | snow zone A (1/3<sup>rd</sup> pixel)    |
| scovb000.xxx    | **<sup>2</sup>** snow cover zone *B*   | mm              | snow zone B (1/3<sup>rd</sup> pixel)    |
| scovc000.xxx    | **<sup>2</sup>** snow cover zone *C*   | mm              | snow zone C (1/3<sup>rd</sup> pixel)    |
| frost000.xxx    | **<sup>2</sup>** frost index  | °C days<sup>-1</sup>     | other pixel     |
| cumi0000.xxx    | **<sup>2</sup>** cumulative interception        | mm              | other pixel     |
| thtop000.xxx    | **<sup>2</sup>** soil moisture upper layer   | mm<sup>3</sup> mm<sup>-3</sup>    | other fraction  |
| thsub000.xxx    | **<sup>2</sup>** soil moisture lower layer   | mm<sup>3</sup> mm<sup>-3</sup>    | other fraction  |
| lz000000.xxx    | **<sup>2</sup>** water in lower zone  | mm              | other fraction  |
| uz000000.xxx    | **<sup>2</sup>** water in upper zone  | mm              | other fraction  |
| dslF0000.xxx    | **<sup>2</sup>** days since last rain variable (forest)   | days            | forest pixel    |
| cumF0000.xxx    | **<sup>2</sup>** cumulative interception (forest)        | mm              | forest pixel    |
| thFt0000.xxx    | **<sup>2</sup>** soil moisture upper layer (forest)   | mm<sup>3</sup> mm<sup>-3</sup>    | forest fraction |
| thFs0000.xxx    | **<sup>2</sup>** soil moisture lower layer (forest)   | mm<sup>3</sup> mm<sup>-3</sup>    | forest fraction |
| lzF00000.xxx    | **<sup>2</sup>** water in lower zone (forest)  | mm              | forest fraction |
| uzF00000.xxx    | **<sup>2</sup>** water in upper zone (forest)   | mm              | forest fraction |
| cseal000.xxx    | **<sup>2</sup>** water in depression storage (sealed)   | mm              | sealed fraction |

**<sup>1</sup>** Output only if option 'InitLisflood' = 1 (pre-run)
**<sup>2</sup>** Output only if option 'InitLisflood' = 0  

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
