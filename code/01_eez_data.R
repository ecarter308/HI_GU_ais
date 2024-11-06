####################
### 01. EEZ data ###
####################

# clear environment
rm(list = ls())

# calculate start time of code (determine how long it takes to complete all code)
start <- Sys.time()

#####################################
#####################################

# set parameters
## designate region name
region_name <- "gum"

## coordinate reference system
### set the coordinate reference system that data should become (NAD83 UTM 19N: https://epsg.io/26919)
crs <- "EPSG:26919"

## designate date
date <- format(Sys.Date(), "%Y%m%d")

#####################################
#####################################

# load packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(renv,
               devtools,
               dplyr,
               ggplot2,
               janitor,
               mregions2,
               plyr,
               purrr,
               rmapshaper,
               sf,
               sp,
               stringr,
               targets,
               terra, # is replacing the raster package
               tidyr)

# Run once devtools is successfully installed
devtools::install_github("cfree14/marineregions", force=T)
library(marineregions)

#####################################
#####################################

# parameters
## country iso3 code
iso3 <- "GUM"

#####################################
#####################################

eez_function <- function(territory){
  # search for the location of interest and get the geometry
  eez <- mregions2::gaz_search(x = territory) %>%
    # filter for only EEZ and ones that are not deleted (***note: the status of interest is standard)
    dplyr::filter(placeType == "EEZ" & status != "deleted") %>%
    # get the geometry for the EEZ
    mregions2::gaz_geometry()
}

#####################################
#####################################

mnp_eez <-

mnp_eez <- mregions2::gaz_search(x = "Northern Mariana") %>%
  dplyr::filter(placeType == "EEZ") %>%
  mregions2::gaz_geometry()

plot(mnp_eez$the_geom)

gum_eez <- mregions2::gaz_search(x = "Guam") %>%
  dplyr::filter(placeType == "EEZ" & status != "deleted") %>%
  mregions2::gaz_geometry()

#####################################
#####################################

data <- marineregions::eezs_lr

eezs <- data %>%
  dplyr::filter(iso_ter1 %in% c("GUM", "MNP"))

plot(eezs$geometry)

# alternative
# test <- data %>%
#   dplyr::filter(stringr::str_detect(string = iso_ter1,
#                                     pattern = c("GUM|MNP")))
