---
title: Disentangling linkages between satellite derived forest structure and productivity essential biodiversity variables.
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
abstract: In today's changing climate and in light of the biodiversity crises, it is integral to be able to monitor the change in biodiversity at large scales. Key to this is the development of variables capable of monitoring biodiversity trends. One framework developped to tackle this problem is the Essential Biodviersity Variables (EBV) framework, which is designed to be analogous to the Essential Climate variables, and capable of monitoring biodiversity globally while also being complementary to one another. Within the EBV framework, there are six EBV classes, two of which are extremely well suited to be monitoring from satellite remote sensing. Among these with the potential to be satellite derived, the ecosystem structure and function classes stand out. Linkages between ecosystem structure and function have preivously been demonstrtated. In this paper, we seek to assess the complementarity of forest structure, as imputed across the entirety of British Columbia, Canada, with the Dynamic Habitat Indices, a yearly summary of productivity indices. Both datasets have been previously linked with biodiversity metrics across a range of scales. Using redundancy analysis, we find that forest structural attributes and the DHIs are decoupled from one another, with the forest structure datasets explaining 14% of the DHI variation. Further, we explore how the proportion of variance explained in the DHIs from primary strucutral attributres such as canopy height and canopy cover and modelled strucutral attributes such as aboveground biomass varies. We find there is generally large overlap between the two datasets. Overall, we find that forest structure as an ecosystem EBV and the DHIs as an ecosystem EBV are well suited to be complementary EBVs across large environmental gradients.
keywords: 
  - remote sensing
  - landsat
  - forest structure
  - forest productivity
  - dynamic habitat indices
  - essential biodiversity variables
  - redundancy analysis
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

With biodiversity being in decline, and facing extinction rates above
the background extinction rate [@thomas2004; @urban2015], as well as the
homogenization of communities at various scales [@mcgill2015] it is
integral to be able to monitor how biodiversity is changing across the
globe. In response, the global biodiversity community is making efforts
to assess and halt the degradation of biodiversity. The Group for Earth
Observation Biodiversity Observation Network has developed the Essential
Biodiversity Variables [EBVs, @pereira2013], designed as an analog to
the Essential Climate Variables framework [@bojinski2014]. EBVs are
designed to be global in scope, relevant to biodiversity information,
feasible to use, and complementary to one another [@skidmore2021]. While
it can be incredibly difficult, time consuming, and expensive to collect
data on biodiversity across wide swaths of land and varying ecosystems,
EBVs, which can be correlated to sampled biodiversity information, allow
for the monitoring and asssessment of protected area effectiveness and
ecosystem health at large spatial scales [@hansen2021]. There are six
EBV classes, each of which correspond to a different facet of
biodiversity including species populations, species traits, community
composition, ecosystem structure, ecosystem function, and genetic
composition [@pereira2013].

Satellite remote sensing has proven to be capable of measuring five of
the six EBV classes, the exception being genetic composition, which
requires in-situ observation and sampling [@skidmore2021]. Species
populations - and in turn community composition - can be assessed with
very-high-resolution imagery to identify tree species at the tree-crown
scale, however it is difficult and computationally expensive to extend
these analyses to broader extents [@fassnacht2016; @graves2016] while
species traits such as vegetation phenology have been observed at the
single-tree scale using, for example, PlanetScope imagery and
drone-based measurements [@wu2021]. However, the spatially limited and
often *ad-hoc* data collection approaches associated with monitoring
individuals is not conducive to the global or regional scales required
for biodiversity trend assessment [@valdez2023].

The two landscape-level EBVs (ecosystem structure and function) are well
suited to be examined at large spatial scales using coarser spatial
measurements, such as those taken from satellites by the Moderate
Resolution Imaging Spectroradiometer [MODIS; @zhang2003], the Landsat
imaging systems [@fisher2006], or Sentinel-2 [@helfenstein2022;
@darvishzadeh2019] programs. These mid-resolution satellites can monitor
processes at broader extents but the coarse spatial resolution removes
the ability to relate these traits to individual organisms. As a result,
satellite remote sensing data has been shown to be arguably the most
effective at monitoring ecosystem based EBVs focused on structure and
function. These EBVs classes can be monitored at regional to global
extents through the use of optical imagery [@cohen2004], as well as
active sensors such as lidar (light detection and ranging) and radar
[@guo2017; @lefsky2002; @lang2021; @neuenschwander2019; @coops2016].

## EBV - Ecosystem Structure

Forest structural diversity has been linked to biodiversity at various
scales [@guo2017; @bergen2009; @gao2014]. Structural attributes range in
complexity from simple (canopy cover; canopy height), to more complex
(vertical and horizontal structural complexity) to modelled (aboveground
biomass; basal area), all of which can be assessed using lidar data
[@coops2021]. A suite of these lidar-derived attributes have been used
as local indicators of biodiversity, including simple metrics such as
canopy cover and canopy height as well as derived metrics including
vertical profiles, aboveground biomass [@lefsky1999; @guo2017;
@coops2016]. Other second order derived metrics such as canopy texture,
height class distribution, edges, and patch metrics have also been used
to examine habitat and biodiversity at landscape scales [@bergen2009].
Advances in satellite remote sensing processing have allowed 3D forest
structure data to be imputed across wide spatial scales [@matasci2018;
@coops2021] using data fusion approaches involving collected lidar data
and optical/radar data.

Increased forest structural complexity has been hypothesized to create
additional niches, leading to increased species diversity [@bergen2009],
which has been frequently demonstrated using avian species diversity
metrics [@macarthur1961]. For example: @herniman2020 used spectral and
lidar derived forest structure data to model avian habitat suitability;
@clawges2008 found that lidar derived forest structural attributes are
capable of identifying habitat types associated with avian species in
pine/aspen forests; @goetz2007 used canopy structural diversity to
predict bird species richness, finding that canopy vertical distribution
was the strongest predictor of species richness. Forest structural
metrics have also been used to study biodiversity in other clades as
well [@davies2014; @nelson2005].

## EBV - Ecosystem Function

With respect to ecosystem function, energy availability in an ecosystem
has shown to be a predictor of species richness and abundances at
various scales [@chase2002; @radeloff2019; @coops2019; @razenkova2023],
and is measurable using satellite remote sensing via the use of various
vegetation indices [@huete2002; @radeloff2019]. Vegetation indices,
which are indicative of photosynthetic activity, are commonly used as
proxies of gross primary productivity [@huang2019]. These vegetation
indices have also been used to assess patterns in biodiversity at single
time points [@bonn2004], and more recently, through yearly summaries of
productivity [@berry2007; @radeloff2019]. The relationship between
energy availability and biodiversity occurs via various hypothesized
mechanisms, such as the available energy hypothesis [@currie2004;
@wright1983], the environmental stress hypothesis [@currie2004], and the
environmental stability hypothesis [@williams2008]. These three
hypotheses have in turn been linked to patterns of annual surface
reflectance in remote sensing data [@berry2007; @radeloff2019].

@berry2007 first explored this idea by proposing the linkage of
intra-annual summaries of MODIS derived GPP to dispersive bird species.
This idea was further refined into the Dynamic Habitat Indices [DHIs;
@coops2008], which have now been shown to be well suited to assess the
three aforementioned hypotheses at global scales [@radeloff2019]. The
cumulative DHI calculates the total amount of energy available in a
given pixel over the course of a year. Cumulative DHI is strongly linked
to the available energy hypothesis, which suggests that with greater
available energy species richness will increase [@wright1983]. The
minimum DHI, which calculates the lowest productivity over the course of
a year can be matched to the environmental stress hypothesis, which
proposes that higher levels of minimum available energy will lead to
higher species richness [@currie2004]. Finally, the variation DHI, which
calculates the coefficient of variance in a vegetation index through the
course of a year, corresponds to the environmental stability hypothesis
which states that lower energy variation throughout a year will lead to
increased species richness [@williams2008].

## Biodiversity Monitoring with EBVs

Biodiversity monitoring programs often require a range of information in
order to accurately assess changes in ecosystem integrity
[@lindenmayer2010]. Choosing datasets that are most closely related to
the phenomenon of interest in a given application allows for direct
connections to monitoring results and management actions [@pressey2021].
With the advent of large-extent monitoring methods like satellite remote
sensing, and a proliferation of potential EBVs datasets, it becomes
important to assess the interrelationships between these datasets, and
assess their complementary of the information to reduce duplication of
efforts [@pereira2013; @skidmore2021]. When strong relationships are
present between EBV classes, it becomes possible to assess the
ecological relationships between potential EBVs. On the other hand, when
datasets do not appear related, they may be well suited to be used in
monitoring programs together, as complementary EBVs.

Linkages between forest ecosystem structure and function have been
examined within a remote sensing context for over 20 years [@huete2002,
@knyazikhin1998; @myneni1994]. While there is significant theoretical
and empirical evidence for their relationship at single time points
(within a single image) [@myneni1994], various relationship directions
and shapes have been found between forest structure and function metrics
[@ali2019]. Hypothesized mechanisms such as niche complementary have
shown that aboveground biomass increases with stand structure
[@zhang2012], while asymmetric competition for light can reduce forest
productivity with increased structural complexity [@bourdier2016]. The
relationship in particular between forest structural diversity metrics -
which are now more accurately and comprehensively derived from lidar
data - and temporal variation in functional metrics, specifically the
metrics of ecosystem productivity via the DHI framework, have yet to be
fully examined.

The overall goal of this paper is to assess patterns of forest ecosystem
structure and function and their complementarity across a wide range of
ecosystems encompassing significant environmental gradients. To do so,
we synthesize data from moderate-scale remote-sensing derived metrics of
forest structure, represented as both simple ALS-extracted metrics of
canopy height, cover and vertical complexity, as well as modelled forest
structure attributes including volume, and aboveground biomass, with a
well-established remote sensing derived index on ecosystem function. Our
first question is to examine how ecosystem structure and function
complement one another across a large environmental gradient and then
compare the simple and modelled representations of forest structure to
different levels of ecosystem function. This question is important as it
provides insights to the EBV community around complementarity of remote
sensing metrics when describing the structure and function of ecosystems
and proposes a method to examine potential overlap when generating
remote sensing EBVs.

Our second question examines the independent and shared relationships of
ecosystem structure height and cover, with modelled forest structure, on
ecosystem function. This provides insight into the choice of remote
sensing attributes to use when developing EBVs within a single EBV
class. Remote sensing datasets can comprise relatively unprocessed
observations, in this case ALS measures of height and cover which are
derived from the raw 3D point cloud vs modelled attributes, such as
biomass and volume, which involve the use the statistical relationships
with field data to transform the observations into more refined data
products. Assessing which of these two (or combination of the two)
approaches has stronger or weaker correlations with estimates of
function provides insights into the choice of data used to build EBVs.
Lastly, we examine how the primary and modelled structure attributes
partition the variance of the DHIs within key biomes and forest types
across a large environmental range, examining to what extent ecosystem
and forest types impacts these relationships and thus providing insight
into the applicability of these results globally.

# Methods

## Study Area {#sec-study-area}

British Columbia is the westernmost province of Canada, and is home to a
variety of terrestrial ecosystems. Approximately 64% of the province is
forested, with large environmental and topographic gradients
[@pojar1987; @bcministryofforests2003]. The Biogeoclimatic Ecosystem
Classification (BEC) system identifies 16 zones based on the dominant
tree species and the ecosystems general climate (@fig-study-map).


::: {.cell}
::: {.cell-output-display}
![Location of biogeoclimatic ecosystem classification (BEC) zones in British Columbia.](../../outputs/bec_map.png){#fig-study-map}
:::
:::


These zones can be further split into subzones, variants, and phases
based on microclimate, precipitation, and topography [@pojar1987]. To
examine trends across the large environmental gradients, we group the
BEC zones into five broad biomes, specifically, the southern interior,
northern interior, montane, alpine, and coastal groups similar to
@hamann2006. We also report each BEC zone's average climate data,
according to @wang2020 (@tbl-bec-group).


::: {#tbl-bec-group .cell tbl-cap='BEC Zones, their aggregate groups, and their average climate values for precipitation, maximum temperature, and minimum temperature. Climate data from Wang et al. 2016.'}
::: {.cell-output-display}
|BEC Group |BEC Zone |Full Name                         | Precipitation (mm/yr)| Max Temperature (°C)| Min Temperature (°C)|
|:---------|:--------|:---------------------------------|---------------------:|--------------------:|--------------------:|
|Alpine    |BAFA     |Boreal Altai Fescue Alpine        |             1357.3149|                  1.9|                 -5.6|
|Alpine    |CMA      |Coastal Mountain-heather Alpine   |             2878.1447|                  4.5|                 -2.4|
|Alpine    |IMA      |Interior Mountain-heather Alpine  |             1621.6666|                  3.1|                 -4.2|
|Coastal   |CDF      |Coastal Douglas-fir               |              986.1071|                 12.9|                  5.9|
|Coastal   |CWH      |Coastal Western Hemlock           |             2518.8419|                 10.6|                  3.5|
|Montane   |ESSF     |Engelmann Spruce -- Subalpine Fir |             1087.6317|                  5.3|                 -3.1|
|Montane   |MH       |Mountain Hemlock                  |             2666.1895|                  7.2|                 -0.2|
|Montane   |MS       |Montane Spruce                    |              622.1450|                  8.3|                 -2.5|
|North     |BWBS     |Boreal White and Black Spruce     |              516.2776|                  5.9|                 -5.3|
|North     |SBPS     |Sub-Boreal Pine -- Spruce         |              480.1034|                  9.0|                 -3.7|
|North     |SBS      |Sub-Boreal Spruce                 |              619.0830|                  8.1|                 -2.3|
|North     |SWB      |Spruce -- Willow -- Birch         |              730.6874|                  3.6|                 -5.7|
|South     |BG       |Bunchgrass                        |              319.9918|                 13.1|                  1.4|
|South     |ICH      |Interior Cedar -- Hemlock         |              901.3568|                  9.5|                 -0.3|
|South     |IDF      |Interior Douglas-fir              |              476.7932|                 10.6|                 -0.7|
|South     |PP       |Ponderosa Pine                    |              352.1779|                 13.6|                  2.9|
:::
:::


## Data

### Forest Structure

We used a suite of forest structural attributes (canopy height, canopy
cover, Lorey's height, overstory cover, basal area, aboveground biomass,
gross stem volume, mean elevation, elevation standard deviation, and
structural complexity \[coefficient of variation in elevation
returns\]). This dataset was created at a 30 m spatial resolution
according to @matasci2018. In brief, the method used a set of lidar
collections and field plots across Canada, and imputed the remaining
pixels using a random forest k-Nearest Neighbour approach on
Landsat-derived surface reflectance and auxiliary data such as
topography. Detailed information on the creation of this dataset can be
found in @matasci2018.

### Dynamic Habitat Indices

We use an established set of indices of annual productivity shown to be
related to global biodvierstiy trends: the Dynamic Habitat Indices
[@radeloff2019]. The DHIs are a set of satellite remote sensing derived
productivity variables that summarize the cumulative amount of available
energy, the minimum available energy, and the variation in available
energy throughout a given year [@berry2007; @radeloff2019]. The DHIs
have previously been produced at a global extent using MODIS imagery ,
and have been used to assess alpha [@radeloff2019] and beta[@andrew2012]
diversity, species abundances [@razenkova2023], and construct novel
ecoregionalizations [@coops2009]; @andrew2013\] . Recent studies have
began to examine how these indices can be constructed at a finer spatial
resolution by using multi-annual Landsat imagery to generate a single
synthetic year of monthly observations [@razenkova2022].

The DHIs were calculated according to [@razenkova2022; Razenkova et al.,
In Press] for all of terrestrial British Columbia. In brief, Google
Earth Engine [@gorelick2017] was used to obtain all valid Landsat pixels
for a given study area, filtering out pixels containing shadows, slouds,
and cloud shadows within each image [@zhu2012], then calculated the NDVI
for each pixel in each image. They then calculated the median NDVI value
for each month across the ten year time span (2011-2020) to generate a
synthetic year of monthly data. The sum, minimum, and coefficient of
variation across this synthetic year of NDVI values is then calculated.
More detailed information can be found in Razenkova et al. (In Press).

## Sampling

We conducted model-based sampling across the sixteen forest-dominated
ecosystems found within British Columbia \[BC figure reference, I have
not made this figure yet\]. Samples were randomly selected within each
BEC zone, in undisturbed pixels. Each sampled pixel had to have a
forested land cover class (coniferous, deciduous, mixed-wood, or
wetland-treed), and be surrounded by the same land cover class. The land
cover mask was generated following [@hermosilla2022] using a
best-available-pixel composite, and an inverse-distance weighted random
forest approach across Canada. Additionally, each pixel had to have a
coefficient of variation less than 0.5 in surrounding pixels in the two
simplest forest structural attributes, canopy height and canopy cover. A
maximum of 3000 samples were sampled in each BEC zone with a 1 km
minimum sampling distance to reduce the effects of spatial
autocorrelation. All variables were natural-log transformed and
standardized. Variables containing zeros were natural-log plus one
transformed. Sampling was conducted in R [@R-base] version 4.2.2 using
the **sgsR** package [@R-sgsR]. Focal analyses for the land cover
classes and coefficient of variation were calculated in Python version
3.9.

## Analysis

### Redundancy Analysis and Variation Partitioning

Redundancy analysis (RDA) and variation partitioning were used to relate
the primary and modelled forest structure attributes to ecosystem
function across a broad environment range. Redundancy analysis functions
similarly to a multiple linear regression, except it is capable of
predicting multiple response variables. It accomplishes this by first
running a multiple linear regression of each predictor variable on each
response variable, then running a principle component analysis on the
residuals from each multiple linear regression. This reduces the
dimensionality of the output, and allows the relationship strength to be
assessed by calculating the loadings of both predictor and response
variables on the RDA axes. Partial redundancy analysis function
similarly, except also considers co-variates [@legendre2012]. Redundancy
analysis has widely been used in community ecology where environmental
variables of interest are compared to species composition
[@blanchet2014; @kleyer2012] and has similarities to partial least
squares regression -- namely, their multivariate approach, usage of
dimensionality reduction, and linearity assumption -- which is commonly
used in remote sensing literature [@roelofsen2014; @burnett2021].

Following the RDA, we employ ANOVAs to determine which axes are
significant, and calculate the proportion of variance attributable to
each axis using the eigenvalues generated from the RDA. We calculate
axis loadings for both predictor and response variables by calculating
the correlation between the variables and the RDA axes. Axis loadings
represent the relationship between a given variable and the RDA axis. We
only consider and display significant axes. To visualize the RDA for
both predictor and response variables, we display the results as path
diagrams, with loadings from each predictor to the RDA axis to the
response variables. The variance explained by each axis is also
displayed in the RDA box (@fig-rda-var). All RDA calculations were done
in R [@R-base] version 4.2.2 using the **vegan** package [@R-vegan].

Variation partitioning is an extension of partial RDA which can assess
the overlap between the explanatory power of two datasets by utilizing
multiple partial RDAs and exchanging which datasets are considered the
predictor, and which is considered the co-variate [@legendre2012].
Variation partitioning is traditionally displayed using a Venn diagram,
in which the percentage of variance explained by each dataset is in a
circle, and the overlap between circles represents the overlap in
variance explained. All variation partition analyses were done in R
[@R-base] version 4.2.2 using the **vegan** package [@R-vegan].

RDA and variation partitioning analyses were conducted for all samples,
as well as individually across each BEC zone and forest type. The
results were aggregated to BEC zone groups (see @sec-study-area for
visualization).

All code associated with the processing and analysis is available at
https://github.com/emuise/code-structProdSem.

# Results


::: {.cell}
::: {.cell-output-display}
![A) Axis loadings from redundancy analysis of primary and modelled forest structural attributes on the dynamic habitat indices. B) Results from variation partitioning of primary and modelled forest structural attributes on the DHIs. Both visualized analyses are across all collected samples. See supplementary information for results from each BEC zone and forest type.](../../outputs/all_data_figure.drawio.png){#fig-rda-var}
:::
:::


To examine the relationship between ecosystem structure and function
across a large environmental gradient, we present the results of a
redundancy analysis of forest structural attributes on the dynamic
habitat indices across the entire sampled dataset in @fig-rda-var A.
While there are three RDA axes associated with the full dataset, the
third axis explains 0.05% of the variance in the DHIs, and as a result
it is not shown. The first axis is strongly represents all the DHIs
(loadings \> 0.85 for all DHIs), and has the strongest loadings from
canopy cover, basal area, aboveground biomass, and gross stem volume.
The other input attributes (canopy height, structural complexity, and
Lorey's height) have smaller loadings. The second axis primarily
represents the seasonality (Minimum and Variation DHI) of the DHIs, with
a very small loading on the Cumulative DHI, and is primarily driven by
canopy cover and complexity (@fig-rda-var A).

The results from the variation partitioning analysis (@fig-rda-var B)
show that the majority of the variance explained by the input datasets
is shared across both primary and modelled attributes. In total, only
14% of the variation in the DHIs is explained by the structural
information, with 8.2% of this being from overlap between the datasets.
The primary and modelled attributes explain 3 and 2.8% of the variation
on their own, respectively (@fig-rda-var B).


::: {.cell}
::: {.cell-output-display}
![Radar plots of average loadings strength by group. A and B show input and response loadings, respectively. C) Boxplots of BEC zone, forest types, and all data loadings for predictor and response variables.](../../outputs/radar_boxplot.png){#fig-radar}
:::
:::


Further, we wanted to examine the strength of the relationship between
the DHIs and primary structural attributes vs modelled structural
attributes across the forest types and ecosystems of the province.
@fig-radar A and B show the axis loadings for structural attributes and
the DHIs, respectively. Across the BEC zone groups, the loadings are
generally similar in the structural attributes. @fig-radar C shows
boxplots of individual BEC zone loadings for structural attributes and
the DHIs. Across the BEC zones, canopy cover is generally the strongest
predictor loading of the first RDA axis, and structural complexity is
generally the weakest predictor loading. The exception is in deciduous
forest types (mixed-wood and broadleaf), where structural complexity is
the largest axis loading, alongside canopy cover (@fig-radar C). The
second axis has smaller significant loadings. The loadings of the DHIs
in the first axis are generally larger than the loadings for the
structural attributes, with the cumulative DHI often being the strongest
loading overall. In alpine BEC zones, the minimum DHI loading is smaller
than the variation and cumulative DHIs. The secondary RDA axis is
primarily driven by variation in the minimum DHI, with medium loadings
in the variation DHI, and small loadings in the cumulative DHI
(@fig-radar B & C).


::: {.cell}
::: {.cell-output-display}
![Stacked bar plot proportion of DHI variation explained by extracted, modelled, and the overlap between primary and modelled structural attributes.](../../outputs/fracts_bar_plot.png){#fig-fracts-bar}
:::
:::


@fig-fracts-bar shows stacked bar plots of the proportion of variation
explained in the DHIs by primary, modelled, and the overlap between
primary and modelled attributes. Running the analysis by forest types
generally results in higher amounts of variance explained, this is
especially prevalent in deciduous forest types (mixed-wood and
broadleaf). The overlap between modelled and primary attributes is
generally higher than each dataset on their own, with the exception
being mixedwood forests and the Coastal Western Hemlock BEC zone.
Notably, the variation explained by the primary and modelled attributes
is commonly presented through a single RDA axis, which generally
corresponds to overall productivity through the year (@fig-radar).
Generally, the DHIs are decoupled from the structural attributes,
regardless of whether the attribute is directly extracted from the point
cloud or is a modelled variable.


::: {.cell}
::: {.cell-output-display}
![False colour maps of axis loadings for the first RDA axis (top) and second RDA axis (bottom). All colour values are normalized to the maximum loading of each variable. A and D show axis loadings for canopy height (r), canopy cover (g) and structural complexity (b). B and E show axis loadings for basal area(r), total biomass (g) and gross stem volume (b). C and F show axis loadings for the cumulative DHI (r), variation DHI (g) and minimum DHI (b).](../../outputs/rgb_normalized.png){#fig-fcc}
:::
:::


@fig-fcc shows false colour composites of the primary (A & C) and
modelled (B & D) loadings across the BEC zones of British Columbia. In
the first RDA axis there is spatial variation in the primary attributes,
with interior zones being primarily driven by canopy cover (green), the
coastal regions having a strong structural complexity loading, and the
boreal in the northwest having the strongest loadings in canopy height
(@fig-fcc A). The modelled attributes generally show gray-scale colour,
indicating that basal area, total biomass, and gross stem volume do not
explain additional variation in the DHIs (@fig-fcc B). Only four zones
have a secondary RDA axis (@fig-radar C). These zones have been
spatially represented in @fig-fcc C & D. Boreal white and black spruce,
interior Douglas-fir, mountain hemlock, and montane spruce have a
secondary axis, with no spatial pattern associated with the presence of
a secondary axis. Canopy cover has the strongest loading in the boreal
white and black spruce, while the secondary axis in the remaining three
zones have the highest loadings in canopy height (@fig-fcc D). Again,
the modeled attributes are in grayscale, indicating similar loadings
across the three modelled attributes (@fig-fcc E). The DHIs in the
second axis are primarily driven by the minimum DHI, with low loadings
on the cumulative DHI, and moderate loadings on the variation DHI (
@fig-fcc F; @fig-radar C).

# Discussion

It is integral to consider the complementarity of potential EBVs
[@pereira2013; @skidmore2021] . Forest structure and productivity have
been shown to be linked in multiple studies spanning three decades
[@ali2019; @myneni1994], however, a linkage between intra-annual
production and forest structure has not been shown. In this study, we
use statistical analyses from community ecology - namely redundancy
analysis and variation partitioning - to assess the complementarity of
forest structure and yearly productivity summaries. We find that the
datasets do not strongly overlap, with forest structure explaining 14%
of the variation in the dynamic habitat indices in samples taken across
the entirety of British Columbia (@fig-rda-var B). This indicates that
they are suitable to be used in tandem with one another when used as
ecosystem EBVs.

Across most of British Columbia's ecosystem, we identified a single RDA
axis associated with the DHIs, encompassing the overall productivity
(@fig-rda-var A). Within this first axis, the strongest loadings were
canopy cover and the modelled attributes. When a second axis was
significant, it consistently had strong loadings on the minimum and
variation DHIs indicating a complex relationship within the DHIs in
certain ecosystems. This secondary axis has smaller axis loadings
associated with the primary and modelled attributes, with the strongest
loadings being canopy cover and structural complexity across the entire
dataset (@fig-rda-var A).

We also sought to explore whether modelled attributes (basal area, gross
stem volume, aboveground biomass, and Lorey's height) add additional
explanatory information when predicting the DHIs, as compared to primary
forest structural attributes. We generally found that canopy cover had
the largest axis loadings in the first RDA axis (@fig-radar), which
corresponds with canopy cover and LAI intercepting radiation from the
sun influencing the amount of energy available in the environment
[@knyazikhin1998]. Modelled attributes such as basal area, aboveground
biomass, and gross stem volume shared similar loading magnitudes across
the range of studied ecosystems, indicating they do not add additional
value when compared to one another (@fig-radar C; @fig-fcc B). The
loadings between the modelled attributes and canopy cover are often
similar, and as such, we recommend utilizing the attributes derived
directly from the point cloud in the case of ALS data, or selecting a
single modelled attribute.

During the analysis we noticed a high amount of total variance explained
in deciduous forests (mixed-wood and broadleaf) when compared to the
other two forest types and most BEC zones. This could possibly be due to
the loss of canopy cover during the winter being linked more closely to
the DHIs, which are an annual summary of productivity, and not taken at
a single time point, reducing the potential temporal mismatch between
the two datasets. Further, the strongest loadings in these two forest
types was vertical structural complexity, rather than canopy cover. This
could indicate that in deciduous forests, additional leaf density at
multiple layers is more important for productivity than canopy cover.

BEC zones dominated by coniferous forests tended to have higher amounts
of variance explained by the structural attributes. This appears to be
contrary to the observation that mixed-wood and broadleaf forests have
much higher amounts of variation explained, and an analysis consisting
solely of coniferous pixels has relatively low amounts of variance
explained (). This could be due to the large range in ecosystem
variation across the province in coniferous forests. Running a similar
analysis across each forest type and each BEC zone could increase the
amount of explained variation, as the structural datasets would likely
have less internal variation.

Finally, we explored the amount of variation explained by primary vs
modelled attributes, as well as their overlap (). We generally found
that the overlap between the primary and modelled attributes explained
most of the variation, with some exceptions, indicating that using
either set of forest structural attributes is suitable when monitoring
biodiversity.

Recent advances in creating synthetic yearly observations have allowed
the DHIs to be generated at a Landsat scale (30 m), rather than the
previously used 1 km DHIs derived from MODIS [@radeloff2019;
@razenkova2022]. This allows these datasets to be matched and analyzed
with other datasets generated from the Landsat archive. This represents
a significant advancement when assessing the utility of EBVs, as the 30
m scale is well suited to examine a range of ecological applications,
including forest structure and productivity [@cohen2004].

In conclusion, we used redundancy analysis and variation partitioning to
assess the complimentarity of two potential EBV datasets - forest
structure and the DHIs. We also separated the forest structure datasets
into primary and modelled attributes in order to assess the need to
develop more complex structural attributes, or if base data derived
directly from lidar datasets was suitable. We found that the structural
attributes are not strongly related to the DHIs, indicating that they
are suitable to be used together as ecosystem scale EBVs when monitoring
forest environments. We also found that variation explained by the
overlap between primary and modelled attributes was often higher than
the variation explained by either individually.

Further research could assess the importance on intra-annual
productivity vs the single time point of forest structure, which does
not strongly change throughout the year (barring large disturbances).

While RDA is common in the ecological literature, this analysis
represents one of the first times this technique has been applied to
assess the complimentary of proposed EBVs.

\newpage

# References {.unnumbered}
