// ---
// engine: knitr
// ---
//
// <!--- note that this nextflow script is converted into a quarto file
//   by running `bash code/sh/convert_nf_to_qmd.sh code/nf/00_template/template.nf`
//   from the `${params.base}` of the project --->
//
// # nf: Indexing the Reference Genomes
//
// :::{.callout-note}
//
// ## Minimal Summary
//
// This [nextflow](https://www.nextflow.io/) pipeline [@ditommaso17] ([`template.nf`](https://github.com/k-hench/XX_NAME_XX/blob/master/nf/0_template/template.nf)) <span style:"color=red">does the followeing</span>
// :::
//
// ## About This Pipeline
//
// The pipeline is structured into a [configuration section](#config-section), a section specifying the individual
// [pipeline components](#workflow-components) and the workflow
// [execution section](#workflow-composition).
//
// As a shorthand to start the workflow, the run command is bundled in the
// accompanying `bash` sript `run_nf.sh`, so the workflow can be
// started by runing:
//
// ```sh
// cd ${params.base}/code/nf/00_template
// bash run_nf.sh
// ```
//
// :::{.callout-warning}
//
//  ## Different *Base Directories*
//
// In all nextflow scripts, there might arise some confusion about
// the difference between the variables `${baseDir}` and `${params.base}`:
//
// - `${params.base}` points to the root of the project folder (which is idendical with the base of this `git` repository)
// - `${baseDir}` points to the path of the executed `nextflow` pipeline (typically `${params.base}/code/nf/<some_dir>`)
// :::
//
// ## Config Section
//
// The following pipeline parameters specify the base and
// output directory, which could alternatively be provided as
// command line options:
//
// ```groovy
// // ----- Config section -----
params.base = "${baseDir}/../../.."
params.outdir = "${params.base}/results"
// // color logging
( c0, c1, c2 ) = [ "\033[0m", "\033[0;32m", "\033[1;30m" ]
// ```
//
// The workflow parameters are logged at the start of the workflow execution.
//
// ```groovy
log.info"""
${c2}XX_NAME_XX${c0}
===================================
${c1}Author:${c0} XX_AUTHOR_XX
-----------------------------------
${c1}base_dir${c0}        : ${params.base}
${c1}params.outdir${c0}   : ${params.outdir}
"""
// ```
//
// The the use of [nexflow DSL2](https://www.nextflow.io/docs/latest/dsl2.html#)
// is enabled, which concludes the configuration.
//
// ```groovy
nextflow.enable.dsl = 2
// ```
//
// ## Workflow Components
//
//
// ```groovy
// // ----- workflow components -----
Channel
  .from( "in" )
  .set{ start_ch }
// ```
//
//
//
// ```groovy
process first_process {
  publishDir "${params.outdir}/test", mode: 'copy', pattern: "*.tsv"
  label "Q_def_test_c_qc"
  memory '1. GB'

  input:
  val( in )

  output:
  file( "test.*" )

  script:
  """
  echo "${in}" > test.txt
  echo "${in}" > test.tsv
  """
}
// ```
// ## Workflow Composition
//
//
//
// ```groovy
// // ----- run workflow -----
workflow {
  main:
  start_ch| first_process
}
// ```
//
// ------