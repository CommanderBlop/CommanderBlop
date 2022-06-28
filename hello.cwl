class: Workflow
doc: "Reverse the lines in a document, then sort those lines."
cwlVersion: v1.0

requirements:
  ScatterFeatureRequirement : {}
  SubworkflowFeatureRequirement: {}

inputs:
  input_arr:
    type: File[]
    doc: "Array of input files to be processed."
  reverse_sort_arr:
    type: boolean
    default: true
    doc: "If true, reverse (descending) sort"

steps:
  subworkflow:
    run:
      class: Workflow
      inputs:
        inputFile: File
        reverse_sort: 
          type: boolean
          default: true
      outputs:
        output:
          type: File
          outputSource: sorted/output
      steps:
        rev:
          in:
            input: inputFile
          out: [output]
          # scatter: input
          run: helloTool.cwl
          requirements:
            - class: ResourceRequirement
              coresMin: 1
              ramMin: 100
        sorted:
          in:
            input: rev/output
            reverse: reverse_sort
          # scatter: input
          out: [output]
          run: sorttool.cwl
          requirements:
            - class: ResourceRequirement
              coresMin: 1
              ramMin: 100
    scatter: inputFile
    in:
      inputFile: input_arr
      reverse_sort: reverse_sort_arr
    out: [output]
outputs:
  output:
    type: File[]
    outputSource: subworkflow/output
  # output:
  #   type: File[]
  #   outputSource: rev/output
  #   doc: "The output files with the lines reversed and sorted."
