#
# This is a template project for WKSEATEC DATRAS QC apps. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


shinyServer(function(input, output, session) {
  

  ## STANDARD REACTIVE DATRAS DATA START
  
  # Use reactivePoll so that our data will be updated when the data or filter files are updated
  datrasData <- reactivePoll(1000, session,
                                 # This function returns the time that files were last modified
                                 checkFunc = function() {
                                   myValue <- ''
                                   if (file.exists(AllDataFile)) {
                                     myValue <- paste(myValue , file.info(AllDataFile)$mtime[1])
                                   }
                                   myValue
                                 },
                                 # This function returns the content the files
                                 valueFunc = function() {
                                   #print('Loading data')
                                   allData <- ''
                                   if (file.exists(AllDataFile)) {
                                     allData <- readICES(AllDataFile ,strict=TRUE)
                                   }
                                   allData
                                 }
  )
  
  datrasFilters <- reactivePoll(1000, session,
                                 # This function returns the time that files were last modified
                                 checkFunc = function() {
                                   myValue <- ''
                                   if (file.exists(myFilters)) {
                                     myValue <- paste(myValue , file.info(myFilters)$mtime[1])
                                   }
                                   myValue
                                 },
                                 # This function returns the content the files
                                 valueFunc = function() {
                                   #print('Loading data')
                                   filters <- ''
                                   if (file.exists(myFilters)){
                                     filters <- read.csv(myFilters, header = TRUE)
                                   }
                                   filters
                                 }
  )
  
  
  # Reactive data
  myData<- reactive({
    
    d <- datrasData()
    f <- datrasFilters()
    
    dataToUse <- FilterData(d,f)
    
  })
  
  # Unfiltered data
  myUnfilteredData<- reactive({
    
    d <- datrasData()
    
  })
  
  # Reactive HL data
  HL<- reactive({
    if ("HL" %in% names(myData()))
      myData()[["HL"]]
  })
  
  # Reactive HH data
  HH<- reactive({
    if ("HH" %in% names(myData()))
      myData()[["HH"]]
  })
  
  # Reactive CA data
  CA<- reactive({
    if ("CA" %in% names(myData()))
      myData()[["CA"]]
  })
  
  # Reactive unfiltered HL data
  unfilteredHL<- reactive({
    if ("HL" %in% names(myUnfilteredData()))
      myUnfilteredData()[["HL"]]
  })
  
  # Reactive unfiltered HH data
  unfilteredHH<- reactive({
    if ("HH" %in% names(myUnfilteredData()))
      myUnfilteredData()[["HH"]]
  })
  
  # Reactive unfiltered CA data
  unfilteredCA<- reactive({
    if ("CA" %in% names(myUnfilteredData()))
      myUnfilteredData()[["CA"]]
  })
  
  ## STANDARD REACTIVE DATRAS DATA END
  
  # Add your Shiny app code
  
  # This is just a simple example plot to show the number of CA records
  output$mainPlot <- renderPlotly({
    
    countBySpecies <- aggregate(RecordType ~ ScientificName_WoRMS + Sex, data = CA(), length)
    
    countBySpecies$NameAndSex <- paste(countBySpecies$ScientificName_WoRMS,countBySpecies$Sex,sep="-")
    
    p<-plot_ly(data=countBySpecies, x = ~NameAndSex, y = ~RecordType, type = 'bar') %>% 
        layout(title = 'Biological record counts', xaxis = list(title = 'Species-Sex'),yaxis = list(title = 'Record count'))
    
  })
  

})
