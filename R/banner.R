
# Reference: https://masalmon.eu/2018/02/22/hexcombine/
library("tidyverse")

paths_hex <-
  # fs::dir_ls("data-raw")
  list.files(
    "data-raw",
    pattern = "dplyr|purrr|tidyr",
    recursive = FALSE,
    full.names = TRUE
  )
path_plus <-
  list.files(
    "data-raw",
    pattern = "plus",
    recursive = FALSE,
    full.names = TRUE
  )
path_caret <-
  list.files(
    "data-raw",
    pattern = "caret",
    recursive = FALSE,
    full.names = TRUE
  )

read_info <- . %>%
  magick::image_read() %>%
  magick::image_info()

img_info_hex <-
  paths_hex[1] %>%
  read_info()

h_hex_scaling <- 1.75
h_hex <- img_info_hex %>% pluck("height")
w_hex <- img_info_hex %>% pluck("width")

img_info_plus <-
  path_plus %>%
  read_info()
img_info_caret <-
  path_caret %>%
  read_info()

h_plus <- img_info_plus %>% pluck("height")
w_plus <- img_info_plus %>% pluck("width")
h_caret <- img_info_caret %>% pluck("height")
w_caret <- img_info_caret %>% pluck("width")

ratio_h_plus <- (h_hex * h_hex_scaling) / h_plus
ratio_h_caret <- (h_hex * h_hex_scaling) / h_caret

h_plus_resized <- h_plus * ratio_h_plus
w_plus_resized <- w_plus * ratio_h_plus
h_caret_resized <- h_caret * ratio_h_caret
w_caret_resized <- w_caret * ratio_h_caret

img_plus_resized <-
  path_plus %>%
  magick::image_read() %>%
  magick::image_resize(paste0(w_plus_resized, "x", h_plus_resized))
img_plus_resized
img_caret_resized <-
  path_caret %>%
  magick::image_read() %>%
  magick::image_resize(paste0(w_caret_resized, "x", h_caret_resized))
img_caret_resized

bkgrd <-
  magick::image_blank(
    width = w_hex * 2 + w_plus_resized + w_caret_resized,
    height = h_hex * h_hex_scaling,
    col = "#FFFFFF"
  )
bkgrd
# read_append <- compose(magick::image_read, magick::image_append)
# read_append <- compose(magick::image_read, magick::image_append)
read_append <- . %>%
  magick::image_read() %>%
  magick::image_append()

path_banner <- file.path("figs", "banner.png")
bkgrd %>%
  magick::image_composite(
    paths_hex %>%
      str_subset("dplyr") %>%
      read_append(),
    offset = paste0("+", 0 * w_hex, "+", 0 * h_hex)
  ) %>%
  magick::image_composite(
    paths_hex %>%
      str_subset("purrr") %>%
      read_append(),
    offset = paste0("+", 0.5 * w_hex, "+", 0.75 * h_hex)
  ) %>%
  magick::image_composite(
    paths_hex %>%
      str_subset("tidyr") %>%
      read_append(),
    offset = paste0("+", 1 * w_hex, "+", 0 * h_hex)
  ) %>%
  magick::image_composite(
    img_plus_resized %>%
      magick::image_append(),
    offset = paste0("+", 2 * w_hex, "+", 0 * h_hex)
  ) %>%
  magick::image_composite(
    img_caret_resized %>%
      magick::image_append(),
    offset = paste0("+", 2 * w_hex + w_plus_resized, "+", 0 * h_hex)
  ) %>%
  magick::image_write(path_banner)
