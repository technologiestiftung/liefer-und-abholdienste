#### Loading Libraries

library(stringr)
library(dplyr)
library(stringdist)

#### 1. Downloading Typeform File ####
Typeform <- read.csv("~/cleaned_export.csv")

# Initial check for duplicates
which(duplicated(Typeform$unique_id)==T)

#### 2. Initial Modifications ####

# Convert Opening Times To Character Vector
Typeform$montag <- as.character(Typeform$montag)
Typeform$dienstag <- as.character(Typeform$dienstag)
Typeform$mittwoch <- as.character(Typeform$mittwoch)
Typeform$donnerstag <- as.character(Typeform$donnerstag)
Typeform$freitag <- as.character(Typeform$freitag)
Typeform$samstag <- as.character(Typeform$samstag)
Typeform$sonntag <- as.character(Typeform$sonntag)

# Merging on names
duplicates_names <- Typeform %>% group_by(name) %>% filter(n() > 1)
duplicates_names <- duplicates_names[order(duplicates_names$name),]

# Merging on addresses
duplicates_address <- Typeform %>% group_by(strasse_nr) %>% filter(n() > 1)
duplicates_address <- duplicates_address[order(duplicates_address$strasse_nr),]

# Fuzzy matching
ClosestMatch2 = function(string, stringVector){
  
  stringVector[amatch(string, stringVector, maxDist=5)]
  
}


ClosestMatch2(Typeform$name,Typeform$name)

originalstring <- Typeform$name

matchedstring <- c()

Typeform$name <- as.character(Typeform$name)

for (i in 1:dim(Typeform)[1]){
  backup <- Typeform 
  backup$name <- as.character(backup$name)
  backup$name[i] <- ""
  matchedstring[i] <- ClosestMatch2(tolower(Typeform$name[i]),tolower(backup$name))
}

fuzzymatching <- as.data.frame(cbind(tolower(originalstring),matchedstring))

