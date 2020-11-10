in_situ_qaqc <- function(insitu_obs_fname,
                         data_location,
                         maintenance_file,
                         ctd_fname,
                         nutrients_fname,
                         secchi_fname,
                         cleaned_observations_file_long,
                         lake_name_code,
                         config){

  print("QAQC Catwalk")

  d <- temp_oxy_chla_qaqc(realtime_file = insitu_obs_fname[1],
                          qaqc_file = insitu_obs_fname[2],
                          maintenance_file = maintenance_file,
                          input_file_tz = "EST",
                          focal_depths,
                          local_tzone = config$local_tzone,
                          config = config)

  if(exists("ctd_fname")){
    if(!is.na(ctd_fname)){
      print("QAQC CTD")
      d_ctd <- extract_CTD(fname = ctd_fname,
                           input_file_tz = "EST",
                           local_tzone = config$local_tzone,
                           focal_depths = config$focal_depths,
                           config = config)
      d <- rbind(d,d_ctd)
    }
  }


  if(exists("nutrients_fname")){
    if(!is.na(nutrients_fname)){
      print("QAQC Nutrients")
      d_nutrients <- extract_nutrients(fname = nutrients_fname,
                                       input_file_tz = "EST",
                                       local_tzone = config$local_tzone,
                                       focal_depths = config$focal_depths)
      d <- rbind(d,d_nutrients)
    }
  }


  if(exists("ch4_fname")){
    if(!is.na(ch4_fname)){
      print("QAQC CH4")
      d_ch4 <- extract_ch4(fname = ch4_fname,
                           input_file_tz = "EST",
                           local_tzone  = config$local_tzone,
                           focal_depths = config$focal_depths)
      d <- rbind(d,d_ch4)
    }
  }


  first_day <- lubridate::as_datetime(paste0(lubridate::as_date(min(d$timestamp)), " ", config$averaging_period_starting_hour))
  first_day <- lubridate::force_tz(first_day, tzone = config$local_tzone)

  last_day <- lubridate::as_datetime(paste0(lubridate::as_date(max(d$timestamp)), " ", config$averaging_period_starting_hour))
  last_day <- lubridate::force_tz(last_day, tzone = config$local_tzone)

  full_time_local <- seq(first_day, last_day, by = "1 day")

  d_clean <- NULL


  for(i in 1:length(config$target_variable)){
    print(paste0("Extracting ",config$target_variable[i]))
    #depth_breaks <- sort(c(bins1, bins2))
    time_breaks <- seq(first_day, last_day, by = config$averaging_period[i])

    d_curr <- d %>%
      dplyr::filter(variable == config$target_variable[i],
                    method %in% config$measurement_methods[[i]]) %>%
      dplyr::mutate(time_class = cut(timestamp, breaks = time_breaks, labels = FALSE)) %>%
      dplyr::group_by(time_class, depth) %>%
      dplyr::summarize(value = mean(value, na.rm = TRUE), .groups = "drop") %>%
      dplyr::mutate(datetime = time_breaks[time_class]) %>%
      dplyr::mutate(variable = config$target_variable[i]) %>%
      dplyr::select(datetime, depth, variable, value) %>%
      dplyr::mutate(date = lubridate::as_date(datetime))

    if(config$averaging_period[i] == "1 hour"){
      d_curr <- d_curr %>%
      dplyr::mutate(hour = lubridate::hour(datetime)) %>%
      dplyr::filter(hour == lubridate::hour(first_day))
    }else{
      d_curr <- d_curr %>%
        dplyr::mutate(hour = NA)
    }

    d_curr <- d_curr %>% dplyr::select(-datetime)

    d_clean <- rbind(d_clean,  d_curr)
  }

  d_clean <- d_clean %>% tidyr::drop_na(value)

  if(!is.na(config$secchi_fname)){

    d_secchi <- extract_secchi(fname = file.path(config$data_location, config$secchi_fname),
                               input_file_tz = "EST",
                               local_tzone  = config$local_tzone,
                               focal_depths = config$focal_depths)

    d_secchi <- d_secchi %>%
      dplyr::mutate(date = lubridate::as_date(timestamp)) %>%
      dplyr::mutate(hour = NA) %>%
      dplyr::select(-timestamp)

    d_clean <- rbind(d_clean,d_secchi)
  }

  d_clean <- d_clean %>% select(date, hour, depth, value, variable)

  readr::write_csv(d_clean, cleaned_observations_file_long)

  #rm(d_clean, d, d_secchi, d_ch4, d_nutrients, d_ctd)
  #gc()
}
