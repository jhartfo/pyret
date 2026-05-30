provide *

import url("https://raw.githubusercontent.com/jhartfo/pyret/refs/heads/main/bootstrap-statistics/libraries/core-bss.arr") as BSDS
provide from BSDS: * hiding(dilate),
  type *,
  data *
end

import math as Math
import statistics as Stats

import url("https://raw.githubusercontent.com/jhartfo/pyret/refs/heads/main/bootstrap-statistics/libraries/combinatorics.arr") as C
provide from C: 
  * 
end

#is-all-numbers = _.all(is-number)

fun list-mean(lst:: List<Number>%(is-all-numbers))-> Number:
    Stats.mean(lst)
end

fun deviations(lst:: List<Number>%(is-all-numbers)) -> List:
  map(_ - list-mean(lst), lst)
end

fun deviations-squared(lst :: List<Number>%(is-all-numbers)) -> List:
    map(num-sqr, deviations(lst))
end

deviations-sqr = deviations-squared

fun variance(lst :: List<Number>%(is-all-numbers)) -> Number:
  C.list-sqr-sum(deviations(lst)) / (length(lst) - 1)
end

fun stdDev(lst :: List<Number>%(is-all-numbers)) -> Number:
    num-sqrt(variance(lst))
end

fun z-score(x :: Number, xbar :: Number, s :: Number) -> Number:
  (x - xbar) / s
end

fun z-scores(lst :: List<Number>%(is-all-numbers)) -> List:
  map(z-score(_, list-mean(lst), stdDev(lst)), lst)
end

fun R(X :: Number,Y :: Number):
  C.list-sum(map2(_ * _, z-scores(X), z-scores(Y))) / (length(X) - 1)
end

fun R2(
    X :: List<Number>%(is-all-numbers),
    Y :: List<Number>%(is-all-numbers)) -> Number:
  num-sqr(R(X,Y))
end

fun list-median(lst :: List<Number>%(is-all-numbers)) -> Number:
    Stats.median(lst)
end

fun list-modes(lst :: List<Number>%(is-all-numbers)) -> List: 
    Stats.modes(lst)
end

fun list-minimum(lst:: List<Number>%(is-all-numbers)) -> Number:
    Math.min(lst)
end

fun list-maximum(lst:: List<Number>%(is-all-numbers)) -> Number:
    Math.min(lst)
end

fun list-range(lst:: List<Number>%(is-all-numbers)) -> Number:
    list-maximum(lst) - list-minimum(lst)
end

fun list-IQR(lst:: List<Number>%(is-all-numbers)) -> Number:
  l           = lst.sort()
  first-half  = l.split-at(num-floor(  l.length() / 2)).prefix
  second-half = l.split-at(num-ceiling(l.length() / 2)).suffix
  num-to-string-digits(
    Stats.median(second-half) - Stats.median(first-half),2)
  end
  
list-iqr = list-IQR

fun list-Q1(lst:: List<Number>%(is-all-numbers)) -> Number:
  values     = lst.sort()
  first-half = values.split-at(num-floor(values.length() / 2)).prefix
  
  Stats.median(first-half)
end

fun list-Q3(lst:: List<Number>%(is-all-numbers)) -> Number:
  values      = lst.sort()
  second-half = values.split-at(num-ceiling(values.length() / 2)).suffix
  
  Stats.median(second-half)
end

list-Q0 = list-minimum
list-Q2 = list-median
list-Q4 = list-maximum

list-q0 = list-Q0
list-q1 = list-Q1
list-q2 = list-Q2
list-q3 = list-Q3
list-q4 = list-Q4

fun list-outliers(lst:: List<Number>%(is-all-numbers)) -> List:
  lower-boundary = list-q1(lst) - (1.5 * (col-iqr(lst)))
  upper-boundary = list-q3(lst) + (1.5 * (col-iqr(lst)))
  list.filter(lam(x): (x < lower-boundary) or (x > upper-boundary) end)
end
  
fun list-without-outliers(lst:: List<Number>%(is-all-numbers)) -> List:
  lower-boundary = list-q1(lst) - (1.5 * (col-iqr(lst)))
  upper-boundary = list-q3(lst) + (1.5 * (col-iqr(lst)))
  list.filter(lam(x): (x >= lower-boundary) or (x <= upper-boundary) end)   
end

###################################################

# random-number from a uniform distribution
# digits tells us how many decimals places
#
# Pyret's built-in num-random gives a (uniformly) random
# NumInteger from 0 to the given value.
# To get any starting place we find the spread between
# the min and max. Once the pseudo-random number is found we 
# add the min to the value to shift the random number 
# to the correct interval.
#
# Because Pyret's num-random only does NumIntegers, e
# need to scale up the values enough that the pseudo-random 
# number has the desired digits. Afterward we scale back down
# to the correct scale
fun random-uniform(
    min    :: Number, 
    max    :: Number, 
    digits :: Number) -> Number:
  magnitude = num-expt(10,digits)          
  spread = max - min 
  rand = num-random(magnitude  * spread)
  
  (rand / magnitude) + min
end

# simulation-uniform returns a list containing n random samples from the uniform distribution
fun simulate-uniform(
    min    :: Number, 
    max    :: Number, 
    digits :: Number,
    n      :: Number) -> List:
  map(lam(x):random-uniform(min,max,digits) end, range-by(0,n + 1,1))
end

|#
