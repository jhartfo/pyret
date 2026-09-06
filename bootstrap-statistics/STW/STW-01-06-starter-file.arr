use context url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/core-bss.arr")
# Load your spreadsheet and define your table

include csv
states-csv = csv-table-url("", default-options)
animals-table = load-table: name, species, sex, age, fixed, legs, weight, weeks

shelter-sheet = load-spreadsheet(
"https://docs.google.com/spreadsheets/d/1VeR2_bhpLvnRUZslmCAcSRKfZWs_5RNVujtZgEl6umA/")

# load the 'animals' sheet as a table
animals-table = 
  load-table: name, species, sex, age, fixed, legs, pounds, weeks
  source: shelter-sheet.sheet-by-name("pets", true)
end

########################################################
# Define some rows
cat-row = row-n(animals-table, 0) 
dog-row = row-n(animals-table, 10) 



########################################################
# Define some helper functions
