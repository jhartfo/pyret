use context url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/uniform-distribution.arr")
provide *

# Computing the values in the normal and t distributions 
# is expensive. Claude Soonet 5 was used to identify
# methods used by statistical packages from r, python, etc
# produce this implementation and validate the accuracy
import url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/normal-approximations.arr") as N

provide from N: 
  normal-pdf, normal-cdf, normal-inv-cdf,
  t-pdf, t-cdf, t-inv-cdf
end

import chart as Ch
import color as C
include csv
include data-source
include reactors


###################################################

# TABLES

url-prefix = 
  "https://raw.githubusercontent.com/jhartfo/pyret/" 
  + "main/bootstrap-statistics/"

# Teachers/students can view 
# Normal table a variety of ways:

# They can view the standard z-tables
ztable-im-neg = image-url(url-prefix + "images/z-table-negative.png")
ztable-im-pos = image-url(url-prefix + "images/z-table-positive.png")
ztable-image  = beside(ztable-im-neg, ztable-im-pos)

# They can view a z/PDF/CDF table of values as a Pyret table:

z-tab = csv-table-url( url-prefix + "data/z-table.csv", default-options)

ztable = load-table: z, PDF, CDF
  sanitize z  using num-sanitizer
  sanitize PDF using num-sanitizer
  sanitize CDF using num-sanitizer
  source: z-tab
end

zable2 = [table-from-columns:
  {"Z"; range-by(-4, 4.01, 0.01)}]
  .build-column("PDF", lam(r): N.normal-pdf(r["Z"]) end)
  .build-column("CDF", lam(r): N.normal-cdf(r["Z"]) end)

# They can view the standard z tables as a Pyret table:

z-tab-neg = csv-table-url(
  url-prefix + "data/z-table-negative.csv", default-options)

z-tab-pos = csv-table-url(
  url-prefix + "data/z-table-positive.csv", default-options)

ztable-negative = load-table: z, a,b,c,d,e,f,g,h,i,j
  sanitize z using num-sanitizer
  sanitize a using num-sanitizer
  sanitize b using num-sanitizer
  sanitize c using num-sanitizer
  sanitize d using num-sanitizer
  sanitize e using num-sanitizer
  sanitize f using num-sanitizer
  sanitize g using num-sanitizer
  sanitize h using num-sanitizer
  sanitize i using num-sanitizer
  sanitize j using num-sanitizer
  source: z-tab-neg
end
  .rename-column("a", "0.00")
  .rename-column("b", "0.01")
  .rename-column("c", "0.02")
  .rename-column("d", "0.03")
  .rename-column("e", "0.04")
  .rename-column("f", "0.05")
  .rename-column("g", "0.06")
  .rename-column("h", "0.07")
  .rename-column("i", "0.08")
  .rename-column("j", "0.09")

ztable-positive = load-table: z, a,b,c,d,e,f,g,h,i,j
  sanitize z using num-sanitizer
  sanitize a using num-sanitizer
  sanitize b using num-sanitizer
  sanitize c using num-sanitizer
  sanitize d using num-sanitizer
  sanitize e using num-sanitizer
  sanitize f using num-sanitizer
  sanitize g using num-sanitizer
  sanitize h using num-sanitizer
  sanitize i using num-sanitizer
  sanitize j using num-sanitizer
  source: z-tab-pos
end
  .rename-column("a", "0.00")
  .rename-column("b", "0.01")
  .rename-column("c", "0.02")
  .rename-column("d", "0.03")
  .rename-column("e", "0.04")
  .rename-column("f", "0.05")
  .rename-column("g", "0.06")
  .rename-column("h", "0.07")
  .rename-column("i", "0.08")
  .rename-column("j", "0.09")

###################################################

# SIMULATIONS 

fun random-normal(m,s):
  
  # Find a random element from a Normal PDF
  # using normal-inv-cdf procedure
  z = N.normal-inv-cdf(num-random(10000) / 10000)
  
  # map the random value into the desired domain
  (z * s) + m
end

# simulation-normal returns a list containing n random samples from the normal distribution
fun simulate-normal(m, s, n):
  map(lam(x):random-normal(m, s) end, range-by(0,n + 1,1))
end

fun random-t(nu):
  
  # Find a random element from Student's t PDF
  # using t-inv-cdf procedure
  N.t-inv-cdf(num-random(10000) / 10000, nu)
  
end

# simulation-normal returns a list containing n random samples from the normal distribution
fun simulate-t(nu, n):
  map(lam(x):random-t(nu) end, range-by(0,n + 1,1))
end

###################################################
   
fun normalPDF-code(m,s) block:
  print(
    "# normalPDF-m-s :: Number -> Number\n" +
    "# Consumes a Number,z, and produces the height of the \n" + 
    "# standard normal distribution curve at the given z. \n" + 
    "m = " + tostring(m) + "\n" +
    "s = " + tostring(s) + " \n" +
    "fun normalPDF-m-s(z):\n" +
    "   " + 
    "(1 / (" + tostring(s) + " * num-sqrt(2 * PI))) " + 
    "* num-exp(-0.5 * num-sqr((z - m) / s))\n" +
    "end"
    )
  nothing
end
   

###################################################   
# Hypothesis Testing for Proportions


fun p-alpha(z):
  N.normal-cdf(z)
end

fun test-statistic-for-p(p,n,h):
  s = num-sqrt( (h * (1 - h)) / n  )
  (p - h) / s
end



###################################################   
# Normal and Student's T Distribution 
# Visualizations and Applets

# draw-empirical-rule :: Number -> Image
# Consumes a Number (0-3) and displays the 
# empirical rule for standards deviations up to the 
# given Number

#P-x-less-than    :: Number, Number, Number -> Image
# consumes the numbers m,s,x and displays 
# P(X < x) = P(Z < z) where z = (x - m) / s

#P-x-greater-than :: Number, Number, Number -> Image
# consumes the numbers m,s,x and displays 
# P(X > x) = P(Z > z) where z = (x - m) / s

#P-x-between      :: Number, Number, Number, Number -> Image
# consumes the numbers m,s,a,b and displays
# P(a < X < b) = P(Za < z <) where z = (x - m) / s

#P-x-beyond       :: Number, Number, Number, Number -> Image
# consumes the numbers m,s,a,b and displays
# P(X < a or X > b) = P(Z < Za or Z > Zb) where z = (x - m) / s

SCALE-X = 30
SCALE-Y = 200
BG      = rectangle(12 * SCALE-X, 300, "solid", "white")
hatch   = rectangle(1, SCALE-Y / 20, "solid", "black")
X-lbl   = text("z", (SCALE-Y * 3) / 50, "black")
Z-lbl   = text("x", (SCALE-Y * 3) / 50, "black")

fun normal-pdf-points(z):
  point(z * SCALE-X, N.normal-pdf(z) * SCALE-Y)   
end

fun get-normal-points(a,b):
  map(normal-pdf-points, range-by(a,b, 0.01)) +
  [list: point(b * SCALE-X, 0), point(a * SCALE-X, 0)]
end

fun draw-normal-solid(a,b,clr):
  point-polygon(get-normal-points(a,b), "solid", clr)
end

fun draw-normal-line(a,b,clr):
  point-polygon(get-normal-points(a,b), "outline", clr)
end

fun draw-normal-gap(a):
  draw-normal-solid(-5,a,"transparent")
end

fun draw-normal-left(a, clr):
  draw-normal-solid(-5,a, clr)
end
  
fun draw-normal-a-to-b(a,b,clr):
  beside-align("bottom",
    draw-normal-gap(a),
    draw-normal-solid(a,b, clr))
end
  
fun draw-normal-right(b,clr):
  beside-align("bottom",
    draw-normal-gap(b),
    draw-normal-solid(b,5, clr))
end
  
fun info(txt, sz):
  text(txt, sz, "black")
end

horiz   = overlay(
  rectangle(10 * SCALE-X, 1, "solid", "black"),
  rectangle(10 * SCALE-X, SCALE-Y / 10, "solid", "transparent"))

l-arrow = overlay-align("right", "center",
  rotate( 90, triangle(SCALE-X / 3, "solid", "black")),
  rectangle(SCALE-X / 3,SCALE-Y / 10, "solid", "transparent"))

r-arrow = overlay-align("left", "center",
  rotate(-90, triangle(SCALE-X / 3, "solid", "black")),
  rectangle(SCALE-X / 3,SCALE-Y / 10, "solid", "transparent"))

one-line = beside(l-arrow, beside(fold(
      lam(y,x): translate(hatch, SCALE-X * x, SCALE-Y / 20, y) end, 
      horiz, 
      range-by(1,10, 1)
      ), r-arrow))

z-labels = fold(
  lam(y ,x): 
    translate(
      text(num-to-string(x), (SCALE-Y * 3) / 50, "black"), 
      SCALE-X * (x + 5), 
      SCALE-Y / 20, y) 
  end, 
  rectangle(10 * SCALE-X, SCALE-Y / 10, "solid", "transparent"), 
  range-by(-4,5, 1))

fun x-labels(m,s): fold(
    lam(y ,x): 
      translate(
        text(num-to-string-digits(
            num-round(100 * ((x * s) + m)) / 100, 2
            ), (SCALE-Y * 3) / 50, "black"), 
        SCALE-X * (x + 5), 
        10, y) 
    end, 
    rectangle(10 * SCALE-X, SCALE-Y / 10, "solid", "transparent"), 
    range-by(-4,5, 1))
end

fun num-lines(m,s):
  fold(above, empty-image,[list:
      one-line,
      z-labels,
      rectangle(SCALE-X / 3, SCALE-Y / 20, "solid", "transparent"),
      one-line,
      x-labels(m,s)
    ])
end

fun draw-normal-shaded(m,s,a,b, direction):
  series = block:
    if direction == "left":
      overlay-align("left", "bottom",
        draw-normal-line(-5,5, "blue"), 
        draw-normal-left(a, "green")
        )
    else if direction == "right":
      overlay-align("left", "bottom",
        draw-normal-line(-5,5, "blue"), 
        draw-normal-right(b, "green")
        )
    else if direction == "between":
      overlay-align("left", "bottom",
        draw-normal-line(-5,5, "blue"), 
        draw-normal-a-to-b(a,b, "green")
        )
    else if direction == "outer-area":
      overlay-align("left", "bottom",
        draw-normal-line(-5,5, "blue"), 
        overlay-align("left", "bottom",
          draw-normal-left(a, "green"),
          draw-normal-right(b, "green")))
    else:
      draw-normal-line(-5,5, "blue")
    end
  end
  translate(
    X-lbl, SCALE-X / 2, (SCALE-Y * 11) / 20, translate(
      Z-lbl, SCALE-X / 2, (SCALE-Y * 3) / 10, translate(
        num-lines(m,s), 6 * SCALE-X, (SCALE-Y * 3) / 8, translate(
          series, 6 * SCALE-X, (SCALE-Y * 3) / 4, BG
          ))))
end
  
fun draw-normal-left-tail(m,s, a):
  draw-normal-shaded(m,s,a,5, "left")
end

fun draw-normal-right-tail(m,s, b):
  draw-normal-shaded(m,s,-5,b, "right")
end

fun draw-normal-between(m,s, a, b):
  draw-normal-shaded(m,s,a,b, "between")
end

fun draw-normal-left-and-right(m,s, a, b):
  draw-normal-shaded(m,s,a,b, "outer-area")
end

P-x-less-than :: Number, Number, Number -> Image
# consumes the numbers m,s,x and displays 
# P(X < x) = P(Z < z) where z = (x - m) / s
fun P-x-less-than(X,m,s):
  
  TITLE-SIZE = SCALE-Y / 10
  TXT-SIZE   = (SCALE-Y * 3) / 40
  Z          = (X - m) / s
  
  series     = block:
    if (Z > -5) and (Z < 5):
      draw-normal-left-tail(m,s,Z)
    else:
      draw-normal-left-tail(m,s,-5)
    end
  end
  
  fold-items = [list:
    info("Standard Normal Distribution", TITLE-SIZE),
    info("P(X < " + num-to-string-digits(X,2) + ") =", TXT-SIZE),
    info("P(Z < " + num-to-string-digits(Z,2) + ") \u2248 ", TXT-SIZE),
    info(num-to-string-digits(N.normal-cdf(Z),4), TXT-SIZE)]
  
  fold-x = repeat(4,6 * SCALE-X)
  fold-y = [list: 
    SCALE-Y * 1.40,
    SCALE-Y * 1.25,
    SCALE-Y * 1.15,
    SCALE-Y * 0.95]
  
  fold3(
    lam(z,w, x,y): translate(w,x,y,z) end, 
    series, fold-items, fold-x, fold-y)
  
end

P-x-greater-than :: Number, Number, Number -> Image
# consumes the numbers m,s,x and displays 
# P(X > x) = P(Z > z) 
# where z = (x - m) / s

fun P-x-greater-than(X,m,s):
  TITLE-SIZE = SCALE-Y / 10
  TXT-SIZE   = (SCALE-Y * 3) / 40
  Z          = (X - m) / s
  
  STRING-1   = (
    "P(X > " + 
    num-to-string-digits(X,2) + 
    ") = 1 - P(X < " +
    num-to-string-digits(X,2) + 
    ") =")
  
  STRING-2 = (
    "P(Z > " + 
    num-to-string-digits(Z,2) + 
    ") = 1 - P(Z < " + 
    num-to-string-digits(X,2) + 
    ") \u2248 ")
  
  series     = block:
    if (Z > -5) and (Z < 5):
      draw-normal-right-tail(m,s,Z)
    else:
      draw-normal-right-tail(m,s,-5)
    end
  end
  
  fold-items = [list:
    info("Standard Normal Distribution", TITLE-SIZE),
    info(STRING-1, TXT-SIZE),
    info(STRING-2, TXT-SIZE),
    info(num-to-string-digits(1 - N.normal-cdf(Z),4), TXT-SIZE)]
  
  fold-x = repeat(4,6 * SCALE-X)
  fold-y = [list: 
    SCALE-Y * 1.40,
    SCALE-Y * 1.25,
    SCALE-Y * 1.15,
    SCALE-Y * 0.95]
  
  fold3(
    lam(z,w, x,y): translate(w,x,y,z) end, 
    series, fold-items, fold-x, fold-y)
  
end

P-x-between :: Number, Number, Number, Number -> Image
# consumes the numbers m,s,a,b and displays
# P(a < X < b) = P(Za < z <) 
# where z = (x - m) / s
fun P-x-between(a,b,m,s):
  
  TITLE-SIZE = SCALE-Y / 10
  TXT-SIZE   = (SCALE-Y * 3) / 40
  Za         = (a - m) / s
  Zb         = (b - m) / s
  
  STRING-1   = (
    "P(" + 
    num-to-string-digits(a,2) + 
    " < X < " +
    num-to-string-digits(b,2) + 
    ") = P(X < " +
    num-to-string-digits(a,2) + 
    ") - P(X < " +
    num-to-string-digits(b,2) + 
    ") =")
    
  STRING-2   = (
    "P(" + 
    num-to-string-digits(Za,2) + 
    " < Z < " + 
    num-to-string-digits(Zb,2) + 
    ") = P(Z < " +
    num-to-string-digits(Za,2) + 
    ") - P(Z < " +
    num-to-string-digits(Zb,2) + 
    ") \u2248")
  
  series     = block:
    if (Za > -5) and (Zb < 5):
      draw-normal-between(m,s,Za,Zb)
    else:
      draw-normal-between(m,s,-5,5)
    end
  end
  
  fold-items = [list:
    info("Standard Normal Distribution", TITLE-SIZE, "black"),
    info(STRING-1, TXT-SIZE),
    info(STRING-2, TXT-SIZE),
    info(
      num-to-string-digits(N.normal-cdf(Zb) - N.normal-cdf(Za),4), 
      TXT-SIZE)]
  
  fold-x = repeat(4,6 * SCALE-X)
  fold-y = [list: 
    SCALE-Y * 1.40,
    SCALE-Y * 1.25,
    SCALE-Y * 1.15,
    SCALE-Y * 0.95]
  
  fold3(
    lam(z,w, x,y): translate(w,x,y,z) end, 
    series, fold-items, fold-x, fold-y) 
end


P-x-beyond :: Number, Number, Number, Number -> Image
# consumes the numbers m,s,a,b and displays
# P(X < a or X > b) = P(Z < Za or Z > Zb) 
# where z = (x - m) / s
fun P-x-beyond(a,b,m,s):
  
  TITLE-SIZE = SCALE-Y / 10
  TXT-SIZE   = (SCALE-Y * 3) / 40
  Za         = (a - m) / s
  Zb         = (b - m) / s
  
  STRING-1   = (
    "P(X < " + 
    num-to-string-digits(a,2) + 
    " or X > " + 
    num-to-string-digits(b,2) + 
    ") = P(X < " + 
    num-to-string-digits(a,2) + 
    ") or P(X >" +
    num-to-string-digits(b,2) + 
    ") = ")
  
  STRING-2   = ( 
    "P(Z < " + 
    num-to-string-digits(Za,2) + 
    " or Z > " + 
    num-to-string-digits(Zb,2) + 
    ") = P(Z < " + 
    num-to-string-digits(Za,2) + 
    ") or P(Z >" +
    num-to-string-digits(Zb,2) + 
    ") \u2248 ")  
  
  series    = block:
    if (Za > -5) and (Zb < 5):
      draw-normal-left-and-right(m,s,Za,Zb)
    else:
      draw-normal-left-and-right(m,s,-5,5)
    end
  end
  
  fold-items = [list:
    info("Standard Normal Distribution", TITLE-SIZE),
    info(STRING-1, TXT-SIZE),
    info(STRING-2, TXT-SIZE),
    info(
      num-to-string-digits(N.normal-cdf(Zb) - N.normal-cdf(Za),4), 
      TXT-SIZE)]
  
  fold-x = repeat(4,6 * SCALE-X)
  fold-y = [list: 
    SCALE-Y * 1.40,
    SCALE-Y * 1.25,
    SCALE-Y * 1.15,
    SCALE-Y * 0.95]
  
  fold3(
    lam(z,w, x,y): translate(w,x,y,z) end, 
    series, fold-items, fold-x, fold-y) 
end

draw-empirical-rule :: Number -> Image
# Consumes a Number (0-3) and displays the 
# empirical rule for standards deviations up to the Number
fun draw-empirical-rule(s):
  
  fun spread(n,clr):
    beside(
      rectangle(1, 10, "solid", clr), 
      beside(
        rectangle(n * SCALE-X, 1, "solid", clr), 
        rectangle(1, 10, "solid", clr)))
  end
  
  fun shade(n): 
    if s >= n: C.color(0,0,255,0.33)
    else: "transparent"
    end
  end
  
  fun shade-txt(n): 
    if s >= n: "black"
    else: "transparent"
    end
  end
  
  TITLE-SIZE = SCALE-Y / 10
  TXT-SIZE   = (SCALE-Y * 3) / 40
  
  c1         = shade(1)
  c2         = shade(2)
  c3         = shade(3)
  s1         = shade-txt(1)
  s2         = shade-txt(2)
  s3         = shade-txt(3)
    
  lbl        = fold(
    above, empty-image,
    [list:
      text("~68% of values lie in this range."  , TXT-SIZE, s1),
      spread(2,s1),
      square(10, "solid", "transparent"),
      text("~95% of values lie in this range."  , TXT-SIZE, s2),
      spread(4,s2),
      square(10, "solid", "transparent"),
      text("~99.7% of values lie in this range.", TXT-SIZE, s3),
      spread(6,s3),
    ])

  series = fold(
    lam(a,b): overlay-align("left", "bottom", a,b) end,
    empty-image,
    [list: 
      draw-normal-line(-5,5, "blue"),
      draw-normal-a-to-b(-1, 1, c1),
      draw-normal-a-to-b(-2, 2, c2),
      draw-normal-a-to-b(-3, 3, c3)]
    )
  
  fold-items = [list:
    one-line,
    z-labels,
    Z-lbl,
    series,
    info("Standard Normal Distribution", TITLE-SIZE),
    text("Empirical Rule", TXT-SIZE, "blue"),
    lbl]
  
  fold-x = [list:
    6 * SCALE-X, 6 * SCALE-X, 15, 6 * SCALE-X, 
    6 * SCALE-X, 6 * SCALE-X, 6 * SCALE-X]
    
  fold-y = [list:
    0.305 * SCALE-Y,
    0.175 * SCALE-Y,
    0.305 * SCALE-Y,
    0.500 * SCALE-Y,
    1.400 * SCALE-Y,
    1.300 * SCALE-Y,
    0.600 * SCALE-Y]
  
  fold3(
    lam(z,w, x,y): translate(w,x,y,z) end, 
    BG, fold-items, fold-x, fold-y)
 
end

