use context shared-gdrive("Bootstrap-DataScience-v1.6.arr", "1-pV0b2FBZSIBxGge5W-rrvJalRUxki3y")

import math as L

average  = (
  1 + 1 +  1 +  1 +  9 + 
  1 + 1 +  1 +  1 +  4 + 
  1 + 4 +  5 +  8 + 12 +
  1 + 4 +  5 +  9 + 20 +
  1 + 4 +  5 + 10 + 12 +
  1 + 1 +  4 + 10 + 16 +
  5 + 9 + 10 + 12 + 12 + 
  1 + 4 +  4 + 10 + 18 +
  3 + 6 +  6 +  8 + 16 +
  1 + 4 + 12 + 16 + 20 +
  3 + 4 +  4 + 16 + 18 +
  5 + 6 + 10 + 12 + 16 +
  2 + 4 +  4 +  8 + 12 +
  4 + 8 + 12 + 15 + 18 +
  1 + 3 +  6 +  9 + 16 +
  2 + 8 +  8 + 10 + 10 +
  3 + 4 +  5 +  8 + 18 +
  3 + 3 +  5 +  5 + 16 +
  4 + 6 +  8 + 12 + 18 +
  4 + 6 +  9 + 12 + 16) / 100

########################################################

# Load your spreadsheet and define your table
shelter-sheet = load-spreadsheet(
"https://docs.google.com/spreadsheets/d/1aNq-lO1zEyXO-PNutu99VMhT1GQPyCQ8F9zKvwqNR3A/edit?usp=sharing")

# load the 'rectangles' sheet as a table
rectangles-table = 
  load-table: number, area
  source: shelter-sheet.sheet-by-name("rectangles", true)
end

########################################################
# Define some rows

small-rectangle = rectangles-table.row-n(6) 
large-rectangle = rectangles-table.row-n(50) 

n               = rectangles-table.length()
average2        = sum(rectangles-table, "area") / n

frequency       = count(rectangles-table, "area")
relative        = frequency
  .transform-column("count", _ / n)
  .rename-column("count", "relative freq")

weighted        = frequency
  .build-column("weight", lam(r): r["value"] * r["count"] end)

rel-weight      = relative
  .build-column("weight", lam(r): r["value"] * r["relative freq"] end)


average3        = sum(weighted, "weight") / n
average4        = sum(rel-weight, "weight") 

########################################################

areas = [list:
  1 ,1 ,1 ,1, 1 ,1 ,1, 5 ,12, 1,
  4 ,1 ,9 ,4 ,1 ,8 ,20,9 ,4 ,10,
  5 ,18,1 ,1 ,1 ,12,12,4 ,12,4 ,
  16,5 ,9 ,4 ,10,5 ,10,4 ,12,8 ,
  6 ,20,10,3 ,16,6 ,10,1 ,4 ,1 ,
  16,12,18,4 ,16,6 ,3 ,16,4 ,8 ,
  5 ,4 ,4 ,8 ,3 ,9 ,1 ,10,18,3 ,
  12,4 ,18,4 ,12,10,8 ,2 ,15,6 ,
  16,8 ,2 ,3 ,5 ,8 ,4 ,12,16,5 ,
  8 ,16,5 ,3 ,6 ,18,4 ,6 ,9 ,12]

average5 = L.sum(areas) / length(areas)




