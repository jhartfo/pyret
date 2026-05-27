use context shared-gdrive("Bootstrap-DataScience-v2.2.arr", "1cuqucVgUe7_HmtVWez1qkkdPH16mgy7P")
# Load your spreadsheet and define your table
results-sheet = load-spreadsheet(
"https://docs.google.com/spreadsheets/d/1N9FbvcLuqjlijvb4esWMCElXZxRPHaH5Z2LygWlhdb0/")

# load the 'animals' sheet as a table
results-table = 
  load-table: Name, VideoGames, Design, DataScience, Cybersecurity, AI, Engineering, ProblemSolving, Automation, Other
    source: results-sheet.sheet-by-name("results", true)
end

########################################################
# Define some rows
hs = row-n(results-table, 0) 
je = row-n(results-table, 1) 
iw = row-n(results-table, 2) 
mw = row-n(results-table, 3) 
mb = row-n(results-table, 4) 

########################################################
# bar charts

bar-chart(results-table, "VideoGames")
bar-chart(results-table, "Design")
bar-chart(results-table, "DataScience")
bar-chart(results-table, "Cybersecurity")
bar-chart(results-table, "AI")
bar-chart(results-table, "Engineering")
bar-chart(results-table, "ProblemSolving")
bar-chart(results-table, "Automation")

########################################################



