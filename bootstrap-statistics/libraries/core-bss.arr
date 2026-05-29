use context  url("https://raw.githubusercontent.com/bootstrapworld/starter-files/fall2026/libraries/core.arr")

provide: * end

# importing boostraps core data science library.
# MAKE SURE WE ARE USING THE MOST CURRENT BRANCK.
import url("https://raw.githubusercontent.com/bootstrapworld/starter-files/fall2026/libraries/core.arr") as Core
provide from Core: 
    * hiding(sort, filter, mean, median, modes, maximum, minimum, iqr, IQR, sum, range, stdev, q1, q3, factorial)
end

import starter2024 as Starter
provide from Starter:
    * hiding(translate, filter, sort, sin, cos, tan)
end

import image as I
provide from I:
    * hiding(translate),
  type *,
  data *
end

import constants as Consts
provide from Consts: PI, E end

import gdrive-sheets as G
provide from G:
    * hiding(load-spreadsheet),
  type *,
  data *
end

import tables as T
import lists  as L
provide from T: * end
provide from L: * hiding(filter, range, sort), type *, data * end

col-sort    = Core.sort
col-filter  = Core.filter
col-mean    = Core.mean
col-median  = Core.median
col-modes   = Core.modes
col-minimum = Core.minimum
col-maximum = Core.maximum
col-iqr     = Core.iqr
col-IQR     = Core.iqr
col-sum     = Core.sum
col-stdev   = Core.stdev
col-range   = Core.range
col-q0      = Core.minimum
col-q1      = Core.q1
col-q2      = Core.mean
col-q3      = Core.q3
col-q4      = Core.maximum

