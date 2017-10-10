# motus
R package to fetch telemetry data from http://motus.org

Core client for the `motus` package; most users should use the motus R package provided by motus.org,
which uses `motusClient` to fetch data.

## Installation ##
```R
    install.packages("devtools")              ## if you haven't already done this
    library(devtools)
    install_github("jbrzusto/motusClient")
```
## Usage vignette ##

A brief sketch is [here](https://github.com/jbrzusto/motusClient/blob/master/inst/doc/motusClient_R_package_usage.md)

## What's working so far:

### 2017 Oct 10

- tagme(): now downloads hourly pulse counts when updating a receiver database

### 2017 Oct 6

- tagme(): for tag project databases, this now also downloads any
ambiguous detections which *could* belong to the project.  These
have negative synthetic motus tagIDs which are mapped to real motus tag IDs
via the `tagAmbig` table.  Functions for users to deal with ambiguous detections are pending.

### 2017 Jul 28

- tagme() - for updating local copies of receiver or tag project detection databases
- tellme() - for asking how much data will need to be transferred by the corresponding tagme() call

The latest version of the data server that works with this package is
now running on a new box, but its database is only populated with data
from 4 (!) receivers.  Raw files from other receivers will be re-run with
the latest version of the tag finder and added to this database.  Only
those users willing to wrestle with alpha code and not actually interested
in getting their data should be using this package for now.

### 2017 Jun 10

- srvTagsForAmbiguities()
- srvMetadataForReceivers()

### 2017 Jun 8

- srvGPSforTagProject()
- srvMetadataForTags()

### 2017 Jun 6

- srvRunsForReceiverProject()
- srvHitsForTagProject()
- srvHitsForReceiverProject()
- srvGPSforReceiverProject()

### 2017 May 31

- srvRunsForTagProject()
- srvBatchesForTagProject()
- srvBatchesForReceiverProject()

### 2017 May 19

- authentication against local data server

### 2017 Feb 7

- some R functions for post-processing

### 2016 Dec 1
- nothing (yes, nothing is working; in fact, nothing is working beautifully)
