library(rsconnect)
library(shiny)
library(shinythemes)

addResourcePath("www", "www")


ui <- fluidPage(tags$head(tags$script(src = "custom.js")),
  theme = shinytheme('readable'),
  titlePanel("An Introduction to Seam Shifted Wake"),
  
  sidebarLayout(
    sidebarPanel(p('These visulizations show the three types of spin that can be imparted on a baseball at pitch release.'),
                 p('Take a moment to explore the different animations and familiarize yourself with the types of spin.'),
                 br(),
      selectInput('video_choice', 'Select Animation:', choices = c('Sidespin', 'Backspin-Topspin', 'Gyrospin' )),
      br(),
      br(),
      p('Pitches that are thrown with backspin, topspin, or sidespin, 
                and have little deviation about their axis of rotation, will move towards the direction of spin.'),
      p('Fastballs with backspin will fight gravity, curveballs with topspin will dive sharply, 
                and changeups with sidespin will move towards a pitchers armside.'),
      p("However, some pitches are able to produce large movement patterns with inefficient rotations around an axis. 
              This effect is known as Seam Shifted Wake (SSW), 
              but SSW can only occur when gyro spin is introduced. This is because the more efficient a pitch's rotation the more magnus forces will act upon the baseball."),      
      p('Gyro spin is best visualized as the spiral of a football. You can also select the gyrospin animation to see a visual recreation.'),
      br(),
      br(),
      p('Select between video examples of SSW Sinker and Sweeper here.'),
      br(),
      selectInput('pitch_video', 'Select Video:', choices = c('Sweeper', 'SSW Sinker')),
      br(),
      p('The animations at the bottom of the page help to envision the ball flight pitchers are looking for when developing SSW Sinkers/Changeups and Sweepers.
        The red dots are used in place of the black circles we saw earlier.'),
      br(),
      p('Choose between the two animations at the bottom here.'),
      br(),
      selectInput('animation_choice', 'Select Animation:', choices = c('SSW Sinker Animation', 'Sweeper Animation')),
      br(),
      ),
    
    mainPanel(h2('This app will serve as a tutorial for players and coaches to visually explain the phenomenon called Seam Shifted Wake (SSW) 
              and its impact on pitch movement and pitch design.'),
              br(),
                 tags$video(
                   width = "750",
                   height = "360",
                   controls = "controls",
                   src = '',
                   type = "video/mp4",
                   loop = TRUE,
                   id = 'selected_video'
                 ),
                 tags$script(
                   HTML('
        Shiny.addCustomMessageHandler("updateVideo", function(message) {
          var video = document.getElementById(message.id);
          video.src = message.src;
          video.load();
          video.play();
        });
      ')
                 ),
              
              br(),
              br(),
              p('When magnus forces are no longer the sole force acting on the flight of the baseball, 
              counterintuitive movements can occur due to the seams of the baseball.
                '),
              p('When gyro spin is introduced, the location of the seams of the baseball throughout flight become much more important.
        The baseball is no longer limited to movement based on its spin, the seams of the baseball can push airflow to smooth parts of the ball
        and created movement not according to the spin direction.'),
              p('Pitchers and coaches can create arsenals for pitchers who have some gyro spin and inefficiency in their normal pitches.
        By changing the orientation of seams in the pitch grip, coaches can create new pitches that the athlete may not know were possible beforehand.'),
              p('The two most popularized pitches using SSW effects today are the Sinker/Changeup and the brand new "Sweeper".'),
              p('Below are videos of pitchers throwing a SSW Sinker and Sweeper and their accompanying Trackman reports. You can choose which one to the '),
              p('In the Trackman reports note the difference in spin based versus actual movement as well as the lower efficiency numbers.
                Both are telltale signs of Seam Shift effects occuring with the pitch.'),
              br(),
              tags$video(
                width = "750",
                height = "360",
                controls = "controls",
                src = '',
                type = "video/mp4",
                loop = TRUE,
                id = 'vid'
              ),
              tags$script(
                HTML('
        Shiny.addCustomMessageHandler("updateVideo", function(message) {
          var video = document.getElementById(message.id);
          video.src = message.src;
          video.load();
          video.play();
        });
      ')),
  p("You may also notice the black circles on the baseballs in the videos. 
    These circles help the pitchers visualize where the seams need to be 
    orientated durng ball flight to produce the SSW results they're looking for."),
  p('For the Sinker/Changeup, keeping the black circle on top of the ball is how
  to make sure the seams in front push air towards that smooth circle.
  This causes the ball to sink and break arm side even though the spin direction is closer to backspin.'),
  p('For the sweeper, making the baseball spin around the axis of the black circle 
    causes the seam orientation to push airflow to the smooth underside of the ball.
    This helps the ball fight gravity better. Because the ball is being pushed up 
    the lessened downward break becomes an increase in horizontal movement.'),
  p('Below are some animations to help slow down and visualize the spin of the ball that would induce SSW.
    The red dot acts as a replacement for the black circles we see in the previous videos.'),
  
  
  br(),
  tags$video(
    width = "750",
    height = "360",
    controls = "controls",
    src = '',
    type = "video/mp4",
    loop = TRUE,
    id = 'ani'
  ),
  tags$script(
    HTML('
        Shiny.addCustomMessageHandler("updateVideo", function(message) {
          var video = document.getElementById(message.id);
          video.src = message.src;
          video.load();
          video.play();
        });
      ')),
  br(),
  br(),
  p("Many thanks to Tread Athletics, Rylan Domingues, and Kieran Liming for their help and guidance with this project!"),
  HTML("Also be sure to check out Texasleaguers tool for pitch visualization and design that heavily inspired this project <a href='https://scout.texasleaguers.com/spin' target='_blank'>here</a>!"),
  br(),
  br(),
  p('Created by Cade Fletcher'),
  
  
  
),

),
)

server <- function(input, output, session) {
  observeEvent(input$video_choice, {
    selected_video <- input$video_choice
    video_path <- paste0('www/', tolower(selected_video), ".mp4")
    session$sendCustomMessage("updateVideo", list(id = "selected_video", src = video_path))
  })

  observeEvent(input$pitch_video, {
    vid <- input$pitch_video
    pitch_video_path <- paste0('www/', vid, '.mp4')
    session$sendCustomMessage('updateVideo', list(id = 'vid', src = pitch_video_path))
    
      })
  observeEvent(input$animation_choice, {
    ani <- input$animation_choice
    ani_path <- paste0('www/', ani, '.mp4')
    session$sendCustomMessage('updateVideo', list(id = 'ani', src = ani_path))
  })
}


shinyApp(ui = ui, server = server)


