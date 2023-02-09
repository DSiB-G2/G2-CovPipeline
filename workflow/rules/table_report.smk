# rule csv_report:
#     input:
#         # a csv formatted file containing the data for the report
#         "results/{sample}/lineage_assignment/{sample}.csv",
#     output:
#         # path to the resulting report directory
#         directory("workflow/report/{sample}/csv-report/"),
#     params:
#         # extra="--sort-column 'contig length'",
#     log:
#         "logs/rbt-csv-report/{sample}",
#     wrapper:
#         "v1.23.1/bio/rbt/csvreport"

rule csv_report:
    input:
        # a csv formatted file containing the data for the report
        aggregate_csv
    output:
        # path to the resulting report directory
        report(directory("workflow/report/csv-report/"), category="Lineage Assignment", htmlindex="index.html"),
    log:
        "logs/rbt-csv-report/csv_report.log",
    wrapper:
        "v1.23.1/bio/rbt/csvreport"