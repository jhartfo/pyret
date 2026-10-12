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
   

#|
###################################################   
# Normal and Student's T Distribution Applet

# Let's define some constants.

# size of the square interaction window
# because of how pixels are parsed, recommended minimum 600
var SIZE     = 600  

# size of the change in p in the interaction window
# when lft and rt arrows are pressed
var DELTA    = 0.1 

var DATA-CLR = "dodger-blue"
var BKGD-CLR = "white"
var WNDW-CLR = "light-goldenrod-yellow"
var TEXT-CLR = "black"
var NORM-CLR = "magenta"

# update state
fun update-SIZE(n)    : SIZE     := n end
fun update-DELTA(n)   : DELTA    := n end
fun update-DATA-CLR(n): DATA-CLR := n end
fun update-BKGD-CLR(n): BKGD-CLR := n end
fun update-WNDW-CLR(n): WNDW-CLR := n end
fun update-TEXT-CLR(n): TEXT-CLR := n end
fun update-NORM-CLR(n): NORM-CLR := n end

##################################################

# stores Reactor state information
data MSVAB:
    msvab(
      m:: Number, 
      s:: Number, 
      v:: Number, 
      a:: Number, 
      b:: Number, 
      c :: Boolean,
      t :: Boolean )
end

##################################################

fun text-helper(txt, n, clr):
  text-font(txt,n, clr,
    "Epigrafica",
    "decorative",
    "normal",
    "normal",
    false
    )
end

format-text       = lam(txt,n): text-helper(txt, n, TEXT-CLR) end
normal-text       = lam(txt,n): text-helper(txt, n, NORM-CLR) end
mean-text         = lam(txt,n): text-helper(txt, n, DATA-CLR) end
beside-bottom     = lam(a,b): beside-align("bottom", a, b) end
overlay-bottom    = lam(a,b): overlay-align("center","bottom",a,b) end
reverse-put-image = lam(b,x,y,i): put-image(i,x,y,b) end

##################################################

# produces on single 'bar' for the histogram 
fun hist-bar(wt,ht):
  overlay(
    rectangle(wt,ht,"outline", TEXT-CLR),
    rectangle(wt,ht,"solid"  , DATA-CLR))
end


# draws the normal and binomial distributions
fun data-visual(state): 

  data-wt     = SIZE * 0.75
  data-ht     = SIZE * 2/6
  gap         = SIZE * 0.020
  girth       = SIZE * 0.004
  tick-len    = SIZE * 0.020
  lbl-size    = SIZE * 0.030

  xbar        = binom-mean(state.n,state.p)
  
  # things get weird is the probability is
  # 0 or 1. Otherwise, we just use the 
  # normal binom-stdDev
  xSD         = block:
    if (state.p == 1) or (state.p == 0):
      binom-stdDev(state.n,1 - DELTA)
    else:
      binom-stdDev(state.n,state.p)
    end
  end
  
  # creates specific functions for the current
  # Binomial and Normal distributions
  B-PDF       = lam(x): binom-probability(x,state.n,state.p) * data-ht end
  N-PDF       = lam(x): ((gausian(xbar,xSD)(x)) * data-ht) end

  # the binomial series to be drawn
  bar-wt      = data-wt / (state.n + 1)
  distribution= map(B-PDF,range(0,state.n + 1))
  bars        = map(lam(x): hist-bar(bar-wt,x) end, distribution)
  
  # the normal series to be drawn
  normal-list = range-by(0,state.n, state.n / data-wt)
  normal-x    = map(lam(x): (x / state.n) * data-wt end, normal-list)
  normal-y    = map(N-PDF,normal-list)

  dots        = block:
    if state.N == true:
      repeat(num-round(data-wt), circle(1,"solid", NORM-CLR))
    else:
      repeat(num-round(data-wt), empty-image)
    end
  end
  
  # putting it altogether
  data-bg     = rectangle(data-wt,data-ht,"solid", BKGD-CLR)
  bottom      = rectangle(data-wt, gap,"solid", BKGD-CLR)
  left        = rectangle(gap, data-ht + gap, "solid", BKGD-CLR)  
  histo       = fold(beside-bottom, empty-image, bars)
  series      = overlay-bottom(histo, data-bg)
  the-data    = fold3(reverse-put-image,series, normal-x,normal-y, dots)
  
  beside(left,below(bottom,the-data))
  
end


# draws axes and labels on top of 
# the above visualization
fun the-series(state):
  
  data-wt    = SIZE * 0.75
  data-ht    = SIZE * 2/6
  gap        = SIZE * 0.020
  girth      = SIZE * 0.004
  tick-len   = SIZE * 0.020
  lbl-size   = SIZE * 0.030
  
  xbar       = binom-mean(state.n,state.p)
  xSD        = binom-stdDev(state.n,state.p)
  
  zero       = format-text(num-to-string-digits(0,0), lbl-size)
  x-bar      = normal-text(num-to-string-digits(xbar,1),lbl-size)
  
  n          = format-text(num-to-string-digits(state.n,0),lbl-size)
  zero-perc  = format-text(num-to-string-digits(0,1), lbl-size)
  half       = format-text(num-to-string-digits(0.5,1),lbl-size)
  hundred    = format-text(num-to-string-digits(1.0,1),lbl-size)
  
  t-buffer   = tick-len * 3
  x-buffer   = data-wt + gap + girth 
  y-buffer   = data-ht + gap + girth + t-buffer + t-buffer
  x-scale    = block:
    if (state.n * state.p) == 0:
      1
    else:
      data-wt / (state.n)
    end
  end
  the-data   = data-visual(state)
  x-axis     = rectangle(data-wt + gap, girth, "solid", TEXT-CLR)
  y-axis     = rectangle(girth, data-ht + gap + girth, "solid", TEXT-CLR)

  top        = rectangle(x-buffer, t-buffer , "solid", BKGD-CLR)
  bottom     = rectangle(x-buffer, t-buffer , "solid", BKGD-CLR)
  left       = rectangle(t-buffer, y-buffer , "solid", BKGD-CLR)
  right      = rectangle(t-buffer, y-buffer , "solid", BKGD-CLR)
  x-tick     = rectangle(girth, 1 * tick-len, "solid", TEXT-CLR)
  m-tick     = rectangle(girth, 2 * tick-len, "solid", NORM-CLR)
  y-tick     = rectangle(1 * tick-len, girth, "solid", TEXT-CLR)

  with-axis  = beside(y-axis,below(x-axis, the-data))
  with-space = beside(
    beside(
      left,above(
        top,below(
          bottom, with-axis))), right)
  
  ticks      = append([list: m-tick,x-tick,x-tick],repeat(3,y-tick))
  labels     = [list:zero, x-bar, n, hundred, half, zero-perc]
  
  tick-x     = [list: 
    gap + girth + t-buffer + (state.n * state.p * x-scale),
    gap + girth + t-buffer + 0,
    gap + girth + t-buffer + (state.n * x-scale),
    tick-len * 3,
    tick-len * 3,
    tick-len * 3]
  
  tick-y     = [list: 
    tick-len * 2.5,
    tick-len * 3,
    tick-len * 3,
    gap + girth + t-buffer + (data-ht),
    gap + girth + t-buffer + (data-ht / 2),
    gap + girth + t-buffer + (0)]
  
  label-x    = [list: 
    gap + girth + t-buffer + 0,
    gap + girth + t-buffer + (state.n * state.p * x-scale),
    gap + girth + t-buffer + (state.n * x-scale),
    tick-len * 1.4,
    tick-len * 1.4,
    tick-len * 1.4]
  
  label-y    = [list: 
    tick-len * 1.5,
    tick-len * 0.5,
    tick-len * 1.5,
    gap + girth + t-buffer + (data-ht * 0.99),
    gap + girth + t-buffer + (data-ht * 1/2 * 0.975),
    gap + girth + t-buffer + (data-ht * -0.01)]
    
  things = append(ticks, labels)
  Xs     = append(tick-x, label-x)
  Ys     = append(tick-y, label-y)
  
  with-labels = fold3(reverse-put-image,with-space, Xs, Ys, things)
  with-labels

end

# draws the arrow keys on the applet
fun button(dir,n):
  arrow    = center-pinhole(
    above(
      triangle(n * 0.012, "solid","white"),
      rectangle(n * 0.006, n * 0.018,"solid","white")))
  arrow-bn = overlay(arrow,square(n * 0.030,"solid","black"))
  
  if      dir == "lt": rotate( 90, arrow-bn) 
  else if dir == "dn": rotate(180, arrow-bn)
  else if dir == "rt": rotate(270, arrow-bn)
  else:                rotate(  0, arrow-bn)
  end
end

# draws tab key on the applet
fun tab-button(n):
  overlay-align("center","center",
    text("Tab", n * 0.025, "white"),
    rectangle(n * 0.071, n * 0.030,"solid","black"))
end

# draws the entire applet
fun applet-chart(state):
  mid      = SIZE / 2
  title1   = block:
    if state.N == true:
      normal-text("Normal Approximation to the", SIZE / 35)
    else:
      empty-image
    end
  end

  title2   = format-text("Binomial Distribution", SIZE / 20)
  series   = the-series(state)
  bg       = rectangle(SIZE, SIZE * 0.80,"solid", WNDW-CLR)

  up       = button("up", SIZE)
  lt       = button("lt", SIZE)
  dn       = button("dn", SIZE)
  rt       = button("rt", SIZE)
  tab-bn   = tab-button(SIZE)
  spacer   = rectangle(SIZE * 0.01, 1,"solid", BKGD-CLR)

  n-eqs    = format-text("    n =", SIZE / 30)
  p-eqs    = format-text("    p =", SIZE / 30)
  notp-eqs = format-text("(1-p) =", SIZE / 30)

  expd     = state.n * state.p
  expd-cmp = state.n * (1 - state.p) 
  
  N        = format-text(num-to-string-digits(state.n,0)    , SIZE / 30 )
  P        = format-text(num-to-string-digits(state.p,2)    , SIZE / 30 )
  NOT-P    = format-text(num-to-string-digits(1 - state.p,2), SIZE / 30 )
  
  EX-eqs    = mean-text(" E(X) =", SIZE / 30)
  EnotX-eqs = mean-text("E(~X) =", SIZE / 30)
  
  EX        = mean-text(num-to-string-digits(expd,2)    , SIZE / 30 )
  EnotX     = mean-text(num-to-string-digits(expd-cmp,2), SIZE / 30 )
  
  lf-rt-txt= format-text("moves (p)robability up and down"    , SIZE / 50)
  up-dn-txt= format-text("moves (n)umber of trials up and down",SIZE / 50)
  tab-txt  = format-text("toggles normal distribution on/off" , SIZE / 50)
    
  lf-rt    = fold(
    beside, 
    empty-image, 
    [list: lt,spacer,rt])

  up-dn    = fold(
    beside, 
    empty-image, 
    [list: up,spacer,dn])

  things   = [list: 
    title1,
    title2, 

    n-eqs,
    p-eqs, 
    notp-eqs, 
    
    N, P, NOT-P,
    
    EX-eqs, EnotX-eqs, EX, EnotX,
    
    lf-rt,
    up-dn,
    tab-bn,
    
    lf-rt-txt,
    up-dn-txt,
    tab-txt,
  ]
  
  Xs       = [list: 
    mid,                               # title1
    mid,                               # title2
    
    (SIZE * 0.0000) + (SIZE * 0.1000), # n-eqs
    (SIZE * 0.0000) + (SIZE * 0.1000), # p-eqs
    (SIZE * 0.0000) + (SIZE * 0.0930), # notp-eqs
    
    (SIZE * 0.1900) + (SIZE * 0.0000), # N
    (SIZE * 0.1900) + (SIZE * 0.0000), # P
    (SIZE * 0.1900) + (SIZE * 0.0000), # NOT-P

    (SIZE * 0.3600) + (SIZE * 0.0000), # EX-eqs
    (SIZE * 0.3470) + (SIZE * 0.0000), # EnotX-eqs
    (SIZE * 0.4800) + (SIZE * 0.0000), # EX
    (SIZE * 0.4800) + (SIZE * 0.0000), # EnotX
    
    (SIZE * 0.6000) + (SIZE * 0.0000), # lf-rt
    (SIZE * 0.6000) + (SIZE * 0.0000), # up-dn
    (SIZE * 0.6000) + (SIZE * 0.0000), # tab-bn

    (SIZE * 1.0000) - (SIZE * 0.2100), # lf-rt-txt
    (SIZE * 1.0000) - (SIZE * 0.1880), # up-dn-txt
    (SIZE * 1.0000) - (SIZE * 0.2100)  # tab-txt
  ]
  
  Ys       = [list: 
    (SIZE * 1.0000) - (SIZE * 0.2500), # title1
    (SIZE * 1.0000) - (SIZE * 0.3030), # title2
    
    (SIZE * 0.0000) + (SIZE * 0.1050), # n-eqs
    (SIZE * 0.0000) + (SIZE * 0.0690), # p-eqs
    (SIZE * 0.0000) + (SIZE * 0.0303), # notp-eqs
    
    (SIZE * 0.0000) + (SIZE * 0.1050), # N
    (SIZE * 0.0000) + (SIZE * 0.0690), # P
    (SIZE * 0.0000) + (SIZE * 0.0303), # NOT-P    
    
    (SIZE * 0.0000) + (SIZE * 0.0690), # EX-eqs
    (SIZE * 0.0000) + (SIZE * 0.0303), # Enot-eqs
    (SIZE * 0.0000) + (SIZE * 0.0690), # EX
    (SIZE * 0.0000) + (SIZE * 0.0303), # EnotX
    
    (SIZE * 0.0000) + (SIZE * 0.1050), # lf-rt
    (SIZE * 0.0000) + (SIZE * 0.0690), # up-dn
    (SIZE * 0.0000) + (SIZE * 0.0303), # tab-bn

    (SIZE * 0.0000) + (SIZE * 0.1050), # lf-rt-txt
    (SIZE * 0.0000) + (SIZE * 0.0690), # up-dn-txt
    (SIZE * 0.0000) + (SIZE * 0.0303)  # tab-txt    
  ]
  
  the-data = overlay(series, bg)
  
  fold3(
    reverse-put-image,the-data, Xs,Ys,things)
  
end

# onkey update function for the reactor
fun increment(state,key):
  if key == "up":
    npN(state.n + 1,state.p, state.N)

  else if (key == "down")  and (state.n > 0):
    npN(state.n - 1,state.p, state.N)
  
  else if (key == "right") and (state.p < 1):
    npN(state.n,state.p + DELTA, state.N)
  
  else if (key == "left")  and (state.p > 0):
    npN(state.n, state.p - DELTA, state.N)
  
  else if (key == "tab"):
    npN(state.n, state.p, not(state.N))
  
  else:
    npN(state.n, state.p, state.N)
  end

end
  
# gausian :: Number , Number -> Function
# generates the Normal PDF function of the given (m)ean and (s)tdDev
fun gausian(m,s):
  denom = (s * num-sqrt(2 * PI))
  lam(x): num-exact(
      num-exp(-0.5 * z-score-m-s(x, m, s) * z-score-m-s(x, m, s)) /
      denom)
  end
end

fun binom-applet(n,p): 
  init = npN(n,p, false)
  
  scene-react = reactor:
    init    : init,
    to-draw : applet-chart,
    on-key  : increment,
    title   : "BINOMIAL DISTRIBUTION"
  end
  
  trace = interact(stop-trace(scene-react))  
  nothing
end


|#







round = lam(x): num-round(x * 1000) / 1000 end




# Normal 0,1
# Normal 10,1
# Normal 70,10


a = map(round, simulate-normal(0, 1, 498))
b = map(round, simulate-normal(10, 1, 376))
c = map(num-round, simulate-normal(70, 10, 604))

