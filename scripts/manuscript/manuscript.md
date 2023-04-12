---
title: Disentangling linkages between satellite derived forest structure and productivity across a range of forest types and ecosystems.
author:
  - name: Evan R. Muise
    email: evan.muise@student.ubc.ca
    affiliations: 
        - id: ubc
          name: University of British Columbia
          department: Forest Resources Management
          address: 2424 Main Mall
          city: Vancouver, BC, Canada
          postal-code: V6T 1Z4
    attributes:
        corresponding: true
  - name: Margaret E. Andrew
    email: M.Andrew@murdoch.edu.au
    affiliations: 
        - id: murd
          name: Murdoch University
          department: Environmental and Conservation Sciences and Harry Butler Institute
          city: Murdoch, WA, Australia
          postal-code: 6150
  - name: Nicholas C. Coops
    email: nicholas.coops@ubc.ca
    affiliations: 
        - id: ubc
          name: University of British Columbia
          department: Forest Resources Management
          address: 2424 Main Mall
          city: Vancouver, BC, Canada
          postal-code: V6T 1Z4
  - name: Txomin Hermosilla
    email: txomin.hermosillagomez@NRCan-RNCan.gc.ca
    affiliations: 
        - id: cfs
          name: Natural Resources Canada
          department: Canada Forest Service (Pacific Forestry Centre)
          address: 506 Burnside Rd W
          city: Victoria, BC, Canada
          postal-code: V8Z 1M5
  - name: A. Cole Burton
    email: cole.burton@ubc.ca
    affiliations: 
        - id: ubc
          name: University of British Columbia
          department: Forest Resources Management
          address: 2424 Main Mall
          city: Vancouver, BC, Canada
          postal-code: V6T 1Z4
  - name: Stephen S. Ban
    email: Stephen.Ban@gov.bc.ca
    affiliations: 
        - id: bcp
          name: Ministry of Environment and Climate Change Strategy
          department: BC Parks
          address: 525 Superior Street
          city: Victoria, BC, Canada
          postal-code: V8V 1T7
abstract: |
  [insert abstract here - nicholas ignore the formatting on the authors for now, i can output to pdf and have it formatted nicely for submission]
keywords: 
  - structural equation modelling
  - remote sensing
  - landsat
  - forest structure
  - forest productivity
  - dynamic habitat indices
date: last-modified
bibliography: [bibliography.bib, packages.bib]
csl: remote-sensing-of-environment.csl
format:
  elsevier-pdf:
    keep-tex: true
    keep-md: true
    journal:
      name: Remote Sensing of Environment
      formatting: review
      model: 3p
      cite-style: authoryear
      layout: twocolumn
  docx: 
    reference-doc: my-styles.docx
    keep-md: true
  pdf: 
    pdf-engine: xelatex
editor: 
  markdown: 
    wrap: 72
execute: 
  echo: false
fig-width: 300
---


::: {.cell}

:::


# Introduction

Biodiversity is the summation of variation in biological life, across
genes, species, communities, and ecosystems. Currently, biodiversity is
in decline, facing extinction rates above the background extinction rate
[@thomas2004; @urban2015], and homogenization of communities at various
scales [@mcgill2015]. In response, the global biodiversity community is
making efforts to assess and halt the degradation of biodiversity on
earth. The Group for Earth Observation Biodiversity Observation Network
has developed the Essential Biodiversity Variables [EBVs, @pereira2013],
designed as an analog to the Essential Climate Variables framework
[@bojinski2014]. EBVs are designed to be global in scope, relevant to
biodiversity information, feasible to utilize, and complementary to one
another [@skidmore2021]. There are six EBV classes, each of which
correspond to a different facet of biodiversity including species
populations, species traits, community composition, ecosystem structure,
ecosystem function, and genetic composition [@pereira2013].

Satellite remote sensing has proven to be capable of measuring five of
the six classes, with the exception being genetic composition, which
requires in-situ observation and sampling [@skidmore2021]. Species
populations - and in turn community composition - can be assessed with
very-high-resolution imagery to identify tree species at the tree-crown
scale, however it is difficult and computationally expensive to extend
these analyses to broader extents [@fassnacht2016; @graves2016]. Species
traits such as phenology have been on a single-tree scale using
PlanetScope imagery and drone-based measurements [@wu2021]. Coarser
measurements, such as those taken by the MODIS [@zhang2003], Landsat
[@fisher2006], or Sentinel [@helfenstein2022; @darvishzadeh2019] series
of satellites can monitor these functional processes at larger extents,
corresponding to ecosystem function, but the coarse spatial resolution
removes the ability to relate these traits to individual trees. Remote
sensing data has been shown to be effective at monitoring ecosystem
structure at regional to global extents through the use of optical
imagery [@cohen2004] and lidar datasets [@lefsky2002; @lang2021;
@neuenschwander2019].

Notably, while remote sensing can provide information on the
species-level EBVs, this information is typically acquired with an
*ad-hoc* approach requiring high spatial and spectral resolution data
[@skidmore2021]. This data can often only be collected at small extents,
rather than the global or regional scales required for biodiversity
trend assessment [@valdez2023]. The two landscape-level EBVs (ecosystem
structure and function) are well suited to be examined at global or
regional scales using moderate-resolution satellite imagery, such as
those provided by the Landsat or Sentinel series of satellites
[@skidmore2021].

Forest structural diversity has been linked to biodiversity at various
scales [@guo2017; @bergen2009; @gao2014]. Many metrics derived from
lidar remote sensing have been used as local indicators of biodiversity,
including simple metrics such as canopy cover and canopy height as well
as derived metrics including vertical profiles, aboveground biomass
[@lefsky1999]. Other second order derived metrics such as canopy
texture, height class distribution, edges, and patch metrics have also
been used to examine habitat and biodiversity at landscape scales
[@bergen2009]. Increased structural complexity has been hypothesized to
create additional niches, leading to increased species diversity
[@bergen2009], which has been frequently demonstrated using avian
species diversity metrics [@macarthur1961]. For example: @herniman2020
used spectral and lidar derived forest structure data to model avian
habitat suitability; @clawges2008 found that lidar derived forest
structural attributes are capable of identifying habitat types
associated with avian species in pine/aspen forests; @goetz2007 used
canopy structural diversity to predict bird species richness, finding
that canopy vertical distribution was the strongest predictor of species
richness. Forest structural metrics have also been used to study
biodiversity in other clades as well [@davies2014; @nelson2005].

Energy availability in an ecosystem has also been shown to be a
predictor of species richness and abundances at various scales
[@chase2002; @radeloff2019; @coops2019; @razenkova], and is measurable
using satellite remote sensing via the use of various vegetation indices
[@huete2002; @radeloff2019]. Vegetation indices, which are indicative of
photosynthetic activity, are commonly used as proxies of gross primary
productivity [@huang2019]. These vegetation indices have also been used
to assess patterns in biodiversity at single time points [@bonn2004],
and more recently, through yearly summaries of productivity
[@radeloff2019].

The relationship between energy availability and biodiversity is
proposed to function through various hypotheses, such as the available
energy hypothesis, the environmental stress hypothesis, and the
environmental stability hypothesis. These three hypotheses have in turn
been linked to patterns of surface reflectance in remote sensing data
[@radeloff2019]. The Dynamic Habitat Indices (DHIs) have been shown to
be well suited to assess these hypotheses. The cumulative DHI calculates
the total amount of energy available in a given pixel over the course of
a year. Cumulative DHI is strongly linked to the available energy
hypothesis, which suggests that with greater available energy species
richness will increase [@wright1983]. The minimum DHI, which calculates
the lowest productivity over the course of a year can be matched to the
environmental stress hypothesis, which proposes that higher levels of
minimum available energy will lead to higher species richness
[@currie2004]. Finally, the variation DHI, which calculates the
coefficient of variance in a vegetation index through the course of a
year, corresponds to the environmental stability hypothesis which states
that lower energy variation throughout a year will lead to increased
species richness [@williams2008].

Biodiversity has been shown to be linked to both forest structure
[@guo2017; @gao2014], and productivity [@radeloff2019] at a range of
scales. Research has highlighted that the relationship between
productivity and biodiversity is reciprocal [@worm2003], making
productivity a suitable biodiversity indicator. Within a forest
environment, there are many possible ecosystem structure and function
metrics that can be assessed. Structural variables range in complexity
from simple (canopy cover; canopy height), to more complex (elevation
coefficient of variation; elevation standard deviation) to modelled
(aboveground biomass; basal area), all of which can be assessed using
lidar data [@coops2021]. Data on ecosystem functionality ranges from
phenology metrics (date of leaf on/leaf off; length of growing season)
to functional traits (chlorophyll content; leaf area index) to
productivity estimates (GPP; total available energy) [@pettorelli2018].
Advances in satellite remote sensing processing have allowed 3d forest
structure data to be imputed across wide spatial scales [@matasci2018;
@coops2021] using data fusion approaches involving collected lidar data
and optical/radar data. Other advances in image compositing have allowed
yearly summaries of vegetation productivity to be calculated at regional
to global scales, summarizing the yearly total, minimum, and variation
in energy availability at similar spatial resolutions [@radeloff2019].

In forested ecosystems, stand structural attributes have also been shown
to influence productivity, with a range of responses dependent on
environmental conditions [@ali2019]. Linkages between forest structure
and productivity (namely, vegetation indices) have been examined for
nearly 20 years [@huete2002, @knyazikhin1998; @myneni1994]. While there
is significant theoretical and empirical evidence for their relationship
at single time points (within a single image) [@myneni1994], various
relationship directions and shapes have been found between forest
structure and productivity metrics [@ali2019]. These relationships,
their shapes, and their strengths have been attributed to multiple
possible hypotheses and have been shown to vary based on environmental
conditions [@ali2019]. The relationship between forest structural
diversity metrics and annual productivity summaries has yet to be fully
examined, including the DHIs.

Understanding the complementarity between potential EBVs is an integral
component of their creation [@skidmore2021]. Structural equation
modelling (SEM) and path analyses have been commonly used in ecology to
assess the causal effects behind various hypotheses [@fan2016;
@grace2010], including the relationship between forest structure,
functioning, and biodiversity [@ali2019]. For example, SEM has commonly
been used to assess the role of structural diversity of carbon storage
as compared to species diversity [@ali2016; @zhang2015].

In this paper we seek to untangle the relationship between two EBVs:
forest structure diversity metrics and yearly summaries of forest
productivity. To accomplish this, we assess this relationship using path
analysis to assess the direct and indirect (as mediated by more complex
forest structural diversity metrics) effects of commonly collected
forest structural metrics (canopy height and canopy cover) on yearly
productivity summaries. Further, we use exploratory structural equation
modelling (ESEM) to identify the latent variables driving the
productivity metrics. We run this analysis using a sample of
wall-to-wall forest structure and productivity data across the province
of British Columbia, and stratified by the forested ecosystems of
British Columbia, Canada, which has some of the largest environmental
gradients on the planet. We compare models using AIC scores and global
fit measures across the ecosystems [@pojar1987]. The results from this
study will assess the linkages and complementarity between two commonly
used biodiversity indicators.

# Methods

## Study Area

British Columbia is the westernmost province of Canada, and is home to a
variety of terrestrial ecosystems [@pojar1987]. Approximately 64% of the
province is forested [@bcministryofforests2003]. There is a large amount
of ecosystem variation in the province, with large climate and
topographic gradients. The Biogeoclimatic Ecosystem Classification (BEC)
system identifies 16 zones based on the dominant tree species and the
ecosystems general climate. These zones can be further split into
subzones, variants, and phases based on microclimate, precipitation, and
topography [@pojar1987].

{insert figure showing ecosystems of interest} need to remake figure
showing ecosystems, highlighting that bunchgrass and alpine zones are
not included

{table showing elevations and climate ranges for each included bec zone}

## Data

### Forest Structure

We utilize a suite of forest structural diversity variables (canopy
height, canopy cover, Lorey's height, overstory cover, basal area,
aboveground biomass, gross stem volume, mean elevation, elevation
standard deviation, and structural complexity \[coefficient of variation
in elevation returns\]). This dataset is created at a 30 m spatial
resolution according to @matasci2018. In brief, the method utilizes a
set of lidar collections and field plots across Canada, and imputes the
remaining pixels using a random forest k-Nearest Neighbour approach.
Detailed information on the creation of this dataset can be found in
@matasci2018.

### Dynamic Habitat Indices

The Dynamic Habitat Indices are a set of satellite remote sensing
derived productivity variables that summarize the cumulative amount of
available energy, the minimum available energy, and the variation in
available energy throughout a given year [@radeloff2019]. The DHIs have
previously been produced at a global extent using MODIS imagery
[@radeloff2019], however, recent studies have examined how these indices
can be constructed at a finer spatial resolution using multi-annual
Landsat imagery.

The DHIs were calculated according to {RAZENKOVA LANDSAT DHI PAPER IN
PRESS} for all of terrestrial British Columbia. In brief, they utilized
Google Earth Engine [@gorelick2017] to obtain all valid Landsat pixels
for a given study area by filtering out low quality pixels, then
calculated the NDVI for each pixel. They use the median NDVI value for
each month across the ten year time span (2011-2020) to calculate the
sum, minimum, and coefficient of variation in NDVI values. More detailed
information can be found in {Razenkova In Press}.

## Sampling

We conducted model based sampling across the fifteen forest dominated
ecosystems found within British Columbia \[BC figure reference, I have
not made this figure yet\]. Samples were randomly selected within BEC
zones of interest alongside multiple criteria. Each sampled pixel had to
have a forested land cover class (coniferous, deciduous, mixed-wood, or
wetland-treed), and be surrounded by the same land cover class.
Additionally, each pixel had to have a coefficient of variation less
than 0.5 in the Lorey's height and canopy cover forest structural
metrics. A maximum of 3000 samples were sampled in each BEC zone. To
meet the normality assumptions of structural equation modelling, all
variables were natural-log transformed and standardized, as per
@grace2016. Variables containing zeros were natural-log plus one
transformed.

## Analysis

### Path Analysis

To determine the relationships between simple lidar derived forest
structural attributes, complex/derived forest structural attributes, and
forest productivity, we used path analysis to analyze two causal models
(@fig-pathdag). To determine primary drivers of the three DHIs, we will
summarize the predictors across ecosystems by counting the strongest
predictor in each BEC zone. This will determine if the primary driver
for each facet of the DHI is simple or complex, and allow us to assess
ecosystem differences.


::: {.cell}
::: {.cell-output-display}
![Proposed path diagrams.](../../outputs/path_dags.png){#fig-pathdag}
:::
:::


### Exploratory Structural Equation Modelling

Secondly, we will use exploratory structural equation modelling
[@marsh2020; @asparouhov2009] to identify latent forest structural
variables within the data, and use these latent variables to predict the
dynamic habitat indices. Exploratory structural equation modelling is a
combination of exploratory factor analysis (EFA) and structural equation
modelling, which relaxes the strict requirement of zero cross-loadings
in confirmatory factor analysis and allows for less strict measurement
models to be used. ESEM is used when it is known that there is a latent
structure to the data, but the specific indicator variables have not yet
been determined.

One advantage of ESEM is that it can create varying numbers of latent
variables. For our analysis, we first ran exploratory factor analysis on
all forest structural attributes both globally and by BEC zone with
between 1-4 potential latent variables. We chose the most parsimonious
EFA model with the lowest AIC scores for each ecosystem, leading to
varying numbers of latent variables. We then determined the anchoring
indicator for each latent variable. The anchors were calculated by
choosing the indicator variable with the largest difference between the
maximum value in a given loading compared to to said indicators loadings
in all other latent variables. Each anchor variable was then assigned to
a named group (Canopy Cover, Height and Biomass, and Structural
Complexity).

Following the EFA, we used structural equation modelling, with latent
variables loadings determined by the EFA. We also filtered the loadings
to be greater than or equal to 0.5, allowing us to examine the number
and composition of latent variables found in each ecosystem. Following
this, we predicted the DHIs in a single SEM with covariances between the
DHIs. If a forest structural attribute did not end up in a latent
variable, it was included in the structural equation model as a DHI
predictor, without a latent variable as a mediator.

## Software

The processing for this paper was done in R version 4.2.2 [@R-base]. We
used *sgsR* [@goodbody2023] for sampling, *terra* [@R-terra] for raster
analyses, *sf* for vector analyses [@R-sf], and *lavaan* [@lavaan2012]
for path analysis and structural equation modelling.

Focal analyses were conducted in R and Python, and the sampling was
conducted across a masked suitability raster for each BEC zone using the
*sgsR* R package version 1.3.4 [@goodbody2023].

All code associated with this analysis is available at
https://github.com/emuise/code-structProdSem.

# Results

## Path Analysis


::: {.cell}
::: {.cell-output-display}
![Proportion of strongest signficant forest structural predictors of yearly productivity metrics in models based on canopy cover vs canopy height.](../../outputs/path_bars.png){#fig-pathbar-prop}
:::
:::

::: {.cell}
::: {.cell-output-display}
![Bar plot of strongest predictors in path analysis for each BEC zone and predicted DHI variable.](../../outputs/strongest_predictor_bar.png){#fig-pathbar-pred}
:::
:::

::: {.cell}
::: {.cell-output-display}
![Map of strongest structural attribute predictor strength on yearly productivity metrics by BEC zone for the two proposed models. If there are no significant predictors, shown in dark grey](../../outputs/path_map_edit.png){#fig-pathmap}
:::
:::


## Exploratory Structural Equation Modelling

I also want to run exploratory SEM with and without the DHI's to see
what grouping it goes in. MinDHI has been breaking because some zones
only have 0 as mindhi (makes sense, they are in the alpine).


::: {.cell}
::: {.cell-output-display}
![Groups of latent variables with loadings greater than or equal to 0.5 for each BEC zone. Loadings were determined using exploratory factor analysis with up to four latent variables, and selecting the number of possible latent variables with the lowest AIC. All forest structure variables were potentially included as indicators in each latent variable.](../../outputs/latent_groups.png){#fig-esem-latent}
:::
:::


Exploratory factor analysis shows three groups of latent variables
(@fig-esem-latent). We assigned the groups to latent variables
indicating canopy cover / biomass metrics, canopy height / biomass
metrics, and structural complexity metrics. Indicators to latent
variable groups by examining anchors for each latent variable. The
anchors were calculated by choosing the indicator variable with the
largest difference between the maximum value in a given loading compared
to to said indicators loadings in all other latent variables.

Both the Ponderosa Pine (PP) and Sub-boreal Pine -- Spruce zones have
one latent variable. Coastal Western Hemlock (CWH), Engelmann Spurce --
Subalpine Fir (ESSF), and Montane Spruce (MS) are the only zones to have
structural complexity based latent variables. CWH is the only zone to
include elevation standard deviation in the structural complexity latent
variable.


::: {.cell}
::: {.cell-output-display}
![Groups of latent variables with loadings greater than or equal to 0.5 for each BEC zone, including the DHIs. Loadings were determined using exploratory factor analysis with up to five latent variables, and selecting the number of possible latent variables with the lowest AIC. All forest structure variables were potentially included as indicators in each latent variable.](../../outputs/latent_dhis.png){#fig-esem-latent-dhi}
:::
:::


Exploratory factor analysis shows three groups of latent variables. We
assigned these groups to attributes based on the indicator variables in
each latent variable, indicating canopy cover, height and biomass, and
structural complexity. When including the DHIs in this EFA, it is rare
that they are included with latent variables with large loadings. The
cumulative DHI is an indicator for the canopy cover latent varible in
the IDF (Interior Douglas-fir) and MS (Montane Spruce) BEC zones. The
DHIs are not included in any other latent variable, indicating that they
compose different information than the forest structural variables.


::: {.cell}
::: {.cell-output-display}
![Boxplots of latent variable loadings across BEC zones as determined by exploratory factor analysis. Red dashed lines show latent variable indicator cutoff before being used as starting values for the SEM models.](../../outputs/latent_boxplot.png){#fig-latent-boxplots}
:::
:::


@fig-latent-boxplots shows boxplots of latent variable loadings from
forest structure indicator variables. A maximum of three valid latent
variables were identified across the sixteen BEC zones. We assigned
indicators variables to latent variable groups by examining the
anchoring variables for each latent variable. The anchoring variables
were calculated by choosing the indicator variable with the largest
difference between the maximum value in a given loading compared to said
indicators loadings in all other latent variables. The only DHI variable
that was included in the latent variables after subsetting the latent
variables to only include strong loadings was the Cumulative DHI in the
canopy cover latent variable.

I need to actually make the DAGs and plot the parameters, but I haven't
gotten there yet. I'll plot the global one to show what it looks like,
then aggregate it in some way - probably similar to the path analysis. I
also may include the variable partitioning that Meg talked about in the
email if I can get it working.

# Discussion

# Conclusion

\newpage

# References {.unnumbered}
