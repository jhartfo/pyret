include math
include image
include reactors
include image-structs

##############################################################
# The following functions represent the different
# compenents of the "Batman Function"
#

dx = 0.01
bman-color = "black"
scalar = 100

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
# This section creates the lists of x's we will input
# into the above functions to draw the batman logo
#
# we will be creating trapezoids; for each, we need
# a left x and right x
#
# create-range-left() and create-range-right will do this.
#

fun create-range-left(start, finish, delta-x):
  map(lam(x): (delta-x * x) + start  end, range(0, (finish - start) / delta-x ) )
end

fun create-range-right(start, finish, delta-x):
  map(lam(x): (delta-x * x) + start + delta-x  end, range(0, (finish - start) / delta-x ) )
end

X01 =  create-range-left(-7.00,-3.00, dx) # batman1
X02 = create-range-right(-7.00,-3.00, dx) # 
X03 =  create-range-left( 3.00, 7.00, dx) # batman1
X04 = create-range-right( 3.00, 7.00, dx) # 
X05 =  create-range-left(-7.00,-4.00, dx) # batman2
X06 = create-range-right(-7.00,-4.00, dx) # 
X07 =  create-range-left( 4.00, 7.00, dx) # batman2
X08 = create-range-right( 4.00, 7.00, dx) # 
X09 =  create-range-left(-4.00, 4.00, dx) # batman3
X10 = create-range-right(-4.00, 4.00, dx) # 
X11 =  create-range-left(-1.00,-0.75, dx) # batman4
X12 = create-range-right(-1.00,-0.75, dx) # 
X13 =  create-range-left( 0.75, 1.00, dx) # batman4
X14 = create-range-right( 0.75, 1.00, dx) # 
X15 =  create-range-left(-0.75,-0.50, dx) # batman5
X16 = create-range-right(-0.75,-0.50, dx) # 
X17 =  create-range-left( 0.50, 0.75, dx) # batman5
X18 = create-range-right( 0.50, 0.75, dx) # 
X19 =  create-range-left(-0.50, 0.50, dx) # batman6
X20 = create-range-right(-0.50, 0.50, dx) # 
X21 =  create-range-left(-3.00,-1.00, dx) # batman7
X22 = create-range-right(-3.00,-1.00, dx) # 
X23 =  create-range-left( 1.00, 3.00, dx) # batman7
X24 = create-range-right( 1.00, 3.00, dx) # 

##############################################################
# next, we will funnel our x's through our batman function 
# to find the y values for our logo
#

Y01 = map(batman1, X01) # 
Y02 = map(batman1, X02) # 
Y03 = map(batman1, X03) # 
Y04 = map(batman1, X04) # 
Y05 = map(batman2, X05) # DOWN
Y06 = map(batman2, X06) # DOWN
Y07 = map(batman2, X07) # DOWN
Y08 = map(batman2, X08) # DOWN
Y09 = map(batman3, X09) # DOWN
Y10 = map(batman3, X10) # DOWN
Y11 = map(batman4, X11) # 
Y12 = map(batman4, X12) # 
Y13 = map(batman4, X13) # 
Y14 = map(batman4, X14) # 
Y15 = map(batman5, X15) # 
Y16 = map(batman5, X16) # 
Y17 = map(batman5, X17) # 
Y18 = map(batman5, X18) # 
Y19 = map(batman6, X19) # 
Y20 = map(batman6, X20) # 
Y21 = map(batman7, X21) # 
Y22 = map(batman7, X22) # 
Y23 = map(batman7, X23) # 
Y24 = map(batman7, X24) # 

##############################################################
# These two functions will draw the trapezoids we need to 
# draw the batman logo. up-trapezoid() for the upper half
# and down-trapezoid() for the lower half.
#

fun up-trapezoid(base1, base2, height, clr):
  if base1 > base2:
   above(
      flip-horizontal(right-triangle(height * scalar, (base1 - base2) * scalar, "solid", clr)),
      rectangle(height * scalar, base2 * scalar, "solid", clr))
  else:
   above(
      (right-triangle(height * scalar, scalar * (base2 - base1), "solid", clr)),
      rectangle(height * scalar, base1 * scalar , "solid", clr))
  end
end

fun down-trapezoid(base1, base2, height, clr):
  if base1 < base2:
    above(
      rectangle(height * scalar, base2 * scalar, "solid", clr),
      flip-vertical(right-triangle(height * scalar, (base2 - base1) * scalar, "solid", clr)))
  else:
    above(  
      rectangle(height * scalar, base2 * scalar, "solid", clr),
      flip-vertical(flip-horizontal(right-triangle(height * scalar, (base1 - base2) * scalar, "solid", clr))))
  end
end

##############################################################
# now, we will make a list of trapezoids that we can then 
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


TOPCENTER = beside-align("bottom",TT13,beside-align("bottom",TT17, beside-align("bottom",TT19,beside-align("bottom",TT15,TT11))))
TOP = 
  beside-align("bottom", TT03,
    beside-align("bottom", TT23,
      beside-align("bottom", TOPCENTER,
        beside-align("bottom", TT21, TT01))))

BOTTOM = 
  beside-align("top", TT07,
    beside-align("top", TT09, TT05))


BATMAN = above(TOP, BOTTOM)

back = rectangle(2000,1200, "solid", "black")

oval = ellipse(1550,750,"solid", "yellow")

logo = overlay(BATMAN, oval)

pic = overlay(logo,back)




