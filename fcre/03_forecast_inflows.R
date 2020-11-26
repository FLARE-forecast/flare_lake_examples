config <- yaml::read_yaml(file.path(forecast_location, "configuration_files","configure_flare.yml"))
run_config <- yaml::read_yaml(file.path(forecast_location, "configuration_files","run_configuration.yml"))

config$run_config <- run_config
config$run_config$forecast_location <- forecast_location
config$data_location <- data_location
config$qaqc_data_location <- qaqc_data_location

# Set up timings
start_datetime_local <- lubridate::as_datetime(paste0(config$run_config$start_day_local," ",config$run_config$start_time_local), tz = config$local_tzone)
if(is.na(config$run_config$forecast_start_day_local)){
  end_datetime_local <- lubridate::as_datetime(paste0(config$run_config$end_day_local," ",config$run_config$start_time_local), tz = config$local_tzone)
  forecast_start_datetime_local <- end_datetime_local
}else{
  forecast_start_datetime_local <- lubridate::as_datetime(paste0(config$run_config$forecast_start_day_local," ",config$run_config$start_time_local), tz = config$local_tzone)
  end_datetime_local <- forecast_start_datetime_local + lubridate::days(config$run_config$forecast_horizon)
}

#Weather Drivers
start_datetime_UTC <-  lubridate::with_tz(start_datetime_local, tzone = "UTC")
end_datetime_UTC <-  lubridate::with_tz(end_datetime_local, tzone = "UTC")
forecast_start_datetime_UTC <- lubridate::with_tz(forecast_start_datetime_local, tzone = "UTC")
forecast_hour <- lubridate::hour(forecast_start_datetime_UTC)
if(forecast_hour < 10){forecast_hour <- paste0("0",forecast_hour)}
noaa_forecast_path <- file.path(config$data_location, config$forecast_met_model,config$lake_name_code,lubridate::as_date(forecast_start_datetime_UTC),forecast_hour)

message("Forecasting inflow and outflows")
source(paste0(lake_directory, "/inflow_outflows/forecast_inflow_outflows.R"))
# Forecast Inflows

forecast_files <- list.files(noaa_forecast_path, full.names = TRUE)
forecast_inflows_outflows(inflow_obs = file.path(config$qaqc_data_location, "/inflow_postQAQC.csv"),
                          forecast_files = forecast_files,
                          obs_met_file = file.path(config$qaqc_data_location,"observed-met_fcre.nc"),
                          output_dir = config$data_location,
                          inflow_model = config$forecast_inflow_model,
                          inflow_process_uncertainty = FALSE,
                          forecast_location = config$run_config$forecast_location)
