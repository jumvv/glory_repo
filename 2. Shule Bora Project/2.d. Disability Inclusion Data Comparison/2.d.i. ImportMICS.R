# =========================================================================== #
# Set up local workspace.
# =========================================================================== #
rm( list = ls() ) # Clear working memory.

# Where are we?  Specify present file and caller file.  ----------
PresentFile = "SN001Import.R"
if ( exists( "CallerFile" ) ) { # If this file was called by some other file:
  TempCallerFile = CallerFile # Save the calling file's name.
  CallerFile = PresentFile 
} else { 
  if ( exists( "TempCallerFile" ) ) rm( TempCallerFile )
  CallerFile = PresentFile 
}

# Load paths. ----------
require( rstudioapi ); setwd( dirname( getActiveDocumentContext()$path ) )
# (Can also run first: ~/Do/SN000Path.R.)
require( here ); source( here( getwd(), "SN000Path.R" ) ) # Load path variables
# require( here ); source( here( getwd(), "SN001CleanHelper.R" ) ) # Load path variables

# Start logging. ----------
# Connection = file( here( PathDo, paste0( CallerFile, ".log" ) ) )
# sink( Connection, split = TRUE ) # Log print messages.
# sink( Connection, append = TRUE, type = "message" ) # Log error messages.

# Start time. ----------
require( tictoc ); tic( CallerFile ) 
require( conflicted ) # to resolve conflicts between function names across packages
conflicts_prefer( dplyr::filter )

# Load packages. ----------
Packages = c( # n: Description (check each printed output to see if loaded correctly)
  "haven" # 1: converting Stata/SPSS datasets to/from R
  , "foreign" # 2: 
  , "dplyr" # 3: 
  , "janitor" # 4: for cleaning variable names for Stata
  , "declared" # 5: 
  , "DDIwR" # 7: Useful functions for various DDI (Data Documentation Initiative) related inputs and outputs. Converts data files to and from DDI, SPSS, Stata, SAS, R and Excel, including user declared missing values.
) 

# install.packages( Packages ) # Use this line to install missing packages.
suppressPackageStartupMessages( { lapply( 
  Packages, require, character.only = TRUE ) } )

# =========================================================================== #
# Load SPSS file and save in .dta ----------
# =========================================================================== #

CountryNames = c(
  "Malawi"
  , "Ghana"
  , "Zimbabwe"
  , "Lesotho"
  , "Madagascar"
  , "Nigeria"
  , "Sao Tome and Principe"
  , "Central African Republic"
  , "Guinea Bissau"
  , "Togo"
  , "DRCongo"
  , "Chad"
  , "Sierra Leone"
  , "The Gambia"
  , "State of Palestine"
  , "Algeria"
  , "Iraq"
  , "Tunisia"
  , "Uzbekistan"
  , "Kosovo (UNSCR 1244) (Roma, Ashkali and Egyptian Communities)"
  , "Kosovo (UNSCR 1244)"
  , "Belarus"
  , "Serbia"
  , "Serbia (Roma Settlements)"
  , "Turkmenistan"
  , "Republic of North Macedonia"
  , "Republic of North Macedonia (Roma Settlements)"
  , "Georgia"
  , "Kyrgyzstan"
  , "Montenegro"
  , "Argentina"
  , "Guyana"
  , "Turks and Caicos Islands"
  , "Cuba"
  , "Dominican Republic"
  , "Honduras"
  , "Costa Rica"
  , "Suriname"
  , "Afghanistan"
  , "Pakistan (Baluchistan)"
  , "Pakistan Khyber Pakhtunkhwa"
  , "Pakistan Sindh"
  , "Pakistan Punjab"
  , "Bangladesh"
  , "Nepal"
  , "Thailand"
  , "Fiji"
  , "Viet Nam"
  , "Samoa"
  , "Tuvalu"
  , "Tonga"
  , "Kiribati"
  , "Mongolia"
  , "Lao PDR"
)

# # For debugging
# CountryNames = c(
#   "DRCongo"
# )
# # For debugging
# CountryNames = c(
#   "Lao PDR"
# )

CountryCounter = 0
for ( CountryName in CountryNames ) {
  tic()
  CountryCounter = CountryCounter + 1
  
  ReadFileStub = paste0( CountryName, " MICS6 SPSS Datasets/fs.sav" )
  
  ReadData = read_sav( file.path( PathDataRaw, ReadFileStub ) )
  
  # clean variable names with janitor
  ReadData = janitor::clean_names( ReadData )
  # clean variable/value lables with  DDIwR
  ReadData = as.declared( ReadData )
  
  # Check if CountryName has space, prepare replacing with underscore
  if ( length( strsplit( CountryName, split = " " )[[ 1 ]] ) > 1 ) {
    CountryNameUnderscored = gsub( " ", "_", CountryName )
  }
  # For Kosovo the output file name is different
  if ( CountryName == "Kosovo (UNSCR 1244) (Roma, Ashkali and Egyptian Communities)" ) {
    CountryName == "Kosovo1"
  }
  if ( CountryName == "Kosovo (UNSCR 1244)" ) {
    CountryName == "Kosovo2"
  }
  if ( CountryName == "Serbia" ) {
    CountryName == "Serbia1"
  }
  if ( CountryName == "Serbia (Roma Settlements)" ) {
    CountryName == "Serbia2"
  }
  if ( CountryName == "Republic of North Macedonia" ) {
    CountryName == "Republic_of_North_Macedonia1"
  }
  if ( CountryName == "Republic of North Macedonia (Roma Settlements)" ) {
    CountryName == "Republic_of_North_Macedonia2"
  }
  if ( CountryName == "Montenegro" ) {
    CountryName == "Montenegro1"
  }
  if ( CountryName == "Montenegro (Roma Settlements)" ) {
    CountryName == "Montenegro2"
  }
  if ( CountryName == "Pakistan (Baluchistan)" ) {
    CountryName == "Pakistan1"
  }
  if ( CountryName == "Pakistan Khyber Pakhtunkhwa" ) {
    CountryName == "Pakistan2"
  }
  if ( CountryName == "Pakistan Sindh" ) {
    CountryName == "Pakistan3"
  }
  if ( CountryName == "Pakistan Punjab" ) {
    CountryName == "Pakistan4"
  }
  # Replace space in CountryName with underscore
  if ( length( strsplit( CountryName, split = " " )[[ 1 ]] ) > 1 ) {
    CountryName = CountryNameUnderscored
  }
  
  WriteFileStub = paste0( CountryName, "_cfm.dta" )  
  
  
  write_dta( 
    ReadData, file.path( PathDataIntermediate, WriteFileStub ), version = 14
  )
  
  CounterStub = paste0( CountryCounter, "/", length( CountryNames ) )
  toc()
  print( paste0( 
    "Written ", CounterStub, ": ", file.path( PathDataIntermediate, WriteFileStub ) 
    ) )
}

# # For debugging
# CountryName = "DRCongo"
# ReadFileStub = paste0( CountryName, " MICS6 SPSS Datasets/fs.sav" )
# ReadData = read_sav( file.path( PathDataRaw, ReadFileStub ) )
# ReadData = janitor::clean_names( ReadData )
# ReadData = as.declared( ReadData )
# WriteFileStub = paste0( CountryName, "_cfm.dta" )  
# write_dta( 
#   ReadData, file.path( PathDataIntermediate, WriteFileStub ), version = 14
# )

