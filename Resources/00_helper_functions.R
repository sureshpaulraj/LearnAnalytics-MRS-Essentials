#' helper functions
# TODO: document with Roxygen

get_repo_dir <- function() {
#' 
    ## script should either be run with the ipynb dir OR in the resources dir as wd.
        ## check for a .ipynb
    cur_nbs <- list.files(pattern = ".ipynb$")
    if (length(cur_nbs) > 0) {
        ## this is the dir!
        return(getwd())
    } else {
        ## if no notebooks found, then check to see if it is in the "Resources" dir,
        if (basename(getwd()) == "Resources") {
            repo_dir <- dirname(getwd())
            cur_nbs <- list.files(pattern = ".ipynb$", path = repo_dir)
            if (length(cur_nbs) > 0) {
                ## this is it!
                return(repo_dir)
            }
        }
    }
    ## if it gets to here - it fails!
    msg <-
            cat("Sourced from",
                getwd(),
                ".\n No notebooks found, and I cannot figure out the locaiton of the notebooks!")
    stop(msg)

}

nbconvert_for_scan <- function(nb, repo_dir = dirname(nb), out_dir = file.path(repo_dir, "Resources", "nbc_Rscripts"), verbose = FALSE) {
    ## needs to know where jupyter is!!!
    nbc_cmd <- paste("jupyter nbconvert --to script", nb)
    ## run it!
    system(nbc_cmd, show.output.on.console = verbose)
    ## clean up and move to appropriate directory:
    if (!file.exists(out_dir)) dir.create(out_dir)
    out_file <- file.path(out_dir, sub(".ipynb$", ".r", basename(nb)))
    file.rename(
        from = sub(".ipynb$", ".r", nb),
        to = out_file
    )
    return(out_file)
}