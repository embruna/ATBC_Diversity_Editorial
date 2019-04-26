Country.Codes <- function(DATASET) {
  
  # DATA CLEANUP
  
  #Remove (trim) the leading and trailing white spaces (not can do with one command as per: http://stackoverflow.com/questions/2261079/how-to-trim-leading-and-trailing-whitespace-in-r)
  trim.trailing <- function (x) sub("\\s+$", "", x)
  DATASET$country<-trim.trailing(DATASET$country)
  trim.leading <- function (x)  sub("^\\s+", "", x)
  DATASET$country<-trim.leading(DATASET$country)
  
  # remove any double spaces
  DATASET$country<-gsub("  ", " ", DATASET$country, fixed=TRUE)
  
  # USING COUNTRY NAMES AND Package "countrycode" TO ADD A COLUMN WITH THE 3 DIGIT CODE 
  
  library(countrycode)
  
  # ELIMINATE ANY ROWS WITH BLANKS IN THE 
  # DATASET=Author.Geo for debugging purposes only
  # DATASET<-subset(DATASET, country!="Unknown")
  
  # Chnage countries as needed, either because country names have changed or to reflect political organization

  DATASET$country[DATASET$country == "Scotland"]  <- "United Kingdom" 
  DATASET$country[DATASET$country == "SCOTLAND"]  <- "United Kingdom"  
  DATASET$country[DATASET$country == "Wales"]  <- "United Kingdom"
  DATASET$country[DATASET$country == "WALES"]  <- "United Kingdom"
  DATASET$country[DATASET$country == "ENGLAND"]  <- "United Kingdom"
  DATASET$country[DATASET$country == "England"]  <- "United Kingdom"
  DATASET$country[DATASET$country == "NORTH IRELAND"]  <- "United Kingdom" 
  DATASET$country[DATASET$country == "NORTHERN IRELAND"]  <- "United Kingdom"  
  DATASET$country[DATASET$country == "N. Ireland"]  <- "United Kingdom"  
  DATASET$country[DATASET$country == "Northern Ireland"]  <- "United Kingdom"  
  DATASET$country[DATASET$country == "German Democratic Republic"]  <- "Germany" #removing old names
  DATASET$country[DATASET$country == "US"]  <- "USA" #in case any snuck in
  DATASET$country[DATASET$country == "Yugoslavia"]  <- "Croatia" #Authors from Pretinac
  # DATASET$country[DATASET$country == "French Guiana"]  <- "France" 
  
  #WOS DATA COME CAPITALIZED, THIS CORRECTS DSOME OF THE ODD ONES
  DATASET$country[DATASET$country == "BOPHUTHATSWANA"]  <- "South Africa"
  DATASET$country[DATASET$country == "BYELARUS"]  <- "Belarus"
  DATASET$country[DATASET$country == "CISKEI"]  <- "South Africa"
  DATASET$country[DATASET$country == "ENGLAND"]  <- "England"
  DATASET$country[DATASET$country == "YEMEN ARAB REP"]  <- "Yemen"
  DATASET$country[DATASET$country == "WALES"]  <- "Wales"
  DATASET$country[DATASET$country == "TRANSKEI"]  <- "South Africa"
  DATASET$country[DATASET$country == "NETH ANTILLES"]  <- "Netherland Antilles"
  DATASET$country[DATASET$country == "MONGOL PEO REP"]  <- "Mongolia"
  DATASET$country[DATASET$country == "FR POLYNESIA"]  <- "French Polynesia"
  DATASET$country[DATASET$country == "FED REP GER"]  <- "Germany"
  DATASET$country[DATASET$country == "GER DEM REP"]  <- "Germany"
  DATASET$country[DATASET$country == "GUINEA BISSAU"]  <- "GUINEA-BISSAU"
  DATASET$country[DATASET$country == "PAPUA N GUINEA"]  <- "Papua New Guinea"  
  DATASET$country[DATASET$country == "W IND ASSOC ST"]  <- NA
  DATASET$country[DATASET$country == "MICRONESIA"]  <- "Federated States of Micronesia"    
  DATASET$country[DATASET$country == "CENT AFR REPUBL"]  <- "Central African Republic"    
  
  # West Indies Associated States: collective name for a number of islands in
  # Eastern Caribbean whose status changed from being British colonies to states 
  # in free association with the United Kingdom in 1967. 
  # Included Antigua, Dominica, Grenada, Saint Christopher-Nevis-Anguilla, 
  # Saint Lucia, and Saint Vincent.
  # Treat as NA for now because would need to check each authors home island
  
  #step3: change all the country names to the codes used in mapping
  #Add a column with the 3 letter country codes to be consistent with the other datasets
  #Maptools uses the ISO 3166 three letter codes: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3
  #The packahge countrycode will take your column of country names and convert them to ISO3166-3 Codes
  #I began by checking the values of COUNTRY to see if there are any mistakes. To do so I just created a vector 
  
  #called CODECHECK
  
  DATASET$geo.code<-countrycode(DATASET$country, "country.name", "iso3c", warn = TRUE)
  #By setting "warn=TRUE" it will tell you which ones it couldn't convert. Because of spelling mistakes, etc.

  DATASET$geo.code<-as.factor(DATASET$geo.code)

  #Deleting rows without country
  # DATASET <- DATASET[!is.na(DATASET$geo.code),] 
  
  # You can correct these as follows in the dataframe with all the data, then add a 
  # new column to the dataframe with the country codes
  
  return(DATASET)
  
}
  