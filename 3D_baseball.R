install.packages('devtools')
library(devtools)
devtools::install_github("tylermorganwall/rayrender")
library(rayrender)
library(rgl)
install.packages('av')
library(av)
library(rayvertex)

options(scipen=999)

filepath = "C:/Users/fletc/Downloads/Tread Winter Intern Project/baseball.obj"
file.exists(filepath)

SSW <- generate_camera_motion(positions = get_saved_keyframes(), frames = 120)
render_animation(scene = scene, camera_motion = SSW, samples = 100, sample_method = 'sobol_blue', 
                 keep_colors = TRUE, ambient_light = TRUE, filename = 'SSW')
av::av_encode_video(glue::glue("SSW{1:120}.png"), framerate=40, output = "SSW_Sinker.mp4")

sweeper <- generate_camera_motion(positions = get_saved_keyframes(), frames = 120)
render_animation(scene = scene, camera_motion = sweeper, samples = 100, sample_method = 'sobol_blue',
                 keep_colors = TRUE, ambient_light = TRUE, filename = 'Sweeper_Animation')
av::av_encode_video(glue::glue("Sweeper_Animation{1:120}.png"), framerate=40, output = "Sweeper.mp4")


scene = generate_ground(material = diffuse(color = 'black')) %>%
  add_object(obj_model(filepath, y = 20, scale_obj=0.45, load_material = TRUE, angle = c(-90, -15, 105))) %>%
  add_object(sphere(x = -1, y = 19, z = .6, radius = .8, material = diffuse(color = 'red')))

render_scene(scene = scene, width = 400, height = 400, samples = 100, lookat = c(-1, 19, .6),
             sample_method = 'random', lookfrom = c(0, 20, 20))


aqobj <- read_obj(filepath)
vertices <- obj$vertices[[1]]
vertix_matrix <- matrix(unlist(vertices), ncol = 3, byrow = TRUE)
center <- colMeans(vertix_matrix)
center
  
frames = 60

#camerax= -20*cos(seq(0,720,length.out = frames+1)[-frames-1]*pi/180) + 1.25
#cameraz= 20*sin(seq(0,720,length.out = frames+1)[-frames-1]*pi/180) + 1.25


#camerax
#cameraz

##Sidespin

get_saved_keyframes()
sidespin <- generate_camera_motion(positions = get_saved_keyframes(), frames = 120)
render_animation(scene = scene, camera_motion = sidespin, samples = 100, sample_method = 'sobol_blue', 
                 keep_colors = TRUE, ambient_light = TRUE, filename = 'sidespin')
av::av_encode_video(glue::glue("sidespin{1:120}.png"), framerate=30, output = "sidespin.mp4")


#sidespin <- for(i in 1:frames) {
  #render_scene(scene, fov=35, 
               #lookfrom = c(camerax[i],1,cameraz[i]),
               #lookat = c(1.25,1,1.25), samples = 100, sample_method = 'sobol_blue', parallel = TRUE,
               #filename=glue::glue("spinningbaseballtest{i}"))
#}
  
#sidespin



av::av_encode_video(glue::glue("spinningbaseballtest{1:(frames-1)}.png"), framerate=20, output = "spinningbaseballtest.mp4")
file.remove(glue::glue("spinningbaseballtest{1:(frames-1)}.png"))



##Backspin/Topspin
frames2 = 90
theta <- seq(0, 360, length.out = frames2 + 1)[-frames2 - 1]
cameraz2 = -20 * sin(theta * pi / 180) + 1.25
cameray2 = 20 * cos(theta * pi / 180) + 20.75


cameraz2
cameray2

scene2 <- generate_ground(material = diffuse(color = 'black')) %>%
  add_object(obj_model(filepath, y = 20, scale_obj=0.45, load_material = TRUE,))
render_scene(scene = scene2, lookat = c(0,20, 1.25), lookfrom = c(10, 20, 20))

get_saved_keyframes()

topspin = generate_camera_motion(positions = get_saved_keyframes(), frames = 120)

render_animation(scene = scene2, camera_motion = topspin, samples = 100, sample_method = 'sobol_blue', 
                 keep_colors = TRUE, ambient_light = TRUE, filename = 'topspin2')

for(i in 1:frames2) {
  render_scene(scene2, fov=35,
               lookfrom = c(0,cameray2[i],cameraz2[i]), camera_up = c(0, 1, 0),
               lookat = c(0,20.75,-1.25), samples = 100, sample_method = 'sobol_blue', parallel = TRUE,
               filename=glue::glue("topspintest{i}"))
}

cameraz2[28:32]
cameray2[28:32]

av::av_encode_video(glue::glue("topspin2{1:120}.png"), framerate=30, output = "topspin2.mp4")
file.remove(glue::glue("topspin2{1:120}.png"))

## gyro
get_saved_keyframes()
motion <- generate_camera_motion(positions = get_saved_keyframes(), frames = 120)
render_animation(scene = scene2, camera_motion = motion, samples = 100, sample_method = 'sobol_blue', keep_colors = TRUE, ambient_light = TRUE, filename = 'gyro')


av::av_encode_video(glue::glue("gyro{1:120}.png"), framerate=30, output = "gyro.mp4")
