

################################################################################
#
# Script para obtener la clasificación de Koppen-Geiger
#
# nicolas.vasquez.pl@uchile.cl
#
################################################################################

cat("\14")
graphics.off()
rm(list = ls())

library("lubridate")
library("ggplot2")
library("sf")
library("randomcoloR")
library("parallel")
library("dplyr")
library("grDevices")
library("readxl")

################################################################################
# Variables necesarias para el código
################################################################################
computer <- "/Users/nvasquez"

source(paste0(computer, "/Dropbox/Doctorado/12_Drafts/05_CC_CL/04_Classif_KG/fn_KoppenGeiger.R"))

dir_data <- paste0(computer, "/Dropbox/Doctorado/02_Database/Forcings/CR2MET_pixel_data_v25")
dir_save <- paste0(computer, "/Dropbox/Doctorado/12_Drafts/05_CC_CL/04_Classif_KG")

# Cargar info de celdas
load(paste0(computer, "/Dropbox/Doctorado/02_Database/Rasters/ID_pixel_data_v1.RData"))
ID <- ID_pixel_data$ID


ti <- as.Date("01-01-1980", format = "%d-%m-%Y")
tf <- as.Date("31-12-2014", format = "%d-%m-%Y")

# Shapefiles
BD <- st_read("/Users/nvasquez/Dropbox/Doctorado/02_Database/Vectores/WB_Adm0_boundary/WB_Adm0_boundary_lines_10m.gpkg")
CL <- st_read("/Users/nvasquez/Dropbox/Doctorado/02_Database/Vectores/WB_Coastlines_10m/WB_Coastlines_10m.gpkg")
SA <- st_read("/Users/nvasquez/Dropbox/Doctorado/02_Database/Vectores/continent-poly/South America.shp")

################################################################################
# Cargar información
################################################################################

KG_classif <- mclapply(X              = seq(from = 1, to = length(ID$ID), by = 1),
                       FUN            = fn_KoppenGeiger,
                       mc.cores       = 5,
                       mc.preschedule = FALSE,
                       #
                       ID             = ID,  # Variable de cada celda
                       dir_data       = dir_data,  # Dirección para cargar la información
                       ti             = ti,  # Fecha inicial para obtener climatología
                       tf             = tf,  # Fecha final para obtener climatología
                       file_prefix    = "CR2MET_data",  # Nombre del archivo a cargar
                       var_name       = "CR2MET_data",  # Nombre de la variable que se cargará
                       col_names      = c("fecha", "pr", "tx","tn"))


KG_classif <- do.call(rbind, KG_classif)
KG_classif$KG_class <- paste0(KG_classif$fst_class, KG_classif$snd_class, KG_classif$third_class)


save(KG_classif,
     file = paste0(dir_save, "/KG_classif_CR2MET_1980-2014.RData"))

################################################################################
# Definir colores iguales a Peel et al. (2007) y Beck et al. (2018)
################################################################################

legend            <- read_xlsx(path = paste0(dir_save, "/KG_plot_labels.xlsx"))
legend$plot_label <- paste0(legend$Longname, " (", legend$Label, ")")

legend$plot <- 0 * 1
KGs         <- unique(KG_classif$KG_class)

for(i in 1:length(KGs)){
  rows <- which(legend$Label == KGs[i])
  
  if(length(rows) ==1){legend$plot[rows] <- 1}
}

legend <- legend[legend$plot == 1, ]

rm(KGs)

legend$colors <- rgb(red = legend$Red, green = legend$Green, blue = legend$Blue, maxColorValue = 255)

################################################################################
# Figuras
################################################################################

KG_classif$KG_class <- factor(KG_classif$KG_class,
                              levels = legend$Label,
                              labels = legend$plot_label)

fig.1 <- ggplot() + 
          geom_sf(data = SA, fill = "gray90", colour = "transparent") +
          geom_tile(data = KG_classif, aes(x = lon, y = lat, fill = KG_class, colour = KG_class)) +
          geom_sf(data = BD,  colour = "black", linewidth = 0.1) +
          geom_sf(data = CL,  colour = "black", linewidth = 0.1) +
          scale_fill_manual(values = legend$colors) +
          scale_colour_manual(values = legend$colors) +
          coord_sf(xlim = c(-76, -66.5), ylim = c(-55, -18.5))
fig.1
