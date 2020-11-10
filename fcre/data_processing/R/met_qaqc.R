met_qaqc <- function(realtime_file,
                     qaqc_file,
                     cleaned_met_file_dir,
                     input_file_tz,
                     local_tzone,
                     nldas = NULL){

  if(!is.na(qaqc_file)){
    d1 <- readr::read_csv(realtime_file,
                          col_names = c("TIMESTAMP","RECORD","BattV","PTemp_C","PAR_Den_Avg","PAR_Tot_Tot","BP_kPa_Avg","AirTC_Avg","RH","Rain_mm_Tot","WS_ms_Avg","WindDir","SR01Up_Avg","SR01Dn_Avg","IR01UpCo_Avg","IR01DnCo_Avg","NR01TK_Avg","Albedo_Avg"),
                          col_types = list(
                            TIMESTAMP = readr::col_datetime(format = ""),
                            RECORD = readr::col_integer(),
                            BattV = readr::col_double(),
                            PTemp_C = readr::col_double(),
                            PAR_Den_Avg = readr::col_double(),
                            PAR_Tot_Tot = readr::col_double(),
                            BP_kPa_Avg = readr::col_double(),
                            AirTC_Avg = readr::col_double(),
                            RH = readr::col_double(),
                            Rain_mm_Tot = readr::col_double(),
                            WS_ms_Avg = readr::col_double(),
                            WindDir = readr::col_double(),
                            SR01Up_Avg = readr::col_double(),
                            SR01Dn_Avg = readr::col_double(),
                            IR01UpCo_Avg = readr::col_double(),
                            IR01DnCo_Avg = readr::col_double(),
                            NR01TK_Avg = readr::col_double(),
                            Albedo_Avg = readr::col_double())) %>%
      dplyr::slice(-c(1,2,3,4))

    #d1 <- d1[-85572, ]

    TIMESTAMP_in <- lubridate::force_tz(d1$TIMESTAMP, tzone = input_file_tz)

    d1$TIMESTAMP <- lubridate::with_tz(TIMESTAMP_in,tz = local_tzone)

    d2 <- readr::read_csv(qaqc_file,
                          col_types = list(Reservoir = readr::col_character(),
                                           Site  = readr::col_character(),
                                           DateTime = readr::col_datetime(format = ""),
                                           Record = readr::col_integer(),
                                           CR3000_Batt_V = readr::col_double(),
                                           CR3000Panel_temp_C  = readr::col_double(),
                                           PAR_Average_umol_s_m2  = readr::col_double(),
                                           PAR_Total_mmol_m2  = readr::col_double(),
                                           BP_Average_kPa  = readr::col_double(),
                                           AirTemp_Average_C  = readr::col_double(),
                                           RH_percent  = readr::col_double(),
                                           Rain_Total_mm  = readr::col_double(),
                                           WindSpeed_Average_m_s  = readr::col_double(),
                                           WindDir_degrees  = readr::col_double(),
                                           ShortwaveRadiationUp_Average_W_m2  = readr::col_double(),
                                           ShortwaveRadiationDown_Average_W_m2  = readr::col_double(),
                                           InfaredRadiationUp_Average_W_m2  = readr::col_double(),
                                           InfaredRadiationDown_Average_W_m2  = readr::col_double(),
                                           Albedo_Average_W_m2  = readr::col_double(),
                                           Flag_PAR_Average_umol_s_m2 = readr::col_integer(),
                                           Note_PAR_Average_umol_s_m2  = readr::col_character(),
                                           Flag_PAR_Total_mmol_m2 = readr::col_integer(),
                                           Note_PAR_Total_mmol_m2  = readr::col_character(),
                                           Flag_BP_Average_kPa = readr::col_integer(),
                                           Note_BP_Average_kPa  = readr::col_character(),
                                           Flag_AirTemp_Average_C = readr::col_integer(),
                                           Note_AirTemp_Average_C  = readr::col_character(),
                                           Flag_RH_percent = readr::col_integer(),
                                           Note_RH_percent  = readr::col_character(),
                                           Flag_Rain_Total_mm = readr::col_integer(),
                                           Note_Rain_Total_mm  = readr::col_character(),
                                           Flag_WindSpeed_Average_m_s = readr::col_integer(),
                                           Note_WindSpeed_Average_m_s  = readr::col_character(),
                                           Flag_WindDir_degrees = readr::col_integer(),
                                           Note_WindDir_degrees  = readr::col_character(),
                                           Flag_ShortwaveRadiationUp_Average_W_m2 = readr::col_integer(),
                                           Note_ShortwaveRadiationUp_Average_W_m2  = readr::col_character(),
                                           Flag_ShortwaveRadiationDown_Average_W_m2 = readr::col_integer(),
                                           Note_ShortwaveRadiationDown_Average_W_m2  = readr::col_character(),
                                           Flag_InfaredRadiationUp_Average_W_m2 = readr::col_integer(),
                                           Note_InfaredRadiationUp_Average_W_m2  = readr::col_character(),
                                           Flag_InfaredRadiationDown_Average_W_m2 = readr::col_integer(),
                                           Note_InfaredRadiationDown_Average_W_m2  = readr::col_character(),
                                           Flag_Albedo_Average_W_m2 = readr::col_integer(),
                                           Note_Albedo_Average_W_m2  = readr::col_character()))


    TIMESTAMP_in <- lubridate::force_tz(d2$DateTime, tzone = input_file_tz)

    d2$TIMESTAMP <- lubridate::with_tz(TIMESTAMP_in,tz = local_tzone)

    #d3 <- read.csv( fname[3])
    #TIMESTAMP_in <- as.POSIXct(d3$time,
    #                           format= "%Y-%m-%d %H:%M",
    #                           tz = input_file_tz)


    #d3$TIMESTAMP <- with_tz(TIMESTAMP_in,tz = local_tzone)

    d1 <- data.frame(time = d1$TIMESTAMP, ShortWave = d1$SR01Up_Avg, LongWave = d1$IR01UpCo_Avg, AirTemp = d1$AirTC_Avg, RelHum = d1$RH, WindSpeed = d1$WS_ms_Avg, Rain = d1$Rain_mm_Tot, pressure = d1$BP_kPa_Avg)
    d2 <- data.frame(time = d2$TIMESTAMP, ShortWave = d2$ShortwaveRadiationUp_Average_W_m2, LongWave = d2$InfaredRadiationUp_Average_W_m2, AirTemp = d2$AirTemp_Average_C, RelHum = d2$RH_percent, WindSpeed = d2$WindSpeed_Average_m_s, Rain = d2$Rain_Total_mm, pressure = d2$BP_Average_kPa)

    d1 <- d1[which(d1$time > d2$time[nrow(d2)] | d1$time < d2$time[1]), ]

    #d3 <- d3[which(d3$TIMESTAMP < d2$TIMESTAMP[1])]

    d <- rbind(d2, d1)

  }else{

    d1 <- readr::read_csv(realtime_file,
                          col_names = c("TIMESTAMP","RECORD","BattV","PTemp_C","PAR_Den_Avg","PAR_Tot_Tot","BP_kPa_Avg","AirTC_Avg","RH","Rain_mm_Tot","WS_ms_Avg","WindDir","SR01Up_Avg","SR01Dn_Avg","IR01UpCo_Avg","IR01DnCo_Avg","NR01TK_Avg","Albedo_Avg"),
                          col_types = list(
                            TIMESTAMP = readr::col_datetime(format = ""),
                            RECORD = readr::col_integer(),
                            BattV = readr::col_double(),
                            PTemp_C = readr::col_double(),
                            PAR_Den_Avg = readr::col_double(),
                            PAR_Tot_Tot = readr::col_double(),
                            BP_kPa_Avg = readr::col_double(),
                            AirTC_Avg = readr::col_double(),
                            RH = readr::col_double(),
                            Rain_mm_Tot = readr::col_double(),
                            WS_ms_Avg = readr::col_double(),
                            WindDir = readr::col_double(),
                            SR01Up_Avg = readr::col_double(),
                            SR01Dn_Avg = readr::col_double(),
                            IR01UpCo_Avg = readr::col_double(),
                            IR01DnCo_Avg = readr::col_double(),
                            NR01TK_Avg = readr::col_double(),
                            Albedo_Avg = readr::col_double())) %>%
      dplyr::slice(-c(1,2,3,4))

    #d1 <- d1[-85572, ]

    TIMESTAMP_in <- as.POSIXct(d1$TIMESTAMP,
                               format= "%Y-%m-%d %H:%M",
                               tz = input_file_tz)

    d1$TIMESTAMP <- with_tz(TIMESTAMP_in,tz = local_tzone)

    d <- data.frame(time = d1$TIMESTAMP, ShortWave = d1$SR01Up_Avg, LongWave = d1$IR01UpCo_Avg, AirTemp = d1$AirTC_Avg, RelHum = d1$RH, WindSpeed = d1$WS_ms_Avg, Rain = d1$Rain_mm_Tot, pressure = d1$BP_kPa_Avg)
  }


  wshgt <- 3
  roughlength <- 0.000114
  d$WindSpeed <- d$WindSpeed * log(10.00 / 0.000114) / log(wshgt / 0.000114)

  maxTempC = 41 # an upper bound of realistic temperature for the study site in deg C
  minTempC = -24 # an lower bound of realistic temperature for the study site in deg C

  d <- d %>%
    dplyr::mutate(ShortWave = ifelse(ShortWave < 0, 0, ShortWave),
                  RelHum = ifelse(RelHum < 0, 0, RelHum),
                  RelHum = ifelse(RelHum > 100, 100, RelHum),
                  AirTemp = ifelse(AirTemp> maxTempC, NA, AirTemp),
                  AirTemp = ifelse(AirTemp < minTempC, NA, AirTemp),
                  LongWave = ifelse(LongWave < 0, NA, LongWave),
                  WindSpeed = ifelse(WindSpeed < 0, 0, WindSpeed)) %>%
    filter(is.na(time) == FALSE)

  d <- d %>%
    mutate(day = lubridate::day(time),
           year = lubridate::year(time),
           hour = lubridate::hour(time),
           month = lubridate::month(time)) %>%
    group_by(day, year, hour, month) %>%
    summarize(ShortWave = mean(ShortWave, na.rm = TRUE),
              LongWave = mean(LongWave, na.rm = TRUE),
              AirTemp = mean(AirTemp, na.rm = TRUE),
              RelHum = mean(RelHum, na.rm = TRUE),
              WindSpeed = mean(WindSpeed, na.rm = TRUE),
              pressure = mean(pressure, na.rm = TRUE),
              Rain = sum(Rain), .groups = "drop") %>%
    mutate(day = as.numeric(day),
           hour = as.numeric(hour)) %>%
    mutate(day = ifelse(as.numeric(day) < 10, paste0("0",day),day),
           hour = ifelse(as.numeric(hour) < 10, paste0("0",hour),hour)) %>%
    mutate(time = lubridate::as_datetime(paste0(year,"-",month,"-",day," ",hour,":00:00"),tz = local_tzone)) %>%
    dplyr::select(time,ShortWave,LongWave,AirTemp,RelHum,WindSpeed,Rain,pressure) %>%
    arrange(time)

  d <- d %>%
    rename(surface_downwelling_shortwave_flux_in_air = ShortWave,
           surface_downwelling_longwave_flux_in_air = LongWave,
           air_temperature = AirTemp,
           relative_humidity = RelHum,
           wind_speed = WindSpeed,
           precipitation_flux = Rain,
           air_pressure = pressure)

  d <- d %>%
    mutate(air_temperature = air_temperature + 273.15,
           relative_humidity = relative_humidity / 100)


  #Note that mm hr-1 is the same as kg m2 hr-1. Converting to kg m2 s-1
  d$precipitation_flux <- d$precipitation_flux / (60 * 60)

  d$air_pressure <- d$air_pressure * 1000

  d$specific_humidity <-  noaaGEFSpoint:::rh2qair(rh = d$relative_humidity,
                                                  T = d$air_temperature,
                                                  press = d$air_pressure)

  d <- d %>%
    select(time, air_temperature, air_pressure, relative_humidity, surface_downwelling_longwave_flux_in_air, surface_downwelling_shortwave_flux_in_air, precipitation_flux, specific_humidity, wind_speed)

  cf_var_names1 <- c("air_temperature", "air_pressure", "relative_humidity", "surface_downwelling_longwave_flux_in_air",
                     "surface_downwelling_shortwave_flux_in_air", "precipitation_flux","specific_humidity","wind_speed")

  cf_var_units1 <- c("K", "Pa", "1", "Wm-2", "Wm-2", "kgm-2s-1", "1", "ms-1")  #Negative numbers indicate negative exponents

  d$time <- lubridate::with_tz(d$time, tzone = "UTC")

  d <- d %>%
    tidyr::drop_na()

  if(!is.null(nldas)){

    print("Gap filling with NLDAS")
    d_nldas <- readr::read_csv(nldas, col_type = readr::cols())

    d_nldas <- d_nldas %>%
      rename(air_temperature = AirTemp,
             surface_downwelling_shortwave_flux_in_air = ShortWave,
             surface_downwelling_longwave_flux_in_air = LongWave,
             relative_humidity = RelHum,
             wind_speed = WindSpeed,
             precipitation_flux = Rain) %>%
      mutate(air_pressure = NA,
             specific_humidity = NA,
             air_temperature = air_temperature + 273.15,
             relative_humidity = relative_humidity/ 100,
             precipitation_flux = precipitation_flux * 1000 / (60 * 60 * 24)) %>%
      select(all_of(names(d)))

    d_nldas$time <- lubridate::with_tz(d_nldas$time, tzone = "UTC")

    d_nldas <- d_nldas %>%
      filter(time >= min(d$time), time <= max(d$time))

    d_nldas_gaps <- d_nldas %>%
      filter(!(time %in% d$time))

    d_full <- rbind(d, d_nldas_gaps) %>%
      arrange(time)

  }else{

    t <- seq(min(d$time), max(d$time), by = "1 hour")
    cont_time <- tibble(time = t)

    d_full <- dplyr::left_join(cont_time, d, by = "time")

    d_full <- d_full %>%
      mutate(air_temperature = imputeTS::na_interpolation(air_temperature, option = "linear"),
             air_pressure = imputeTS::na_interpolation(air_pressure, option = "linear"),
             relative_humidity = imputeTS::na_interpolation(relative_humidity, option = "linear"),
             surface_downwelling_longwave_flux_in_air = imputeTS::na_interpolation(surface_downwelling_longwave_flux_in_air, option = "linear"),
             surface_downwelling_shortwave_flux_in_air = imputeTS::na_interpolation(surface_downwelling_shortwave_flux_in_air, option = "linear"),
             precipitation_flux = imputeTS::na_interpolation(precipitation_flux, option = "linear"),
             specific_humidity = imputeTS::na_interpolation(specific_humidity, option = "linear"),
             wind_speed = imputeTS::na_interpolation(wind_speed, option = "linear"))
  }

  model_name <- "observed-met"
  site <- "fcre"
  lat <- 37.27
  lon <- 360-79.9
  start_time <- dplyr::first((d$time))
  end_time <- dplyr::last((d$time))
  cf_units <- cf_var_units1

  identifier <- paste(model_name, site,sep="_")

  fname <- paste0(identifier,".nc")

  output_file <- file.path(cleaned_met_file_dir, fname)

  start_time <- min(d$time)
  end_time <- max(d$time)

  data <- d_full %>%
    dplyr::select(-time)

  diff_time <- as.numeric(difftime(d_full$time, d_full$time[1], units = "hours"))

  cf_var_names <- names(data)

  time_dim <- ncdf4::ncdim_def(name="time",
                               units = paste("hours since", format(start_time, "%Y-%m-%d %H:%M")),
                               diff_time, #GEFS forecast starts 6 hours from start time
                               create_dimvar = TRUE)
  lat_dim <- ncdf4::ncdim_def("latitude", "degree_north", lat, create_dimvar = TRUE)
  lon_dim <- ncdf4::ncdim_def("longitude", "degree_east", lon, create_dimvar = TRUE)

  dimensions_list <- list(time_dim, lat_dim, lon_dim)

  nc_var_list <- list()
  for (i in 1:length(cf_var_names)) { #Each ensemble member will have data on each variable stored in their respective file.
    nc_var_list[[i]] <- ncdf4::ncvar_def(cf_var_names[i], cf_units[i], dimensions_list, missval=NaN)
  }

  nc_flptr <- ncdf4::nc_create(output_file, nc_var_list, verbose = FALSE, )

  #For each variable associated with that ensemble
  for (j in 1:ncol(data)) {
    # "j" is the variable number.  "i" is the ensemble number. Remember that each row represents an ensemble
    ncdf4::ncvar_put(nc_flptr, nc_var_list[[j]], unlist(data[,j]))
  }

  ncdf4::nc_close(nc_flptr)  #Write to the disk/storage

}
