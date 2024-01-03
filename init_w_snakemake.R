library(purrr)
try_create_dir <- \(dir){if(!dir.exists(dir)){dir.create(dir)}}

init_project <- \(name,
                  path = "~/Desktop",
                  from_scratch = TRUE,
                  template_dir = "~/work/software/R/init_project/templates",
                  author = "XX_AUTHOR_XX",
                  init_git = TRUE){
  path_full <- file.path(path, name)
  
  
  if(from_scratch){
    if(dir.exists(path_full)){stop("Will not overrided exisiting directory - aborted!")}
    dir.create(path_full)
  }
  
  if(!file.exists(file.path(path_full, paste0(name, ".Rproj")))){
    usethis::create_project(path_full, open = FALSE)
  }
  
  path_code <- file.path(path_full, "code")
  path_logs <- file.path(path_code, "logs")
  path_sm <- file.path(path_code, "workflow")
  path_smk <- file.path(path_sm, "rules")
  path_env <- file.path(path_sm, "env")
  path_data <- file.path(path_full, "data")
  path_results <- file.path(path_full, "results")
  path_sh <- file.path(path_code, "sh")
  path_metadata <- file.path(path_full, "data", "metadata")
  path_img <- file.path(path_results, "img")
  path_py <- file.path(path_code, "py")
  path_bench <- file.path(path_code, "benchmark")
  
  list(path_code, path_logs,
       path_py, path_bench,
       path_sm,
       path_smk,
       path_env,
       path_results, path_img,
       path_data, path_results,
       path_metadata,
       path_sh) |>
    walk(try_create_dir)
  
  if(dir.exists( file.path(path_full, "R"))){ ff::file.move(from = file.path(path_full, "R"), file.path(path_code, "R")) }
  
  readr::read_lines(file.path(template_dir, "contributors.yml")) |>
    stringr::str_replace("XX_NAME_XX", name) |>
    stringr::str_replace("XX_AUTHOR_XX", author )|>
    stringr::str_replace("XX_DATE_XX", as.character(Sys.Date())) |> 
    readr::write_lines(file = file.path(path_metadata, "contributors.yml"))
  
  svg(filename = file.path(path_img, "logo.svg"),
      width = 240/300,
      height = 275/300,
      bg = 'transparent'); grid::grid.circle();dev.off()
  
  if(!file.exists(file.path(path_full, "README.md"))){
    readr::write_lines(x = c(paste0('# ', name,
                                    ' <img src="results/img/logo.svg" align="right" alt="" width="120" />'),
                             "", paste0("**Author:** ", author)),
                       file = file.path(path_full, "README.md"))
  }
  
  tidyr::tribble(
    ~source, ~target_dir,
    "snakefile", path_sm,
    "config.yml", path_sm,
    "r_tidy.yml", path_env,
    "template.smk", path_smk,
    "make_launch_dir.sh", path_sh
  ) |> 
    pwalk(.f = \(source, target_dir){ 
      file.copy(file.path(template_dir, source),
                file.path(target_dir, source))
      })
  
  if(init_git){
    if(Sys.which("git") != ""){
      file.copy(file.path(template_dir, ".gitignore"),
                file.path(path_full, ".gitignore"),
                overwrite = TRUE)
      system(paste0("cd ", path_full, 
                    " && git init && git add . && git commit -m 'setup base structure' && cd -"))
    } else {cat("git not found!")}
  }
}

init_project(name = "arcgaz_ml_temporal", path = "~/work/hoffman_lab/arcgaz_SPP/", author = "Kosmas Hench")
