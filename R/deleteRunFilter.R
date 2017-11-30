#' Delete a filter  matching a filter name (and optionally a project ID)
#'
#' @param src dplyr sqlite src, as returned by \code{dplyr::src_sqlite()}
#'
#' @param filterName unique name given to the filter 
#'
#' @param motusProjID optional project ID attached to the filter in order to share with other users of the same project.
#'
#' @param clearOnly boolean. When true, only remove the probability records associated with the filter, 
#' but retain the filter itself
#'
#' @return the integer filterID of the filter deleted
#'
#' @export
#'
#' @author Denis Lepage, Bird Studies Canada

deleteRunFilter <- function(src, filterName, motusProjID=NA, clearOnly=FALSE) {

  sql = function(...) DBI::dbExecute(con, sprintf(...))

  # determines the filterID
  filterID = getRunFilterID(src, filterName, motusProjID)
  if (!is.null(filterID)) {

    sql("delete from runFilters where filterID = '%d'", filterID)
    if (!clearOnly) 
      sql("delete from filters where filterID = '%d'", filterID)
    
  }
  
  return(filterID)

}