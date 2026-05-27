use context shared-gdrive("BSS-1 (v1.0).arr", "136EywBqeyuhJ0AX6LXc6eCoK2fpBKhR6")
################################################################
# Bootstrap: DataScience 
# Support files, as of Fall 2024

provide: * end

import statistics as Stats
import math as Maths
import shared-gdrive("BSS-1 (v1.0).arr", "136EywBqeyuhJ0AX6LXc6eCoK2fpBKhR6") as BBS1
provide from BBS1: * end
provide from Maths: * end
provide from Stats: * end

include image
include lists
include statistics
include statistics

fun product(a-list):
  fold(_ * _ , 1, a-list)
end

fun factorial(n):
  product(range(1, n + 1))
end

fun triangle-number(n):
  sum(range(1, n + 1))
end
