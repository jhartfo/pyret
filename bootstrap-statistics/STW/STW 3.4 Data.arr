use context url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/uniform-distribution.arr")

provide *

include matrices

import url( "https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/twoway-table.arr") as TW

provide from TW: * ,
  type *,
  data *
end

dinosaurs = [table-from-columns:
  {"femur"; [list:38,56,59,64,74]},
  {"humerus"; [list:41,63,70,72,84]}
  ]

E07 = [table-from-columns:
  {"team"; [list:"Bears", "Vikings", "Packers", "Lions"]},
  {"points scored"; [list: 421, 360, 376, 324]},
  {"wins"; [list:12,8,6,6]}
  ]

E08 = [table-from-columns:
  {"team"; [list:"Bears", "Vikings", "Packers", "Lions"]},
  {"points allowed"; [list: 283, 341, 400, 360]},
  {"wins"; [list:12,8,6,6]}
  ]

E0708 = [table-from-columns:
  {"team"; [list:"Bears", "Vikings", "Packers", "Lions"]},
  {"points scored"; [list: 421, 360, 376, 324]},
  {"points allowed"; [list: 283, 341, 400, 360]},
  {"wins"; [list:12,8,6,6]}
  ]


E09 = [table-from-columns:
  {"month"; [list:"Oct", "Nov, "Dec", "Jan", "Feb", "Mar", "Apr", "May"]},
  {"temperature"; [list:49.4, 38.2,27.2,28.6,29.5,46.4,49.7,57.1]},
  {"fuel"; [list: 520, 610, 870, 850, 880, 490, 450,250]}
  ]

E10 = [table-from-columns:
  {"airport"; [list:"Raleigh-Durham", "Orlando", "St. Louis", "Denver", "Houston", "Phoenix"]},
  {"distance from Philly"; [list: 340, 860, 810, 1550, 1330, 2070]},
  {"fare"; [list:131, 120, 139, 180, 174, 188]}
  ]

E23 = [table-from-columns:
  {""; [list:]},
  {""; [list:]}
  ]

