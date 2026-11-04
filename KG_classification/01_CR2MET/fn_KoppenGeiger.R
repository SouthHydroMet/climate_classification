

fn_KoppenGeiger <- function(i_cell      = 1,
                            ID          = NA,  # Variable de cada celda
                            dir_data    = NA,  # Dirección para cargar la información
                            ti          = NA,  # Fecha inicial para obtener climatología
                            tf          = NA,  # Fecha final para obtener climatología
                            file_prefix = "CR2MET_data",  # Nombre del archivo a cargar
                            var_name    = "CR2MET_data",  # Nombre de la variable que se cargará
                            col_names   = c("fecha", "pr", "tx","tn")){ # nombre de las columnas de la variable que se cargará. Deben estar en orden: fecha, pr, tx y tn){ # Nombre de la variable que se carga
  
  
  load(paste0(dir_data, "/", file_prefix, "_ID_", ID$ID[i_cell], ".RData"))
  
  ##############################################################################
  # Homologar la información para que el código funcione
  ##############################################################################
  
  x <- get(var_name)
  x <- x[col_names]
  
  colnames(x)[1] <- "fecha"
  colnames(x)[2] <- "pr"
  colnames(x)[3] <- "tx"
  colnames(x)[4] <- "tn"
  
  # Obtener temperatura media diaria
  x$tm <- (x$tx + x$tn) / 2
  
  ##############################################################################
  # Dejar solamente el periodo de interés y obtener promedios
  ##############################################################################
  
  rows    <- which(x$fecha >= ti & x$fecha <= tf)
  x       <- x[rows, ]
  x$month <- month(x$fecha)

  n_yr    <- year(tf) - year(ti) + 1
  
  clim <- group_by(.data = x, month)
  clim <- summarise(.data = clim, pr = sum(pr)/n_yr, tx = mean(tx), tn = mean(tn), tm = mean(tm))  
  
  rm(rows, x)
  
  ##############################################################################
  # Dejar solamente el periodo de interés y obtener promedios
  ##############################################################################
  
  first_class  <- ""
  second_class <- ""
  third_class  <- ""
  
  rows_winter <- which(clim$month == 4 | clim$month == 5 | clim$month == 6 | clim$month == 7 | clim$month == 8 | clim$month == 9)
  rows_summer <- which(clim$month == 1 | clim$month == 2 | clim$month == 3 | clim$month == 10| clim$month == 11| clim$month == 12)
  
  ##############################################################################
  # Comenzar clasificación. Se parte con clase B, según sugerencia de Peel et al. (2007).
  ##############################################################################
  
  # Obtener p_threshold
  if(sum(clim$pr[rows_winter]) / sum(clim$pr) >= 0.7){
    p_thresh <- 2 * mean(clim$tm)
  }else if(sum(clim$pr[rows_summer]) / sum(clim$pr) >= 0.7){
    p_thresh <- 2 * mean(clim$tm) + 28
  }else{
    p_thresh <- 2 * mean(clim$tm) + 14
  }
  
  ############################################################
  # CLASIFICACIÓN B
  ############################################################
  if(sum(clim$pr) <= 10 * p_thresh){
    first_class <- "B"
    
    # segunda clasificación
    if(sum(clim$pr) < 5 * p_thresh){  second_class <- "W"
    }else{                            second_class <- "S"    }
    
    # Tercera clasificación
    if(mean(clim$tm) >= 18){   third_class <- "h"
    }else{                     third_class <- "k"     }
    
  ############################################################
  # CLASIFICACIÓN A
  ############################################################
  }else if(min(clim$tm) >= 18){
    
    first_class <- "A"
    
    if(      min(clim$pr) >= 60){                       second_class <- "f"
    }else if(min(clim$pr) >= (100 - sum(clim$pr)/25)){  second_class <- "m"
    }else{                                              second_class <- "w"    }
    
  ############################################################
  # CLASIFICACIÓN C
  ############################################################
  }else if(max(clim$tm) > 10 & min(clim$tm) > 0 & min(clim$tm) < 18){
    
    first_class <- "C"
    
    # Second class
    if(min(clim$pr[rows_summer]) < 40 & min(clim$pr[rows_summer]) < (max(clim$pr[rows_winter])/3)){
      second_class <- "s"
    }else if(min(clim$pr[rows_winter]) <= (max(clim$pr[rows_summer])/10)){
      second_class <- "w"
    }else{
      second_class <- "f"
    }
    
    # Tercera clasificación
    if(     max(clim$tm) >= 22){       
      third_class <- "a"
    }else if(max(clim$tm) <  22 & sum(clim$tm >= 10) >= 4){
      third_class <- "b"
    }else if(max(clim$tm) <  22 & sum(clim$tm >= 10) >= 1){
      third_class <- "c"
    }else{}
    
  ############################################################
  # CLASIFICACIÓN D
  ############################################################
  }else if(max(clim$tm) > 10 & min(clim$tm) <= 0){
    
    first_class <- "D"
    
    # Second class
    if(min(clim$pr[rows_summer]) < 40 & min(clim$pr[rows_summer]) < (max(clim$pr[rows_winter])/3)){
      second_class <- "s"
    }else if(min(clim$pr[rows_winter]) < (max(clim$pr[rows_summer]) / 10)){
      second_class <- "w"
    }else{
      second_class <- "f"
    }
    
    # Third class
    if(max(clim$tm) >= 22){
      third_class <- "a"
    }else if(max(clim$tm) < 22 & sum(clim$tm >= 10) >= 4){
      third_class <- "b"
    }else if(max(clim$tm) < 22 & sum(clim$tm >= 10) < 4 & min(clim$tm) < -38){
      third_class <- "d"
    }else{
      third_class <- "c"
    }
  ############################################################
  # CLASIFICACIÓN E
  ############################################################
  }else if(max(clim$tm) < 10){
    
    first_class <- "E"
    
    if(max(clim$tm) > 0){
      second_class <- "T"
    }else{
      second_class <- "F"
    }
    
  }else{
    
  }
  
  
  ##############################################################################
  # Guardar info
  ##############################################################################
  KP_class <- data.frame(ID          = ID$ID[i_cell],
                         lat         = ID$lat[i_cell],
                         lon         = ID$lon[i_cell],
                         fst_class   = first_class,
                         snd_class   = second_class,
                         third_class = third_class)

  return(KP_class)
    
}