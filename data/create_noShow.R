#Let's set working directory for correct one
setwd("C:/Users/Julius/yliopisto/kansis/datascience/IODS-final")

library(stringr)
library(dplyr)

#load dataset
noShow <- read.csv("data/No-show-Issue-Comma-300k.csv")

#Our Y variable Status (Show-up, no-show) is coded with values 1 and 2. We recode it to 01
#variable and delete old one

noShow$Status01[noShow$Status == "No-Show"] <- 1
noShow$Status01[noShow$Status == "Show-Up"] <- 0

noShow <- select(noShow, -Status)

#rename Status variable to original name 
names(noShow)[names(noShow) == 'Status01'] <- 'Status'


#Variable Apointmentdata needs to be cleaned. It's values are "yyyy-mm-dd+T+00:00:00Z"
#All the variables have same time stamp of 00:00:00 and Z in the end which is useless
#so we delete them to be able to access dates.

noShow$ApointmentData_fix <- str_sub(noShow$ApointmentData, 1, 10) 

#transform chr variable to Date structure
noShow$ApointmentData_fix <- as.Date(noShow$ApointmentData_fix)

#delete old now useless variable
noShow <- select(noShow, -ApointmentData)

#AppointmentRegistration has variables in the form of "yyyy-mm-dd+T+hh:min:secZ"
#This has timestamp compared to earlier one so we will get two variables for this compared
#Appointmentregistration: one for date and for time of the day when the registration was done
noShow <- cbind(noShow, str_split_fixed(noShow$AppointmentRegistration, "T", 2))

#Str_split_fixed gives variable '1' and '2' for new variable names so we rename them for correct ones
#We also fix appoitmentdata_fix to AppointmentDate
names(noShow)[names(noShow) == 'ApointmentData_fix'] <- 'AppoitmentDate'
names(noShow)[names(noShow) == '1'] <- 'RegistrationDate'
names(noShow)[names(noShow) == '2'] <- 'RegistrationTime'

#We also fix some spelling errors from the dataset
names(noShow)[names(noShow) == 'Alcoolism'] <- 'Alchoholism'
names(noShow)[names(noShow) == 'HiperTension'] <- 'Hypertension'
names(noShow)[names(noShow) == 'Handcap'] <- 'Handicap'


#From the registrationTime we only need the hour.
noShow$RegistrationTime <- str_sub(noShow$RegistrationTime, 1, 2) 

#transform both to to correct from chr structure 
noShow$RegistrationDate <- as.Date(noShow$RegistrationDate)
noShow$RegistrationTime <- as.integer(noShow$RegistrationTime)

#Now we can delete AppointmentRegistration variable
noShow <- select(noShow, -AppointmentRegistration)

str(noShow)
