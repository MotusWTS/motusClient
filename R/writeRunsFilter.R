#' Write to the local database the probabilities associated with runs for a filter
#'
#' @param src dplyr sqlite src, as returned by \code{dplyr::src_sqlite()}
#'
#' @param filterName unique name given to the filter 
#'
#' @param motusProjID optional project ID attached to the filter in order to share with other users of the same project.
#'
#' @param df dataframe containing the runID and probability values to save in the local database
#'
#' @param overwrite boolean. When TRUE ensures that existing records matching the same filterName 
#' and runID get replaced
#'
#' @param delete boolean. When TRUE, removes all existing filter records associated with the filterName 
#' and re-inserts the ones contained in the dataframe. This option should be used if the dataframe 
#' provided contains the entire set of filters you want to save.
#'
#' @return the integer filterID of the filter deleted
#'
#' @export
#'
#' @author Denis Lepage, Bird Studies Canada

writeRunsFilter <- function(src, filterName, motusProjID=NA, df, overwrite=TRUE, delete=FALSE) {

  sql = function(...) DBI::dbExecute(src$con, sprintf(...))
  
  # determines the filterID
  filterID = getRunsFilterID(src, filterName, motusProjID)
  if (!is.null(filterID)) {
    if (delete) {
      deleteRunsFilter(src, filterName, motusProjID, clearOnly = TRUE)
    }
    df$filterID = filterID

    dbInsertOrReplace(src$con, "runFilers", df, replace=overwrite)
  }
  
  return(filterID)

}