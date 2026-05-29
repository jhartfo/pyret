use context url("https://raw.githubusercontent.com/jhartfo/pyret/refs/heads/main/bootstrap-statistics/libraries/core-bss.arr")
provide *


import url("https://raw.githubusercontent.com/jhartfo/pyret/refs/heads/main/bootstrap-statistics/libraries/core-bss.arr") as BSDS
provide from BSDS: * hiding(dilate),
  type *,
  data *
end

import math as Math
import statistics as Stats

fun raise-non-number-list(fn):
  raise("Cannot calculate the " + 
    fn + "because the list does not contain numeric data.")
end

fun raise-non-number(fn):
  raise("Cannot calculate the " + 
    fn + "because the argument(s) were not an NumIntegers")
end

fun list-product(    lst :: List<Number>%(is-all-numbers)) -> Number : fold(_ * _, 1, lst) end
fun list-sum(        lst :: List<Number>%(is-all-numbers)) -> Number : fold(_ + _, 0, lst) end

fun list-squared-sum(lst :: List<Number>%(is-all-numbers)) -> Number  : list-sum(map(num-sqr, lst)) end
fun num-triangular(  n   :: Number) -> Number : (n * (n + 1)) / 2 end 

#############################################

fun factorial(n :: NumInteger) -> Number:
  if (n == 1) or (n == 0): 1
  else:
    n * factorial(n - 1)
  end
end

list-sqr-sum      = list-squared-sum
tri-number        = num-triangular
triangular-number = num-triangular

fun falling-factorial(n:: Number, k :: Number) -> Number:
  if k == 1: n
  else:
    n * ff(n - 1, k - 1)
  end
end

fun rising-factorial(n,k):
  if (k - 0) == 1: n
  else:
    n * rf(n + 1, k - 1)
  end
end

permutation = falling-factorial

fun combination(n:: Number, k :: Number) -> Number:
  if is-number(n) and is-number(k):
    permutation(n,k) / factorial(k)
  else:
    raise-non-number("combinations")
  end
end

fun pascal-triangle(n):
  if is-number(n):
    map(
      lam(x): map(combination(x,_), range-by(0,x + 1,1)) end, 
      range-by(0,n + 1,1))
  else:
    raise-non-number("pascal's triangle")
  end
end

#############################################
#|

fun list-mean(some-list):
  if some-list.all(is-number):
    Stats.mean(some-list)
  else:
    raise-non-number-list("mean")
  end
end

fun deviations(some-list):
  if some-list.all(is-number):
    map(_ - list-mean(some-list), some-list)
  else:
    raise-non-number-list("deviations from the mean")
  end
end

fun deviations-squared(some-list):
  if some-list.all(is-number):
    map(num-sqr, deviations(some-list))
  else:
    raise-non-number-list("squared deviations")
  end
end

deviations-sqr = deviations-squared

fun variance(some-list):
  if some-list.all(is-number):
    list-sqr-sum(deviations(some-list)) / (length(some-list) - 1)
  else:
    raise-non-number-list("variance")
  end
end

fun stdDev(some-list):
  if some-list.all(is-number):
    num-sqrt(variance(some-list))
  else:
    raise-non-number-list("variance")
  end
end

fun z-score(x, xbar, s):
  (x - xbar) / s
end

fun z-scores(some-list):
  map(z-score(_, list-mean(some-list), stdDev(some-list)), some-list)
end

fun R(X,Y):
  list-sum(map2(_ * _, z-scores(X), z-scores(Y))) / (length(X) - 1)
end

fun R2(X,Y):
  num-sqr(R(X,Y))
end

fun list-median(some-list):
  if some-list.all(is-number):
    Stats.median(some-list)
  else:
    raise-non-number-list("median")
  end
end

fun list-modes(some-list): 
  if some-list.all(is-number):
    Stats.modes(some-list)
  else:
    raise-non-number-list("modes")
  end
end

fun list-minimum(some-list):
  if some-list.all(is-number):
    Math.min(some-list)
  else:
    raise-non-number-list("minimum")
  end
end

fun list-maximum(some-list):
  if some-list.all(is-number):
    Math.min(some-list)
  else:
    raise-non-number-list("minimum")
  end
end

fun list-range(some-list):
  if some-list.all(is-number):
    list-maximum(some-list) - list-minimum(some-list)
  else:
    raise-non-number-list("range of values")
  end
end

fun list-IQR(some-list):
  if some-list.all(is-number):
    l           = some-list.sort()
    first-half  = l.split-at(num-floor(  l.length() / 2)).prefix
    second-half = l.split-at(num-ceiling(l.length() / 2)).suffix
    num-to-string-digits(
      Stats.median(second-half) - Stats.median(first-half),2)
  else:
    raise-non-number-list("Inter-Quaterile Range")
  end
end
  
list-iqr = list-IQR

fun list-Q1(some-list):
  if some-list.all(is-number):
    values     = some-list.sort()
    first-half = values.split-at(num-floor(values.length() / 2)).prefix
    
    Stats.median(first-half)
  else:
    raise-non-number-list("first quartile")
  end
end

fun list-Q3(some-list):
  if some-list.all(is-number):
    values      = some-list.sort()
    second-half = values.split-at(num-ceiling(values.length() / 2)).suffix
    
    Stats.median(second-half)
  else:
    raise-non-number-list("third quartile")
  end
end

list-Q0 = list-minimum
list-Q2 = list-median
list-Q4 = list-maximum

list-q0 = list-Q0
list-q1 = list-Q1
list-q2 = list-Q2
list-q3 = list-Q3
list-q4 = list-Q4

fun list-outliers(some-list):
  if some-list.all(is-number):
    lower-boundary = list-q1(some-list) - (1.5 * (iqr(some-list)))
    upper-boundary = list-q3(some-list) + (1.5 * (iqr(some-list)))
    list.filter(lam(x): (x < lower-boundary) or (x > upper-boundary) end)
  else:
    raise-non-number-list("outliers")
  end
end
  
fun list-without-outliers(some-list):
  if some-list.all(is-number):
    lower-boundary = list-q1(some-list) - (1.5 * (iqr(some-list)))
    upper-boundary = list-q3(some-list) + (1.5 * (iqr(some-list)))
    list.filter(lam(x): (x >= lower-boundary) or (x <= upper-boundary) end)   
  else:
    raise-non-number-list("list without the outliers")
  end
end

###################################################

fun random-uniform(a,b,d):
  (num-random(num-expt(10,d) * ((b - a) + 0)) / num-expt(10,d)) + a
end

# simulation-uniform returns a list containing n random samples from the uniform distribution
fun simulate-uniform(a,b, d,n):
  map(lam(x):random-uniform(a,b,d) end, range-by(0,n + 1,1))
end

|#
