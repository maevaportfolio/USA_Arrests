
# Define UI for application that draws a histogram
ui <- fluidPage(

  dashboardPage(
    dashboardHeader(title ="Exploring the 1973 US Arrests data with R & Shiny Dashboard",titleWidth = 650),
                    
    dashboardSidebar(
      
      #Sidebarmenu
      sidebarMenu(
        id = "sidebar",
        
        #first menuitem
        menuItem("Dataset", tabName = "data", icon = icon("database")),
        menuItem(text = "Visualization", tabName = "viz", icon=icon("chart-line")),
        conditionalPanel("input.sidebar == 'viz' && input.t2 == 'distro'", selectInput(inputId = "var1" , label ="Select the Variable type" , choices =c1, selected = "Rape")),
        conditionalPanel("input.sidebar == 'viz' && input.t2 == 'relation' ", selectInput(inputId = "var2" , label ="Select the X variable" , choices =c1, selected = "Rape")),
        conditionalPanel("input.sidebar == 'viz' && input.t2 == 'relation' ", selectInput(inputId = "var3" , label ="Select the Y variable" , choices =c1, selected = "Assault")),
        conditionalPanel("input.sidebar == 'viz' && input.t2 == 'trends' ", selectInput(inputId = "var4" , label ="Select the Arrest Type" , choices =c2))
      )          
    ),
    
    dashboardBody(
      tabItems(
        ## First tab item
        tabItem(tabName = "data", 
                tabBox(id="t1", width = 12, 
                       tabPanel("About", icon=icon("address-card"),
                                fluidRow(
                                  column(width = 8, tags$img(src="crime.jpg", width =600 , height = 300),
                                         tags$br() , 
                                         tags$a("Photo by Campbell Jensen on Unsplash"), align = "center"),
                                  column(width = 4, tags$br() ,
                                         tags$p("This data set comes along with base R and contains statistics, in arrests per 100,000 residents for assault, murder, and rape in each of the 50 US states in 1973. Also, given is the percent of the population living in urban areas.")
                                  )
                                )
                                
                       ),
                       tabPanel("Data", icon=icon("address-card"), dataTableOutput("dataT")),
                       tabPanel("structure", icon=icon("address-card"), verbatimTextOutput("structure")),
                       tabPanel("summary stats", icon=icon("address-card"), verbatimTextOutput("summary"))
                )
                
        ),
        
        #second tab item 
        tabItem(tabName="viz",
                tabBox(id="t2", width = 12,
                       tabPanel("crime Trend by State", value = "trends",
                                fluidRow(tags$div(align="center", box(tableOutput("top5"), title = textOutput("head1") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE)),
                                         tags$div(align="center", box(tableOutput("low5"), title = textOutput("head2") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE))),
                                    
                                plotlyOutput("bar")),
                       tabPanel(" Distribution", value = "distro", plotlyOutput("histplot")),
                       tabPanel("Correlation Matrix", plotlyOutput("cor")),
                       tabPanel("Relationship among Arrest types & Urban Population", value = "relation",
                                radioButtons(inputId ="fit" , label = "Select smooth method" , choices = c("loess", "lm"), selected = "lm" , inline = TRUE),
                                plotlyOutput("scatter"))
                
      
  
      
    )
    
  )
  
  ))
))




