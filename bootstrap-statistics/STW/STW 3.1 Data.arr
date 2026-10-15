use context url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/uniform-distribution.arr")

include matrices

import url( "https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/twoway-table.arr") as TW

provide from TW: * ,
  type *,
  data *
end


E11 = TW.twoway(
  TW.feat(
    "Resonse", 
    [list:
      "Broken Glass",
      "No Broken Glass"]),
  TW.feat(
    "@ording", 
    [list: 
      "smashed into", 
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


















