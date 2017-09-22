#' get information about the motus data server API
#'
#' The deviceID is returned for any serial number of a receiver deployed
#' by a project you have permissions to.
#'
#' @return
#' a list with (at least) these items:
#' \itemize{
#'    \item maxRows; integer; maximum number of rows returned by any API calls
#' }
#'
#' @export
#'
#' @author John Brzustowski \email{jbrzusto@@REMOVE_THIS_PART_fastmail.fm}

srvAPIinfo = function() {
    return(srvQuery(API=Motus$API_API_INFO, params=list(), auth=FALSE))
}
