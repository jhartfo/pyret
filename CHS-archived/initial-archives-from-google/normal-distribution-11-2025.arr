provide *

# This file provides a Standard Normal Distribution Library
#
# This version of the normal distribution does not use
# any calculus. Instead, NormalCDF is calculated directly by
# Combining the genereric gausian function with the normal coefficient
#
# NormalCDF is approximated using information from this 
# wikipedia article:
# https://en.wikipedia.org/wiki/Error_function
# itself referencing:
# Numerical Recipes in Fortran 77: The Art of Scientific Computing
# (2nd Ed) (1992) 
# by Press, Teukolsky, Vetterling, Flannery 
# Cambridge University Press.
#
# InvNormalCDF is found by creating a lookup table
#

include math
include chart
include image-structs
include image
include tables

fun round(x,n):
  num-round(x * num-expt(10,n)) / num-expt(10,n)
end
  
SIG-FIG = 2

# Normal Distribution
##############################################################################
normal-coeff = 1 / (num-sqrt( 2 * 2 * PI))

fun gaussian(x):
  num-exp(-0.5 * x * x)
end

fun NormalPDF(x):
  normal-coeff * gaussian(x)
end

fun factorial(n):
  if (n == 1) or (n == 0): 1
  else:
    n * factorial(n - 1)
  end
end

fun term(n): lam(z):
    (num-expt(-1,n) * num-expt(z, (2 * n) + 1)) / 
    (factorial(n) * ((2 * n) + 1))
  end
end

fun erf(z):
  seq    = range(0,100)
  taylor = map(lam(n): term(n)(z) end, seq)
  
  (2 * sum(taylor)) / num-sqrt(PI)
end

fun NormalCDF(x):
  C = round(x / num-sqrt(2), SIG-FIG)
  num-to-roughnum(round(0.5 * (1 + erf(C)), SIG-FIG))
end

###################################################

Zs = range-by(-4,4,1 / num-expt(10, SIG-FIG))
z-table = [table-from-columns:
  {"Z"; Zs},
  {"PDF"; map(lam(z): num-exact(NormalPDF(z)) end, Zs)},
  {"CDF"; map(lam(z): num-exact(NormalCDF(z)) end, Zs)}
  ]
#|
fun Pcountif(p):
  Ps.filter(lam(x): x <= p end)
end
|#

fun InvNormalCDF(p):
  if p < -400: 0
  else if p > 400: 1
  else:
    z-table.filter(lam(r): r["P"] >= p end).row-n(0)["Z"]
  end
end

################################################################################

#|
normal-series1 = from-list.function-plot(NormalPDF).color(red)  .legend("Normal Distribution")
normal-series2 = from-list.function-plot(NormalCDF).color(green).legend("Cummulative Normal Distribution")

spacing = string-repeat("- ", 25) 
Normal-chart = render-charts([list:normal-series1, normal-series2])  
  .title(spacing + "The Normal Distribution" + spacing)
  .num-samples(1280)  
  .height(1200)
  .width( 1200)
  .x-min(-4.0)
  .x-max( 4.0)
  .y-min(-0.1)
  .y-max( 1.1)
  .x-axis("X")
  .y-axis("p")
  .get-image()
|#
