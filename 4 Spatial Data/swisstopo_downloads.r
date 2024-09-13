download_district_shapes <- function() {
  # This function downloads the district polygons for Switzerland from swisstopo.
  
  # Create data directories if they don't exist yet
  dir.create("raw_data", showWarnings = FALSE)
  dir.create("ready_data", showWarnings = FALSE)
  
  # First define the paths. These might need adjustment if you have a different folder structure.
  boundaries_zip <- "raw_data/boundaries.zip"
  district_shape_file <- "ready_data/boundaries/swissTLMRegio_BEZIRKSGEBIET_LV95.shp"
  
  # If the shape-file already exists, we don't need to download it again.
  if (!file.exists(district_shape_file)) {
    # Download the zip file from swisstopo and unpack it.
    download.file("https://data.geo.admin.ch/ch.swisstopo.swisstlmregio/swisstlmregio_2022/swisstlmregio_2022_2056.shp.zip",
                  boundaries_zip)
    unzip(boundaries_zip,
          c("swissTLMRegio_Boundaries_LV95/swissTLMRegio_BEZIRKSGEBIET_LV95.dbf",
            "swissTLMRegio_Boundaries_LV95/swissTLMRegio_BEZIRKSGEBIET_LV95.prj",
            "swissTLMRegio_Boundaries_LV95/swissTLMRegio_BEZIRKSGEBIET_LV95.shp",
            "swissTLMRegio_Boundaries_LV95/swissTLMRegio_BEZIRKSGEBIET_LV95.shx"),
          junkpaths=T, exdir="ready_data/boundaries")
  }
  
  # Read the shape files with SF
  district_shapes <- read_sf(district_shape_file) |> filter(ICC == "CH")
  return(district_shapes)
}

download_postcode_shapes <- function() {
  # This function downloads the postcode polygons for Switzerland from swisstopo.
  
  # Create data directories if they don't exist yet
  dir.create("raw_data", showWarnings = FALSE)
  dir.create("ready_data", showWarnings = FALSE)
  
  # First define the paths. These might need adjustment if you have a different folder structure.
  postcode_zip <- "raw_data/postcode.zip"
  # There are localities and postcodes in the data. These need to be joined.
  locality_shape_file <- "ready_data/AMTOVZ_SHP_LV95/AMTOVZ_LOCALITY.shp"
  postcode_shape_file <- "ready_data/AMTOVZ_SHP_LV95/AMTOVZ_ZIP.shp"
  
  # If the shape-files already exists, we don't need to download it again.
  if (!file.exists(locality_shape_file)) {
    # Download the zip file from swisstopo and unpack it.
    download.file("https://data.geo.admin.ch/ch.swisstopo-vd.ortschaftenverzeichnis_plz/ortschaftenverzeichnis_plz/ortschaftenverzeichnis_plz_2056.shp.zip", 
                  postcode_zip)
    unzip(postcode_zip, exdir="ready_data")
  }
  
  # Read the shape files with SF
  locality_shape <- read_sf(locality_shape_file)
  postcode_shape <- read_sf(postcode_shape_file)
  # Join the locality names and the postcodes
  return(postcode_shape  |> st_join(locality_shape |> select("NAME")))
}
