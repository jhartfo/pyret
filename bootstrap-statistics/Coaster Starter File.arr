use context shared-gdrive("Bootstrap-DataScience-v2.2.arr", "1cuqucVgUe7_HmtVWez1qkkdPH16mgy7P")

# Load your spreadsheet and define your table
shelter-sheet = load-spreadsheet(
"https://docs.google.com/spreadsheets/d/1E2E8huSdwhAlLrNh1C9xdoxKZ_YpoXVtm5NnXRF8KAA/")

# load the 'animals' sheet as a table
coaster-table = 
  load-table: name, material, ht, design, speed, duration
    source: shelter-sheet.sheet-by-name("RollerCoasters", true)
end

########################################################
# Define some rows
steel-row = row-n(coaster-table, 0) 
wood-row  = row-n(coaster-table, 2) 



########################################################
# Define some helper functions



fun get-column(T, col):
  T.get-column(col)
end

height   = get-column(coaster-table, "ht")
material = get-column(coaster-table, "material")


########################################################
# Define random and logical subsets
