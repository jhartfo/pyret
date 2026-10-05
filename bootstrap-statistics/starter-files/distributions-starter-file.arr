use context url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/distributions-library.arr")

# This starter file contains lists 
# (mystery01 through mystery16) each representing 
# data collected from an unknown distribution
# your job is to determine it shape; whether it is 
# approximately symmetric, skewed left or skewed right;
# mean (xbar), and standard deviation of the distribution (s),
# the number of elements in the distribution (n); and a 
# broad description of the distribution (you can paste in 
# the histogram if you want.

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



