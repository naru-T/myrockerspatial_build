library(shiny)
library(leaflet)
library(sf)
library(sp)
library(tidyverse)
library(shinydashboard)
library(shinythemes)
#library(rmapshaper)
#library(lubridate)
library(MyRMiscFunc)
library(gwpcor)
library(here)
library(spdplyr)
library(GWmodel)


##extract 2005 variable
#  alldata <- sf::st_read(here("data/alldata.gpkg"))
#  tokyo2005_sf <- alldata  %>%
#    dplyr::filter(., str_detect(string = 都道府県名.x, "東京都")) %>%
#    dplyr::filter(., str_detect(string = 市区郡町村名.x, "区")) %>%
#    dplyr::select(., ends_with("2005"))
#
# #save(tokyo2005_sp, file = "tokyo2005_sp.rd")
# write_gpkg(tokyo2005_sf,file = "tokyo2005_sf.gpkg")

tokyo2005_sf <- sf::st_read(here("tokyo2005_sf.gpkg")) %>% st_transform(.,4326)
load(here("dMat.rd")) #load distant matrix 


#tokyo2005_sf <- alldata_sf %>%
#  dplyr::filter(., str_detect(string = 都道府県名.x, "東京都")) %>%
#  dplyr::filter(., str_detect(string = 市区郡町村名.x, "区")) %>%
#  dplyr::select(., ends_with("2005"))
#save(tokyo2005_sf, file = "tokyo2005_sf.rd")

#load(here("data/cor_res_ad783.rd"))
#load(here("data/Pcor_res_ad783.rd"))


#calc func
gwpcor_calc <- function(var1, var2, var3,b){
  out <- gwpcor(tokyo2005_sf,
                vars = c(var1 %+% "_2005",
                         var2 %+% "_2005",
                         var3 %+% "_2005"),
                method = "pearson",
                kernel = "bisquare",
                bw = b,
                adaptive = TRUE,
                longlat = TRUE,
                dMat=dMat)
  return(out$SDF)
  }

varname_id <-  names(tokyo2005_sf) %>%
  grep("\\_2005$", .)

varname <- names(tokyo2005_sf)[varname_id] %>%
  strsplit(., "_2005") %>%
  sapply(.,"[[",1)
#%>%
#  unique()



# varname2 <- sub("corr_","", names(Cor_res$SDF)) %>%
#            strsplit(., "_2005.") %>%
#            sapply(.,"[[",1) %>%
#            unique()

#load("alldata_ward_2000.rd")
#cho_name <- alldata_sf %>%
#  dplyr::filter(., str_detect(string = 都道府県名.x, "東京都")) %>%
#  dplyr::filter(., str_detect(string = 市区郡町村名.x, "区")) %>%
#  dplyr::select(町丁名)


##https://github.com/rstudio/shiny/issues/2056
## Simplify shapefile to speed up rendering
#shapefile <- ms_simplify(Cor_res$SDF, keep = 0.01, keep_shapes = TRUE)

#shapefile <- Cor_res$SDF
 #var <- names(shapefile)
 #bounds<-bbox(shapefile)

 bounds<-st_bbox(tokyo2005_sf)

 #
# r_colors <- rgb(t(col2rgb(colors()) / 255))
# names(r_colors) <- colors()
#
#
# n2 <- names(shapefile)[2]
# shapefile_selected <- shapefile[,n2]
# names(shapefile_selected) <- "val"
# pal1 <- colorBin("YlOrRd",shapefile_selected@data$val , bins=9, na.color = "#bdbdbd")
#
#
# leaflet(shapefile_selected) %>%
#   addTiles() %>%
#   addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
#               fillColor = ~pal1(val)) %>%
#   setView(mean(bounds[1,]),
#           mean(bounds[2,]),
#           zoom=11)
#

ui <- dashboardPage(
  dashboardHeader(title = "GW correlation"),
  dashboardSidebar(sidebarMenu(menuItem("Choose parameters", tabName = "map"),
                               selectInput(inputId = "input_type1",
                                           label = "Correlation pair 1",
                                           choices = varname,
                                           selected=varname[10]),
                               selectInput(inputId = "input_type2",
                                           label = "Correlation pair 2",
                                           choices = varname,
                                           selected=varname[20]),
                               selectInput(inputId = "input_type3",
                                           label = "Control variable",
                                           choices = varname,
                                           selected=varname[30]),
                               # Copy the line below to make a set of radio buttons
                               radioButtons("radio", label = h3("Type"),
                                            choices = list("GW correlation" = "cor", "GW partial correlation" = "pcor"),
                                            selected = "cor")
                               #uiOutput("dateSelect"),
                               #uiOutput("typeSelect")
                               #uiOutput("backgroundSelect"),
                               #uiOutput("presidentSelect")
                               )),
  dashboardBody(tabItems(
    tabItem(tabName = "map",
            leafletOutput("mymap", height=500)))))



server <- function(input, output, session) {
  # output$dateSelect <- renderUI({
  #   switch(input$input_type,
  #          "Date" = dateRangeInput("dateInput", "Dates:",
  #                                  min=min(wikiraw$incident_date), max = max(wikiraw$incident_date),
  #                                  start = min(wikiraw$incident_date), end = max(wikiraw$incident_date)),
  #          "Presidency" = checkboxGroupInput("president", "Presidency",
  #                                            choices = levels(wikiraw$presidency),
  #                                            selected = "President1"))
  # })

  # output$typeSelect <- renderUI({
  #   selectInput("type", "Correlation pair",
  #               choices = names(shapefile), multiple = FALSE,
  #               selected = names(shapefile)[1])})

  # output$backgroundSelect <- renderUI({
  #   checkboxGroupInput("background", "Incident background",
  #                      choices = unique(wikiraw$incident_background),
  #                      selected = wikiraw$incident_background[1])})


  selected <- reactive({

    #req(reactiveVals$switch == TRUE)
    if(input$radio=="cor"){
      #shapefile <- Cor_res$SDF
      w1 <- which(varname==input$input_type1)
      w2 <- which(varname==input$input_type2)
      ww <- sort(c(w1,w2))
      vn <- "corr_" %+% varname[ww[1]] %+% "_2005." %+% varname[ww[2]] %+% "_2005"

      shapefile <- gwpcor_calc(var1 = input$input_type1,
                               var2 = input$input_type2,
                               var3 = input$input_type3,
                               b = 783)

      } else{
      #shapefile <- Pcor_res$SDF
      w1 <- which(varname==input$input_type1)
      w2 <- which(varname==input$input_type2)
      ww <- sort(c(w1,w2))
      vn <- "pcorr_" %+% varname[ww[1]] %+% "_2005." %+% varname[ww[2]] %+% "_2005"

      shapefile <- gwpcor_calc(var1 = input$input_type1,
                               var2 = input$input_type2,
                               var3 = input$input_type3,
                               b = 783)
      }

    #shapefile_selected <- shapefile [,vn]
    shapefile_selected <- shapefile %>% dplyr::select(vn)
    names(shapefile_selected)[1] <- "val"

    # wikiagg <- wikiraw %>% group_by(ID_2, incident_date, incident_type, incident_background, presidency) %>%
    #   summarize(sum_event = sum(event))
    # if(input$input_type=="Date"){wikiagg <- filter(wikiagg,
    #                                                incident_date >= min(input$dateInput),
    #                                                incident_date <= max(input$dateInput),
    #                                                incident_type%in%input$type,
    #                                                incident_background%in%input$background)}
    # if(input$input_type=="Presidency"){wikiagg <- filter(wikiagg,
    #                                                      incident_type%in%input$type,
    #                                                      incident_background%in%input$background,
    #                                                      presidency%in%input$president)}
    #
    # wikiagg <- wikiagg %>% group_by(ID_2) %>%
    #   summarize(sum_event = sum(sum_event))
   
     shapefile_selected <- shapefile_selected %>% st_as_sf()
  })

  output$mymap <- renderLeaflet({

    leaflet() %>%
      addProviderTiles("CartoDB.DarkMatter") %>%
      setView(mean(bounds[c(1,3)]),
              mean(bounds[c(2,4)]),
              zoom=11
      )

    # leaflet() %>%
    #   addProviderTiles("CartoDB.DarkMatter") %>%
    #   setView(mean(bounds[c(1,3)]),
    #           mean(bounds[c(2,4)]),
    #           zoom=11
    #   )
  })

  observe({
    #if(!is.null(input$typeSelect)){
      shapefile_selected <-  selected()
      #shapefile_selected <- shapefile[,output$typeSelect]
      #names(shapefile_selected) <- "val"



      ##Define palette across range of data
      # wikiaggpal <- shapefile %>% group_by(ID_2) %>%
      #   summarize(sum_event = sum(event))
      pal1 <- colorBin("RdBu",
                       #shapefile_selected$val ,
                       c(-1,1),
                       bins=8 ,
                       na.color = "#bdbdbd")


       leafletProxy("mymap", data = shapefile_selected) %>%
         clearControls() %>%
         clearShapes() %>%
         addPolygons(data = shapefile_selected, stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
                     fillColor = ~pal1(val)) %>%
         addLegend(
           "bottomleft", # Legend position
           pal=pal1, # color palette
           values=~val, # legend values
           opacity = 1
         )
    })
}
shinyApp(ui, server)
