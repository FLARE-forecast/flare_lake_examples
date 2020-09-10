config <- yaml::read_yaml(file.path(lake_directory,"data_processing","observation_processing.yml"))

config$data_location <- data_location
config$qaqc_data_location <- qaqc_data_location
#config$obs_config <- readr::read_csv(file.path(run_config$forecast_location, config$obs_config_file), col_types = readr::cols())

library(tidyverse)
library(lubridate)

source(file.path(lake_directory, "data_processing/R/extract_CTD.R"))
source(file.path(lake_directory, "data_processing/R/extract_nutrients.R"))
source(file.path(lake_directory, "data_processing/R/temp_oxy_chla_qaqc.R"))
source(file.path(lake_directory, "data_processing/R/extract_ch4.R"))
source(file.path(lake_directory, "data_processing/R/extract_secchi.R"))
source(file.path(lake_directory, "data_processing/R/in_situ_qaqc.R"))
source(file.path(lake_directory, "data_processing/R/met_qaqc.R"))
source(file.path(lake_directory, "data_processing/R/inflow_qaqc.R"))

if(is.null(config$met_file)){
  met_qaqc(realtime_file = file.path(config$data_location, config$met_raw_obs_fname[1]),
           qaqc_file = file.path(config$data_location, config$met_raw_obs_fname[2]),
           cleaned_met_file_dir = config$qaqc_data_location,
           input_file_tz = "EST",
           local_tzone = config$local_tzone,
           nldas = file.path(config$data_location, config$nldas))
}else{
  file.copy(file.path(config$data_location,config$met_file), cleaned_met_file, overwrite = TRUE)
}

cleaned_inflow_file <- paste0(config$qaqc_data_location, "/inflow_postQAQC.csv")

if(is.null(config$inflow1_file)){
  inflow_qaqc(realtime_file = file.path(config$data_location, config$inflow_raw_file1[1]),
              qaqc_file = file.path(config$data_location, config$inflow_raw_file1[2]),
              nutrients_file = file.path(config$data_location, config$nutrients_fname),
              cleaned_inflow_file ,
              config$local_tzone,
              input_file_tz = 'EST')
}else{
  file.copy(file.path(config$data_location,config$inflow1_file), cleaned_inflow_file, overwrite = TRUE)
}


cleaned_observations_file_long <- paste0(config$qaqc_data_location,
                                         "/observations_postQAQC_long.csv")
if(is.null(config$combined_obs_file)){
  in_situ_qaqc(insitu_obs_fname = file.path(config$data_location,config$insitu_obs_fname),
               data_location = config$data_location,
               maintenance_file = file.path(config$data_location,config$maintenance_file),
               ctd_fname = file.path(config$data_location,config$ctd_fname),
               nutrients_fname =  file.path(config$data_location, config$nutrients_fname),
               secchi_fname = file.path(config$data_location, config$secchi_fname),
               cleaned_observations_file_long = cleaned_observations_file_long,
               lake_name_code = config$lake_name_code,
               config = config)
}else{
  file.copy(file.path(config$data_location,config$combined_obs_file), cleaned_observations_file_long, overwrite = TRUE)
}

file.copy(file.path(config$data_location,config$sss_fname), file.path(config$qaqc_data_location,basename(config$sss_fname)))

if(!is.null(config$specified_sss_inflow_file)){
  file.copy(file.path(config$data_location,config$specified_sss_inflow_file), file.path(config$qaqc_data_location,basename(config$specified_sss_inflow_file)))
}
if(!is.null(config$specified_sss_outflow_file)){
  file.copy(file.path(config$data_location,config$specified_sss_outflow_file), file.path(config$qaqc_data_location,basename(config$specified_sss_outflow_file)))
}
if(!is.null(config$specified_metfile)){
  file.copy(file.path(config$data_location,config$specified_metfile), file.path(config$qaqc_data_location,basename(config$specified_metfile)))
}

if(!is.null(config$specified_inflow1)){
  file.copy(file.path(config$data_location,config$specified_inflow1), file.path(config$qaqc_data_location,basename(config$specified_inflow1)))
}

if(!is.null(config$specified_inflow2)){
  file.copy(file.path(config$data_location,config$specified_inflow2), file.path(config$qaqc_data_location,basename(config$specified_inflow2)))
}

if(!is.null(config$specified_outflow1)){
  file.copy(file.path(config$data_location,config$specified_outflow1), file.path(config$qaqc_data_location,basename(config$specified_outflow1)))
}

