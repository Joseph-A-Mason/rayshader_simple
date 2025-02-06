library(terra)
library(hillshader)
library(rayshader)
library(rayrender)

setwd("C:/Users/mason/Dropbox/aeolian_landscapes/GIS_working/temp")

#Import data from DEM to rayshader, creating a matrix
localtif = rast("dem.tif")
local_mat = terra::as.matrix(localtif, wide=TRUE)

#Create hillshade layer. Give it some time
local_mat %>%
  # Create hillshade layer using
  # ray-tracing
  ray_shade() %>%
  # Add ambient shading
  add_shadow_2d(
    ambient_shade(
      heightmap = local_mat
    )
  )

#create 3D model
local_mat %>% 
  height_shade() %>%
  add_overlay(sphere_shade(local_mat, texture = "imhof1", colorintensity = 5), alphalayer=0.5) %>%
  add_shadow(lamb_shade(local_mat), 0) %>%
  add_shadow(ambient_shade(local_mat),0) %>% 
  add_shadow(texture_shade(local_mat,detail=8/10,contrast=9,brightness = 11), 0.1) %>%
  plot_3d(local_mat, zscale = 0.5, windowsize = c(1000, 800))

#change view of object: use these lines to experiment
render_camera(theta = 350, phi=20,zoom= 0.20, fov= 56, shift_vertical = 300)
render_camera(theta = 300, phi=30,zoom= 0.40, fov= 56 )
rgl::rgl.close()
