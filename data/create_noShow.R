#We will use dataset from Kaggle:
#https://www.kaggle.com/joniarroba/noshowappointments
#It has information about people who have or not have showed up for the medical appointment

#Let's set working directory for correct one
setwd("C:/Users/Julius/yliopisto/kansis/datascience/IODS-final")

#needed libraries for data wrangling
library(stringr)
library(dplyr)

#load dataset
noShow <- read.csv("data/No-show-Issue-Comma-300k.csv")

#Our Y variable Status (Show-up, no-show) is coded with values 1 and 2. We recode it to 0/1
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

#split in to two variables
noShow <- cbind(noShow, str_split_fixed(noShow$AppointmentRegistration, "T", 2))

#Str_split_fixed gives variable '1' and '2' for new variable names so we rename them for correct ones
#We also fix appoitmentdata_fix to AppointmentDate
names(noShow)[names(noShow) == 'ApointmentData_fix'] <- 'AppoitmentDate'
names(noShow)[names(noShow) == '1'] <- 'RegistrationDate'
names(noShow)[names(noShow) == '2'] <- 'RegistrationHour'

#We also fix some spelling errors from the dataset
names(noShow)[names(noShow) == 'Alcoolism'] <- 'Alchoholism'
names(noShow)[names(noShow) == 'HiperTension'] <- 'Hypertension'
names(noShow)[names(noShow) == 'Handcap'] <- 'Handicap'


#From the registrationTime we only need the hour.
noShow$RegistrationHour <- str_sub(noShow$RegistrationHour, 1, 2) 

#transform both to to correct from chr structure 
noShow$RegistrationDate <- as.Date(noShow$RegistrationDate)
noShow$RegistrationHour <- as.integer(noShow$RegistrationHour)

#Now we can delete the original AppointmentRegistration variable
noShow <- select(noShow, -AppointmentRegistration)


#table(noShow$Age)
#Our dataset has one -2 year old and five -1 year olds. We will delete everybody who
#is under 0 years old.
noShow <- filter(noShow, Age >= 0 )

#Handicap variable has values from 0 to 4 which point how severe the handicapness is
#We will change it to binary just pointing if person has handicap or not
noShow$Handicap[noShow$Handicap > 0] <- 1

#SMS_reminder to 0/1 variable
noShow$Sms_Reminder[noShow$Sms_Reminder > 0]  <- 1

#save data to the folder
write.csv(noShow, "data/noShow.csv")

#test if it worked fine
noShow_test<- read.csv("data/noShow.csv", header = TRUE)
str(noShow_test)
