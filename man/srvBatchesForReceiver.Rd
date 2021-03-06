% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/srvBatchesForReceiver.R
\name{srvBatchesForReceiver}
\alias{srvBatchesForReceiver}
\title{get the batches for a receiver from the data server}
\usage{
srvBatchesForReceiver(deviceID, batchID = 0)
}
\arguments{
\item{deviceID}{integer scalar motus device ID}

\item{batchID}{integer largest batchID already owned for this project.
Default: 0, meaning none.}
}
\value{
data.frame with these columns:
\itemize{
\item batchID integer motus batch ID
\item motusDeviceID integer motus device ID
\item monoBN boot number, for SG receivers; NA for Lotek
\item tsStart first timestamp of data
\item tsEnd last timestamp of data
\item numHits integer number of hits
\item ts real processing timestamp
}
}
\description{
get the batches for a receiver from the data server
}
\author{
John Brzustowski \email{jbrzusto@REMOVE_THIS_PART_fastmail.fm}
}
