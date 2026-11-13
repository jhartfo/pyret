use context url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/uniform-distribution.arr")

provide *

include matrices

import url( "https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/twoway-table.arr") as TW

provide from TW: * ,
  type *,
  data *
end

F150 = [table-from-columns:
  {"miles"; [list:
      70583,129484, 29932, 29953, 24495, 75678,  8359,  4447, 
      34007, 58023, 44447, 68474,144162,140776, 29397,131385]},
  {"price"; [list:
      21994, 9500,29875,41995,41995,28986,31891,37991,
      34995,29988,22896,33961,16883,20897,27495,13997]}
  ]

foot-taller = [table-from-columns:
  {"foot"; [list:23,32,22,28,28,23]},
  {"height"; [list:167,188,150,163,185,155]}
  ]

svl = [table-from-columns:
  {"svl" ; [list:73, 80, 63, 73, 92, 68, 65, 70, 90, 69, 58, 79, 84, 72]},
  {"mass"; [list:7.2, 10, 6, 8.1, 17.5,  8.2, 6.2, 8, 15, 7.9, 6, 11, 17, 9.2]}
  ]

protein-calories = [table-from-columns:
  {"protein" ; [list:14,12,13,13,7,8,6,8,5,9]},
  {"calories"; [list:80,100,120,130,130,140,150,160,180,310]}
  ]

E07 = [table-from-columns:
  {
    "brand"; 
    [list: 
      "Butterfinger Minis", "Junior Mints", "M&Ms", "Milk Duds", "Peanut M&Ms", "Raisinets", 
      "Reece's Pieces", "Skittles", "Sour Patch Kids", "SweeTarts", "Twizzlers", "Whoppers"]},
  {"sugar"; [list: 45,107, 62, 44, 79, 60, 61, 87, 92, 136, 59, 48]},
  {"calories"; [list: 450, 570, 480, 370, 790, 420, 580, 450, 490, 680, 460, 350]}
  ]

E08 = [table-from-columns:
  {"size"; [list:60, 55, 50, 47, 42, 39, 32]},
  {"proce"; [list:1000, 800, 700, 600, 430, 400, 300]}
  ]

E09 = [table-from-columns:
  {"stumps"; [list:2,2,1,3,3,4,3,1,2,5,1,3,2,1,2,2,1,1,4,1,2,1,4]},
  {"larvae"; [list:
      10,30, 12, 24, 36,40, 43,11, 27, 56, 18, 40, 
      25, 8, 21, 14, 16, 6, 54, 9, 13, 14, 50]}
  ]

E10 = [table-from-columns:
  {"day"; [list:1,2,5,6,7,8,9,10,12,13,16,18,19,20,21]},
  {"weight"; [list:124, 121, 103, 96, 90, 84, 78, 71, 58, 50, 27, 16, 12, 8, 6]}
  ]

E19 = [table-from-columns:
  {"bean"; [list: 
      "soybeans", "garbanzos", "blck beans", "adzuki beans", "cranberry beans", "great northern beans", 
      "kidney beans", "navy beans", "pinto beans", "white beans", "lima beans", "mung beans"]},
  {"carbohydrate"; [list: 8.5, 22.5, 20.0, 28.5, 21.5, 18.5, 20.0, 23.5, 22.5, 22.5, 19.5, 19.0]},
  {"protein"; [list: 14,7,8,8.5,8,7,7.5,7.5,7.5,8.5,7,7]}
  ]

E20 = [table-from-columns:
  {"subject"; [list:1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]},
  {"HbA1c"  ; [list:
      6.1, 6.3, 6.4, 6.8, 7.0, 7.1, 7.5, 7.7, 7.9, 
      8.7, 9.4,10.4,10.6,10.7,10.7,11.2,13.7,19.3]},
  {"FPG"; [list:
      141, 158, 12, 153, 134, 95, 96, 78, 148, 172, 
      200, 271, 103, 172, 359, 145, 147, 255]}
  ]

E22-A = [table-from-columns:
  {"x"; [list:10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5]},
  {"y"; [list:8.04, 6.95, 7.58, 8.81, 8.33, 9.96, 7.24, 4.26, 10.84, 4.82, 5.68]}
  ]

E22-B = [table-from-columns:
  {"x"; [list:10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5]},
  {"y"; [list:9.14, 9.14, 8.74, 8.77, 9.26, 8.10, 6.13, 3.10, 9.13, 8.26, 4.74]}
  ]

E22-C = [table-from-columns:
  {"x"; [list:10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5]},
  {"y"; [list:7.46, 6.77, 12.74, 7.11, 7.81, 8.84, 6.08, 5.39, 8.15, 6.42, 5.73]}
  ]

E22-D = [table-from-columns:
  {"x"; [list:8,8,8,8,8,8,8,8,8,8,19]},
  {"y"; [list:6.58, 5.76, 7.71, 8.84, 8.47, 7.04, 5.25, 5.56, 7.91, 6.89, 12.50]}
  ]

E23 = [table-from-columns:
  {"mass"; [list:33, 43, 40, 55, 49]},
  {"rate"; [list:1050, 1120, 1400, 15100, 1700]}
  ]
