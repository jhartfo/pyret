use context url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/distributions-library.arr")

# This starter file contains lists 
# (mystery01 through mystery16) each representing 
# data collected from an unknown distribution.

# use the below lines of code below to find for each list: 
# * Number of elements (n) ,
# * Mean (xbar) ,
# * Standard Deviation (s) ,
# * Approximately Dymmeteric, Skewed Left, or Skewed right, and 
# * a brief description of the distribution.
# 
# You may find it useful to view the histogram at different
# bin sizes, and may wish to paste in the final histogram into 
# the document you where you are answering these questions.
#
# Make sure this Typed Assignment is completed with MLA format
# and turned in on Canvas.

################################################3

# A new function that might be helpful:

# list-histogram :: List, Number -> Image
# (remember the number is the bin size for the hisotgram

# type up your results and turn them in on Canvas

# Example
list-1     = [list:2, 4, 6]

x          = list-1
n          = list-length(x)
x-bar      = fold(_ + _, 0, x) / n 
x-devs     = map(_ - x-bar, x)
x-devs-sqr = map(num-sqr(_), x-devs)
variance   = fold(_ + _, 0, x-devs-sqr) / (n - 1)
stdev      = num-sqrt(variance)

list-histogram(x,1.5)



