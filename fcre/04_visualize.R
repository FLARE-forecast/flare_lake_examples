#saved_file <- "/Users/quinn/Dropbox (VTFRS)/Research/SSC_forecasting/run_flare_package/wrr_runs_obs/wrr_runs_H_2019_03_14_2019_03_15_F_16_20201124T085027.nc"
#qaqc_data_location <- "/Users/quinn/Dropbox/Research/SSC_forecasting/FLARE_package/flare_lake_examples/fcre/qaqc_data/"

#file_name <- saved_file
flare::plotting_general(file_name = saved_file,
                        qaqc_location = qaqc_data_location)

visualization_location <- file.path(lake_directory,"visualization")
source(paste0(visualization_location,"/manager_plot.R"))

#saved_file <- "/Users/quinn/Dropbox (VTFRS)/Research/SSC_forecasting/run_flare_package/wrr_runs_obs/wrr_runs_H_2019_03_14_2019_03_15_F_16_20201124T085027.nc"
#qaqc_data_location <- "/Users/quinn/Dropbox/Research/SSC_forecasting/FLARE_package/flare_lake_examples/fcre/qaqc_data/"

manager_plot(file_name = saved_file,
             qaqc_location = qaqc_data_location,
             focal_depths = c(1, 5, 8))

