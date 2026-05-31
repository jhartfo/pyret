use context starter2024
provide * 

import matrices as M
import math as Math

# This library library first defines the 
# Stirling Numbers of the first Kind, Second Kind and 
# the Signed Stirling Numbers of the First Kind
#
# Next, we define the Stirling Matrices. We then use
# these Matrices to generate polynomial functions
# given information from a sequence's table a 
# differences

fun stirling1(n,k): # stirling number of the first kind
  if n == k: 1
  else if (n == 0) or (k == 0): 0
  else: stirling1(n - 1, k - 1) + ((n - 1) * stirling1(n - 1, k))
  end
end

fun stirling2(n,k): # stirling number of the second kind
  if n == k: 1
  else if (n == 0) or (k == 0): 0
  else: stirling2(n - 1, k - 1) + (k * stirling2(n - 1, k))
  end
end

fun stirling1-signed(n,k): # signed stirling number of the first kind
  value = 
    if n == k: 1
    else if (n == 0) or (k == 0): 0
    else: stirling1(n - 1, k - 1) + ((n - 1) * stirling1(n - 1, k))
  end
  value * num-expt(-1, n - k)
end

fun factorial(n):
  fold(_ * _, 1, range-by(1,n + 1,1))
end

fun stirling2-matrix(n):
  M.build-matrix(n, n, lam(i,j): stirling2(i,j) end).transpose()
end

# uses signed stirling number of the first kind
fun stirling1-matrix(n):
  M.build-matrix(n, n, lam(i,j): stirling1-signed(i,j) end).transpose()
end

#############################################
# generating polynomials

# creates a (N x N) Diagonal Matrix 
# where elements on the diagonal are n!
fun D(N):
  M.build-matrix(N, N, lam(i,j): if i == j: factorial(i) else: 0 end end).transpose()
end

# the inverse of D(N)
fun d(n):
  D(n).inverse()
end

# consumes a matrix, delta,  containing the intial
# values from a table of differences and produces 
# the coefficients of the underlying polynomial
# in ascending order starting with constant term.
fun coeffs(delta):
  n = length(delta.row-list())
  M.mtx-to-list(stirling1-matrix(n) * d(n) * delta)
end


# evaluates the function fn with the given argument
fun evaluate(fn, x): fn(x) end

# given a coefficent and a power, produces
# an executable monomial function
fun monomial(c,power) -> Function:
  lam(x): num-expt(x,power) * c
  end
end


# consumes a List of coefficients and constructs
# polynomial function
fun polynomial(c):
  powers = reverse(range(0, length(c)))
  terms = map2(monomial, c, powers)
  lam(x): Math.sum(map(lam(fn): evaluate(fn,x) end, terms))
  end
end 


#|

# suppose we have the sequence: a_n = 1, 4, 9, 16, 25, . . . 
# (where a_0 = 1)
# then the first differences are : 3, 5, 7, 9, . . .
# and the second differences are : 2, 2, 2, . . . .

# the initial values of these sequences are : 1, 3, 2
# (all additional difference sequence will be constant zero 
# sequences) 

# we package them into a Matrix 
delta = [M.matrix(3,1):1,3,2]

# the cofficients of the polynomial
n = coeffs(delta)

# functions f and g should produce the same values 
g = polynomial(n)
f = lam(x): (x * x) + (2 * x) + 1 end

|#
   
   
   
