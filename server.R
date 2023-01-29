library(shiny) # shiny features
library(shinydashboard) # shinydashboard functions
library(DT)  # for DT tables
library(dplyr)  # for pipe operator & data manipulations
library(plotly) # for data visualization and plots using plotly 
library(ggplot2) # for data visualization & plots using ggplot2
library(ggtext) # beautifying text on top of ggplot
library(maps) # for USA states map - boundaries used by ggplot for mapping
library(ggcorrplot) # for correlation plot
library(shinycssloaders) # to add a loader while graph is populating
library(shiny)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  #Structure
  output$structure <- renderPrint(
    my_data %>%
      str()
  )
  
  #Summary
  output$summary <- renderPrint(
    
    my_data %>%
      summary()
    
  )
  
  #DataTable
  
  output$dataT <- renderDataTable(
    my_data
  )
  
  # stacked histogram and boxplot
  output$histplot <- renderPlotly({
    
    p1 = my_data %>% 
      plot_ly() %>% 
      add_histogram(~get(input$var1)) %>%
      layout(xaxis = list(title = input$var1))
    
    # Box plot
    p2 = my_data %>%
      plot_ly() %>%
      add_boxplot(~get(input$var1)) %>%
      layout(yaxis = list(showticklabels = F))
    
    #Stacking plots
    subplot(p2, p1, nrows = 2, shareX = TRUE) %>%
      hide_legend() %>%
      layout(title = 'Distribution chart - Histogram and Boxplot',
             yaxis = list(title='Frquency'))
    
  })
    
    #scatter 
    output$scatter <- renderPlotly({
      
      # creating scatter plot for relationship using ggplot
      
   p = my_data %>% 
        ggplot(aes(x=get(input$var2), y=get(input$var3)))+
        geom_point() +
        geom_smooth(method=get(input$fit)) +
        labs(title = paste("Relation b/w", input$var2, "and" , input$var3),
             x = input$var2,
             y = input$var3) +
        theme(  plot.title = element_textbox_simple(size=10, halign=0.5))
    
  
   ggplotly(p)
   
   })

    ## Correlation plot
    output$cor <- renderPlotly({
      my_df <- my_data %>% 
        select(-State)
      
      # Compute a correlation matrix
      corr <- round(cor(my_df), 1)
      
      # Compute a matrix of correlation p-values
      p.mat <- cor_pmat(my_df)
      
      corr.plot <- ggcorrplot(
        corr, 
        hc.order = TRUE, 
        lab= TRUE,
        outline.col = "white",
        p.mat = p.mat
      )
      
      ggplotly(corr.plot)
      
    })
    
    
    ### Bar Charts - State wise trend
    output$bar <- renderPlotly({
      my_data %>% 
        plot_ly() %>% 
        add_bars(x=~State, y=~get(input$var4)) %>% 
        layout(title = paste("Statewise Arrests for", input$var4),
               xaxis = list(title = "State"),
               yaxis = list(title = paste(input$var4, "Arrests per 100,000 residents")))
   
    
                })
   
    # Rendering the box header  
    output$head1 <- renderText(
      paste("5 states with high rate of", input$var4, "Arrests")
    )
    
    # Rendering the box header 
    output$head2 <- renderText(
      paste("5 states with low rate of", input$var4, "Arrests")
    )
    
    
    # Rendering table with 5 states with high arrests for specific crime type
    output$top5 <- renderTable({
      
      my_data %>% 
        select(State, input$var4) %>% 
        arrange(desc(get(input$var4))) %>% 
        head(5)
      
    })
    
    # Rendering table with 5 states with low arrests for specific crime type
    output$low5 <- renderTable({
      
      my_data %>% 
        select(State, input$var4) %>% 
        arrange(get(input$var4)) %>% 
        head(5)
      
      
    })
     
}