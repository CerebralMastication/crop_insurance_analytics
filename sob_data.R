


library(tidyverse)

## summary of business files are downloaded from here:
## http://www.rma.usda.gov/data/sob/scc/index.html

## file spec is here: https://www.rma.usda.gov/-/media/RMAweb/SCC-SOB/State-County-Crop-Coverage/sobsccc_1989forward-pdf.ashx?la=en

## records before 1989 use a different record format

# function to grab data from the server and save it locally then load it into a dataframe
load_rma_data <- function(remote = TRUE,
                          years = 1989:2018) {
  
  sob_list <- vector(mode = "list", length = length(years))
  
  ## using i to track which element of sob_list we are popping the
  ## data into
  i <- 1 
  
  for (year in years) {
    if (remote) {
      # download the remote file if remote == true, otherwise assume
      # the data is in the ./data/ directory and properly named
      url <-
        paste0(
          'https://www.rma.usda.gov/-/media/RMAweb/SCC-SOB/State-County-Crop-Coverage/sobcov_',
          year,
          '.ashx'
        )
      dest <- paste0('./data/sobcov_', year, '.zip')
      print(paste("downloading", year, "into ", dest))
      download.file(url, dest)
    }
    
    dest <- paste0('./data/sobcov_', year, '.zip')
    print(paste("importing", year, "from", dest , "into data frame."))
    df_sob <- read_delim(
      dest,
      delim = '|',
      col_names = c(
        'year',
        'stFips',
        'stAbbr',
        'coFips',
        'coName',
        'cropCd',
        'cropName',
        'planCd',
        'planAbbr',
        'coverCat',
        'deliveryType',
        'covLevel',
        'policyCount',
        'policyPremCount',
        'policyIndemCount',
        'unitsReportingPrem',
        'indemCount',
        'quantType',
        'quantNet',
        'companionAcres',
        'liab',
        'prem',
        'subsidy',
        'otherSubsidy',
        'additionalSubsidy',
        'discount',
        'indem',
        'lossRatio'
      ),
      col_types = cols(
        year = col_double(),
        stFips = col_character(),
        stAbbr = col_character(),
        coFips = col_character(),
        coName = col_character(),
        cropCd = col_character(),
        cropName = col_character(),
        planCd = col_character(),
        planAbbr = col_character(),
        coverCat = col_character(),
        deliveryType = col_character(),
        covLevel = col_double(),
        policyCount = col_double(),
        policyPremCount = col_double(),
        policyIndemCount = col_double(),
        unitsReportingPrem = col_double(),
        indemCount = col_double(),
        quantType = col_character(),
        quantNet = col_double(),
        companionAcres = col_double(),
        liab = col_double(),
        prem = col_double(),
        subsidy = col_double(),
        otherSubsidy = col_double(),
        additionalSubsidy = col_double(),
        discount = col_double(),
        indem = col_double(),
        lossRatio = col_double()
      ),
      trim_ws = TRUE
    )
    
    sob_list[[i]] <- df_sob
    i <- i + 1
  }
  
  sob <- bind_rows(sob_list)
  return(sob)
}

# load the data. If this has been run before, the files should be local,
# so set remote = FALSE
sob <- load_rma_data(remote = FALSE, years = 1989:2018)

write_csv(sob, "data/sob_89-18.csv")

sob <- read_csv("data/sob_89-18.csv")

# sanity check
sob %>%
  group_by(year) %>%
  summarize(prem = sum(prem, na.rm=TRUE)) %>% tail


sob %>%
  filter(cropName %in% c("CORN", "SOYBEANS", "WHEAT") &
           stAbbr %in% c("IL","IN","IA","MN","NE") ) %>%
  group_by(
    year,
    stFips,
    stAbbr,
    coFips,
    coName,
    cropCd,
    cropName,
    planCd,
    planAbbr,
    coverCat,
    deliveryType,
    covLevel
  ) %>%
  summarize(liab = sum(liab),
            prem = sum(prem),
            indem = sum(indem)) ->
  sob_limited_group_1


write_csv(sob_limited_group_1, "data/sob_limited_group_1.csv")



