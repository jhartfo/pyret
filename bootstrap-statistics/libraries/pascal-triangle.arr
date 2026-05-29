use context starter2024

# this program generates an Image of Pascal's Triangle
# that is colored as in Sierpinski's triangle 

radius = 20
row    = 32
shell  = 1.05
Xunit  = radius * sin(2 * PI * 1/6)
Yunit  = radius * cos(2 * PI * 1/6)
bg     = square(2 * shell * radius * row, "solid", "lime-green" )

clr1   = "black"
clr2   = "sky blue"
clr3   = "yellow"

reverse-put-image = lam(base, x,y,im): put-image(im, x,y, base) end

fun factorial(n): fold(_ * _, 1, range(1,n + 1)) end
fun combo(n,k): factorial(n) / factorial(n - k) / factorial(k) end

fun hexagon(r, style, clr):
  x   = lam(t): r * sin(t * 2 * PI * 1/6) end
  y   = lam(t): r * cos(t * 2 * PI * 1/6) end
  pts = map(lam(t): point(x(t), y(t)) end, range(0,6))
  point-polygon(pts, style, clr)
end

fun block(n):
  clr       = 
    if num-modulo(n,2) == 0: clr2
    else: clr3
  end
  hex-fill  = hexagon(radius,"solid", clr)
  hex-shell = hexagon(radius * shell,"solid", clr1)

  overlay(text(num-to-string(n), radius * 0.5, clr1),
    overlay(hex-fill, hex-shell))
end

fun triangular(n):
  n * (n + 1) * 1/2
end

X = fold(append, empty, map(
    lam(n): map(
        lam(x): ((Xunit * 2 * x) - (Xunit * (n + 1))) + ((row + 1) * Xunit) end,
      range(1, n + 1)) end, 
    range-by(row, 0, -1)))

Y = fold(append, empty, map(    
    lam(x): map(lam(n): ((n - 1) * 2 * radius) + (x * Yunit) end, repeat(x, ((row + 1) - x))) end, 
    range-by(row, 0, -1)))

H = map(block, fold(append, empty,map(lam(n): map(lam(k): combo(n,k) end, range(0,n + 1)) end, range-by(row - 1 ,-1,-1))))

fold3(reverse-put-image, bg,X,Y,H)









