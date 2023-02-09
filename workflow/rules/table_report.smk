rule csv_report:
    input:
        "results/{sample}/lineage_assignment/{sample}.csv"
    output:
        report(directory("workflow/report/{sample}/csv-report/"), category="Lineage Assignment", subcategory="CSV Viewer", htmlindex="index.html"),
    log:
        "logs/rbt-csv-report/{sample}/",
    wrapper:
        "v1.23.1/bio/rbt/csvreport"