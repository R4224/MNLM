% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mnlm_planargradient.R
\name{mnlm_planargradient}
\alias{mnlm_planargradient}
\title{Multiple neutral landscape models using planar gradients}
\usage{
mnlm_planargradient(nlayers = 2, r, ncol, nrow, resolution = 1, rescale = TRUE)
}
\arguments{
\item{nlayers}{The number of NLMs to generate.}

\item{r}{The correlation coefficient between the first NLM and each successive NLM.}

\item{ncol}{The number of columns in the rasters .}

\item{nrow}{The number of rows in the rasters.}

\item{resolution}{The resolution of the rasters (default = 1).}

\item{rescale}{If TRUE (default), raster values are scaled from 0 to 1.}
}
\description{
Multiple neutral landscape models using planar gradients
}
\details{
Generates multiple neutral landscape models with linear gradients.
The r argument can accept either a single value, in which case all NLMs produced will have the same correlation with the first layer, or a vector containing the desired correlation coefficients for each layer.
}
\examples{
NLMs <- mnlm_planargradient(nlayers = 3, r = c(0.3, 0.6), ncol = 20, nrow = 20)
}
\references{
Sciaini, M., Fritsch, M., Scherer, C., & Simpkins, C. E. (2018). NLMR and landscapetools: An integrated environment for simulating and modifying neutral landscape models in R. Methods in Ecology and Evolution, 9(11), 2240–2248. doi:10.1111/2041-210X.13076
Palmer, M.W. (1992) The coexistence of species in fractal landscapes. The American Naturalist, 139, 375 - 397.
}
