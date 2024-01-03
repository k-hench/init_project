"""
snakemake -n --rerun-triggers mtime -R target_rule
snakemake --dag target_rule | dot -Tsvg > ../results/img/dag_test.svg
snakemake --rulegraph target_rule | dot -Tsvg > ../results/img/rulegraph_test.svg

snakemake --jobs 50 \
    --latency-wait 30 \
    -p \
    --default-resources mem_mb=10240 threads=1 \
    --use-singularity \
    --singularity-args "--bind $CDATA" \
    --use-conda \
    --rerun-triggers mtime \
    --cluster '
      sbatch \
        --export=ALL \
        -n {threads} \
        -e logs/{name}.{jobid}.err \
        -o logs/{name}.{jobid}.out \
        --mem={resources.mem_mb}' \
        --jn job_c.{name}.{jobid}.sh \
        -R target_rule
"""

rule target_rule:
    message:
      """
      Demo of a pipline subset target
      """
    input:
      res = "../results/{ref}.check".format( ref = SPEC_REF )

rule worker_example:
    output:
      ref = "../results/{ref}.check"
    params:
      dummy = "test"
    conda: "r_tidy"
    container: c_popgen
    resources:
      mem_mb=20480
    benchmark:
      "benchmark/worker_{ref}.tsv"
    log:
      "logs/worker_{ref}.log"
    shell:
      """
      touch {output.ref}
      echo {params.dummy} > {log}
      """
