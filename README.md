# Creating a Basic Project 


This repo contains a `R` script to create a basic project folder structure that is based on some code and a set of templates (located within `./templates`).
The directory of the template folder is needed for the project creation to work properly.

## Downloading the Script and Templates

The examples below assume that this repo has been cloned into the local Download folder (`~/Downloads`).

```sh
cd ~/Downloads
git clone https://github.com/k-hench/init_project.git
cd init_project
```

## Quick Setup of a Basic Project Structure

To use the setup, source the main script `init_project.R` and call the function of the same name (`init_project()`):

```r
source("init_project.R")
init_project(name = "test_name",
             path = "~/Desktop",
             from_scratch = FALSE,
             template_dir = "~/Downloads/init_project/templates",
             author = "me",
             init_git = TRUE )
```

This will create the following folder-structure from scratch:

```
test_name/
├── code/
│   ├── css/
│   │   ├── styles.css
│   │   └── styles.scss
│   ├── nf/
│   │   ├── 00_template/
│   │   │   ├── run_nf.sh
│   │   │   └── template.nf
│   │   └── nf_cebitec.conf
│   ├── qmd/
│   │   ├── references.bib
│   │   ├── references.qmd
│   │   └── session_info.qmd
│   ├── R/
│   └── sh/
│       └── convert_nf_to_qmd.sh
├── data/
│   └── metadata/
│       └── contributors.yml
├── docs/
│   └── logo.svg
├── .git/
│   └── ...
├── img/
│   └── logo.svg
├── results/
├── .gitignore
├── index.qmd
├── _quarto.yml
├── README.md
└── test_name.Rproj
```

## Extending an Existing Directory

To extend this structure within an already existing directory, the parameter `from_scratch` can be set to `FALSE`:

```r
init_project(name = "test2",
             path = "~/some/path",
             from_scratch = FALSE,
             template_dir = "~/Downloads/init_project/templates",
             author = "me")
```

Furthermore, the initialization of a git repository can be toggled on or off with `init_git = TRUE/FALSE`.

---
