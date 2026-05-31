use context starter2024

provide *

# for more information, go to
# https://en.wikipedia.org/wiki/Metallic_mean

# the metallic ratios or metallic means 
# generalize the notion of the golden ratio

golden-ratio = (1 + num-sqrt(5)) / 2
silver-ratio = 1 + num-sqrt(2)
bronze-ratio = (3 + num-sqrt(13)) / 2

fun radical(n):
  num-sqrt(num-sqr(n) + 4)
end

examples:
  metallic(1) is-roughly golden-ratio
  metallic(2) is-roughly silver-ratio
  metallic(3) is-roughly bronze-ratio
end
fun metallic(n):
  (n + radical(n)) / 2
end

# One of the uses of the metallic numbers is to 
# use them to create fibboncci-like sequences
# by a closed-form formula instead of recursively

# x_0 = 0, x_1 = 1,
# x_n = x_(n-1) + x_(n-2)
fun fib(x):
  Phi = metallic(1)
  phi = metallic(1 * -1) * -1
  A = num-expt(Phi,x)
  B = num-expt(phi,x)
  num-round((A - B) / num-sqrt(5))
end

# x_0 = 2, x_1 = 1,
# x_n = x_(n-1) + x_(n-2)
fun lucas(x):
  Phi = metallic( 1)
  phi = metallic(-1) * -1
  A = num-expt(Phi,x)
  B = num-expt(phi,x)
  num-round((A + B) )
end

# x_0 = 2, x_1 = 1,
# x_n = (2 * x_(n-1)) + x_(n-2)
fun pell(x):
  Phi = metallic(2)
  phi = metallic(2 * -1) * -1
  A = num-expt(Phi,x)
  B = num-expt(phi,x)
  num-round((A - B)  / (2 * num-sqrt(2)))
end

fun fib-sequence(n)  : map(fib  , range(0,n + 1)) end
fun lucas-sequence(n): map(lucas, range(0,n + 1)) end
fun pell-sequence(n) : map(pell , range(0,n + 1)) end

#|
fib-sequence(10)
lucas-sequence(10)
pell-sequence(10)
|#





