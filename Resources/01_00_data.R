## does any relevant preprocessing.
## naming convention is
## DD_DD_preprocess.R
##    DD - overall order of groups
##    DD - order within that group
## For this file, it takes the relevant datasets in the nycflights13
## package and writes them to csv files in the data directory


## function to create_data
create_data <- function(repo_dir = NULL, verbose = FALSE) {
    ## if it's null, check for some directories...
    if (is.null(repo_dir)) {
        repo_dir <- get_repo_dir()
    }
    data_dir <- file.path(repo_dir, "data")
    dir.create(data_dir, showWarnings = verbose)
    ## adjust below to create the relevant data files
    if (!require(nycflights13)) {
        stop("The package nycflights13 is required to create the data used for this library! Checkpoint should fix this...")
    }
    ## first create airports.csv:
    airports_csv <- file.path(data_dir, "airports.csv")
    if (!file.exists(airports_csv)) { 
        if (verbose) {
            cat("Creating", airports_csv, "...")
        }
        write.csv(x = nycflights13::airports,
              file = airports_csv,
              quote = FALSE,
              row.names = FALSE)
    } else {
        if (verbose) {
            cat("File", airports_csv, "already exists. Skipping.")
        }    
    }
    ## split the nycflights13::flights into a couple of files:

    ## next create the 2 flights datasets (but only if they don't exist already!!)
    flights_csv <- file.path(data_dir, "flights_q1.csv")
    if (!file.exists(flights_csv)) {
        if (verbose) {
            cat("Creating", flights_csv, "...")
        }
        write.csv(x = subset(nycflights13::flights, month <= 3),
              file = flights_csv,
              quote = FALSE,
              row.names = FALSE)
    } else {
        if (verbose) {
            cat("File", flights_csv, "already exists. Skipping.")
        }
    }

    flights_csv <- file.path(data_dir, "flights_q234.csv")
    if (!file.exists(flights_csv)) {
        if (verbose) {
            cat("Creating", flights_csv, "...")
        }
        write.csv(x = subset(nycflights13::flights, month > 3),
              file = flights_csv,
              quote = FALSE,
              row.names = FALSE)
    } else {
        if (verbose) {
            cat("File", flights_csv, "already exists. Skipping.")
        }
    }

    if(verbose) cat("Done with data!\n")
    invisible(NULL)
}

