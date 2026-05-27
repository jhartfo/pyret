use context essentials2021

# The Cameroon flag has 4 components.
# To recreate the flag, we need to first 
# define all of of these pieces for Pyret
green-rectangle = rectangle(150, 300, "solid", "forest green")
red-rectangle = rectangle(150, 300, "solid", "red")
yellow-rectangle = rectangle(150, 300, "solid", "yellow")
yellow-star = star(65, "solid", "yellow")

# We also need to define a box to place all of the 
# pieces into.
box = rectangle(450,300,"outline", "black")

# Here, we will add one piece at a time. We begin 
# with green-rectangle and add it to box using
# the put-image function, and we name this new image 
# cameroon1. 
cameroon1 = put-image(green-rectangle,75, 150, box)

# Next, we add red-rectangle to cameroon1 to create a new
# image called cameroon2. We continue adding pieces unitl
# we have the completed flaf called cameroon
cameroon2 = put-image(red-rectangle,225, 150, cameroon1)
cameroon3 = put-image(yellow-rectangle, 375, 150, cameroon2)
cameroon = put-image(yellow-star, 225, 150, cameroon3)

# Click `run` and enter `cameroon` into the Interactions 
# Area to see the Cameroon flag.

