% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dbInsertOrReplace.R
\name{dbInsertOrReplace}
\alias{dbInsertOrReplace}
\title{Save records from a data frame into a db table, replacing
existing records when primary keys collide.}
\usage{
dbInsertOrReplace(con, name, df, replace = TRUE)
}
\arguments{
\item{con}{DBI database connection}

\item{name}{name of table to insert or replace records into}

\item{df}{data from which to write data.}

\item{replace}{boolean that determines whether existing records are replaced or ignored.}
}
\value{
no return value
}
\description{
Seems like an obvious missing piece of the DBI.  Ideally,
dbWriteTable would have a boolean 'replace' argument that served
the same purpose; i.e. record-wise overwrite, rather than
table-wise.
}
\author{
John Brzustowski \email{jbrzusto@REMOVE_THIS_PART_fastmail.fm}
}
