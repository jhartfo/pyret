use context starter2024

provide * 



import url("https://raw.githubusercontent.com/jhartfo/pyret/refs/heads/main/bootstrap-statistics/visualizations/pascals-triangle.arr") as PT
provide from PT: * end

# testing has shown forming these functions directly
# with map and fold is more effecient than using recursion

#|hiding(
    # don't pass the incremental helper functions 
    # for drawing the pascal's triangle
    num-to-x-range, num-to-y-range, pos-to-x, 
    build-row-x, pos-to-y, build-row-y)
end
|#

is-all-numbers = _.all(is-number)

list-product :: List<Number>%(is-all-numbers) -> Number
fun list-product(lst): 
  fold(_ * _, 1, lst) 
end

list-sum :: List<Number>%(is-all-numbers) -> Number
fun list-sum(lst): 
  fold(_ + _, 0, lst) 
end

list-squared-sum :: List<Number>%(is-all-numbers) -> Number
fun list-squared-sum(lst): 
  list-sum(map(num-sqr, lst)) 
end

num-triangular :: NumInteger -> Number
fun num-triangular(n): 
  (n * (n + 1)) / 2 
end 

factorial :: NumInteger -> Number
fun factorial(n):
  fold(_ * _, 1, range-by(1,n + 1,1))
end

falling-factorial :: NumInteger, NumInteger -> Number
fun falling-factorial(n,k):
  fold(_ * _, 1, range-by(n - k - -1,n + 1,1))
end

rising-factorial :: NumInteger, NumInteger -> Number
fun rising-factorial(n,k):
  fold(_ * _, 1, range-by(n,n + k,1))
end

list-sqr-sum      = list-squared-sum
tri-number        = num-triangular
triangular-number = num-triangular
permutation       = falling-factorial

combination :: NumInteger, NumInteger -> Number
fun combination(n,k):
  permutation(n,k) / factorial(k)
end

fun pascals-row(n):
  map(combination(n,_), range-by(0,n + 1,1))
end

fun pascals-triangle(n :: Number) -> List:
  map(pascals-row, range-by(0,n,1))
end

#|
#########################################

# this section generates an Image of Pascal's Triangle
# that is colored as in Sierpinski's triangle 

# First a few constants

SHELL  = 1.05
RADIUS = 20
CLR1   = "black"
CLR2   = "sky blue"
CLR3   = "yellow"
CLR4   = "lime green"

#########################################

# just like put-image but inputs are swapped
# places nicely with fold
reverse-put-image = lam(base, x,y,im): put-image(im, x,y, base) end

hexagon :: Number, String, String -> Image
# creates a regular hexagon pointing up, 
# for tiling the triangle
fun hexagon(r, style, clr):
  rotate(90, regular-polygon(r, 6,style , clr))
end

# if n is even -> CLR2
# if n is odd  -> CLR3
fun sierpinski-color(n:: Number):
  if num-modulo(n,2) == 0: CLR2
  else: CLR3
  end
end

# creates a hexgon with border with the 
# Number displayed on the interior and
# colored accoring to the sierpinski triangle
fun block(n:: Number) -> Image:
  clr       = sierpinski-color(n)
  hex-fill  = hexagon(RADIUS,"solid", clr)
  hex-shell = hexagon(RADIUS * SHELL,"solid", CLR1)

  overlay(text(num-to-string(n), RADIUS * 0.5, CLR1),
    overlay(hex-fill, hex-shell))
end

#########################################

HEX-WT = image-width( hexagon(RADIUS,"solid", CLR1)) / 2 
BLK-WT = image-width( block(1)) / 2
BDR-WT = BLK-WT - HEX-WT

HEX-MD = RADIUS * cos(2 * PI * 1/6)
BLK-MD = RADIUS * cos(2 * PI * 1/6) * SHELL
HEX-PT = (image-height(hexagon(RADIUS,"solid", CLR1)) / 2) - HEX-MD 
BLK-PT = (image-height(block(1)) / 2)                      - BLK-MD
BDR-HT = BLK-WT - HEX-WT
HEX-HT = (image-height(hexagon(RADIUS,"solid", CLR1)) / 2) 
BLK-HT = (image-height(block(1)) / 2)                      

#########################################

num-to-x-range :: Number, Number -> List
# creates the list of x positions by row
fun num-to-x-range(n,nr):
  range-by(1, n + 1, 1)
end

num-to-y-range :: Number, Number -> List
# creates the list of y positions by row
fun num-to-y-range(n, nr):
  #f = print(repeat(n, ((nr + 1) - n)))
  repeat(n, ((nr + 1) - n))
end

pos-to-x :: Number, Number, Number -> Number
# maps an x position to an x coordinate given
# a row and number of rows
fun pos-to-x(x, r, nr):
  ((HEX-WT + (BDR-HT * 1/2)) * (nr - r)) +  # ROW START
  ((HEX-WT + BLK-WT) * x)                   # POSITION
end

build-row-x :: Number, Number -> List
# consumes a Number, n, converts that 
# Number into range of numbers from 1 to n+1
# Then we map number in the new range to the specified coordinates
fun build-row-x(r,nr):
  map(pos-to-x(_, r, nr), num-to-x-range(r,nr))
end

pos-to-y :: Number -> Number
# maps an y position to an y coordinate given
# a row and number of rows
fun pos-to-y(r):
  (r * (HEX-PT + BLK-MD + BLK-MD)) + BLK-HT + BLK-MD
end

build-row-y :: Number, Number -> List
# consumes a Number, n, converts that 
# Number into range of numbers from 1 to n+1
# Then we map number in the new range to the specified coordinates
fun build-row-y(r, nr):
  repeat(r, pos-to-y(nr - r))
end

fun image-pascals-triangle(numrows):
  wt   = pos-to-x(numrows,32,32) + (BLK-WT * 2)
  ht   = pos-to-y(numrows)
  bg   = rectangle(wt,ht, "solid", CLR4 ) 
  rows = range-by(numrows, 0, -1)
  pt   = pascals-triangle(numrows).reverse()
  H    = map(block, fold(append, empty, pt))
  X    = fold(append, empty, map(build-row-x(_, numrows), rows))
  Y    = fold(append, empty, map(build-row-y(_, numrows), rows))
 
  fold3(reverse-put-image, bg, X,Y,H)
end

|#



