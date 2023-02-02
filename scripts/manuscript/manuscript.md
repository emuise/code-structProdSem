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
  - name: Margaret E. Andrew
    email: M.Andrew@murdoch.edu.au
    affiliations: 
        - id: murd
          name: Murdoch University
          department: Environmental and Conservation Sciences and Harry Butler Institute
          city: Murdoch, WA, Australia
          postal-code: 6150
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
  This is the abstract. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum augue turpis, dictum non malesuada a, volutpat eget velit. Nam placerat turpis purus, eu tristique ex tincidunt et. Mauris sed augue eget turpis ultrices tincidunt. Sed et mi in leo porta egestas. Aliquam non laoreet velit. Nunc quis ex vitae eros aliquet auctor nec ac libero. Duis laoreet sapien eu mi luctus, in bibendum leo molestie. Sed hendrerit diam diam, ac dapibus nisl volutpat vitae. Aliquam bibendum varius libero, eu efficitur justo rutrum at. Sed at tempus elit.
keywords: 
  - structural equation modelling
  - remote sensing
  - landsat
  - forest structure
  - forest productivity
date: last-modified
bibliography: bibliography.bib
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
---



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
another [@skidmore2021].

There are six EBV classes, each corresponding to a different facet of
biodiversity, including, genetic composition, species populations,
species traits, community composition, ecosystem structure, and
ecosystem function [@pereira2013]. @fernández2020 divides the six
classes into two approaches, with one focusing on species biodiversity,
and the other focusing on ecosystem diversity. Remote sensing has proven
to be capable of measure five of the six classes, with the exception
being genetic composition, which requires in-situ observation and
samples [@skidmore2021]. Notably, while remote sensing can provide
information on the remaining two species EBV classes, this information
is typically acquired with an *ad-hoc* approach. This collects high
resolution, small spatial extent information, rather than the global or
regional scales required for biodiversity assessment. Community
composition falls into a similar dilemma, requiring species population
information which necessitates high resolution spatial data.

The remaining two classes, ecosystem structure and function, are
incredibly well suited to be examined at global or regional scales using
mid-resolution satellite imagery, such as that provided by the Landsat
series of satellites. Advances in satellite remote sensing processing
have allowed 3d forest structure data to be imputed across wide spatial
scales [@matasci2018; @coops2021] using data fusion approaches involving
collected lidar data and optical/radar data. Other advances in image
compositing have allowed yearly summaries of vegetation productivity to
be calculated at regional to global scales, summarizing the yearly
energy totals, minimums, and variations [@radeloff2019]. These datasets
correspond quite well with the EBV classes ecosystem structure (forest
structural diversity metrics), and ecosystem function (forest
productivity metrics).

Forest structural diversity has been linked to biodiversity at various
scales [@guo2017; @bergen2009; @gao2014]. Increased structural
complexity is hypothesized to create additional niches, leading to
increased species diversity [@bergen2009]. The relationship between
forest structure and biodiversity is commonly assessed using avian
species diversity metrics [@macarthur1961; @goetz2007], however, other
clades (and habitats), have been used [@davies2014; @nelson2005]. Many
metrics derived from lidar remote sensing have been used as local
indicators of biodiversity, including canopy cover, canopy height,
vertical profiles, and aboveground biomass, while other 2nd order
derived metrics such as canopy texture, height class distribution,
edges, and patch metrics have been used to examine habitat and
biodiversity at landscape scales [@bergen2009].

The dynamic habitat indices (DHIs) are indicators of productivity
calculated by summarizing vegetation indices over the course of one (or
multiple) years [@radeloff2019]. These indices have been related to
multiple facets of biodiversity at a range of scales, including species
occurrence and abundance [@razenkova2020], alpha [@radeloff2019] and
beta diversity [@andrew2012]. Hypotheses behind the biodiversity
productivity relationships have been established, including the
species-energy hypothesis, the environmental stress hypothesis, and the
environmental stability hypothesis [@coops2019]. The cumulative DHI
calculates the total amount of energy available in a given pixel over
the course of a year. Cumulative DHI is strongly linked to the available
energy hypothesis, which suggests that with greater available energy
species richness will increase [@wright1983]. The minimum DHI, which
calculates the lowest productivity over the course of a year can be
matched to the environmental stress hypothesis, which proposes that
higher levels of minimum available energy will lead to higher species
richness [@currie2004]. Finally, the variation DHI, which calculates the
coefficient of variance in a vegetation index through the course of a
year, corresponds to the environmental stability hypothesis which states
that lower energy variation throughout a year will lead to increased
species richness [@williams2008].

Linkages between forest structure and productivity (namely, vegetation
indices) have been examined for nearly 20 years [@huete2002,
@knyazikhin1998; @myneni1994]. While there is significant theoretical
and empirical evidence for their relationship at single time points
(within a single image) [@myneni1994], various relationship directions
and shapes have been found between forest structure and productivity
metrics [@ali2019]. These relationships, their shapes, and their
strengths have been attributed to multiple possible hypotheses and can
vary based on environmental conditions [@ali2019]. The relationship
between forest structural diversity metrics and annual productivity
summaries has yet to be fully examined, including the DHIs.

Some vegetation structure metrics are simpler, and more accurate, to
calculate than others [@coops2021]. These basic metrics, such as canopy
height and canopy cover,can then be used to estimate additional
structure metrics, such as basal area or total biomass. Canopy height
and cover are commonly used as an indicator of vertical and horizontal
variation, respectively. Recently, more attention has been paid to
internal structural complexity metrics, which can be more difficult and
time consuming to generate [@coops2021; @ma2022] .

In this study, we seek to untangle the relationship between two EBVs:
forest structure diversity metrics and yearly summaries of forest
productivity. To accomplish this, we assess this relationship using path
analysis to assess the direct and indirect (as mediated by more complex
forest structural diversity metrics) effects of commonly collected
forest structural metrics (canopy height and canopy cover) on yearly
productivity summaries. Doing so will in turn assess their utility as
complementary EBVs. We ran this analysis separately across four forested
land covers and the forested ecosystems of British Columbia, Canada.

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
topography.

## Data

## Sampling

## Analysis

# Results

# Discussion

# Conclusion

\newpage

# References {.unnumbered}
