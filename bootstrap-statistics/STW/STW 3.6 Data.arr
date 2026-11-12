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

E01 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E02 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E03 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E04 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E05 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E06 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E07 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E08 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E09 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E10 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E11 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E12 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E13 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E14 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]

E15 = [table-from-columns:
  {"a"; [list:]},
  {"b"; [list:]}
  ]



