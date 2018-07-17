
# Reference: https://masalmon.eu/2018/02/22/hexcombine/
library("tidyverse")

paths <-
  fs::dir_ls("data-raw")
img_info <-
  paths[1] %>%
  magick::image_read() %>%
  magick::image_info()
h <- img_info %>% pluck("height")
w <- img_info %>% pluck("width")
n_col <- paths %>% length()
n_row <- 1L
bkgrd <-
  magick::image_blank(width = w * n_col * 2 / 3, height = h * n_row * 1.75, col = "#FFFFFF")
bkgrd
# read_append <- compose(magick::image_read, magick::image_append)
read_append <- . %>%
  magick::image_read() %>%
  magick::image_append()
bkgrd %>%
  magick::image_composite(
    paths %>%
      str_subset("dplyr") %>%
      read_append(),
    offset = paste0("+", 0 * w, "+", 0 * h)
  ) %>%
  magick::image_composite(
    paths %>%
      str_subset("purrr") %>%
      read_append(),
    offset = paste0("+", 0.5 * w, "+", 0.75 * h)
  ) %>%
  magick::image_composite(
    paths %>%
      str_subset("tidyr") %>%
      read_append(),
    offset = paste0("+", 1 * w, "+", 0 * h)
  ) %>%
  magick::image_write(file.path("figs", "banner.png"))
