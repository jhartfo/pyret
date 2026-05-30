use context url("https://raw.githubusercontent.com/jhartfo/pyret/refs/heads/main/bootstrap-statistics/libraries/core-bss.arr")
provide *

#import url("https://raw.githubusercontent.com/jhartfo/pyret/refs/heads/main/bootstrap-statistics/libraries/pascals-triangle.arr") as PT

import url("https://raw.githubusercontent.com/jhartfo/pyret/refs/heads/main/bootstrap-statistics/libraries/core-bss.arr") as BSDS
provide from BSDS: * hiding(dilate),
  type *,
  data *
end

import math as Math
import statistics as Stats

url("https://raw.githubusercontent.com/jhartfo/pyret/refs/heads/main/bootstrap-statistics/libraries/combinatorics.arr") as C
provide from C: 
  * 
end

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
