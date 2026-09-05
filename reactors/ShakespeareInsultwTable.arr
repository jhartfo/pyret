use context essentials2021
include reactors
include image

include gdrive-sheets

###########################
#
#  PRESS RUN TO BEGIN !!!
#
#    After the generator is closed,
#    insult-list and insult-table 
#    will contain a list 
#    of generated insults. 
#
#  To run again wihout clicking RUN,
#  type 'run-generator()' and press [enter]
#
###########################

# Load your spreadsheet and define your table
insult-id    = "1tNk3u9LIAlNnKKXAjwn7tmjAXZKJEE4nIIbliz1by7w"
insult-sheet = load-spreadsheet(insult-id)
insult-tbl   = load-table: A,B,C
  source: insult-sheet.sheet-by-name("Sheet1", false)
end

col-A = insult-tbl.get-column("A").filter(lam(x): x <> '"' end)
col-B = insult-tbl.get-column("B").filter(lam(x): x <> '"' end)
col-C = insult-tbl.get-column("C").filter(lam(x): x <> '"' end)

##############################
# New data type

data SceneState:
  | posn(a :: Number, b :: Number, c :: Number) 
end

#############
# Lets define some CONSTANTS
TEXT-COLOR   = "cornflower-blue"
BACK-COLOR   = "light-yellow"
TAIL-COLOR   = "dark-gray"
INSULT-COLOR = "dark-magenta"
TEXT1        = "   Welcome to the Shakespearean Insult Generator   "
TEXT2        = "   Here's an insult for you to try:   "
TEXT3        = "You're a:"
TEXT4        = "To generate a new insult, press any key."
TEXT5        = ""
LINE0        = text(""    , 20, TEXT-COLOR)
LINE1        = text(TEXT1 , 45, TEXT-COLOR)
LINE2        = text(TEXT2 , 45, TEXT-COLOR)
LINE3        = text(TEXT3 , 45, TEXT-COLOR)
LINE4        = text(TEXT4 , 20, TAIL-COLOR)
LINE5        = text(TEXT5 , 20, TAIL-COLOR)
INTRO-TEXT   = above(LINE0, above(LINE1, LINE2))
TAIL-TEXT    = above(LINE4, above(LINE5, LINE0))
YOURE-A      = text(TEXT3 , 30, TEXT-COLOR)
WT           = 1000
HT           = 600
WINDOW       = rectangle(WT,HT,"solid",BACK-COLOR)
BOX          = rectangle(WT - 50, 150, "solid", "white")
START        = posn(0,0,0)

############
# Functions to operate the generator

fun find-insult():
  a = num-random(length(col-A))
  b = num-random(length(col-B))
  c = num-random(length(col-C))
  posn(a,b,c)
end

fun build-insult(columns):
  A = col-A.get(columns.a)
  B = col-B.get(columns.b)
  C = col-C.get(columns.c)
  A + " " + B + " " + C
end
  
fun next-state-key(STATE, key):  
  find-insult()
end
  
fun draw-state(STATE):
  put-image(text(build-insult(STATE),30,INSULT-COLOR), WT / 2, HT / 2,
    put-image(INTRO-TEXT, WT / 2, HT - 45, 
      put-image(TAIL-TEXT, WT / 2, 45, 
        put-image(YOURE-A, 100, (HT / 2) + 100, 
          put-image(BOX, WT / 2, HT / 2, WINDOW)))))
end

##############
# Here we go!

scene-react = reactor:
  init    : START,
  to-draw : draw-state,
  on-key  : next-state-key
end

temporary    = interact-trace(scene-react)
insult-table = temporary.transform-column("state", build-insult)
insult-list  = insult-table.get-column("state")

fun run-generator():
  interact-trace(scene-react).transform-column("state",build-insult)
end
