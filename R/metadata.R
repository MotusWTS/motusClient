#' update entire metadata for receivers and tags from Motus server. Contrary to tagme, 
#' this function retrieves the entire set of metadata for tags and receivers, and not only those 
#' pertinent to the detections of your local file.
#'
#' @param src src_sqlite object representing the database (either tag or receiver)
#'
#' @param projectIDs optional integer vector of Motus projects IDs for which metadata should
#' be obtained; default: NULL, meaning obtain metadata for all tags and receivers that your permissions 
#' allow.  
#'
#' @param replace logical scalar; if TRUE (default), existing data replace the existing metadata with the newly acquired ones. 
#'
#' @param delete logical scalar; Defaut = FALSE. if TRUE, the entire metadata tables are cleared (for all projects) before re-importing the metadata. 
#'
#' @seealso \code{\link{tagme}} provides an option to update only the metadata relevant to a specific 
#' project or receiver file.
#'
#' @export
#'
#' @author Denis Lepage, Bird Studies Canada

metadata = function(src, projectIDs=NULL, replace=TRUE, delete=FALSE) {

    sql = function(...) DBI::dbExecute(src$con, sprintf(...))
    if (delete) {
      cat("Deleting local copy of Motus metadata\r\n")
      sql("delete from species")
      sql("delete from projs")
      sql("delete from tagDeps")
      sql("delete from tagProps")
      sql("delete from tags")
      sql("delete from antDeps")
      sql("delete from recvDeps")
      sql("delete from recvs")
    }
    
    cat("Loading complete Motus metadata\r\n")
    if (!is.null(projectIDs))
      cat(sprintf("Project # %s\r\n", paste(projectIDs,collapse=", ")))
    
    ## get metadata for tags, their deployments, and species names
    tmeta = srvTagMetadataForProjects(projectIDs=projectIDs)
  	dbInsertOrReplace(src$con, "tags", tmeta$tags, replace)
  	dbInsertOrReplace(src$con, "tagDeps", tmeta$tagDeps, replace)
  	dbInsertOrReplace(src$con, "tagProps", tmeta$tagProps, replace)
  	dbInsertOrReplace(src$con, "species", tmeta$species, replace)
  	dbInsertOrReplace(src$con, "projs", tmeta$projs, replace)
  	## update tagDeps.fullID
  	DBI::dbExecute(src$con, "update tagDeps set fullID = (select printf('%s#%s:%.1f@%g(M.%d)', t3.label, t2.mfgID, t2.bi, t2.nomFreq, t2.tagID)
      from tags as t2 join projs as t3 on t3.id = tagDeps.projectID where t2.tagID = tagDeps.tagID limit 1)")

    ## get metadata for receivers and their antennas
  	rmeta = srvRecvMetadataForProjects(projectIDs)
  	dbInsertOrReplace(src$con, "recvDeps", rmeta$recvDeps, replace)
  	dbInsertOrReplace(src$con, "recvs", rmeta$recvDeps[,c("deviceID", "serno")], replace)
  	dbInsertOrReplace(src$con, "antDeps", rmeta$antDeps, replace)
  	dbInsertOrReplace(src$con, "projs", rmeta$projs, replace)
  	cat("Done\r\n")
}
