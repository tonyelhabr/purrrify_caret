
Introduction
============

See my blog posts (to be linked here) for the full write-ups, or, check out the `.html` file(s) in the `output/` directory in this repo, which was used as the basis for the blog post. The `figs/` directory also contains some of the visualizations in the post.

The documents can be recreated with the following commands:

``` r
# rmarkdown::render("R/01-tea_uil_cors.Rmd", output_dir = "output", intermediates_dir = "output")
paths <-
  list.files(
    path = "R",
    pattern = "Rmd$",
    recursive = FALSE,
    full.names = TRUE
  )
dir_output <- "output"
purrr::map(
  paths[1],
  ~rmarkdown::render(
    .x,
    output_dir = dir_output, 
    intermediates_dir = dir_output
  )
)
```

Highlights
==========

Here are a couple of the coolest visualizations, in my opinion.

![](figs/purrrify_caret-banner.png)

![](figs/viz_summ_diabetes_bymethod.png)
