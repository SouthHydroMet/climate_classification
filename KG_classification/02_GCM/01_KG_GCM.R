

#################################################################################
#
# Script para obtener Koppen-Geiger según GCMs
#
# nicolas.vasquez.pl@uchile.cl
#
#################################################################################

cat("\14")
graphics.off()
rm(list = ls())

library("parallel")

source("/Users/nvasquez/Dropbox/Doctorado/12_Drafts/05_CC_CL/04_Classif_KG/02_GCM/fn_KoppenGeiger.R")

#################################################################################
# Variables necesarias para el código
#################################################################################

dir_gcm  <- "/Users/nvasquez/Dropbox/Doctorado/12_Drafts/05_CC_CL/05_metrics/Mean_values"
dir_save <- "/Users/nvasquez/Dropbox/Doctorado/12_Drafts/05_CC_CL/04_Classif_KG/02_GCM"

gcms <- list.files(dir_gcm)


load("/Users/nvasquez/Dropbox/Doctorado/02_Database/Rasters/ID_pixel_data_v1.RData")
ID <- ID_pixel_data$ID
rm(ID_pixel_data)



for(i_gcm in 1:length(gcms)){
  
  
  dir_data <- paste0(dir_gcm, "/", gcms[i_gcm]) 
  

  KG_classif <- mclapply(X              = seq(from = 1, to = length(ID$ID), by = 1),
                         FUN            = fn_KoppenGeiger,
                         mc.cores       = 6,
                         mc.preschedule = FALSE,
                         #
                         ID             = ID,  # Variable de cada celda
                         dir_data       = dir_data)
    
  
  KG_classif     <- do.call(rbind, KG_classif)
  KG_classif$gcm <- gcms[i_gcm]
  
  save(KG_classif,
       file = paste0(dir_save, "/KG_classif_", gcms[i_gcm], ".RData"))
  
  
  # # #
  cat("\14")
  print(paste0("GCM ", i_gcm, " de ", length(gcms)))
  
}


