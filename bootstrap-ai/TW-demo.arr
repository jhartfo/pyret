use context url-file("https://raw.githubusercontent.com/bootstrapworld/starter-files/fall2026/", "libraries/ai-library.arr")

#########################################
#
# This demo is built on top of the Decision Tree Starter File resources,
# but first, we need to load the TwoWay library
import url( "https://raw.githubusercontent.com/jhartfo/pyret/refs/heads/main/bootstrap-statistics/libraries/twoway-table.arr") as TW
#
#########################################

shelter-sheet = load-spreadsheet("https://docs.google.com/spreadsheets/d/1DjY_8v8VGyacnpuy72Up4oYYIJ64gqvoCKR7_LTf3lI/")

training = 
  load-table: ID, species, sex, pounds, tail, mammal, swims
    source: shelter-sheet.sheet-by-name("training", true)
  end

testing = 
  load-table: ID, species, sex, pounds, tail, mammal, swims
    source: shelter-sheet.sheet-by-name("testing", true)
  end

###############################################################

# Classifier from Evaluating Decision Trees, slide #22 
fun swims-classifier(r):
  if r["swims"] == true:
    "dog"
  else: 
    "cat"
  end
end

# we can define an ai-library confusion-matrix
CM1 = confusion-matrix(training, "species", swims-classifier)
CM1

# or we can define a TwoWay table representing the data from the
# confusion matrix
CM2 = TW.table-to-confusion-matrix(training, "species", swims-classifier)

# Now we can display the data AS a two way table
CM2

# We can display it as a heatmap
CM2.heatmap()

# We can .normalize-rows and display the heatmap
CM2.normalize-rows().heatmap()

# we might create a verstion of .make-display() that drops the totals
# and  sets a different ceiling for heatmaps besides .n()


