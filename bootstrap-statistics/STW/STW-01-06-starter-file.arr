use context url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/core-bss.arr")
# Load your spreadsheet and define your table

include csv
states-csv = csv-table-url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/STW/STW%201.5%20states.csv", default-options)
states-table = load-table: state, travel-time, foreign-born
  source: states.csv
end
