use context starter2024

provide: * end

# importing boostraps core data science library.
# MAKE SURE WE ARE USING THE MOST CURRENT BRANCK.
import url("https://raw.githubusercontent.com/bootstrapworld/starter-files/fall2026/libraries/core.arr") as Core
provide from Core: 
    * hiding(mean, median, modes, maximum, minimum, iqr, IQR, sum, range, stdev, q1, q3, factorial)
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
provide from L: * hiding(filter, range, sort, length), type *, data * end

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

########################################################################
# Generating Lists

# produces a sequence using the given Function 
sequence :: Number, Number, Function -> List
fun sequence(a, b, fn) block:
  map(fn, range-by(a,b,1))
end

fun geometric(a,b,r) block:
  sequence(a,b,num-expt(r,_))
end

arithmetic = range-by

########################################################################
# get the inde of an element in a list

cutoff-at-value :: Any, List -> List
# consumes a List and a value, if the value
# is a member of the List, produces a new
# containing elements before the frst appearance
# of the value, otherwise returns the List
fun cutoff-at-value(b, lst):
  if lst == empty:
    empty
  else if lst.first == b:
    empty
  else:
    link(lst.first, cutoff-at-value(b, lst.rest))
  end
end

list-index :: Any, List -> Number
# consumes a List and a value, if the value
# is a member of the List, returns the length
# of the cutoff-at-value of the List, representing
# the index. Otherwise, raise the value is not in the list
fun list-index(b, lst):
  if member(lst,b):
    length(cutoff-at-value(b, lst))
  else:
    raise(tostring(b) + " is not a member of the list")
  end
end

########################################################################
# Tables and Lists

list-to-table :: List, String -> Table
# recasts a list as a single column Table
fun list-to-table(lst, lbl) block:
  [T.table-from-columns: {lbl; lst}] 
end

# this function equivalent to .get-column from the Table library
get-column :: Table, String -> List
fun get-column(tbl, col) block:
  tbl.get-column(col)
end

# this function equivalent to .length from the Table library
fun table-length(tbl) block:
  tbl.length()
end

element-n :: List, NumInteger -> Any
# consumes a List and produces the nth element
# negative index upto (length(lst)  * -1) are
# allowed
fun element-n(lst, n) block:
  if n >= lst.length():
    raise("element-n : n too large : " + to-string(n))
  else if n < (-1 * lst.length()):
    raise("element-n : n too small : " + to-string(n))
  else:
    lst.get(num-modulo(n, length(lst)))
  end
end

########################################################################
# list functions

list-length = length

# similar to .sort for from List library with the 
# added functionality of ascending and descending
# similar to the the table sort function above
list-sort :: List, Boolean -> List
fun list-sort(lst, ascend) block:
  if ascend:
    lst.sort()
  else:
    lst.sort().reverse()
  end
end

########################################################################

count-value :: Table, String, Any -> Number
# consumes a Table, column, and a category, and produces the
# number of occurences of the caegory in the column
fun count-value(tbl, col, value) block:
  tbl.filter(lam(r): r[col] == value end).length()
end

frequency-table :: Table, String -> Table
# produces a frequency table sorted by frequency in descending order
fun frequency-table(tbl, col) block:
  Core.sort(Core.count(tbl, col), "frequency", false)
end

rel-freq-table :: Table, String -> Table
# produces a table frequency and relative frequency sorted by frequency in descending order
fun rel-freq-table(tbl, col) block:
  extend frequency-table(tbl, col) using frequency:
    rel : frequency / tbl.length()
  end.rename-column("rel", "rel freq")
end

freq-to-data :: Table -> Table
# consumes a frequency table and recreates the raw data
# that could be used to create charts.
fun freq-to-data(f-table):
  value  = f-table.column-names().get(0) 
  series = f-table.build-column("repeats", lam(r): repeat(r["frequency"], r[value]) end).get-column("repeats")
  list-to-table(fold(append, empty, series), value)
end

########################################################################
# visualizing lists

list-dot-plot :: List, String -> Image
# consumes a List, converts it into a Table 
# creates a dot-plot
fun list-dot-plot(lst, lbl) block:
  tbl = list-to-table(lst, "list values")
  Core.dot-plot(tbl, "list values", "list values")
end
  
list-histogram :: List, Number -> Image
# consumes a List and a Number, converts it into a Table 
# creates a histogram with the bin size set to the Numbern 
fun list-histogram(lst, bin) block:
  tbl = list-to-table(lst, "list values")
  Core.histogram(tbl, "list values", "list values", bin)
end

fun bar-chart-from-freq(summary, lbl) block:
  color-table = Core.distinct-colors(summary, "frequency")
  Core.bar-chart-raw(color-table, "value", "frequency", lbl)
end

