use context url-file("https://raw.githubusercontent.com/bootstrapworld/starter-files/fall2026/projects/games", "../../libraries/game-library.arr")

# 0. Game title: Write the title of your game here
TITLE         = "Luke's Ice Cream Extravaganzza"
TITLE-COLOR   = "white"

im-url-prefix = "https://raw.githubusercontent.com/jhartfo/pyret/main/pyret-art/images/"

# Graphics - danger, target, projectile and player images
BACKGROUND    = scale(1.00,image-url(im-url-prefix + "tatooine.jpg"))
DANGER        = scale(0.40,image-url(im-url-prefix + "snake.png"))
TARGET        = scale(0.40,image-url(im-url-prefix + "iceCream.png"))
PLAYER        = scale(0.40,image-url(im-url-prefix + "luke.png"))

# here's a screenshot of the game, with the PLAYER at (320, 240),
# the TARGET at (400 500) and the DANGER at (150, 200)
SCREENSHOT    = 
  translate(DANGER, 150, 200,
    translate(TARGET, 400, 500, 
      translate(PLAYER, 320, 240, BACKGROUND)))

######################################################
# 1. Making the Danger and the Target Move

update-danger :: Number, Number -> Posn
# given the danger's x-coordinate, output the NEXT x

# write EXAMPLEs for update-danger below this line

fun update-danger(x,y):
  posn(x - 5, y)
end

update-target :: Number, Number -> Posn
# given the target's x-coordinate and y-coordinate, output the NEXT x

# write EXAMPLEs for update-target below this line
examples:
  0 is 0
end
fun update-target(x,y):
  posn(x + 10, y)
end

######################################################
# 2. Making the Danger and the Target Come Back Again: 
#    We need to know that they're gone!  
#    Are they on the screen?

is-safe-left :: Number -> Boolean
# Is the character visible on the left side of the screen?

# Write an EXAMPLE that makes this true, and one that makes this false:

fun is-safe-left(x):
  x > -50
end

is-safe-right :: Number -> Boolean
# Is the character visible on the right side of the screen?

# Write an EXAMPLE that makes this true, and one that makes this false:

fun is-safe-right(x):
  x < 690
end

is-onscreen :: Number, Number -> Boolean
# Determines if the coordinate is on the screen

# EXAMPLEs:

fun is-onscreen(x, y):
  is-safe-left(x) and is-safe-right(x)
end

fun update-player(x, y, key):
  if (key == "up") and (y < 520) :
    posn(x, y + 10)
    
  else if (key == "w") and (y < 620):
    posn(x, y + 20)
    
  else if (key == "w") and (y >= 620):
    posn(x, -20)
    
  else if (key == "down") and (y > -20) :
    posn(x, y - 10)
    
  else if (key == "x") and (y > -20) :
    posn(x, y - 20)
    
  else if (key == "x") and (y <= -20) :
    posn(x, 620)
    
  else if (key == "h")  :
    posn(x, -1 * y)

  else if (key == "s")  :
    posn(x, -1 * y)
    
  else if (key == "right") and (x <= 680) :
    posn(x + 10, y)

  else if (key == "left")  and (x >= -30):
    posn(x - 10, y)

  else if (key == "d") and (x <= 700) :
    posn(x + 20, y)

  else if (key == "a")  and (x >= -50):
    posn(x - 20, y)

  else if (key == "a")  and (x < -50):
    posn(680, y)

  else if (key == "d") and (x > 700) :
    posn(-100, y)    
    
  else:
    posn(x, y)
    
  end
end

######################################################
# 4. Collisions: When the player is close enough to the Target
#    or the Danger, then something should happen!
#    We need to know what "close enough" means, and we need to
#    know how far apart things are.

# If _distances-color_ is set to "yellow", then the game will draw
# a yellow triangle between the player and each character. 
# That triangle will be labelled with line-length on the legs,
# and with distance on the hypotenuse. (This works for any valid color)
_distances-color_ = ""

line-length :: Number, Number -> Number
# the distance between two points on a number line
# some examples - notice that we should always return the
# same answer, no matter what the order of the inputs is!
examples:
  line-length(20, 10) is 20 - 10
  line-length(10, 20) is 20 - 10
end

fun line-length(a, b):
  if a > b: a - b
  else: b - a
  end
end

distance :: Number, Number, Number, Number -> Number
# The distance between two points on screen:
# We have the player's x and y, and a character's x and y.
# How far apart are they?
# EXAMPLEs:

fun distance(px, py, cx, cy):
  num-sqrt(((px - cx) * (px - cx)) + ((py - cy) * (py - cy)))
end

is-collision :: Number, Number, Number, Number -> Boolean 
# How close is close enough?  
# We have the player's x and y, and a character's x and y.
# We can ask how far apart they are.  Did they collide?
# EXAMPLEs:


fun is-collision(px, py, cx, cy):
  distance(px, py, cx, cy) < 70
end

mystery = radial-star(5, 5, 3, "solid", "silver")
fun update-mystery(x, y):
  x + 20
end

######################################################
# PROVIDED CODE

g = make-game(TITLE, TITLE-COLOR,
  BACKGROUND,
  DANGER, update-danger,
  TARGET, update-target,
  PLAYER, update-player,
  mystery, update-mystery,
  _distances-color_, line-length, distance,
  is-collision, is-onscreen)

play(g)

