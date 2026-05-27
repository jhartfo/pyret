use context essentials2021
include shared-gdrive("TrapezoidRule.arr", "1i9DRMdsZQS6M-TLDQpmCQsGI7hZrblUC")
#include my-gdrive("TrapezoidRule.arr")



rd      = circle(80, "solid", "red")
wt      = circle(40, "outline", "black")
bl      = circle(20, "solid", "blue")
ex-list = [list: wt, bl]


fun d-to-r(d):
  (d * 2 * PI) / 360
end

WIDTH  = 100
HEIGHT = 200
SLANT  = num-sqrt(num-sqr(WIDTH) + num-sqr(HEIGHT))
ANGLE  = (num-atan(HEIGHT / WIDTH) / (2 * PI)) * 360

piece1-01 = right-triangle(100,200,"solid", "silver")
piece1-02 = flip-horizontal(right-triangle(100,200,"solid", "silver"))
piece1-03 = rectangle(250,200,"solid", "silver")

piece1-00 = [list: piece1-02, piece1-03, piece1-01]
piece1    = stack-beside-align(empty-image, piece1-00, "center")
piece1




piece2-01 = rotate(
  180,right-triangle(
    40 * num-cos(d-to-r(ANGLE)), 40, "solid", "dim-grey"))
piece2-02 = rectangle(SLANT,40, "solid", "dim-grey")
piece2-03 = right-triangle(
  40 * num-cos(d-to-r(ANGLE)), 40, "solid", "dim-grey")
  
piece2-00 = [list: piece2-01, piece2-02, piece2-03]  
piece2    = rotate(ANGLE,stack-beside-align(empty-image, piece2-00, "center"))

beside(piece2, piece1)


fun f1(x): 2 * x end
fun f2(x): 200 end 
fun f3(x): (-2 * (x - 300)) + 200 end

fun g1(x): 
  if (2 * (x - 40)) < 0: 0
  else: 2 * (x - 40)
  end
end

X1 = range(000, 101)
X2 = range(100, 141)

Yf1= map(f1,X1)
Yf2= map(f2,X2)

Yg1= map(g1,X1)
Yg2= map(g1,X2)

Tf1 = map2(
  lam(x,y): up-trapezoid(x,y,1,"black") end,
  Yf1.take(length(Yf1)), 
  Yf1.drop(1)
  )
Tf2 = map2(
  lam(x,y): up-trapezoid(x,y,1,"black") end,
  Yf2.take(length(Yf2)), 
  Yf2.drop(1)
  )

Tg1 = map2(
  lam(x,y): up-trapezoid(x,y,1,"silver") end,
  Yg1.take(length(Yg1)), 
  Yg1.drop(1)
  )
Tg2 = map2(
  lam(x,y): up-trapezoid(x,y,1,"silver") end,
  Yg2.take(length(Yg2)), 
  Yg2.drop(1)
  )

T1 = map2(lam(x,y): overlay-align("center", "bottom", x,y) end, Tg1, Tf1)
T2 = map2(lam(x,y): overlay-align("center", "bottom", x,y) end, Tg2, Tf2)

stack-beside-align(empty-image, stack-lists([list: T1, T2]), "bottom")



fun rc(r):
  r
end

map(rc, range(0,10))



