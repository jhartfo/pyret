use context essentials2021
include color

# NOTE: the placement of the stars is random so each time the 
# program is run, a different image is created!
#
# Happy fourth of July!
# Here we design a "New Constellation", the constellation of
# soverign states united in common cause.
# 
###########################################
#
# Contents :
# 
#  1.     Definitions  
#  1.a.     Define Constants
#  1.b.     Define Functions
#  1.b.1.     Draw Sky and Stars Functions
#  1.b.2.     Draw Text Functions
#  1.b.2.     Starburst Colors
#  1.b.3.     Draw Starbusts
#  1.b.4.     Generate Random Numbers
#  1.b.5.     Trig and Algebra Functions for calculating Starbusts
#  2.     Components
#  2.a.     Sky and Star Components
#  2.b.     Text Components
#  2.c.     Starbust Components
#  3.     Put it all together!
#


###########################################
# 1.a. Define Constants                   #
###########################################

# Dimensions of the final image
WT         = 640
HT         = 480

# Stars Counts
NUM-STARS  = 80 # aproximate; minimum 16
NUM-BIG-WT = 3
NUM-WHITE  = 13
NUM-RED    = num-round((NUM-STARS - NUM-WHITE - NUM-BIG-WT) / 2)
NUM-BLUE   = num-round((NUM-STARS - NUM-WHITE - NUM-BIG-WT) / 2)

# Constraints on size of stars
MIN-WHITE  = 0.60
MAX-WHITE  = 0.80
MIN-RED    = 0.30
MAX-RED    = 0.60
MIN-BLUE   = 0.30
MAX-BLUE   = 0.60

# Colors
WHITE1     = "white"
WHITE2     = color(250,250,150,0.50)
WHITE3     = color(250,250,150,0.30)
BLUE1      = color(180,180,255,0.90)
BLUE2      = color(000,000,255,0.50)
RED1       = color(255,180,100,0.90)
RED2       = color(255,030,000,0.50)
RED3       = "crimson"

# Highest rgb blue value allowed
# the larger the number, the lighter/bluer 
# the bottom of the image will be
BLUE-MAX   = 50

# Text
TEXT1      = "Resolved that the Flag of the united states"
TEXT2      = "be 13 stripes alternate red and white, that the union"
TEXT3      = "be 13 stars white in a blue field representing"
TEXT4      = "a new constellation."

# Fireworks positions G(H,K) and R(H,K)
HG         = 580
KG         = 150
HR         = 480
KR         = 180

# Firework configuration
NUM-SECT   = 15
MIN-RADIUS = 15
MAX-RADIUS = 80
NUM-LAYERS = 10

STEP-SIZE  = (MAX-RADIUS - MIN-RADIUS) / NUM-LAYERS
OFF-SET    = (STEP-SIZE * NUM-SECT) / 9

###########################################
# 1.b. Functions                          #
###########################################

# reverse-put-image :: Image, Number, Number, Image -> Image
# just put-image with the parameters rearranged
fun reverse-put-image(bs, x, y, im):
  put-image(im, x, y, bs)
end

# sky-slice :: Number -> Image
# takes in a Number and draws a blue rectangle colored
# a rgb blue value of the Number
examples:
  sky-slice(0)  is rectangle(WT, 1, "solid", color(0,0, 0,1))
  sky-slice(50) is rectangle(WT, 1, "solid", color(0,0,50,1))
end
fun sky-slice(n):
  rectangle(WT, 1, "solid", color(0,0,n,1))
end

# sim-star :: Number, Color, Color -> Image
# Takes in a Number and Two Colors creates two overlayed
# circles to simulate a star
examples:
  sim-star(3, BLUE1, BLUE2) is scale(3, overlay(
      circle(2,"solid",BLUE1),
      circle(4,"solid",BLUE2))
    )
  sim-star(4,  RED1,  RED2) is scale(4, overlay(
      circle(2,"solid",RED1),
      circle(4,"solid",RED2))
    )
end
fun sim-star(s,clr1, clr2):
  scale(s, 
    overlay(
      circle(2,"solid",clr1),
      circle(4,"solid",clr2))
    )
end
  
# white-star :: Number -> Image
# blue-star  :: Number -> Image
# red-star   :: Number -> Image
# The following functions are each special cases
# of a sim-star

fun white-star(s): sim-star(s, WHITE1, WHITE2) end
fun blue-star(s) : sim-star(s, BLUE1,  BLUE2)  end
fun red-star(s)  : sim-star(s, RED1,   RED2)   end

# white-star-big :: Number -> Image
# takes in a Number and returns a white-star 
# overlays with a rhombus
examples:
  white-star-big(3) is rotate(1,
    scale(3, overlay(
        white-star(3 / 2),
        rhombus(50, 2, "solid", WHITE3)
        )))
  white-star-big(4) is rotate(1,
    scale(4, overlay(
        white-star(4 / 2),
        rhombus(50, 2, "solid", WHITE3)
        )))  
end
fun white-star-big(s): 
  rotate(1,
  scale(s, overlay(
      white-star(s / 2),
        rhombus(50, 2, "solid",WHITE3)
        )))
end

#########################################

# red-text :: String -> Image
# takes in a String and displays it in red
examples:
  red-text("s") is text-font("s", 20, RED3,"normal",
    "decorative","normal","bold", false)
  red-text("") is text-font("", 20, RED3,"normal",
    "decorative","normal","bold", false)
end
fun red-text(my-text):
  text-font(
    my-text, 
    20, 
    RED3,
    "normal",
    "decorative",
    "normal",
    "bold", 
    false)
end

#########################################

# streak-red :: Number -> color
# takes in a number returns a shade of red
examples:
  streak-red( 0,1) is color(255, 160, 160, 1.00)
  streak-red(10,0) is color(255, 130, 130, 0.00)
end
fun streak-red(x,t):
  color(255, (160 - (3 * x)), (160 - (3 * x)), t)
end

# streak-green :: Number -> color
# takes in a number returns a shade of green
examples:
  streak-green( 0,1) is color(160, 255, 160, 1.00)
  streak-green(10,0) is color(130, 255, 130, 0.00)
end
fun streak-green(x,t):
  color( (160 - (3 * x)), 255, (160 - (3 * x)), t)
end

#########################################

# streak :: Number, Number, String -> Image
# takes in a two Numbers (size and angle) and a 
# color (red or green) returns of overlayed 
# ellipses rotated by the angle 
examples:
  streak(10, 0, "green") is rotate( 0, overlay(
      ellipse((10 + 0), 3, "solid", streak-green(1,1)),
      ellipse((10 + 3), 8, "solid", streak-green(10 * 3, 10 / 100))))
  streak(20,90, "red")   is rotate(90, overlay(
      ellipse((20 + 0), 3, "solid", streak-red(1,1)),
      ellipse((20 + 3), 8, "solid", streak-red(20 * 3, 20 / 100))))
end
fun streak(size, angle, clr):

  clr1 = block:
    if clr == "red":  
      streak-red(1,1)
    else: 
      streak-green(1,1)
    end 
  end
  
  clr2 = block:
    if clr == "red":  
      streak-red(size * 3, size / 100)
    else: 
      streak-green(size * 3, size / 100)
    end 
  end
  
  top = ellipse((size + 0), 3, "solid", clr1)
  bot = ellipse((size + 3), 8, "solid", clr2)
  rotate( angle, overlay(top, bot))
end  
  
# red-streak   :: Number, Number -> Image
# green-streak :: Number, Number -> Image
# special cases of streak
fun red-streak(s,a)  : streak(s,a,"red")   end
fun green-streak(s,a): streak(s,a,"green") end


fun green-flash(r):
  circle(r,"solid", streak-green(1.0 * r, 1 - (r / 50)))
end

fun red-flash(r):
  circle(r,"solid", streak-red(  1.0 * r, 1 - (r / 50)))
end

#########################################

rand-range :: Number, Number -> Number
# rand-range consumes a lower Number and a upper Number
# and returns a random Number between the two.
fun rand-range(a,b):
  num-random(b - a) + a
end

# These functions will generate random values
# with a lower limit indictated in the function
# name and a upper limit of WT or HT.
# There is one random-x because we want the 
# stars across the entire width. But there are
# several random y functions because certain 
# stars will only populate in certain altitudes
# in the picture.

# num is a dumby variable and it not used, but 
# is necessary when the function is used as a 
# parameter in the map() function.

random-x000 :: Number -> Number
random-y000 :: Number -> Number
random-y200 :: Number -> Number
random-y250 :: Number -> Number
random-y300 :: Number -> Number

fun random-x000(num): rand-range(0  , WT ) end
fun random-y000(num): rand-range(0  , HT ) end
fun random-y200(num): rand-range(200, HT ) end
fun random-y250(num): rand-range(250, HT ) end
fun random-y300(num): rand-range(300, HT ) end

fun rand-b-size(num): rand-range(MIN-BLUE, MAX-BLUE) end
fun rand-r-size(num): rand-range(MIN-RED , MAX-RED ) end

#########################################

# rad-to-deg :: Number -> Nmber
# converts radians to degrees
examples:
  rad-to-deg(2 * PI) is 360
  rad-to-deg(PI / 2) is 90
end
fun rad-to-deg(x): num-exact((360 * x) / (2 * PI)) end

# find-raw-angle :: Number -> Number
# Takes in a Number (0 to NUM-SECT). After dividing the circle 
# into NUM-SECT sectors, find -raw-angle determines 
# the degrees for the nth position around the circle
examples:
  find-raw-angle(1) is num-exact((1 / NUM-SECT) * (2 * PI))
  find-raw-angle(3) is num-exact((3 / NUM-SECT) * (2 * PI))
end
fun find-raw-angle(n): num-exact((n / NUM-SECT) * (2 * PI)) end

# find-x :: Number, Number -> Number
# find-y :: Number, Number -> Number
# takes in 2 NUmbers (radius and angle) and finds x-coordinate
# and y-coordinate (respectively) on a circle of the given radius
# at the given angle
examples:
  find-x(2,PI / 4) is num-exact(2 * num-cos(PI / 4))
  find-y(3,PI / 2) is num-exact(3 * num-sin(PI / 2))
end
fun find-x(r,a): num-exact(r * num-cos(a)) end
fun find-y(r,a): num-exact(r * num-sin(a)) end

# to-r-offset :: Number, Number -> Number
# takes in 2 Numbers (radius and angle) given the radius and
# a constant OFF-SET, the raw angle is adjusted
# build texture in the overall starburst
examples:
  to-r-offset(2,4) is num-exact(4 + (2 / OFF-SET))
  to-r-offset(3,5) is num-exact(5 + (3 / OFF-SET))
end
fun to-r-offset(r,a): num-exact(a + (r / OFF-SET)) end 

# repeating-r :: Number -> List
# Takes in a NUmber and creates a List of 
# NUM-SECT copies of the Number.
examples:
  repeating-r(1) is repeat(NUM-SECT, 1)
  repeating-r(2) is repeat(NUM-SECT, 2)
end
fun repeating-r(x): repeat(NUM-SECT, x) end


###########################################
# 2.a. Star Components                    #
###########################################

# Lists of random x coordinates
starx1 = map(random-x000, range(0,NUM-BLUE  ))
starx2 = map(random-x000, range(0,NUM-RED   ))
starx3 = map(random-x000, range(0,NUM-WHITE ))
starx4 = map(random-x000, range(0,NUM-BIG-WT))

# Lists of random y coordinates
stary1 = map(random-y000, range(0,NUM-BLUE  ))
stary2 = map(random-y200, range(0,NUM-RED   ))
stary3 = map(random-y300, range(0,NUM-WHITE ))
stary4 = map(random-y250, range(0,NUM-BIG-WT))

# Lists of  star sizes, some random
stars1 = map(rand-b-size, range(0,NUM-BLUE))
stars2 = map(rand-r-size, range(0,NUM-RED ))
stars3 = repeat(NUM-WHITE , MIN-WHITE)
stars4 = repeat(NUM-BIG-WT, MAX-WHITE)

# Creates actual star Images
star1  = map(blue-star     , stars1)
star2  = map(red-star      , stars2)
star3  = map(white-star    , stars3)
star4  = map(white-star-big, stars4)

# lists of stars, xs, ys
starx = fold(append,[list:], [list: starx1, starx2, starx3, starx4])
stary = fold(append,[list:], [list: stary1, stary2, stary3, stary4])
stars = fold(append,[list:], [list: star1 , star2 , star3 , star4 ])

###########################################
# 2.b. Text Components                    #
###########################################

red-text-1    = red-text(TEXT1)
red-text-2    = red-text(TEXT2)
red-text-3    = red-text(TEXT3)
red-text-4    = red-text(TEXT4)

text-lines    = [list: red-text-1, red-text-2, red-text-3, red-text-4]
textx         = [list: 194, 237, 205, 100]
texty         = [list:  86,  63,  40,  20]

###########################################
# 2.c. Starbust Components                #
###########################################

flash-radii   = range-by(0, MAX-RADIUS / 2, 2)

lst-raw-angle = map(find-raw-angle, range(0,NUM-SECT))
radii         = range-by(MIN-RADIUS, MAX-RADIUS + STEP-SIZE, STEP-SIZE)
r-repeated    = fold(append,[list:], map(repeating-r, radii))
a-repeated    = fold(append,[list:],repeat(NUM-LAYERS + 1, lst-raw-angle))
a-offset      = map2(to-r-offset, r-repeated, a-repeated)

list-sizes    = map(_ / 3, r-repeated)
list-angles   = map(rad-to-deg,a-offset)    
cos-list      = map2(find-x, r-repeated, a-offset)
sin-list      = map2(find-y, r-repeated, a-offset)

red-rings     = map2(red-streak  , list-sizes,list-angles)
red-x         = map(_ + HR,cos-list)
red-y         = map(_ + KR,sin-list)

green-rings   = map2(green-streak, list-sizes,list-angles)
green-x       = map(_ + HG,cos-list)
green-y       = map(_ + KG,sin-list)

red-flashes   = map(red-flash  , flash-radii)
red-flash-x   = repeat(length(flash-radii),HR)
red-flash-y   = repeat(length(flash-radii),KR)

green-flashes = map(green-flash, flash-radii)
green-flash-x = repeat(length(flash-radii),HG)
green-flash-y = repeat(length(flash-radii),KG)

# lists of starburst, xs, ys
starbursts    = fold(append,[list:],
  [list: red-flashes, green-flashes, red-rings, green-rings])

starburst-x   = fold(append,[list:],
  [list: red-flash-x, green-flash-x, red-x, green-x])

starburst-y   = fold(append,[list:],
  [list: red-flash-y, green-flash-y, red-y, green-y])

# this just what the flash looks like by istelf
flash-example = overlay(
  fold(overlay,empty-image,red-flashes),
  square(100,"solid","black"))

###########################################
# 3. Put it all together!!!               #
###########################################

the-void     = fold(
  above, 
  empty-image,
  map(sky-slice, range-by(0,BLUE-MAX, BLUE-MAX / HT))
  )

sky          = fold3(reverse-put-image, the-void,  
  starx      , stary      , stars)

sky-and-text = fold3(reverse-put-image, sky, 
  textx      , texty      , text-lines)

sky-and-all  = fold3(reverse-put-image, sky-and-text, 
  starburst-x, starburst-y, starbursts)

sky-and-all




