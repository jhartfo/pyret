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

E21 = [table-from-columns:
  {"sandwich"; [list:
      "Big Mac", "Quarter Pounder with Cheese", "Double Quarter Pounder with Cheese",
      "Hamburger", "Cheeseburger", "Double Cheeseburger", "McDouble" ]},
  {"fat"; [list: 27, 26, 43, 8, 11, 21, 17]},
  {"calories"; [list:530, 520, 750, 240, 290, 430, 380]}
  ]


E22 = [table-from-columns:
  {"minutes"; [list:15, 16, 18, 20, 22, 25]},
  {"floors"; [list:73, 82, 88, 20, 22, 25]}
  ]

