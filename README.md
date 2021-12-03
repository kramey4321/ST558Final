# ST558Final

# Purpose of this App

This app was the final for my awesome ST558 class.  It takes the user on a lovely stroll down 'what goes into housing prices' lane.  There is a chance for the user to play around with individual variables and see how they impact the sales price.  Then, the user has the opportunity to build their own model based on which values seem to have value (HA!)

# Packages to run the app

library(shiny)
library(tidyverse)
library(DT)
library(tree)
library(caret)
library(randomForest)
library(rattle)

# Install packages

my_packages <- c("shiny", "tidyverse", "DT", "tree", "caret", "randomForest", "rattle")  
lapply(my_packages, require, character.only = TRUE) 

# Code to run app

shiny::runApp('HousingApp')