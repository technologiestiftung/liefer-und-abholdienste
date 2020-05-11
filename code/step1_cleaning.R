#### Loading Libraries

library(stringr)
library(ggmap)
library(dplyr)

#### 1. Downloading Typeform File ####

Typeform <- read.csv("~/uncleaned_export.csv")

#### 2. Initial Modifications ####

# Convert Opening Times To Character Vector
Typeform$montag <- as.character(Typeform$montag)
Typeform$dienstag <- as.character(Typeform$dienstag)
Typeform$mittwoch <- as.character(Typeform$mittwoch)
Typeform$donnerstag <- as.character(Typeform$donnerstag)
Typeform$freitag <- as.character(Typeform$freitag)
Typeform$samstag <- as.character(Typeform$samstag)
Typeform$sonntag <- as.character(Typeform$sonntag)

#### 3. Data Cleaning ####

# Subsetting Relevant Columns
Subset_Typeform <- Typeform[,c(13:19)]

## Remove All Capital Letters
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) {tolower(x)}))

# Identify Common Signals for Closed Store/Restaurant
Subset_Typeform[Subset_Typeform=="ruhetag"] <- NA
Subset_Typeform[Subset_Typeform=="geschlossen"] <- NA
Subset_Typeform[Subset_Typeform=="den ganzen Tag"] <- "00:00-00:00"
Subset_Typeform[Subset_Typeform=="ganzen Tag"] <- "00:00-00:00"

## Change "bis" to "-"
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) { gsub("bis","-",x)}))

## Change "und" to "-"
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) { gsub("und","-",x)}))

## Correct Common Typos
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) { gsub(";",":",x)}))
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) { gsub("\\.",":",x)}))
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) { gsub('"',"",x)}))
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) { gsub("'","",x)}))
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) { gsub(",",":",x)}))
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) { gsub("/",":",x)}))

## Removing Accents
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) {iconv(x,from="UTF-8",to="ASCII//TRANSLIT")}))

## Remove All Characters (i.e. Letters)
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) {str_replace_all(x, "[a-z,A-Z]", " ")}))
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) {gsub('"',"",x)}))

# Remove All Spaces
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) {gsub(" ","",x)}))

# Remove First Character for Answers Starting With "-"
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) {gsub('^-', '',x)}))

# Add ":00" At the End of All Strings
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) {paste0(x,":00")}))

# Convert "00:00" to ":00" 
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) {gsub('00:00', ':00',x)}))

# Convert "::" to ":" 
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) {gsub('::', ':',x)}))

# Convert "30:00" to ":30"  
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) {gsub('30:00', ':30',x)}))

# Convert "::" to ":" Once Again
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) {gsub('::', ':',x)}))

# Add a "0" if String has Less than 11 Characters
Subset_Typeform$montag <- as.character(Subset_Typeform$montag)
Subset_Typeform$montag[nchar(Subset_Typeform$montag)<11] <- paste0(0,Subset_Typeform$montag[nchar(Subset_Typeform$montag)<11])

Subset_Typeform$dienstag <- as.character(Subset_Typeform$dienstag)
Subset_Typeform$dienstag[nchar(Subset_Typeform$dienstag)<11] <- paste0(0,Subset_Typeform$dienstag[nchar(Subset_Typeform$dienstag)<11])

Subset_Typeform$mittwoch <- as.character(Subset_Typeform$mittwoch)
Subset_Typeform$mittwoch[nchar(Subset_Typeform$mittwoch)<11] <- paste0(0,Subset_Typeform$mittwoch[nchar(Subset_Typeform$mittwoch)<11])

Subset_Typeform$donnerstag <- as.character(Subset_Typeform$donnerstag)
Subset_Typeform$donnerstag[nchar(Subset_Typeform$donnerstag)<11] <- paste0(0,Subset_Typeform$donnerstag[nchar(Subset_Typeform$donnerstag)<11])

Subset_Typeform$freitag <- as.character(Subset_Typeform$freitag)
Subset_Typeform$freitag[nchar(Subset_Typeform$freitag)<11] <- paste0(0,Subset_Typeform$freitag[nchar(Subset_Typeform$freitag)<11])

Subset_Typeform$samstag <- as.character(Subset_Typeform$samstag)
Subset_Typeform$samstag[nchar(Subset_Typeform$samstag)<11] <- paste0(0,Subset_Typeform$samstag[nchar(Subset_Typeform$samstag)<11])

Subset_Typeform$sonntag <- as.character(Subset_Typeform$sonntag)
Subset_Typeform$sonntag[nchar(Subset_Typeform$sonntag)<11] <- paste0(0,Subset_Typeform$sonntag[nchar(Subset_Typeform$sonntag)<11])

# Remove All Final Discrepancies
Subset_Typeform$montagtest.1 <- NA
Subset_Typeform$montagtest.1 <- ifelse(str_detect(Subset_Typeform$montag, '^\\d{3}[\\-]')==T,
                                      substring(Subset_Typeform$montag, 2),
                                      Subset_Typeform$montag)


                   
Subset_Typeform$montagtest.2 <- NA
Subset_Typeform$montagtest.2 <- ifelse(str_detect(Subset_Typeform$montag, '^\\d{3}[\\-]')==T,
                                        sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$montagtest.1),
                                        Subset_Typeform$montag)


Subset_Typeform$montagtest.3 <- NA
Subset_Typeform$montagtest.3 <- ifelse(str_detect(Subset_Typeform$montagtest.2, '^\\d{2}[\\-]')==T,
                                        sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$montagtest.2),
                                        Subset_Typeform$montagtest.2)


Subset_Typeform$dienstagtest.1 <- NA
Subset_Typeform$dienstagtest.1 <- ifelse(str_detect(Subset_Typeform$dienstag, '^\\d{3}[\\-]')==T,
                                        substring(Subset_Typeform$dienstag, 2),
                                        Subset_Typeform$dienstag)



Subset_Typeform$dienstagtest.2 <- NA
Subset_Typeform$dienstagtest.2 <- ifelse(str_detect(Subset_Typeform$dienstag, '^\\d{3}[\\-]')==T,
                                        sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$dienstagtest.1),
                                        Subset_Typeform$dienstag)


Subset_Typeform$dienstagtest.3 <- NA
Subset_Typeform$dienstagtest.3 <- ifelse(str_detect(Subset_Typeform$dienstagtest.2, '^\\d{2}[\\-]')==T,
                                        sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$dienstagtest.2),
                                        Subset_Typeform$dienstagtest.2)


Subset_Typeform$mittwochtest.1 <- NA
Subset_Typeform$mittwochtest.1 <- ifelse(str_detect(Subset_Typeform$mittwoch, '^\\d{3}[\\-]')==T,
                                          substring(Subset_Typeform$mittwoch, 2),
                                          Subset_Typeform$mittwoch)



Subset_Typeform$mittwochtest.2 <- NA
Subset_Typeform$mittwochtest.2 <- ifelse(str_detect(Subset_Typeform$mittwoch, '^\\d{3}[\\-]')==T,
                                          sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$mittwochtest.1),
                                          Subset_Typeform$mittwoch)


Subset_Typeform$mittwochtest.3 <- NA
Subset_Typeform$mittwochtest.3 <- ifelse(str_detect(Subset_Typeform$mittwochtest.2, '^\\d{2}[\\-]')==T,
                                          sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$mittwochtest.2),
                                          Subset_Typeform$mittwochtest.2)



Subset_Typeform$donnerstagtest.1 <- NA
Subset_Typeform$donnerstagtest.1 <- ifelse(str_detect(Subset_Typeform$donnerstag, '^\\d{3}[\\-]')==T,
                                          substring(Subset_Typeform$donnerstag, 2),
                                          Subset_Typeform$donnerstag)



Subset_Typeform$donnerstagtest.2 <- NA
Subset_Typeform$donnerstagtest.2 <- ifelse(str_detect(Subset_Typeform$donnerstag, '^\\d{3}[\\-]')==T,
                                          sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$donnerstagtest.1),
                                          Subset_Typeform$donnerstag)


Subset_Typeform$donnerstagtest.3 <- NA
Subset_Typeform$donnerstagtest.3 <- ifelse(str_detect(Subset_Typeform$donnerstagtest.2, '^\\d{2}[\\-]')==T,
                                          sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$donnerstagtest.2),
                                          Subset_Typeform$donnerstagtest.2)


Subset_Typeform$freitagtest.1 <- NA
Subset_Typeform$freitagtest.1 <- ifelse(str_detect(Subset_Typeform$freitag, '^\\d{3}[\\-]')==T,
                                            substring(Subset_Typeform$freitag, 2),
                                            Subset_Typeform$freitag)



Subset_Typeform$freitagtest.2 <- NA
Subset_Typeform$freitagtest.2 <- ifelse(str_detect(Subset_Typeform$freitag, '^\\d{3}[\\-]')==T,
                                            sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$freitagtest.1),
                                            Subset_Typeform$freitag)


Subset_Typeform$freitagtest.3 <- NA
Subset_Typeform$freitagtest.3 <- ifelse(str_detect(Subset_Typeform$freitagtest.2, '^\\d{2}[\\-]')==T,
                                            sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$freitagtest.2),
                                            Subset_Typeform$freitagtest.2)


Subset_Typeform$samstagtest.1 <- NA
Subset_Typeform$samstagtest.1 <- ifelse(str_detect(Subset_Typeform$samstag, '^\\d{3}[\\-]')==T,
                                         substring(Subset_Typeform$samstag, 2),
                                         Subset_Typeform$samstag)



Subset_Typeform$samstagtest.2 <- NA
Subset_Typeform$samstagtest.2 <- ifelse(str_detect(Subset_Typeform$samstag, '^\\d{3}[\\-]')==T,
                                         sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$samstagtest.1),
                                         Subset_Typeform$samstag)


Subset_Typeform$samstagtest.3 <- NA
Subset_Typeform$samstagtest.3 <- ifelse(str_detect(Subset_Typeform$samstagtest.2, '^\\d{2}[\\-]')==T,
                                         sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$samstagtest.2),
                                         Subset_Typeform$samstagtest.2)



Subset_Typeform$sonntagtest.1 <- NA
Subset_Typeform$sonntagtest.1 <- ifelse(str_detect(Subset_Typeform$sonntag, '^\\d{3}[\\-]')==T,
                                         substring(Subset_Typeform$sonntag, 2),
                                         Subset_Typeform$sonntag)



Subset_Typeform$sonntagtest.2 <- NA
Subset_Typeform$sonntagtest.2 <- ifelse(str_detect(Subset_Typeform$sonntag, '^\\d{3}[\\-]')==T,
                                         sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$sonntagtest.1),
                                         Subset_Typeform$sonntag)


Subset_Typeform$sonntagtest.3 <- NA
Subset_Typeform$sonntagtest.3 <- ifelse(str_detect(Subset_Typeform$sonntagtest.2, '^\\d{2}[\\-]')==T,
                                         sub("(.{2})(.*)", "\\1:00\\2", Subset_Typeform$sonntagtest.2),
                                         Subset_Typeform$sonntagtest.2)

# Remove NAs Within Strings
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) {gsub('NA', '',x)}))

# Create a Signal (99:99-99:99) for All Missing Data (currently 00:00)
Subset_Typeform <- data.frame(lapply(Subset_Typeform, function(x) {gsub('^0:00$', '99:99-99:99',x)}))

# Create Columns to Identify Strings that Do Not Fit the Proper Format (XX:XX-XX:XX)
Subset_Typeform$Complete_Cases_NAs_Montag <- gsub('^\\d{2}:\\d{2}[\\-]\\d{2}:\\d{2}$', NA, Subset_Typeform$montagtest.3)
Subset_Typeform$Complete_Cases_NAs_Dienstag <- gsub('^\\d{2}:\\d{2}[\\-]\\d{2}:\\d{2}$', NA, Subset_Typeform$dienstagtest.3)
Subset_Typeform$Complete_Cases_NAs_Mittwoch <- gsub('^\\d{2}:\\d{2}[\\-]\\d{2}:\\d{2}$', NA, Subset_Typeform$mittwochtest.3)
Subset_Typeform$Complete_Cases_NAs_Donnerstag <- gsub('^\\d{2}:\\d{2}[\\-]\\d{2}:\\d{2}$', NA, Subset_Typeform$donnerstagtest.3)
Subset_Typeform$Complete_Cases_NAs_Freitag <- gsub('^\\d{2}:\\d{2}[\\-]\\d{2}:\\d{2}$', NA, Subset_Typeform$freitagtest.3)
Subset_Typeform$Complete_Cases_NAs_Samstag <- gsub('^\\d{2}:\\d{2}[\\-]\\d{2}:\\d{2}$', NA, Subset_Typeform$samstagtest.3)
Subset_Typeform$Complete_Cases_NAs_Sonntag <- gsub('^\\d{2}:\\d{2}[\\-]\\d{2}:\\d{2}$', NA, Subset_Typeform$sonntagtest.3)

# Create Finalized Vectors with Clean Opening Times
Typeform$montagClean <- as.character(Subset_Typeform$montagtest.3)
Typeform$montagClean[!is.na(Subset_Typeform$Complete_Cases_NAs_Montag)] <- "DOUBLE-CHECK"

Typeform$dienstagClean <- as.character(Subset_Typeform$dienstagtest.3)
Typeform$dienstagClean[!is.na(Subset_Typeform$Complete_Cases_NAs_Dienstag)] <- "DOUBLE-CHECK"

Typeform$mittwochClean <- as.character(Subset_Typeform$mittwochtest.3)
Typeform$mittwochClean[!is.na(Subset_Typeform$Complete_Cases_NAs_Mittwoch)] <- "DOUBLE-CHECK"

Typeform$donnerstagClean <- as.character(Subset_Typeform$donnerstagtest.3)
Typeform$donnerstagClean[!is.na(Subset_Typeform$Complete_Cases_NAs_Donnerstag)] <- "DOUBLE-CHECK"

Typeform$freitagClean <- as.character(Subset_Typeform$freitagtest.3)
Typeform$freitagClean[!is.na(Subset_Typeform$Complete_Cases_NAs_Freitag)] <- "DOUBLE-CHECK"

Typeform$samstagClean <- as.character(Subset_Typeform$samstagtest.3)
Typeform$samstagClean[!is.na(Subset_Typeform$Complete_Cases_NAs_Samstag)] <- "DOUBLE-CHECK"

Typeform$sonntagClean <- as.character(Subset_Typeform$sonntagtest.3)
Typeform$sonntagClean[!is.na(Subset_Typeform$Complete_Cases_NAs_Sonntag)] <- "DOUBLE-CHECK"

# Convert the Signal (99:99-99:99) to NAs
Typeform <- data.frame(lapply(Typeform, function(x) {gsub('99:99-99:99', "",x)}))

#### 4. Finding Coordinates ####

# Correcting Address
Typeform$strasse_nr <- as.character(Typeform$strasse_nr)
Typeform$strasse_nr[1179] <- "Grünbergallee 101"

# Load API
ggmap::register_google(key = "") # Input own key here

address_with_zip <- paste(Typeform$strasse_nr,Typeform$plz)

# Read in the CSV Data and Store it in a Variable 
origAddress <- as.data.frame(address_with_zip)
colnames(origAddress)[1] <- "addresses"
origAddress$addresses <- as.character(origAddress$addresses)

# Initialize the Data Frame
geocoded <- data.frame(stringsAsFactors = FALSE)

# Getting Long and Lat Coordinates
for(i in 1:nrow(origAddress))
{
  try({result <- geocode(origAddress$addresses[i], output = "latlona", source = "google")
  origAddress$lon[i] <- as.numeric(result[1])
  origAddress$lat[i] <- as.numeric(result[2])
  origAddress$geoAddress[i] <- as.character(result[3])}, silent=TRUE) 
}

# Save Information in Original Dataset
Typeform$lon <- origAddress$lon
Typeform$lat <- origAddress$lat

#### 5. Check for Names in Email Adresses ####

# Create an ID Column
Typeform$id <- seq(1,dim(Typeform)[1])

# Printing all Email Adresses
options(max.print=2000)
Typeform$mail

# Erase Email for these Rows
RowNumber <- c(9,12,13,21,29,54,55,82,113,127,177,181,199,213,216,218,226,243,252,273, 290, 292, 310, 333, 352,395,396,409,436,445,458,472,474,485,518,537,593,598,625,629,631,651,684,777,789,848,901,968,1049,1074,1087,1096,1130,1170,1183,1187,1205,1206,1207,1240,1257,1264,1279,1284,1286,1338)
Typeform$mail[RowNumber] <- ""

#### 6. Exporting Clean Dataset ####

# Checking All Column Names
colnames(Typeform)

# Replacing Original Time Columns
Typeform$montag <- Typeform$montagClean
Typeform$dienstag <- Typeform$dienstagClean
Typeform$mittwoch <- Typeform$mittwochClean
Typeform$donnerstag <- Typeform$donnerstagClean
Typeform$freitag <- Typeform$freitagClean
Typeform$samstag <- Typeform$samstagClean
Typeform$sonntag <- Typeform$sonntagClean

# Remove Unecessary Columns
Typeform <- Typeform[,-c(22:28)]
colnames(Typeform)

# Changing Columns Names 
colnames(Typeform)[1] <- "name"  
colnames(Typeform)[2] <- "strasse_nr"  
colnames(Typeform)[3] <- "plz"  
colnames(Typeform)[4] <- "angebot"  
colnames(Typeform)[5] <- "lieferung"  
colnames(Typeform)[6] <- "beschreibung_lieferangebot"  
colnames(Typeform)[7] <- "selbstabholung"  
colnames(Typeform)[8] <- "angebot_selbstabholung"  
colnames(Typeform)[9] <- "fon"  
colnames(Typeform)[10] <- "w3"  
colnames(Typeform)[11] <- "mail"  
colnames(Typeform)[12] <- "art"  
colnames(Typeform)[13] <- "montag"  
colnames(Typeform)[14] <- "dienstag"  
colnames(Typeform)[15] <- "mittwoch"  
colnames(Typeform)[16] <- "donnerstag"  
colnames(Typeform)[17] <- "freitag"  
colnames(Typeform)[18] <- "samstag"  
colnames(Typeform)[19] <- "sonntag" 
colnames(Typeform)[20] <- "lon"  
colnames(Typeform)[21] <- "lat"  

# Remove all Rows with no Coordinates
Typeform <- Typeform[!is.na(Typeform$lat),]

# Overwrite the ID Column
Typeform$id <- seq(1,dim(Typeform)[1])

# Remove all Entries that are Not in Berlin
# https://www.berlinstadtservice.de/xinh/Postleitzahlen_Berlin.html : Berlin hat die Postleitzahlen 10115 bis 14199
OutsideBerlin <- Typeform[as.numeric(as.character(Typeform$plz))<10115 | as.numeric(as.character(Typeform$plz))>14199,]

# Double-check which are due to Typos and Correct the Postal Numbers & Adresses
Typeform$strasse_nr <- as.character(Typeform$strasse_nr)
Typeform$plz <- as.character(Typeform$plz)

Typeform$strasse_nr[830] <- "Olivaer Platz 16"
Typeform$plz[830] <- "10707"

# Run the command again with the corrections
OutsideBerlin <- Typeform[as.numeric(as.character(Typeform$plz))<10115 | as.numeric(as.character(Typeform$plz))>14199,]

# Remove restaurants outside Berlin
OutsideBerlin$id
Typeform <- Typeform[-c(20,166,251,336,376,573,723,764),]

# Change . for , in Coordinates
Typeform$lon <- gsub("[.]",",",Typeform$lon)
Typeform$lat <- gsub("[.]",",",Typeform$lat)

# Change str., Str., strasse and Strasse for Straße
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
Typeform$strasse_nr <- trim(Typeform$strasse_nr) # Removing White Space Beginning and End of String
Typeform$strasse_nr <- gsub(" str\\. "," Straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub(" str "," Straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub("str "," Straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub(" Str\\. "," Straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub(" Str "," Straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub("-str\\. ","-Straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub("-str ","-Straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub(" Str\\."," Straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub("-Str\\. ","-Straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub("-Str ","-Straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub("str\\.","straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub(" strasse "," Straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub("strasse ","straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub(" Strasse "," Straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub("-Strasse ","-Straße ",Typeform$strasse_nr)
Typeform$strasse_nr <- gsub("  "," ",Typeform$strasse_nr)

# Convert TRUE-FALSE to WAHR-FALSCH 
Typeform <- data.frame(lapply(Typeform, function(x) {gsub("FALSE","FALSCH",x)}))
Typeform <- data.frame(lapply(Typeform, function(x) {gsub("TRUE","WAHR",x)}))

# Removing Duplicates Based on Names and Adresses
Typeform <- Typeform[!duplicated(Typeform[c(1,2)],fromLast=T),] 

Typeform$name <- as.character(Typeform$name)
Typeform$name[269] <- "Cookies Cream/Crackers"

Typeform <- Typeform[-c(207,189,268,202,144,187,251,637,343,111,73,16,82,239,294,8,128,62,157,132,212),]

# Write a CSV File with the Final Output (File Name Contains Current Date and Time)
currentDate <- Sys.Date()
currentTime <- gsub(":","_",substr(Sys.time(), start = 12, stop = 19))

# Change Fon Variable To Character
class(Typeform$fon)
Typeform$fon <- as.character(Typeform$fon)

csvFileName <- paste("/~/Typeform_Clean_",currentDate,"_",currentTime,".csv",sep="")
write.csv(Typeform, file=csvFileName, row.names=FALSE,fileEncoding="UTF-8")
