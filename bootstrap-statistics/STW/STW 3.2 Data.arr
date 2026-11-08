use context url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/uniform-distribution.arr")

provide *

include matrices

import url( "https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/twoway-table.arr") as TW

provide from TW: * ,
  type *,
  data *
end

faster-farther = [table-from-columns:
  {"time"; [list: 5.41, 5.05, 7.01, 7.17, 6.73, 5.68, 5.78, 6.31, 6.44, 6.50, 6.80, 7.25]},
  {"distance"; [list: 171,184,90,65,78,130, 173, 143, 92, 139, 120, 110]}
  ]

weight-training = [table-from-columns:
  {"benchpress"; [list: 95,111,113,125,135,145,165,180,180,196,95,111]},
  {"squat"; [list:141,208,100,218,284, 275, 338,338,420,420,141,208]}
  ]

candy = [table-from-columns:
  {"brand"; [list: "Butterfinger Minis", "Junior Mints", "M&Ms", "Milk Duds", "Peanut M&Ms", "Raisinets", "Reece's Pieces", "Skittles", "Sour Patch Kids", "SweeTarts", "Twizzlers", "Whoppers"]},
  {"sugar"; [list: 45,107, 62, 44, 79, 60, 61, 87, 92, 136, 59, 48]},
  {"calories"; [list: 450, 570, 480, 370, 790, 420, 580, 450, 490, 680, 460, 350]}
  ]

E07 = [table-from-columns:
  {"speed"; [list:10,20,30,40,50,60,70,80,90,100,110,120,130,140,150]},
  {"fuel"; [list: 21,13,10,8,7,5.90, 6.30, 6.95, 7.57, 8.27, 9.03, 9.87, 10.79, 11.77,12.83]}
  ]

E08 = [table-from-columns:
  {"body weight"; [list: 120,187, 109,103,131,165,158,116]},
  {"backpack weight"; [list: 26,30,26,24,29,35,31,28]}
  ]

E09 = [table-from-columns:
  {"name"; [list:"Apocolypse", "Bullet", "Corkscrew", "Flying Turns", "Goliath", "Hidden Anoconda", "Iron Shark", "Stinger", "Wild Eagle"]},
  {"height"; [list: 100, 196, 70,50,192,152,100,131,210]},  
  {"speed"; [list:55,83,55,24,66,65,52,50,61]}
  ]

E10 = [table-from-columns:
  {"city"; [list:"Limon", "DEnver", "Golden", "Flagler", "Eagle", "Vail", "Glenwood Springs", "Rifle", "Grand Junction", "Dillon"]},
  {"elevation"; [list: 5452, 5232, 6408, 5002, 6595, 8220, 7183, 5386, 4591, 9049]},
  {"temperature"; [list: 27, 31,29,29,21,18,25,26,29,16]}
  ]

E15 = [table-from-columns:
  {"country"; [list:"Switzerland", "Timor-Leste", "Uganda", "Ghana", "Peru", "Cambodia", "Suriname", "Armenia", "Sweden", "Niger", "Serbia", "Kenya", "Fiji", "Grenada"]},
  {"mortality"; [list: 4.4, 56.4, 127.5, 68.5, 21.3, 87.5, 26.3, 21.6, 2.8, 160.3, 7.1, 84.0, 17.6, 14.5]},
  {"income"; [list: 38993.90, 2475.68, 1202.53, 1382.95, 7858.97, 1830.97, 8199.03, 4523.44, 32021.00, 643.39, 10005.20, 1493.53, 4016.20, 8826.90]}
  ]

E16 = [table-from-columns:
  {"bean"; [list: "soybeans", "garbanzos", "blck beans", "adzuki beans", "cranberry beans", "great northern beans", "kidney beans", "navy beans", "pinto beans", "white beans", "lima beans", "mung beans"]},
  {"carbohydrate"; [list: 8.5, 22.5, 20.0, 28.5, 21.5, 18.5, 20.0, 23.5, 22.5, 22.5, 19.5, 19.0]},
  {"protein"; [list: 14,7,8,8.5,8,7,7.5,7.5,7.5,8.5,7,7]}
  ]





