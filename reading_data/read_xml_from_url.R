ReadXmlFromUrl <- function(fileDataUrl, fileDataDest, zip, downloadData=TRUE) {
  # Downloads an xml file from the given url and saves it to the given
  # destination.  Reads the downloaded file with xmlTreeParse and uses XPATH
  # to filter values.
  #
  # Returns the number of Baltimore restaurants in the given zip.
  #
  # Args:
  #   fileDataUrl: the url containing the data file
  #   fileDataDest: the file name that will contain the data from the url
  #     file will be placed in the data directory
  #   zip: the Baltimore zip code to search for restaurants
  #   downloadData: determines whether the data should be
  #     downloaded, use false if you have previously downloaded the data
  #
  # Returns:
  #   An integer vector containing the number of restaurants in the given zip

  library(XML)
  source("download_data_from_url.r")

  DownloadDataFromUrl(fileDataUrl, fileDataDest, downloadData)

  # Can also download from the URL directly with xmlTreeParse
  doc <- xmlTreeParse(fileDataDest, useInternal=TRUE)
  rootNode <- xmlRoot(doc)

  # generate the XPATH expression to filter "zipcode" xml elements that have
  # the given zipcode value
  expression <- paste("//row/zipcode[text()=",
                      zip,
                      "]",
                      sep="")

  # Get the nodes matching the XPATH expression
  nodes <- getNodeSet(rootNode, expression)
  return(length(nodes))
}

# Tests
# Read the XML data on Baltimore restaurants:
fileDataUrl <- paste("https://d396qusza40orc.cloudfront.net/",
                     "getdata%2Fdata%2Frestaurants.xml",
                     sep="")
fileDataDest <- paste(dataDir,
                      "getdata-data-restaurants.xml",
                      sep="")
ReadXmlFromUrl(fileDataUrl, fileDataDest, 21217)
# [1] 32