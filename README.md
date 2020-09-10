# Examples and test of configurations for FLARE

## Download Data
`lake_directory <- "/Users/quinn/Dropbox/Research/SSC_forecasting/FLARE_package/flare_lake_examples/fcre/"`

`qaqc_data_location <- file.path(lake_directory, "qaqc_data")`

`data_location <- "/Users/quinn/Dropbox/Research/SSC_forecasting/SCC_data"`

`if(!dir.exists(qaqc_data_location)){
  dir.create(qaqc_data_location)
}`

`source(file.path(lake_directory, "01_download_data.R"))`

## QAQC Data

`source(file.path(lake_directory, "02_process_observations.R"))`

## Test GLM

`forecast_location <- file.path(lake_directory, "glm")`

`source(file.path(forecast_location,"03_generate_forecast.R"))`

`source(file.path(lake_directory, "04_visualize.R"))`

## Test GLM-AED oxygen only

`forecast_location <- file.path(lake_directory, "glm_aed_oxy")`

`source(file.path(forecast_location,"03_generate_forecast.R"))`

`source(file.path(lake_directory, "04_visualize.R"))`

## Test GLM-AED

`forecast_location <- file.path(lake_directory, "glm_aed")`

`source(file.path(forecast_location,"03_generate_forecast.R"))`

`source(file.path(lake_directory, "04_visualize.R"))`

## Test GLM-AED

`forecast_location <- file.path(lake_directory, "glm_aed_sss")`

`source(file.path(forecast_location,"03_generate_forecast.R"))`

`source(file.path(lake_directory, "04_visualize.R"))`

## Clean up

`unlist(qaqc_data_location)`
