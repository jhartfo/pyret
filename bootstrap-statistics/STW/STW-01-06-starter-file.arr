use context url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/core-bss.arr")

include csv
include data-source
include url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/STW/STW%201.5%20Data.arr")

# Load your spreadsheet and define your table

states-csv = csv-table-url( "https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/STW/STW%201.5%20states.csv", default-options)

states-table = load-table: state, travel-time, foreign-born
  sanitize travel-time  using num-sanitizer
  sanitize foreign-born using num-sanitizer
  source: states-csv
end


CO2-csv = csv-table-url( "https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/STW/STW%201.5%20carbon-dioxide.csv", default-options)

CO2-table = load-table: country, CO2
  #sanitize CO2  using num-sanitizer
  source: CO2-csv
end

mlb-table = list-to-table(E9 , "home runs")
mp3-table = list-to-table(E10, "length")

states-table
CO2-table
mlb-table
mp3-table

#######################################################################
