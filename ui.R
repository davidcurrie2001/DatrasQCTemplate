#
# This is a template project for WKSEATEC DATRAS QC apps. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#



shinyUI(fluidPage(
  
  # Application title
  titlePanel("DATRAS QC Template"),
  
  fluidRow(
    column(12,plotlyOutput("mainPlot"))
  )
  

))
