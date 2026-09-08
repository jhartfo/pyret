use context starter2024
################################################################
# Bootstrap: DataScience 
# Support files, as of Fall 2024

# to launch applet with n =10 and p = 0.5, type 
# binom-applet(10,0.5) where n = 10

provide *
#use context essentials2021
#include world
include reactors

fun sum(a-list):
  fold(_ + _, 0, a-list)
end

fun mean(a-list):
  sum(a-list) / length(a-list)
end

fun deviations(a-list):
  map(_ - mean(a-list), a-list)
end

fun deviations-sqr(a-list):
  map(num-sqr, deviations(a-list))
end

fun variance(a-list):
  sum(deviations-sqr(a-list)) / (length(a-list) - 1)
end

fun stdDev(a-list):
  num-sqrt(variance(a-list))
end

fun z-score-m-s(value, xbar, s):
  (value - xbar) / s
end

fun z-score(value, a-list):
  (value - mean(a-list)) / stdDev(a-list)
end

fun z-scores(a-list):
  map(_ / stdDev(a-list), deviations(a-list))
end

fun standard-score(value, a-list):
  z-score(value, a-list)
end

fun standard-scores(a-list):
  z-scores(a-list)
end

#######################################################

#
# Q1 and Q3 are calculated by finding the median of the upper and lower halves of the disribution.

# needs to error handle empty list
fun median(a-list):
  sorted-list = a-list.sort()
  mid-pns = find-median-position(a-list)
  a = sorted-list.get(mid-pns.get(0))
  b = sorted-list.get(mid-pns.get(1))
  #[list:a,b]
  mean(([list: a,b]))
end

# needs to error handle empty list
fun find-median-position(a-list):
  
  len = length(a-list)
  mid = num-floor(len / 2)
  
  if len == 0:
    [list:0,0]
  else if num-modulo(len,2) == 0:
    a = mid
    b = mid - 1
    [list: a,b]
  else:
    a = (len - 1) / 2
    [list: a,a]
  end
end

# needs to error handle empty list
# if median is a single value point, it is removed
fun split-at-median(a-list):

  len = length(a-list)
  if len == 1:
    [list: a-list, a-list]
  else if num-modulo(len,2) == 0:
    [list:
      a-list.sort().take((len) / 2),
      a-list.sort().drop((len) / 2)
    ]
  else:
    [list:
      a-list.sort().take((len - 1) / 2),
      a-list.sort().drop((len + 1) / 2)
    ]
  end
end

fun Q0(a-list):
  a-list.sort().get(0)
end

fun Q1(a-list):
  median(split-at-median(a-list).get(0))
end

fun Q2(a-list):
  median(a-list)
end

fun Q3(a-list):
  median(split-at-median(a-list).get(1))
end
  
fun Q4(a-list):
  a-list.sort().reverse().get(0)
end

fun five-number-summary(a-list):
  [list:
    Q0(a-list),
    Q1(a-list),
    Q2(a-list),
    Q3(a-list),
    Q4(a-list)]
end

fun IQR(a-list):
  Q3(a-list) - Q1(a-list)
end

fun outliers-partition(a-list):
  iqr = IQR(a-list)
  lower = Q1(a-list) - (iqr * 1.5)
  upper = Q3(a-list) + (iqr * 1.5)
  
  part = partition(lam(x): (x < lower) or (x > upper) end, a-list.sort())
  [list: part.is-true, part.is-false]
end

fun remove-outliers(a-list):
  outliers-partition(a-list).get(1)
end

fun outliers(a-list):
  outliers-partition(a-list).get(0)
end

#######################################################

fun r(x-list, y-list):
  sum(map2(_ * _, z-scores(x-list),z-scores(y-list ))) / (length(x-list) - 1)
end
  
fun slope(x-list, y-list):
  r(x-list, y-list) * (stdDev(y-list) / stdDev(x-list))
end

fun intercept(x-list, y-list):
  mean(y-list) - (slope(x-list, y-list) * mean(x-list))
end

fun interpolation(x-list, y-list):
  model = lam(x): (slope(x-list, y-list) * x ) + intercept(x-list, y-list) end
  
  map(model, x-list)
end

fun residuals(x-list, y-list):
  y-hat = interpolation(x-list, y-list)
  map2(lam(x,y): x - y end, y-list, y-hat)
end
  
fun residuals-sqr(x-list, y-list):
  map(num-sqr,residuals(x-list, y-list))
end

fun residuals-stdDev(x-list, y-list):
  num-sqrt(sum(residuals-sqr(x-list, y-list))) / (length(x-list) - 2)
end

fun mean-price-residuals-sqr(x-list, y-list):
  map(lam(x): num-sqr(x - mean(y-list)) end, y-list)
end

fun r-sqr(x-list, y-list):
  a = sum(mean-price-residuals-sqr(x-list, y-list))
  b = sum(residuals-sqr(x-list, y-list))
  (a - b) / a
end

#######################################################

fun factorial(n):
  fold(_ * _, 1, range(1,n + 1))
end

fun falling-factorial(n,k):
  factorial(n) / factorial(n - k)
end

fun permutation(n,k):
  falling-factorial(n,k)
end

fun combination(n,k):
  permutation(n,k) / factorial(k)
end

#######################################################

fun binom-probability(x, n, p):
  combination(n,x) * num-expt(p,x) * num-expt(1 - p, n - x)
end

fun binom-mean(n,p):
  n * p
end

fun binom-stdDev(n,p):
  num-sqrt(n * p * (1 - p))
end
  
fun binom-PDF(n,p):
  fun prob(x):
    binom-probability(x,n, p)
  end
  map(prob, range(0,n + 1))
end

fun binom-CDF(n,p):
  probs = binom-PDF(n,p)
  fun cummulative(x):
    sum(probs.split-at(x).prefix)
  end
  map(cummulative, range(0,n + 1))
end

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

fun update-SIZE(n)    : SIZE     := n end
fun update-DELTA(n)   : DELTA    := n end
fun update-DATA-CLR(n): DATA-CLR := n end
fun update-BKGD-CLR(n): BKGD-CLR := n end
fun update-WNDW-CLR(n): WNDW-CLR := n end
fun update-TEXT-CLR(n): TEXT-CLR := n end
fun update-NORM-CLR(n): NORM-CLR := n end

data NandPwithNPDF:
    npN(n:: Number, p:: Number, N :: Boolean)
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

fun hist-bar(wt,ht):
  overlay(
    rectangle(wt,ht,"outline", TEXT-CLR),
    rectangle(wt,ht,"solid"  , DATA-CLR))
end

fun data-visual(state): 

  data-wt     = SIZE * 0.75
  data-ht     = SIZE * 2/6
  gap         = SIZE * 0.020
  girth       = SIZE * 0.004
  tick-len    = SIZE * 0.020
  lbl-size    = SIZE * 0.030

  xbar        = binom-mean(state.n,state.p)
  
  xSD         = block:
    if (state.p == 1) or (state.p == 0):
      binom-stdDev(state.n,1 - DELTA)
    else:
      binom-stdDev(state.n,state.p)
    end
  end
      
  B-PDF       = lam(x): binom-probability(x,state.n,state.p) * data-ht end
  N-PDF       = lam(x): ((gausian(xbar,xSD)(x)) * data-ht) end

  normal-list = range-by(0,state.n, state.n / data-wt)
  normal-x    = map(lam(x): (x / state.n) * data-wt end, normal-list)
  normal-y    = map(N-PDF,normal-list)

  bar-wt      = data-wt / (state.n + 1)
  dist        = map(B-PDF,range(0,state.n + 1))
  bars        = map(lam(x): hist-bar(bar-wt,x) end, dist)

  dots        = block:
    if state.N == true:
      repeat(num-round(data-wt), circle(1,"solid", NORM-CLR))
    else:
      repeat(num-round(data-wt), empty-image)
    end
  end
  
  data-bg     = rectangle(data-wt,data-ht,"solid", BKGD-CLR)
  bottom      = rectangle(data-wt, gap,"solid", BKGD-CLR)
  left        = rectangle(gap, data-ht + gap, "solid", BKGD-CLR)  
  histo       = fold(beside-bottom, empty-image, bars)
  series      = overlay-bottom(histo, data-bg)
  the-data    = fold3(reverse-put-image,series, normal-x,normal-y, dots)
  
  beside(left,below(bottom,the-data))
  
end

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

fun tab-button(n):
  overlay-align("center","center",
    text("Tab", n * 0.025, "white"),
    rectangle(n * 0.071, n * 0.030,"solid","black"))
end
  
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

fun binom-applet(n,p): 
  init = npN(n,p, false)
  
  scene-react = reactor:
    init    : init,
    to-draw : applet-chart,
    on-key  : increment,
    title   : "BINOMIAL DISTRIBUTION"
  end
  
  interact(stop-trace(scene-react))  
  
  end

fun has-left-tail(n,p):
  value = (binom-mean(20, 0.5) - (4  * binom-stdDev(20,0.5)))
  value >= 0
end

fun has-right-tail(n,p):
  value = (binom-mean(20, 0.5) + (4  * binom-stdDev(20,0.5)))
  value <= n
end
  
Normal-PDF = lam(x):gausian(0,1)(x) * 0.001 end

fun Normal-CDF():
  
  fun cummulation(x):
    sum(map(lam(n): Normal-PDF() * 0.001 end,range-by(-5,x + 0.001,0.001)))
  end
  map(cummulation, range-by(-5,5, 0.001))
end

fun cumm(x):
  sum(map(Normal-PDF,range-by(-5,x + 0.001,0.001)))
end
