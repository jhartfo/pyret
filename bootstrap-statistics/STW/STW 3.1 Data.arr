use context url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/uniform-distribution.arr")

provide *

include matrices

import url( "https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/twoway-table.arr") as TW

provide from TW: * ,
  type *,
  data *
end

superpowers = TW.twoway(
  TW.feat(
    "Superpower",
    [list: 
      "Invisibility",
      "Super Stength",
      "Telepathy",
      "Fly",
      "Freeze Time"]),
  TW.feat(
    "Sex",
    [list: "Female", "Male"]),
  [matrix(5,2): 15,14,3,19,36,6,32,20,18,37])


titanic = TW.twoway(
  TW.feat(
    "Survival Status",
    [list: "Survived", "Died"]
    ),
  TW.feat(
    "Class of Travel",
    [list: "First", "Second", "Third"]
    ),
  [matrix(2,3): 197, 94, 151, 122,167, 476]
  )

squirrels = TW.twoway(
TW.feat(
    "Behaviour Towards Humans",
    [list: "Approach", "Indifferent", "Run Away"]
    ),
  TW.feat(
    "Age",
    [list: "Juvenile", "Adult"]
    ),
  [matrix(3,2): 111,756, 138, 1241, 81, 571]
  )


E11 = TW.twoway(
  TW.feat(
    "Resonse", 
    [list:
      "Broken Glass",
      "No Broken Glass"]),
  TW.feat(
    "Wording", 
    [list: 
      "Smashed into", 
      "Hit", 
      "Control"]),
  [matrix(2,3): 16,7,6,34,43,44]
  )

E12 = TW.twoway(
  TW.feat(
    " Hatching Status ", 
    [list:
      "Hatched",
      "Didn't Hatch"]),
  TW.feat(
    "Nest Temperature", 
    [list: 
      "Cold", 
      "Neutral", 
      "Hot"]),
  [matrix(2,3): 16,38,75,11,18,29]
  )

E13 = TW.twoway(
  TW.feat(
    "Career Pitch", 
    [list:
      "Stayed in STEM",
      "Part-time STEM",
      "Non-STEM Job",
      "Left Workforce"]),
  TW.feat(
    "Type of Parent", 
    [list: 
      "Father", 
      "Mother"]),
  [matrix(4,2): 484,121,9,22, 117,38,19,31]
  )

E14= TW.twoway(
  TW.feat(
    "Career Goal", 
    [list:
      "Service",
      "STEM",
      "Arts",
      "Unrealistic",
      "Other"]),
  TW.feat(
    "Type of Parent", 
    [list: 
      "Father", 
      "Mother"]),
  [matrix(5,2): 32,6,8,20,4,11,17,12,23,17]
  )

E19 = TW.twoway(
  TW.feat(
    "Snowmobile Use",
    [list:"Never Used", "Snowmobile Renter", "Snowmobile Owner"]),
  TW.feat(
    "Environmental Club", 
    [list: "No", "Yes"]),
  [matrix(3,2): 445,212,497,77,279, 16]
  )

E20 = TW.twoway(
  TW.feat(
    "Play Video Games?",
    [list:"Yes", "No"]),
  TW.feat(
    "Age Group", 
    [list: "18-29", "30-49", "50-64", "65+"]),
  [matrix(2,4): 887, 1217, 650, 279, 429, 872, 985, 840]
  )

E23a = TW.twoway(
  TW.feat(
    "Housing Status",
    [list: "Own", "Rent"]),
  TW.feat(
    "Sex", 
    [list: "Male", "Female"]),
  [matrix(2,2): 132, 122,50, 44]
  )

E23b = TW.twoway(
  TW.feat(
    "Housing Status",
    [list: "Own", "Rent"]),
  TW.feat(
    "Marital Status", 
    [list: "Married", "Not Married"]),
  [matrix(2,2): 172,82,40, 54]
  )










