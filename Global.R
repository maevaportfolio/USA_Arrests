#USArrests dataset

library(dplyr)

USArrests

# create data objet 
my_data <- USArrests
my_data


#Structure of the data
my_data %>%
  str()


#summary
my_data %>%
  summary()


#first few observations 
my_data %>%
  head()


#Assigning row names to object
states = rownames(my_data)

my_data = my_data %>%
  mutate(State=states)

str(my_data)

#second menuitem visualization 


#Creating histogram and boxplot for distribution tabPanel
p1 = my_data %>% 
  plot_ly() %>% 
  add_histogram(~Rape) %>% 
  layout(xaxis = list(title = "Rape"))

# Box plot
p2 = my_data %>%
  plot_ly() %>%
  add_boxplot(~Rape) %>%
 layout(yaxis = list(showticklabels = F))


# Stacking plots
subplot(p2, p1, nrows = 2, shareX = TRUE) %>%
  hide_legend() %>%
  layout(title = 'Distribution chart - Histogram and Boxplot',
         yaxis = list(title='Frquency'))

# Choices for selectInput - without states column 
c1 = my_data %>%
  select(-State) %>%
  names()

# creating scatter plot for relationship using ggplot

my_data %>% 
  ggplot(aes(x= Rape, y= Assault))+
  geom_point() +
  geom_smooth(method="lm") +
  labs(title = "Relation b/w rape and Assault Arrests",
       x = "Rape",
       y = "Assault") +
  theme(  plot.title = element_textbox_simple(size=10, halign=0.5))


# Column names without state and UrbanPopulation. This will be used in the selectinput for choices in the shinydashboard
c2 = my_data %>% 
  select(-"State", -"UrbanPop") %>% 
  names()

#Top 5 states with high rates 
my_data %>% 
  select(State, Rape) %>%
  arrange(desc(Rape)) %>%
  head(5)

#Top 5 rates with low rates 
my_data %>% 
  select(State, Rape) %>%
  arrange(Rape) %>%
  head(5)
