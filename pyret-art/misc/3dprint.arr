include image
include shared-gdrive("printLibrary.arr", "1KZ0Nuk194iINaNJ2FPC4VCoodI6sQvOs")

#|
  Click Run. 
   This will produce three tables that will provide the model 
   for object. In Notepad, or other unformatted text editor, 
   open a new plain text file with the extension .obj
   
   Copy and past, in order each of the three tables (Make sure 
   to "Click to show the remaining rows. " There is a clipboard 
   button at the top-right corner of each table.
   
   Inside the .obj file there are two tweeks to complete our model
   1. all of the "v" and "f" need to be changed to just v and f.
   2. The headers of each table need to be deleted. 
   
   After this is complete, save the file. 
   Now the file should be a well-defined .obj 3D model
|#

# 100-gon is pretty good approximation 
# for a circle
NUM-SIDES      = 100 
ANGLES         = (360 / NUM-SIDES) * ((2 * PI) / 360)
DX             = 0.1
XMIN           = 0
XMAX           = 1
list-positions = range(0,NUM-SIDES)
list-angles    = map(lam(x): x * ANGLES end ,list-positions)

# This function provides the profile for the solid formed
# by revoling about the x-axis
Radius :: Number -> Number
fun Radius(x):
  (-1 * x) + 1
end

# layers provides a list of x values for a function
# radii provides a list of radii that corresponds
# with a given x
layers = range-by(XMIN,XMAX,DX)
radii  = map(Radius, layers)

##############################
# here build the data for our object

# finds all the vertices in the model
vertex-table(NUM-SIDES, layers, radii) 

# connects all the vertices by drawing lots of 
# tiny quadrilaterals faces this is what the 
# printer actually prints 
make-faces(NUM-SIDES, layers, radii)    

# we probably need to top and bottom so that our model 
# is solid and printable
make-caps(NUM-SIDES, layers.length())




