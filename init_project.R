library(purrr)
try_create_dir <- \(dir){if(!dir.exists(dir)){dir.create(dir)}}

init_project <- \(name,
                  path = "~/Desktop",
                  from_scratch = TRUE,
                  template_dir = "~/work/software/R/init_project/templates",
                  author = "XX_AUTHOR_XX",
                  init_git = FALSE){
  path_full <- file.path(path, name)
 
  
  if(from_scratch){
    if(dir.exists(path_full)){stop("Will not overrided exisiting directory - aborted!")}
    dir.create(path_full)
  }
  
  if(!file.exists(file.path(path_full, paste0(name, ".Rproj")))){
    usethis::create_project(path_full, open = FALSE)
  }
  
  path_code <- file.path(path_full, "code")
  path_nf <- file.path(path_code, "nf")
  path_nf_c1 <- file.path(path_code, "nf", "00_template")
  path_qmd <- file.path(path_code, "qmd")
  path_docs <- file.path(path_full, "docs")
  path_data <- file.path(path_full, "data")
  path_results <- file.path(path_full, "results")
  path_sh <- file.path(path_code, "sh")
  path_css <- file.path(path_code, "css")
  path_metadata <- file.path(path_full, "data", "metadata")
  path_img <- file.path(path_full, "img")
  
  list(path_code,
       path_nf,
       path_nf_c1,
       path_qmd,
       path_docs, path_img,
       path_data,path_results,
       path_metadata,
       path_sh, path_css) |>
    walk(try_create_dir)
  
  readr::read_lines(file.path(template_dir, "contributors.yml")) |>
    stringr::str_replace("XX_NAME_XX", name) |>
    stringr::str_replace("XX_AUTHOR_XX", author )|>
    stringr::str_replace("XX_DATE_XX", as.character(Sys.Date())) |> 
    readr::write_lines(file = file.path(path_metadata, "contributors.yml"))
  
  svg(filename = file.path(path_full, "img", "logo.svg"),
      width = 240/300,
      height = 275/300,
      bg = 'transparent'); grid::grid.circle();dev.off()
  
  file.copy(file.path(path_img, "logo.svg"),
            file.path(path_docs, "logo.svg"))
  
  if(!file.exists(file.path(path_full, "README.md"))){
    readr::write_lines(x = c(paste0('# ', name,
                                  ' <img src="img/logo.svg" align="right" alt="" width="120" />'),
                             "", paste0("**Author:** ", author)),
                       file = file.path(path_full, "README.md"))
  }
  
  readr::read_lines(file.path(template_dir, "_quarto.yml")) |>
    stringr::str_replace("XX_NAME_XX", name) |>
    stringr::str_replace("XX_AUTHOR_XX", author )|>
    stringr::str_replace("XX_DATE_XX", as.character(Sys.Date())) |> 
    readr::write_lines(file = file.path(path_full, "_quarto.yml"))
  
  readr::write_lines(x = c('<img src="logo.svg" align="right" alt="" width="160" />',
                           '',
                           "# Index {.unnumbered}"),
                     file = file.path(path_full, "index.qmd"))
  
  file.copy(file.path(template_dir, "references.qmd"),
            file.path(path_code, "qmd", "references.qmd"))
  file.copy(file.path(template_dir, "session_info.qmd"),
            file.path(path_code, "qmd", "session_info.qmd"))
  
  file.copy(file.path(template_dir, "references.bib"),
            file.path(path_code, "qmd", "references.bib"))
 
  file.copy(file.path(template_dir, "styles.scss"),
            file.path(path_css, "styles.scss"),
            overwrite = TRUE)
  
  if(Sys.which("sass") != ""){
    system(paste0("cd ", path_full, 
                  " && sass ", file.path(path_css, "styles.scss"),
                  " ", file.path(path_css, "styles.css"),
                  " && cd -"))
    file.remove(file.path(path_css, "styles.css.map"))
  }
  
  file.copy(file.path(template_dir, "convert_nf_to_qmd.sh"),
            file.path(path_sh, "convert_nf_to_qmd.sh"))
  
  readr::read_lines(file.path(template_dir, "nf_cebitec.conf")) |>
    stringr::str_replace("XX_NAME_XX", stringr::str_to_upper(name)) |>
    readr::write_lines(file = file.path(path_nf, "nf_cebitec.conf"))

  readr::read_lines(file.path(template_dir, "template.nf")) |>
    stringr::str_replace("XX_NAME_XX", stringr::str_to_upper(name)) |>
    stringr::str_replace("XX_AUTHOR_XX", author )|>
    stringr::str_replace("XX_DATE_XX", as.character(Sys.Date())) |> 
    readr::write_lines(file = file.path(path_nf_c1, "template.nf"))
  readr::write_lines(x = "nextflow run template.nf -c ../nf_cebitec.conf -resume", 
                     file = file.path(path_nf_c1, "run_nf.sh"))
  
  
  if(dir.exists( file.path(path_full, "R"))){ ff::file.move(from = file.path(path_full, "R"), file.path(path_code, "R")) }
  
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
