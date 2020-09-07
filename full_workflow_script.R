#Container 1:  Download Data

source("/Users/quinn/Dropbox/Research/SSC_forecasting/FLARE_package/flare_fcr/01_download_data.R")

#Container 2:  QAQC Data

source("/Users/quinn/Dropbox/Research/SSC_forecasting/FLARE_package/flare_fcr/02_process_observations.R")


#Container 3:  Run forecast

source("/Users/quinn/Dropbox/Research/SSC_forecasting/FLARE_package/flare_fcr/03_generate_forecast.R")

#Container 4:  Visualize and potentially score

source("/Users/quinn/Dropbox/Research/SSC_forecasting/FLARE_package/flare_fcr/04_visualize.R")
