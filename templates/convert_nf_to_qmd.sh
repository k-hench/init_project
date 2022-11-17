# sed 's=^//\s*==' nf/nf_01/nf_with_r.nf > nf_01.qmd
no_prefix=${1#code/nf/*}
sed 's=^//\s*==' ${1} > code/qmd/nf_${no_prefix%/*}.qmd
