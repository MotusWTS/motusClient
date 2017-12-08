#' update the metadata for receivers and tags in a motus tag detection database.
#' only available by tag project ID (not for receiver databases). Updates all existing
#' metadata previously loaded. This function allows to load all metadata associated 
#' with a project, instead of only those that are relevant to the detections
#' in the current database, as per the \link{\code{tagme}} function.
#'
#' @param projID integer scalar project code from motus.org
#'
#' @param dir: path to the folder where you are storing databases
#' Default: the current directory; i.e. \code{getwd()}
#'
#' @param tsBegin float optional start timestamp to load metadata
#'
#' @param tsEnd float optional end timestamp to load metadata
#'
#' @param allRecv logical boolean; if TRUE, request metadata for all receivers 
#' across all projects, based on the user permissions
#'
#' @author Denis Lepage, Bird Studies Canada

metadata = function(projID, dir=getwd(), tsBegin=NULL, tsEnd=NULL, allRecv=FALSE) {

    if (length(projID) != 1 || (! is.numeric(projID)))
        stop("You must specify an integer project ID.")

    if (missing(projID)) {
        ## special case: update all existing databases in \code{dir}
        return(lapply(dir(dir, pattern="\\.motus$"),
                      function(f) {
                          metadata(projID=sub("\\.motus$", "", f), dir=dir, tsBegin=tsBegin, tsEnd=tsEnd, allRecv=allRecv)
                      }))
    }

    dbname = getDBFilename(projID, dir)
    have = file.exists(dbname)
    if (! new && ! have)
        stop("Database ", dbname, " does not exist.\n",
             "Maybe you just need to specify 'dir=' to tell me where to find it?"
             )
    rv = dplyr::src_sqlite(dbname, create=FALSE)

    ## get metadata for tags, their deployments, and species names
    tmeta = srvMetadataForTagsByProject(projID=projID)
    dbInsertOrReplace(sql$con, "tags", tmeta$tags)
    dbInsertOrReplace(sql$con, "tagDeps", tmeta$tagDeps)
    dbInsertOrReplace(sql$con, "species", tmeta$species)
    dbInsertOrReplace(sql$con, "projs", tmeta$projs)
    ## update tagDeps.fullID
    sql("
update
   tagDeps
set
   fullID = (
      select
         printf('%s#%s:%.1f@%g(M.%d)', t3.label, t2.mfgID, t2.bi, t2.nomFreq, t2.tagID)
      from
         tags as t2
         join projs as t3 on t3.id = tagDeps.projectID
      where
         t2.tagID = tagDeps.tagID
      limit 1
   )
")
    
	if (allRecv) projID = NULL
	
    ## get metadata for receivers and their antennas
    rmeta = srvMetadataForReceiversByProject(projID)
    dbInsertOrReplace(sql$con, "recvDeps", rmeta$recvDeps)
    dbInsertOrReplace(sql$con, "recvs", rmeta$recvDeps[,c("deviceID", "serno")])
    dbInsertOrReplace(sql$con, "antDeps", rmeta$antDeps)
    dbInsertOrReplace(sql$con, "projs", rmeta$projs)

    return(rv)
}
