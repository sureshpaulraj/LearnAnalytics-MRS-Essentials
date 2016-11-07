## This script configures and attempts to install or download the relevant dependencies for the jupyter notebooks contained within the repository. 
## ASSUMES that this is run from the repository root directory (which can be arbitrarily named)
## The main sections are:
## options
## packages
## datasets that need to be retrieved
## any preprocessing steps that need to be taken

## load some helper functions
## Assumes that it's being run from the repo directory!
source("Resources/00_helper_functions.R") 

## Set Options!
date_to_checkpoint_to <- "2015-11-30" ## approximately the last date associated with the current version of R Open used in MRS/MRC
options(
    stringsAsFactors = FALSE,
    repos = paste0("https://mran.revolutionanalytics.com/snapshot/",date_to_checkpoint_to) ## only set here in case checkpoint is not installed!
)
verbose = FALSE

##############################
## PACKAGES
##############################
## leverage checkpoint!

# make sure checkpoint is installed! Can't use checkpoint *for* checkpoint
if (!require(checkpoint, quietly = !verbose)) {
    # make sure that we're using a relatively recent version of CRAN:
    tryCatch(
        install.packages("checkpoint"),
        error = function(e) stop("installation of checkpoint failed!")
    )
    library(checkpoint)
}

## convert .ipynb files to r scripts so checkpoint can do the necessary work...
## Reason this is necessary is that checkpoint:::scanForPackages() won't check ipynb files.
repo_dir <- get_repo_dir()
nb_files <- list.files(pattern = ".ipynb$", path = repo_dir)
lapply(nb_files, nbconvert_for_scan, verbose = verbose)

## let `checkpoint()` take care of it!
checkpoint(date_to_checkpoint_to, verbose = verbose)

## TODO: add code for packages NOT on MRAN when it becomes necessary! 
## leverage results returned from checkpoint()

##############################
## DATA
##############################
## this section is specifically for setting up relevant datasets!
resources_dir <- file.path(get_repo_dir(), "Resources")
source(file.path(resources_dir, "01_00_data.R"))
create_data(get_repo_dir())

##############################
## preprocessing!
##############################
source(file.path(resources_dir, "02_00_preprocess_function.R"))
# preprocess()

cat("Done with configuration!")