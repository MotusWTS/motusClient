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
#' @param p.default default probability (default: 1.0) used and returned by this function for detection records with 
#' runID's not referenced in the filter. When p.default >= p.min, all records not listed in your filter will be returned.
#' When p.default < p.min, all records not listed in your filter will be excluded.
#'
#' @return a dplyr tbl object referencing the results from alltags, and including the probability from the specified filter
#'
#' @export
#'
#' @author Denis Lepage, Bird Studies Canada

applyRunsFilter = function(src, filterName, motusProjID=NA, p.min=0, where.stmt=NA, p.default=1.0) {

  # sqlq = function(...) DBI::dbGetQuery(src$con, sprintf(...))
  
  # determines the filterID
  filterID = getRunsFilterID(src, filterName, motusProjID)
  if (!is.null(filterID)) {

    if (is.na(where.stmt)) where.stmt = ""
    else where.stmt = paste(" AND ", where.stmt, sep="")
    
	return(dplyr::tbl(src, sql(sprintf("select * from (select a.*, IFNULL((SELECT probability from runsFilters b where a.runID = 
    b.runID and a.motusTagID = b.motusTagID and filterID = %d),%f) as probability from alltags a) tbl where IFNULL(probability,%f) >= %f %s", 
    filterID, p.default, p.default, p.min, where.stmt))))
                                 
  }
  
}