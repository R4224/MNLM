#' Multiple neutral landscape models using fractal Brownian motion
#'
#' @param nlayers The number of NLMs to generate
#' @param r The correlation coefficient between the first NLM and each successive NLM
#' @param nrow The number of rows in the rasters
#' @param ncol The number of columns in the rasters
#' @param resolution The resolution of the rasters (default = 1)
#' @param fract_dim The fractal dimension of the process (default = 1). Can be set individually for each layer.
#' @param user_seed Set seed for simulation (optional)
#' @param rescale If TRUE (default), raster values are scaled from 0 to 1
#' @details
#' Generates multiple neutral landscape models using fractional Brownian motion, an extension of Brownian motion in which the correlation between steps is controlled by frac_dim.
#' Higher values of frac_dim produce smoother, more correlated surfaces, while lower value produce rougher, less correlated surfaces.
#' The r argument can accept either a single value, in which case all NLMs produced will have the same correlation with the first layer, or a vector containing the desired correlation coefficients for each layer.
#' @examples
#' NLMs <- mnlm_fbm(nlayers = 3, r = c(0.3, 0.6), ncol = 20, nrow = 20)
#' @references
#' Sciaini, M., Fritsch, M., Scherer, C., Simpkins, C. E. (2018). NLMR and landscapetools: An integrated environment for simulating and modifying neutral landscape models in R. Methods in Ecology and Evolution, 9(11), 2240–2248. doi:10.1111/2041-210X.13076
#' Travis, J.M.J. & Dytham, C. (2004). A method for simulating patterns of habitat availability at static and dynamic range margins. Oikos , 104, 410–416.
#' Martin Schlather, Alexander Malinowski, Peter J. Menck, Marco Oesting, Kirstin Strokorb (2015). nlm_fBm. Journal of Statistical Software, 63(8), 1-25. URL http://www.jstatsoft.org/v63/i08/.
#' @importFrom NLMR nlm_fbm
#' @import terra
#' @export
mnlm_fbm <- function(nlayers = 2, r, ncol, nrow, resolution = 1, fract_dim = 1, user_seed = NULL, rescale = TRUE){
  if(length(r) == 1) r <- rep(r, nlayers - 1)
  if(length(fract_dim) == 1) fract_dim <- rep(fract_dim, nlayers)

  # Check that all fractal dimensions are <= 2
  if(any(fract_dim > 2)) {
    stop("All values of 'fract_dim' must be <= 2 for nlm_fbm(). You supplied: ", paste(fract_dim, collapse = ", "))
  }

  for(i in 1:nlayers){
    nlm <- terra::rast(NLMR::nlm_fbm(ncol = ncol, nrow = nrow, resolution = resolution, fract_dim = fract_dim[i], rescale = rescale))
    if(i == 1) nlm.s <- nlm
    else nlm.s <- c(nlm.s, nlm)
  }

  for(j in 2:nlayers){
    s <- c(nlm.s[[1]], nlm.s[[j]])
    newNLM <- rasterQR(s, r[j-1])
    names(newNLM) <- paste0("nlm.", j)
    terra::ext(newNLM) <- terra::ext(nlm.s[[1]]) # Match extents
    nlm.s[[j]] <- newNLM
  }

  names(nlm.s[[1]]) <- "nlm.1"
  message("NLMs generated successfully!")
  return(nlm.s)

}

