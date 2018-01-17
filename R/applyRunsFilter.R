#' Returns a dataframe of all detections matching the filter conditions. Filters are a list of runID that the user can 
#' build for the purpose of excluding specific runs from the resulting dataframe.
#'
#' @param src dplyr sqlite src, as returned by \code{dplyr::src_sqlite()}
#'
#' @param filterName unique name given to the filter 
#'
#' @param motusProjID optional project ID attached to the filter in order to share with other users of the same project.
#'
#' @param p.min the minimum probability returned (p.min = 0: no filter applied)
#'
#' @param where.stmt where statement in SQL format (e.g. where.stmt="motusTagID = 12345 AND runLen >= 4")
#'
#' @return a dataframe containing the results from alltags, matching the specified filter conditions
#'
#' @export
#'
#' @author Denis Lepage, Bird Studies Canada

applyRunsFilter = function(src, filterName, motusProjID=NA, p.min=0, where.stmt=NA) {

  sqlq = function(...) DBI::dbGetQuery(src$con, sprintf(...))
  
  # determines the filterID
  filterID = getRunsFilterID(src, filterName, motusProjID)
  if (!is.null(filterID)) {

    if (is.na(where.stmt)) where.stmt = ""
    else where.stmt = paste(" AND ", where.stmt, sep="")
    
    return (sqlq("select * from (select a.*, (SELECT probability from runsFilters b where a.runID = 
        b.runID and a.motusTagID = b.motusTagID and filterID = %d) as probability from alltags a) tbl where IFNULL(probability,1) >= %f %s", 
        filterID, p.min, where.stmt))
                                 
  }
  
}