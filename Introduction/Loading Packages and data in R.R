#loading required packages
library(data.table) #for loading in dataset
library(dplyr) #for data manipulation
library(ggplot2) #for data visualization
library(caret) #for modelling
library(xgboost) #for modelling xgboost
library(corrplot) #for plotting correlations
library(cowplot) #for combining plots

#loading data
BM_train <- fread("BMTrain.csv", na.strings = "")
BM_test <- fread("BMTest.csv", na.strings = "")