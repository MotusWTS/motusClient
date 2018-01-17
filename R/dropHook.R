#' drop a function from a hook
#'
#' @param hookName character scalar hook hame; must be one of the names
#' in \code{names(Motus$hooks)}.  The name indicates the \code{motusClient} function
#' which is being customized.
#'
#' @param n; position of function on hook.  If omitted, all functions are removed
#' from the hook, otherwise, the `n`th one is removed, if it exists.
#'
#' @note: \code{\link{addHook()}} adds functions to the end of a hook, so the
#' functions on a hook are in order of being added, from earliest to latest.
#' You can get the list of functions on each hook by examining the global
#' variable \code{Motus$hooks}.
#'
#' @return TRUE; if hookName is not valid or there is no hook at position `n` (if supplied),
#' then stops with an error
#'
#' @export
#'
#' @author John Brzustowski \email{jbrzusto@@REMOVE_THIS_PART_fastmail.fm}

dropHook = function(hookName, n) {
    if (is.null(Motus$hooks[[hookName]]))
        stop("invalid hook name")
    if (missing(n)) {
        Motus$hooks[[hookName]] = list()
    } else if (n < 1 || n > length(Motus$hooks[[hookName]])) {
        stop("no function at position ", n, " of hook ", hookName)
    } else {
        Motus$hooks[[hookName]] = Motus$hooks[[hookName]][-n]
    }
    return (TRUE)
}
