include math
include image
include reactors
include image-structs

# This program creates the batman logo. 
# The general philosophy is inspired by the Trapezoid Rule for approximating
# an integral where the Region is cut into tiny vertical trapezoids that
# are subsequently glued together.

# after running type "BATMAN" into the interactions window to see the final image

##############################################################
# 
# Let's define some constants
#

dx         =  1   # how wide the slivers of the picture will be 
bman-color = "black" # of course batman's color is black
SCALAR     =  100      # how much we are going to scale up the final picture


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

fun batman7(x): # {-1 < x < 1 } UP
  ((6 * num-sqrt(10)) / 7) +
  ((-0.5 * num-abs(x)) + 1.5 ) +
  (((-3 * num-sqrt(10)) / 7) * num-sqrt(4 - num-sqr(num-abs(x) - 1)) )
end

##############################################################
# 
# Batman is actually big and bold so we need to make his 
# logo, big and bold. So we are going to scale it up by the constant SCALAR at the top !!!
#
# fn-scale() scales a math function in both x and y directions

fun fn-scale(f, k):
  lam(x): k  * f(x / k) end
end

# here is batman function scaled up
b01 = fn-scale(batman1, SCALAR)
b02 = fn-scale(batman2, SCALAR)
b03 = fn-scale(batman3, SCALAR)
b04 = fn-scale(batman4, SCALAR)
b05 = fn-scale(batman5, SCALAR)
b06 = fn-scale(batman6, SCALAR)
b07 = fn-scale(batman7, SCALAR)

##############################################################
# We will need to use a new datatype, List, to create our Batman
# image. Lists are just like it sounds, a list of things.
# Ex: fibb10 = [list: 0,1,1,2,3,5,8,13,21,34] 
#
# You can create a List without actually typing the list by hand.
# One method is to use range(start, stop). The list will begin 
# at start and end at stop - 1
# Ex: range(0,10) = [list: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
#
# Another method would be to use the map() which maps one
# list to a new list using a user defined function.
# In the sections below, we first create lists using range()
# Then we map those to an appropriate list of x values then we use 
# the above batman functions to make lists of y values
# Finally we use map2() to combine the x's and y's into a list of 
# Images (trapezoids) that we can then glue together into the final
# picture
#
################################################################
# This section creates the lists of x's we will input
# into the above functions to draw the batman logo
#
# we will be creating trapezoids; for each, we need
# a left x and right x
#
# create-range-left() and create-range-right() will do this.
#

fun create-range-left(start, finish, delta-x):
  map(lam(x): (delta-x * x) + start  end, range(0, (finish - start) / delta-x ) )
end

fun create-range-right(start, finish, delta-x):
  map(lam(x): (delta-x * x) + start + delta-x  end, range(0, (finish - start) / delta-x ) )
end

X01 =  create-range-left(-7.00 * SCALAR,-3.00 * SCALAR, dx) # batman1
X02 = create-range-right(-7.00 * SCALAR,-3.00 * SCALAR, dx) # 
X03 =  create-range-left( 3.00 * SCALAR, 7.00 * SCALAR, dx) # batman1
X04 = create-range-right( 3.00 * SCALAR, 7.00 * SCALAR, dx) # 
X05 =  create-range-left(-7.00 * SCALAR,-4.00 * SCALAR, dx) # batman2
X06 = create-range-right(-7.00 * SCALAR,-4.00 * SCALAR, dx) # 
X07 =  create-range-left( 4.00 * SCALAR, 7.00 * SCALAR, dx) # batman2
X08 = create-range-right( 4.00 * SCALAR, 7.00 * SCALAR, dx) # 
X09 =  create-range-left(-4.00 * SCALAR, 4.00 * SCALAR, dx) # batman3
X10 = create-range-right(-4.00 * SCALAR, 4.00 * SCALAR, dx) # 
X11 =  create-range-left(-1.00 * SCALAR,-0.75 * SCALAR, dx) # batman4
X12 = create-range-right(-1.00 * SCALAR,-0.75 * SCALAR, dx) # 
X13 =  create-range-left( 0.75 * SCALAR, 1.00 * SCALAR, dx) # batman4
X14 = create-range-right( 0.75 * SCALAR, 1.00 * SCALAR, dx) # 
X15 =  create-range-left(-0.75 * SCALAR,-0.50 * SCALAR, dx) # batman5
X16 = create-range-right(-0.75 * SCALAR,-0.50 * SCALAR, dx) # 
X17 =  create-range-left( 0.50 * SCALAR, 0.75 * SCALAR, dx) # batman5
X18 = create-range-right( 0.50 * SCALAR, 0.75 * SCALAR, dx) # 
X19 =  create-range-left(-0.50 * SCALAR, 0.50 * SCALAR, dx) # batman6
X20 = create-range-right(-0.50 * SCALAR, 0.50 * SCALAR, dx) # 
X21 =  create-range-left(-3.00 * SCALAR,-1.00 * SCALAR, dx) # batman7
X22 = create-range-right(-3.00 * SCALAR,-1.00 * SCALAR, dx) # 
X23 =  create-range-left( 1.00 * SCALAR, 3.00 * SCALAR, dx) # batman7
X24 = create-range-right( 1.00 * SCALAR, 3.00 * SCALAR, dx) # 

##############################################################
# next, we will funnel our x's through our batman function 
# to find the y values for our logo
#

Y01 = map(b01, X01) # 
Y02 = map(b01, X02) # 
Y03 = map(b01, X03) # 
Y04 = map(b01, X04) # 
Y05 = map(b02, X05) # DOWN
Y06 = map(b02, X06) # DOWN
Y07 = map(b02, X07) # DOWN
Y08 = map(b02, X08) # DOWN
Y09 = map(b03, X09) # DOWN
Y10 = map(b03, X10) # DOWN
Y11 = map(b04, X11) # 
Y12 = map(b04, X12) # 
Y13 = map(b04, X13) # 
Y14 = map(b04, X14) # 
Y15 = map(b05, X15) # 
Y16 = map(b05, X16) # 
Y17 = map(b05, X17) # 
Y18 = map(b05, X18) # 
Y19 = map(b06, X19) # 
Y20 = map(b06, X20) # 
Y21 = map(b07, X21) # 
Y22 = map(b07, X22) # 
Y23 = map(b07, X23) # 
Y24 = map(b07, X24) # 

##############################################################
# These two functions will draw the trapezoids we need to 
# draw the batman logo. up-trapezoid() for the upper half
# and down-trapezoid() for the lower half.
#

fun up-trapezoid(base1, base2, height, clr):
  if base1 > base2:
   above(
      flip-horizontal(right-triangle(height, (base1 - base2), "solid", clr)),
      rectangle(height, base2, "solid", clr))
  else:
   above(
      (right-triangle(height,(base2 - base1), "solid", clr)),
      rectangle(height, base1, "solid", clr))
  end
end

fun down-trapezoid(base1, base2, height, clr):
  if base1 < base2:
    above(
      rectangle(height, base2, "solid", clr),
      flip-vertical(right-triangle(height, (base2 - base1), "solid", clr)))
  else:
    above(  
      rectangle(height, base2, "solid", clr),
      flip-vertical(flip-horizontal(right-triangle(height, (base1 - base2), "solid", clr))))
  end
end

##############################################################
# now, we will make lists of trapezoids that we can then 
# stack together into the desired image.
#

T01 = map2(lam(b1, b2): up-trapezoid(b1,b2, dx, bman-color)end, Y01, Y02)
T03 = map2(lam(b1, b2): up-trapezoid(b1,b2, dx, bman-color)end, Y03, Y04)
T05 = map2(lam(b1, b2): down-trapezoid(0 - b1,0 - b2, dx, bman-color)end, Y05, Y06) # DOWN
T07 = map2(lam(b1, b2): down-trapezoid(0 - b1,0 - b2, dx, bman-color)end, Y07, Y08) # DOWN
T09 = map2(lam(b1, b2): down-trapezoid(0 - b1,0 - b2, dx, bman-color)end, Y09, Y10) # DOWN
T11 = map2(lam(b1, b2): up-trapezoid(b1,b2, dx, bman-color)end, Y11, Y12)
T13 = map2(lam(b1, b2): up-trapezoid(b1,b2, dx, bman-color)end, Y13, Y14)
T15 = map2(lam(b1, b2): up-trapezoid(b1,b2, dx, bman-color)end, Y15, Y16)
T17 = map2(lam(b1, b2): up-trapezoid(b1,b2, dx, bman-color)end, Y17, Y18)
T19 = map2(lam(b1, b2): up-trapezoid(b1,b2, dx, bman-color)end, Y19, Y20)
T21 = map2(lam(b1, b2): up-trapezoid(b1,b2, dx, bman-color)end, Y21, Y22)
T23 = map2(lam(b1, b2): up-trapezoid(b1,b2, dx, bman-color)end, Y23, Y24)

##############################################################
# 
# Here, we will stack together the trapezoids.
#

TT01 = for fold(stacked from empty-scene(0,0), elem from T01):
  beside-align("bottom",elem, stacked)
  end  

TT03 = for fold(stacked from empty-scene(0,0), elem from T03):
  beside-align("bottom",elem, stacked)
  end  

TT05 = for fold(stacked from empty-scene(0,0), elem from T05):
  beside-align("top",elem, stacked)
  end 

TT07 = for fold(stacked from empty-scene(0,0), elem from T07):
  beside-align("top",elem, stacked)
  end 

TT09 = for fold(stacked from empty-scene(0,0), elem from T09):
  beside-align("top",elem, stacked)
  end 

TT11 = for fold(stacked from empty-scene(0,0), elem from T11):
  beside-align("bottom",elem, stacked)
  end  

TT13 = for fold(stacked from empty-scene(0,0), elem from T13):
  beside-align("bottom",elem, stacked)
  end  

TT15 = for fold(stacked from empty-scene(0,0), elem from T15):
  beside-align("bottom",elem, stacked)
  end  

TT17 = for fold(stacked from empty-scene(0,0), elem from T17):
  beside-align("bottom",elem, stacked)
  end  

TT19 = for fold(stacked from empty-scene(0,0), elem from T19):
  beside-align("bottom",elem, stacked)
  end  

TT21 = for fold(stacked from empty-scene(0,0), elem from T21):
  beside-align("bottom",elem, stacked)
  end  

TT23 = for fold(stacked from empty-scene(0,0), elem from T23):
  beside-align("bottom",elem, stacked)
  end  

##############################################################
# 
# Finally, we will assemble all the parts
#

TOPCENTER = 
  beside-align("bottom",TT13,
    beside-align("bottom",TT17, 
      beside-align("bottom",TT19,
        beside-align("bottom",TT15,TT11))))

TOP = 
  beside-align("bottom", TT03,
    beside-align("bottom", TT23,
      beside-align("bottom", TOPCENTER,
        beside-align("bottom", TT21, TT01))))

BOTTOM = 
  beside-align("top", TT07,
    beside-align("top", TT09, TT05))


crest  = above(TOP, BOTTOM)
back   = rectangle(3200,2000, "solid", "black")
oval   = ellipse(3000,1400,"solid", "yellow")
logo   = overlay-align("center", "center", scale(2,crest), oval)
BATMAN = overlay-align("center", "center", logo, back)

bman = scale(0.5,overlay(BATMAN, rectangle(10,10,"solid","black")))

bman


