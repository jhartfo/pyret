use context essentials2021
include image
include image-structs

# NOTE: the placement of the stars is random so each time the 
# program is run, a different image is created!
#
# Happy fourth of July!
# Here we design a "New Constellation", the constellation of
# soverign states united in common cause.
# 
##################################################
#
# Contents :
# 
#  1. Define a new data type
#  2. Define constants
#  3. Define Functions
#  4. Define Elements (Blue Sky)
#  5. Define Elements (Stars)
#  6. Define Elements (Text)
#  7. Define Elements (Fireworks)
#  8. Put it all together
#

# 1. ###################################
#
# new data type. Here,
# Posn is an ordered triple which provides
# (x, y, scale) for some element in the 
# final picture.

data Posn:
  | posn(x :: Number, y :: Number) 
end

# 2. ####################################
#
# Let's define some contants

# Basic shape
WT         = 640
HT         = 480
SLICE-HT   = 1

# Stars Counts and Sizes
NUM-STARS  = 80 # aproximate; minimum 16
NUM-BIG-WT = 3
NUM-WHITE  = 13
NUM-RED    = num-round((NUM-STARS - NUM-WHITE - NUM-BIG-WT) / 2)
NUM-BLUE   = num-round((NUM-STARS - NUM-WHITE - NUM-BIG-WT) / 2)

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

# Text
TEXT1      = "Resolved that the Flag of the united states"
TEXT2      = "be 13 stripes alternate red and white, that the union"
TEXT3      = "be 13 stars white in a blue field representing"
TEXT4      = "a new constellation."

# Fireworks positions
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

# 3. ####################################
#
# Let's define some untility functions

# test images and elements for the below examples:
rd = circle(30, "solid", "red")
wh = circle(20, "solid", "white")
bl = circle(10, "solid", "blue")
br = rectangle(100, 100, "solid", "blue")
em = empty-image
md = posn(50, 50)

stack-lists :: List -> List
# stack-lists consumes a List containing other lists and
# returns a new List whose elements come from the elements
# of the component Lists which are appended to the elements 
# of the previous component List. (did you follow that?)
# (it just smashes Lists together.)
examples:
  stack-lists([list: [list:1],[list: 2],[list: 3]]) is [list: 1,2,3]
  stack-lists([list: [list: ],[list:  ],[list:  ]]) is [list: ]
end
fun stack-lists(lists):
  fold(lam(x,y): append(x,y) end, [list:], lists)
end

arrange-images :: Image, List, List -> Image
# arrange-images consumes a base Image, a List of Posns, 
# and a List of Images and will return a new image
# where the elements of the List of images is placed on the base 
# Image at locations from the cooresponding element in the List of
# Posns. 
examples:
  arrange-images(br,[list: md], [list: wh]) is put-image(wh,md.x,md.y,br)
  arrange-images(br,[list: md], [list: rd]) is put-image(rd,md.x,md.y,br)
end
fun arrange-images(base, point-lists, image-lists):
  fold2(lam(b, pt,i): put-image(i,pt.x,pt.y,b) end, base, point-lists, image-lists)
end

stack-above :: Image, List -> Image
# stack-above consumes a base image and a List
# containings images. The function will use above()
# to place each element in the list above the previous 
# image one, beginning with the base image.
examples:
  stack-above(rd, [list: wh, bl]) is above(rd, above(wh, bl))
  stack-above(em, [list: rd, bl]) is above(rd, bl)
end
fun stack-above(start, images):
  fold(lam(x,y): above(x,y) end, start, images)
end

stack-overlay :: Image, List -> Image
# stack-above consumes a base image and a List
# containings images. The function will use above()
# to place each element in the list above the previous 
# image one, beginning with the base image.
examples:
  stack-overlay(rd, [list: wh, bl]) is overlay(rd, overlay( wh, bl))
end
fun stack-overlay(start, images):
  fold(lam(x,y): overlay(x,y) end, start, images)
end


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

# random size for the stars
fun blue-size(num): rand-range(MIN-BLUE, MAX-BLUE) end
fun red-size(num) : rand-range(MIN-RED , MAX-RED ) end

round :: Number, Number -> Number
# round takes in a number, x, and rounds 
# to the n Number of decimals places 
fun round(x,n):
  decimals = num-expt(100,n)
  num-round(decimals * x) / decimals
end

rotate-about-origin :: Posn, Number -> Posn
# rotate-about-origin takes in a Posn, rotates a 
# angle radians nad returns a new Posn
examples:
  rotate-about-origin(posn(1,0),PI / 2) is posn(0,1)
  rotate-about-origin(posn(2,0),PI / 2) is posn(0,2)
end
fun rotate-about-origin(pt, angle):
  x = round((pt.x * num-cos(angle)) - (pt.y * num-sin(angle)),3)
  y = round((pt.x * num-sin(angle)) + (pt.y * num-cos(angle)),3)
  posn(x,y)
end

rotate-about-point :: Posn, Posn, Number -> Posn
# rotate-about-point takes in two Posns. The first is translated
# so that the second lies on the orgin. Then rotated about the 
# orgin before translating back to original position.
examples:
  rotate-about-point(posn(1,0), posn(1,0), PI / 2) is posn(1,0)
  rotate-about-point(posn(2,0), posn(0,0), PI / 2) is posn(0,2)

end
fun rotate-about-point(pt, center, angle):
  translated-pt = posn(pt.x - center.x, pt.y - center.y)
  rotated-pt = rotate-about-origin(translated-pt, angle)
  posn(rotated-pt.x + center.x, rotated-pt.y + center.y)
end

r-to-d :: Number -> Number
# take in a radian (Number) and returns the 
# degrees (Number
examples: 
  r-to-d(2 * PI) is 360
  r-to-d((2 * PI) / 4) is 90
  r-to-d((2 * PI) / 6) is 60
end
fun r-to-d(radian):
  round((radian * 360) / (2 * PI),3)
end

# 4. ####################################
#
shade-rectangle :: Number -> Image
# takes in a number(ht) and creates a 
# rectangle colored in an rgb blue and 
# sized with preset ht and wt. This is used to 
# create the night sky
check:
  shade-rectangle( 0) is rectangle(WT,SLICE-HT, "solid", color(0,0, 0,1))
  shade-rectangle(10) is rectangle(WT,SLICE-HT, "solid", color(0,0,10,1))
end
fun shade-rectangle(ht):
  rectangle(WT, SLICE-HT, "solid", color(0, 0, ht , 1 ))
end

# Here we make a list of blue rectangles then
# stack them together to form the sky
inv-scale   = HT / 50
list-ht     = map(lam(x): x / inv-scale end, range(1, HT))
list-slices = map(shade-rectangle, list-ht)
sky         = stack-above(shade-rectangle(100), list-slices)

# 5. ####################################
#
white-star     :: Number -> Image
blue-star      :: Number -> Image
red-star       :: Number -> Image
white-star-big :: Number -> Image
# Stars are defined as colored circles of different sizes
# or a colors rhombus+circle of different sizes 
#
examples:
  white-star(1)  is 
  scale(1.0, circle(2,"solid", WHITE1))
  blue-star(1.5) is 
  scale(1.5, circle(2,"solid", BLUE1 ))
  red-star(2.5)  is 
  scale(2.5, circle(2,"solid", RED1  ))
end
fun white-star(s):
  scale(s, 
    overlay(
      circle(2,"solid",WHITE1),
      circle(4,"solid",WHITE2))
    )
  end
fun blue-star(s): 
  scale(s, 
    overlay(
      circle(3,"solid",BLUE1),
      circle(5,"solid",BLUE2))
    )
end
fun red-star(s):
  scale(s, 
    overlay(
      circle(3,"solid",RED1),
      circle(5,"solid",RED2))
    )
end
fun white-star-big(s): 
  rotate(1,
  scale(s, overlay(
      white-star(s / 2),
        rhombus(50, 2, "solid",WHITE3)
        )))
end

# Lists of random x coordinates
listx1 = map(random-x000, range(0,NUM-BLUE  ))
listx2 = map(random-x000, range(0,NUM-RED   ))
listx3 = map(random-x000, range(0,NUM-WHITE ))
listx4 = map(random-x000, range(0,NUM-BIG-WT))

# Lists of random y coordinates
listy1 = map(random-y000, range(0,NUM-BLUE  ))
listy2 = map(random-y200, range(0,NUM-RED   ))
listy3 = map(random-y300, range(0,NUM-WHITE ))
listy4 = map(random-y250, range(0,NUM-BIG-WT))

# Lists combined into random ordered pairs
listp1 = map2(posn, listx1, listy1)
listp2 = map2(posn, listx2, listy2)
listp3 = map2(posn, listx3, listy3)
listp4 = map2(posn, listx4, listy4)

# Lists of  star sizes, some random
lists1 = map(blue-size, range(0,NUM-BLUE))
lists2 = map(red-size , range(0,NUM-RED ))
lists3 = repeat(NUM-WHITE , MIN-WHITE)
lists4 = repeat(NUM-BIG-WT, MAX-WHITE)

star1  = map(blue-star     , lists1)
star2  = map(red-star      , lists2)
star3  = map(white-star    , lists3)
star4  = map(white-star-big, lists4)

list-stars = stack-lists([list: star1 , star2 , star3 , star4 ])
star-posns = stack-lists([list: listp1, listp2, listp3, listp4])

# 6. ####################################
#
# red-text :: String -> Image
# takes in a String and displays it red
check:
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

RED-TEXT-1 = red-text(TEXT1)
RED-TEXT-2 = red-text(TEXT2)
RED-TEXT-3 = red-text(TEXT3)
RED-TEXT-4 = red-text(TEXT4)

list-text  = [list: RED-TEXT-1, RED-TEXT-2, RED-TEXT-3, RED-TEXT-4]
text-posns = [list: posn(194,86), posn(237,63), posn(205,40), posn(100,20)]

# 7. ###################################
#
# Here, we are creating fireworks. It takes
# several steps:
# 
# 1. Define functions to create variable
#    Green and variable Red
# 2. Define functions for the red and green
#    streaks that represent the fireworks
# 3. Build rings of streaks
#
# my-red :: Number -> color
# takes in a number returns a shade of red
check:
  my-red( 0) is color(255, 160, 160, 1.00)
  my-red(10) is color(255, 130, 130, 0.00)
end
fun my-red(x,t):
  color(255, (160 - (3 * x)), (160 - (3 * x)), t)
end

# my-green :: Number -> color
# takes in a number returns a shade of green
check:
  my-green( 0) is color(160, 255, 160, 1.00)
  my-green(10) is color(130, 255, 130, 0.00)
end
fun my-green(x,t):
  color( (160 - (3 * x)), 255, (160 - (3 * x)), t)
end

list-angle   = map(lam(x): (2 * PI * x) / NUM-SECT end, range(0,NUM-SECT))
radii        = range-by(MIN-RADIUS, MAX-RADIUS + STEP-SIZE, STEP-SIZE)
flash-radii  = range-by(0, MAX-RADIUS, 2)

fun red-streak(size, angle): 
    rotate( angle, overlay(
      ellipse((size + 0), 3, "solid", my-red(1,1)),
      ellipse((size + 3), 8, "solid", my-red(size * 3, size / 100))))
end

red-rings = stack-lists(
  map(
    lam(r): map(
        lam(a): red-streak(r / 3, (360 * a) / (2 * PI)) end, map(
        lam(x): x + (r / OFF-SET) end, list-angle)) end, radii)
  )

red-posns = stack-lists(
  map(
    lam(r): map(
      lam(a): posn(
            HR + (r * num-cos(a)),
            KR + (r * num-sin(a))
          ) end, map(
        lam(x): x + (r / OFF-SET) end, list-angle)) end, radii)
  )

red-flash = stack-overlay(empty-image,
  map(lam(r): 
    circle(r,"solid", my-red(1.0 * r, 1 - (r / 50))) end,flash-radii))

fun green-streak(size, angle): 
    rotate( angle, overlay(
      ellipse((size + 0), 3, "solid", my-green(1,1)),
      ellipse((size + 3), 8, "solid", my-green(size * 3, size / 100))))
end

green-rings = stack-lists(
  map(
    lam(r): map(
        lam(a): green-streak(r / 3, (360 * a) / (2 * PI)) end, map(
        lam(x): x + (r / OFF-SET) end, list-angle)) end, radii)
  )

green-posns = stack-lists(
  map(
    lam(r): map(
      lam(a): posn(
            HG + (r * num-cos(a)),
            KG + (r * num-sin(a))
          ) end, map(
        lam(x): x + (r / OFF-SET) end, list-angle)) end, radii)
  )

green-flash = stack-overlay(empty-image,
  map(lam(r): 
    circle(r,"solid", my-green(1.0 * r, 1 - (r / 50))) end,flash-radii))

flash       = [list: red-flash, green-flash]
flash-posns = [list: posn(HR,KR), posn(HG,KG)]
    
#|

r-streak :: Number, Number -> Image
# takes in two Numbers, size and angle, returns a Red streak
# This will produce the individual flashes
check:
  r-streak(10,10) is rotate((10 * 360) / (2 * PI), overlay(
      ellipse((10), 5,"solid",my-red( 0)),
      ellipse((13),12,"solid",my-red(10))))
end
fun r-streak(size, angle): rotate( angle, overlay(
      ellipse((size + 0),  5, "solid", my-red(0)),
      ellipse((size + 3), 12, "solid", my-red(size))))
end

g-streak :: Number, Number -> Image
# takes in a number returns a Green streak
# This will produce the individual flashes
check:
  g-streak(10,10) is rotate((10 * 360) / (2 * PI), overlay(
      ellipse((10), 5,"solid",my-green( 0)),
      ellipse((13),12,"solid",my-green(10))))
end
fun g-streak(size, angle): rotate( angle, overlay(
      ellipse((size + 0), 5,"solid",my-green(0)),
      ellipse((size + 3),12,"solid",my-green(size))))
end

list-angle  = map(lam(x): (2 * PI * x) / NUM-SECT end, range(0,NUM-SECT))
radii       = range-by(20, MAX-RADIUS + 1, 1)



red-rings   = stack-lists(map(
    lam(x): map(
        lam(y): r-streak(
        x / 3, r-to-d(y) - (0)) end, list-angle) end, radii))



red-rings = stack-lists(map(
    lam(a): map(
      lam(r): r-streak(r, r-to-d(a) - ((r / 10) + 1)) end, radii) end,list-angle)
  )


red-posns  = stack-lists(map(
    lam(a): map(
      lam(r): posn(
            HR + (r * num-cos(a - (r / 100))),
            KR + (r * num-sin(a - (r / 100)))
        ) end, radii) end,list-angle)
  )
  


green-rings = stack-lists(map(
    lam(x): map(
        lam(y): g-streak(x / 3, r-to-d(y) + ((x / 10) - 1)) end, map(
        lam(z): z + (0) end, list-angle)) end, radii))







lr2        = map(lam(x): r-streak( 20,x) end, list-angle)
lr3        = map(lam(x): r-streak( 30,x) end, list-angle)
lr4        = map(lam(x): r-streak( 40,x) end, list-angle)
lr5        = map(lam(x): r-streak( 50,x) end, list-angle)
lr6        = map(lam(x): r-streak( 60,x) end, list-angle)
lr7        = map(lam(x): r-streak( 70,x) end, list-angle)
lr8        = map(lam(x): r-streak( 80,x) end, list-angle)
lr9        = map(lam(x): r-streak( 90,x) end, list-angle)
lr0        = map(lam(x): r-streak(100,x) end, list-angle)
list-red   = stack-lists([list: lr2, lr3, lr4, lr5, lr6, lr7, lr8, lr9, lr0])

lg2        = map(lam(x): g-streak( 20,x) end, list-angle)
lg3        = map(lam(x): g-streak( 30,x) end, list-angle)
lg4        = map(lam(x): g-streak( 40,x) end, list-angle)
lg5        = map(lam(x): g-streak( 50,x) end, list-angle)
lg6        = map(lam(x): g-streak( 60,x) end, list-angle)
lg7        = map(lam(x): g-streak( 70,x) end, list-angle)
lg8        = map(lam(x): g-streak( 80,x) end, list-angle)
lg9        = map(lam(x): g-streak( 90,x) end, list-angle)
lg0        = map(lam(x): g-streak(100,x) end, list-angle)
list-green = stack-lists([list: lg2, lg3, lg4, lg5, lg6, lg7, lg8, lg9, lg0])



red-posns  = stack-lists(map(
    lam(x): map(
      lam(y): posn(
            (x * num-cos(y + ((x / 10) - 1))) + HR, 
            (x * num-sin(y + ((x / 10) - 1))) + KR
        ) end, list-angle) end,radii)
  )

  
green-posns  = stack-lists(map(
    lam(x): map(
        lam(y): rotate-about-point(posn(HG + x, KG), posn(HG,KG), y) end, map(
        lam(z): z - ((x / 40)) end, list-angle) ) end , radii))

  |#
# 8. ###################################
#
# Let's put it all together!
#



image1 = arrange-images(sky,    star-posns  , list-stars )  
image2 = arrange-images(image1, text-posns  , list-text  )
image3 = arrange-images(image2, flash-posns , flash      ) 
image4 = arrange-images(image3, red-posns   , red-rings  ) 
image5 = arrange-images(image4, green-posns , green-rings) 

scale(1,image5  )
  

# Alternative star design
# scale(0.03,radial-star(220, 120, 0, "outline", "red"))

  
