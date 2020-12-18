
manager_plot <- function(file_name,
                         qaqc_location,
                         focal_depths = c(1, 5, 8)){


  png_file_name <- paste0(tools::file_path_sans_ext(file_name),"_turnover.png")

  print(qaqc_location)
  output <- flare::combine_forecast_observations(file_name,
                                                 qaqc_location,
                                                 extra_historical_days = 5)
  obs <- output$obs
  full_time_local_extended <- output$full_time_local_extended
  diagnostic_list <- output$diagnostic_list
  state_list <- output$state_list
  forecast <- output$forecast
  par_list <- output$par_list
  obs_list <- output$obs_list
  state_names <- output$state_names
  par_names <- output$par_names
  diagnostics_names <- output$diagnostics_names
  full_time_local <- output$full_time_local
  obs_long <- output$obs_long
  depths <- output$depths


  dirname(file_name)


  png(png_file_name,width = 12, height = 6,units = 'in',res=300)
  par(mfrow=c(1,2))

  #PLOT OF TURNOVER PROBABILITY
  turnover_index_1 <- 4
  turnover_index_2 <- 25

  temp <- state_list[["temp"]]


  forecast_start <- min(which(forecast == 1))
  forecast_end <- length(forecast)
  prob_zero <- rep(NA,length(seq(forecast_start,forecast_end,1)))

  if(length(which(forecast == 1)) > 0){
  for(i in forecast_start:forecast_end){
    prob_zero[i-(forecast_start - 1)] = 100*length(which(temp[i,turnover_index_1,] - temp[i,turnover_index_2,] < 1))/length((temp[i,1,]))
  }

  plot(full_time_local,rep(-99,length(full_time_local)),ylim=c(0,100),xlab = 'date',ylab = '% chance')
  title('Turnover forecast',cex.main=0.9)

  forecast_index <- max(which(forecast == 0))

  points(full_time_local[forecast_start:forecast_end],prob_zero,type='o',ylim=c(0,100), xlab = 'date',ylab = 'Probablity of turnover')
  axis(1, at=full_time_local - lubridate::hours(lubridate::hour(full_time_local[1])),las=2, cex.axis=0.7, tck=-0.01,labels=FALSE)
  abline(v = full_time_local[forecast_index])
  text(full_time_local[forecast_index] - lubridate::days(2),80,'past')
  text(full_time_local[4],80,'future')

  }
  #HISTORICAL AND FUTURE TEMPERATURE
  if(length(depths) == 10){
    depth_colors <- c("firebrick4",
                      "firebrick1",
                      "DarkOrange1",
                      "gold",
                      "greenyellow",
                      "medium sea green",
                      "sea green",
                      "DeepSkyBlue4",
                      "blue2",
                      "blue4")

  }else if(length(depths) == 19){
    depth_colors <- c("firebrick4",
                      NA,
                      "firebrick1",
                      NA,
                      "DarkOrange1",
                      NA,
                      "gold",
                      NA,
                      "greenyellow",
                      NA,
                      "medium sea green",
                      NA,
                      "sea green",
                      NA,
                      "DeepSkyBlue4",
                      NA,
                      "blue2",
                      NA,
                      "blue4")
  }else{
    depth_colors <- c("firebrick4",
                      NA,
                      NA,
                      "firebrick1",
                      NA,
                      NA,
                      "DarkOrange1",
                      NA,
                      NA,
                      "gold",
                      NA,
                      NA,
                      "greenyellow",
                      NA,
                      NA,
                      "medium sea green",
                      NA,
                      NA,
                      "sea green",
                      NA,
                      NA,
                      "DeepSkyBlue4",
                      NA,
                      NA,
                      "blue2",
                      NA,
                      NA,
                      "blue4",
                      NA)
  }


  full_time_local_plotting <-seq(full_time_local[1] - lubridate::days(5), max(full_time_local), by = "1 day")
  forecast_index <- which(full_time_local_plotting == full_time_local[which.max(forecast == 0)])

  plot(full_time_local_plotting,rep(-99,length(full_time_local_plotting)),ylim=c(-5,35),xlim = c(full_time_local_plotting[1] - lubridate::days(2), max(full_time_local_plotting)), xlab = 'date',ylab = expression(~degree~C))
  title(paste0('Water temperature forecast'),cex.main=0.9)
  tmp_day <- full_time_local[-1][1]
  axis(1, at=full_time_local - lubridate::hours(lubridate::hour(full_time_local[1])),las=2, cex.axis=0.7, tck=-0.01,labels=FALSE)
  depth_colors_index = 0
  for(i in 1:length(depths)){
    if(length(which(depths[i]  == depths)) >= 1 ){
      depth_colors_index <- i
      points(full_time_local_plotting[1:forecast_index], obs[1:forecast_index,i,1],type='l',col=depth_colors[depth_colors_index],lwd=1.5)
      index <- which(focal_depths == depths[i])
      if(length(index) == 1){
        temp_means <- rep(NA, length(full_time_local))
        temp_upper <- rep(NA, length(full_time_local))
        temp_lower <- rep(NA, length(full_time_local))
        for(k in 2:length(temp_means)){
          temp_means[k] <- mean(temp[k,i,])
          temp_lower[k] <- quantile(temp[k,i,], 0.1)
          temp_upper[k] <- quantile(temp[k,i,], 0.9)
        }

        points(full_time_local, temp_means,type='l',lty='dashed',col=depth_colors[depth_colors_index],lwd=1.5)
        points(full_time_local, temp_upper,type='l',lty='dotted',col=depth_colors[depth_colors_index],lwd=1.5)
        points(full_time_local, temp_lower,type='l',lty='dotted',col=depth_colors[depth_colors_index],lwd=1.5)
      }
    }
  }

  abline(v = full_time_local[which.max(forecast == 0)])
  text(full_time_local_plotting[forecast_index-2],30,'past')
  text(full_time_local[4],30.1,'future')

  legend("left",c("0.1m","1m", "2m", "3m", "4m", "5m", "6m", "7m","8m", "9m"),
         text.col=c("firebrick4", "firebrick1", "DarkOrange1", "gold", "greenyellow", "medium sea green", "sea green",
                    "DeepSkyBlue4", "blue2", "blue4"), cex=1, y.intersp=1, x.intersp=0.001, inset=c(0,0), xpd=T, bty='n')
  legend('topright', c('mean','confidence bounds'), lwd=1.5, lty=c('dashed','dotted'),bty='n',cex = 1)

  mtext(paste0('Falling Creek Reservoir\n',lubridate::month(tmp_day),'/',lubridate::day(tmp_day),'/',lubridate::year(tmp_day)), side = 3, line = -2, outer = TRUE, font = 2)
  dev.off()
}
