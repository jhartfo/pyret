use context starter2024
include image

SCALAR     =  50
dx         =  SCALAR / 200

bman-color = "black" # of course batman's color is black
bkgd-color = "yellow" 

##############################################################
# The following functions represent the different
# compenents of the "Batman Function"
#

fun batman1(x): #  { 3 < x < 7 }U{-7 < x <-3 } UP
  3 * num-sqrt(1 - ((x * x) / 49))
end

fun batman2(x): #  { 4 < x < 7 }U{-7 < x <-4 } DOWN
  -3 * num-sqrt(1 - ((x * x) / 49))
end

fun batman3(x): # {-4 < x < 4 } DOWN
  num-abs(x / 2) + 
  (-1 * (((3 * num-sqrt(33)) - 7) / (112)) * (x * x))  + 
  -3 + 
  num-sqrt(1 - num-sqr(num-abs(num-abs(x) - 2) - 1))
end

fun batman4(x): # {-1 < x < -0.75 }U{ 0.75 < x < 1 } UP
  9 - (8 * num-abs(x))
end

fun batman5(x): # { 0.50 < x < 0.75 }U{-0.75 < x < -0.50 } UP
  (3 * num-abs(x)) + 0.75
end

fun batman6(x): # {-0.5 < x < 0.5} UP
  2.25
end

fun batman7(x): # {-3 < x < -1 }U{1 < x < 3} UP
  ((6 * num-sqrt(10)) / 7) +
  ((-0.5 * num-abs(x)) + 1.5 ) +
  (((-3 * num-sqrt(10)) / 7) * num-sqrt(4 - num-sqr(num-abs(x) - 1)) )
end

##############################################################
# 
# Batman is actually big and bold so we need to make his 
# logo, big and bold. So we are going to scale it up by the constant SCALAR at the top !!!
#
# fn-scale() :: Function, Number -> Function
# scales a math function in both x and y directions

fun fn-scale(f, k):
  lam(x): k  * f(x / k) end
end

# here is the batman function scaled up
b01        = fn-scale(batman1, SCALAR) 
b02        = fn-scale(batman2, SCALAR) 
b03        = fn-scale(batman3, SCALAR) 
b04        = fn-scale(batman4, SCALAR) 
b05        = fn-scale(batman5, SCALAR) 
b06        = fn-scale(batman6, SCALAR) 
b07        = fn-scale(batman7, SCALAR) 

################################################################

# List of x-values
# notation: x-n-m -> 
#                    n:= function number, 
#                    m:= number of the list for a given function

x-1-2      = range-by(-7.00 * SCALAR,-3.00 * SCALAR, dx) # up
x-7-1      = range-by(-3.00 * SCALAR,-1.00 * SCALAR, dx) # up
x-4-2      = range-by(-1.00 * SCALAR,-0.75 * SCALAR, dx) # up
x-5-2      = range-by(-0.75 * SCALAR,-0.50 * SCALAR, dx) # up
x-6-1      = range-by(-0.50 * SCALAR, 0.50 * SCALAR, dx) # up
x-5-1      = range-by( 0.50 * SCALAR, 0.75 * SCALAR, dx) # up
x-4-1      = range-by( 0.75 * SCALAR, 1.00 * SCALAR, dx) # up
x-7-2      = range-by( 1.00 * SCALAR, 3.00 * SCALAR, dx) # up
x-1-1      = range-by( 3.00 * SCALAR, 7.00 * SCALAR, dx) # up

x-2-1      = range-by( 4.00 * SCALAR, 7.00 * SCALAR, dx).reverse() # down
x-3-1      = range-by(-4.00 * SCALAR, 4.00 * SCALAR, dx).reverse() # down
x-2-2      = range-by(-7.00 * SCALAR,-4.00 * SCALAR, dx).reverse() # down

# List of y-values
# notation: the same as above
y-1-2      = map(b01, x-1-2)
y-7-1      = map(b07, x-7-1)
y-4-2      = map(b04, x-4-2)
y-5-2      = map(b05, x-5-2)
y-6-1      = map(b06, x-6-1)
y-5-1      = map(b05, x-5-1)
y-4-1      = map(b04, x-4-1)
y-7-2      = map(b07, x-7-2)
y-1-1      = map(b01, x-1-1)

y-2-1      = map(b02, x-2-1)
y-3-1      = map(b03, x-3-1)
y-2-2      = map(b02, x-2-2)

# combine x,y into points
# notation: the same as above
p-1-2      = map2(point, x-1-2, y-1-2)
p-7-1      = map2(point, x-7-1, y-7-1)
p-4-2      = map2(point, x-4-2, y-4-2)
p-5-2      = map2(point, x-5-2, y-5-2)
p-6-1      = map2(point, x-6-1, y-6-1)
p-5-1      = map2(point, x-5-1, y-5-1)
p-4-1      = map2(point, x-4-1, y-4-1)
p-7-2      = map2(point, x-7-2, y-7-2)
p-1-1      = map2(point, x-1-1, y-1-1)

p-2-1      = map2(point, x-2-1, y-2-1)
p-3-1      = map2(point, x-3-1, y-3-1)
p-2-2      = map2(point, x-2-2, y-2-2)

# list of lists of points
all-points = [list:  
  p-1-2, p-7-1, p-4-2, p-5-2, p-6-1, # top left and center
  p-5-1, p-4-1, p-7-2, p-1-1,        # top right
  p-2-1, p-3-1, p-2-2                # bottom right to left
  ]

# all points in a single list
pts        = fold(append, empty, all-points)

################################################################

# putting it all together

# crest creates a polygonal represenation the batman logo
crest      = point-polygon(pts,"solid", bman-color)

back       = rectangle(16 * SCALAR,10 * SCALAR,"solid",bman-color)
oval       = ellipse(  15 * SCALAR, 7 * SCALAR,"solid",bkgd-color)

BATMAN     = overlay(overlay(crest, oval), back)
BATMAN



