#' Multiple neutral landscape models using Perlin noise
#'
#' @param nlayers The number of NLMs to generate
#' @param r The correlation coefficient between the first NLM and each successive NLM
#' @param nrow The number of rows in the rasters
#' @param ncol The number of columns in the rasters
#' @param frequency Determines the granularity of the features in the noise
#' @param interpolator Determines how values between sampled points be calculated. Options are 'linear', 'hermite', or 'quintic' (default), ranging from lowest to highest quality.
#' @param fractal The fractal type to use. Options are 'none', 'fbm' (default), 'billow', or 'rigid-multi'. It is suggested that you experiment with the different types to get a feel for how they behaves.
#' @param octaves The number of noise layers used to create the fractal noise. Ignored if fractal = 'none'. Can be set individually for each layer.
#' @param lacunarity The frequency multiplier between successive noise layers when building fractal noise. Ignored if fractal = 'none'. Can be set individually for each layer.
#' @param gain The relative strength between successive noise layers when building fractal noise (default = 0.5). Ignored if fractal = 'none'. Can be set individually for each layer.
#' @param pertubation The pertubation to use. Either 'none' (default), 'normal', or 'fractal'. Defines the displacement (warping) of the noise, with 'normal' giving a smooth warping and 'fractal' giving a more erratic warping.
#' @param pertubation_amplitude The maximal pertubation distance from the origin (default = 1). Ignored if pertubation = 'none'. Can be set individually for each layer.
#' @details
#' Generates multiple neutral landscape models using perlin noise, a well known gradient noise algorithm that has been used extensively for generating landscapes.
#' The r argument can accept either a single value, in which case all NLMs produced will have the same correlation with the first layer, or a vector containing the desired correlation coefficients for each layer.
#' @examples
#' NLMs <- mnlm_perlin(nlayers = 3, r = c(0.3, 0.6), ncol = 20, nrow = 20)
#' @references Perlin, Ken (1985). An Image Synthesizer. SIGGRAPH Comput. Graph. 19 (0097-8930): 287–296. doi:10.1145/325165.325247.
#' @importFrom ambient noise_perlin
#' @import terra
#' @export
mnlm_perlin <- function(nlayers = 2, r, ncol, nrow, frequency = 0.01, interpolator = "quintic", fractal = "fbm", octaves = 3,
                        lacunarity = 2, gain = 0.5, pertubation = "none", pertubation_amplitude = 1){
  if(length(r) == 1) r <- rep(r, nlayers - 1)
  if(length(frequency) == 1) frequency <- rep(frequency, nlayers)
  if(length(octaves) == 1) octaves <- rep(octaves, nlayers)
  if(length(lacunarity) == 1) lacunarity <- rep(lacunarity, nlayers)
  if(length(gain) == 1) gain <- rep(gain, nlayers)
  if(length(pertubation_amplitude) == 1) pertubation_amplitude <- rep(pertubation_amplitude, nlayers)

  for(i in 1:nlayers){
    nlm <- terra::rast(ambient::noise_perlin(dim = c(ncol, nrow), frequency = frequency[i], interpolator = interpolator, fractal = fractal,
                                             octaves = octaves[i], lacunarity = lacunarity[i], gain = gain[i], pertubation = pertubation,
                                             pertubation_amplitude = pertubation_amplitude[i]))
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
  return(nlm.s)

}

