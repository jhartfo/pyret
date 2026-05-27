use context shared-gdrive("modified_Bootstrap-DataScience-v2.2.arr", "11ZHV3T0ElK7EOdX7PDV7X2yHoTag6rq8")
provide *

import shared-gdrive("modified_Bootstrap-DataScience-v2.2.arr", "11ZHV3T0ElK7EOdX7PDV7X2yHoTag6rq8") as BSDS
provide from BSDS: * ,
  type *,
  data *
end

import chart as Ch
import color as C

#|
When calculating the Normal PDF, CDF, and InvCDF there are 
trade offs regarding accuracy and memory.
Accuracy has not been an acceptable compromise, given
students have access to accurate published z-tables. 
The situation is even more strenuous for Student's
T-distrbution.

After a lot of trial an error, we have this version where
z tables are generated in this Google sheet: |#
models-url = "https://docs.google.com/spreadsheets/d/1FcReu6B4wYPpZBjJ2f9fb_YUYf_YEtLntjkxuCwzdes/edit?usp=sharing" 

#|
NormalPDF is calculated directly

NormalCDF is approximated using information from this 
wikipedia article:
https://en.wikipedia.org/wiki/Error_function
itself referencing:
Numerical Recipes in Fortran 77: The Art of Scientific Computing
(2nd Ed) (1992) 
by Press, Teukolsky, Vetterling, Flannery 
Cambridge University Press.

InvNormalCDF is found by using z-lookup from the Google Sheet

InvTCDF is found by a combination similar lookup tables. For our purposes
the T distribution is only needed for finding the critical values 
so the InvTCDF and the front facing t-table are the only elements 
of the T distribution provided.
|#

###################################################
# This module provides:
# NormalPDF, NormalCDF, InvNormalCDF, z-table,
# Normal-chart, random-normal, simulate-normal,
# InvTCDF, t-table

SIG-FIG = 3

fun round(x,n):
  num-round(x * num-expt(10,n)) / num-expt(10,n)
end
 
# NormalPDF 
###################################################
normal-coeff = 1 / (num-sqrt( 2 * 2 * PI))

fun gaussian(x):
  num-exp(-0.5 * x * x)
end

fun factorial(n):
  if (n == 1) or (n == 0): 1
  else:
    n * factorial(n - 1)
  end
end

fun term(n): lam(z):
    (num-expt(-1,n) * num-expt(z, (2 * n) + 1)) / 
    (factorial(n) * ((2 * n) + 1))
  end
end

fun erf(z):
  seq    = range-by(0,100,1)
  taylor = map(lam(n): term(n)(z) end, seq)
  
  (2 * sum(taylor)) / num-sqrt(PI)
end

###################################################
models-sheet = load-spreadsheet(models-url)
  
# standard z table with z's with two decimal places
# ranging from -4.00 t0 4.00 suitable for viewing
z-table     =
  load-table: Z, PDF, CDF
    source: models-sheet.sheet-by-name("z-table", true)
end

# granular z-table suitable for looking ups values
# but is too long for viewing withing Pyret
z-lookup    =
  load-table: rawZ, Z, PDF, CDF
    source: models-sheet.sheet-by-name("z-lookup", true)
end

t-table = load-table: 
  df,	P-2500,	P-2000,	P-1500,	P-1000,	P-0500,	P-0250,	P-0200,	P-0100,	P-0050,	P-0025,	P-0010,	P-0005
  source: models-sheet.sheet-by-name("t-table", true)
end
  .rename-column("P-2500", "P=0.2500")
  .rename-column("P-2000", "P=0.2000")
  .rename-column("P-1500", "P=0.1500")
  .rename-column("P-1000", "P=0.1000")
  .rename-column("P-0500", "P=0.0500")
  .rename-column("P-0250", "P=0.0250")
  .rename-column("P-0200", "P=0.0200")
  .rename-column("P-0100", "P=0.0100")
  .rename-column("P-0050", "P=0.0050")
  .rename-column("P-0025", "P=0.0025")
  .rename-column("P-0010", "P=0.0010")
  .rename-column("P-0005", "P=0.0005")

t-2tail = load-table: 
  df,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z, AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR, AS,AT,AU,AV,AW,AX,AY,AZ,BA,BB,BC,BD,BE,BF,BG,BH,BI,BJ, BK,BL,BM,BN,BO,BP,BQ,BR,BS,BT,BU,BV,BW,BX,BY,BZ,CA,CB, CC,CD,CE,CF,CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT, CU,CV,CW,CX
  source: models-sheet.sheet-by-name("t-lookup-2tail", true)
end

t-1tail = load-table: 
  df,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z, AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR, AS,AT,AU,AV,AW,AX,AY,AZ,BA,BB,BC,BD,BE,BF,BG,BH,BI,BJ, BK,BL,BM,BN,BO,BP,BQ,BR,BS,BT,BU,BV,BW,BX,BY,BZ,CA,CB, CC,CD,CE,CF,CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT, CU,CV,CW,CX
  source: models-sheet.sheet-by-name("t-lookup-1tail", true)
end

t-col-dict = load-table: p, col
  source: models-sheet.sheet-by-name("t-col-dict", true)
end


###################################################

# Consumes a Number and outputs values from the
# Standard Normal Probability Distribution 
fun NormalPDF(x):
  normal-coeff * gaussian(x)
end

# Consumes a Number and returns the probability of any 
# values less the Number occuring within the 
# Standard Normal Distribution 
fun NormalCDF(x):
  C = round(x / num-sqrt(2), SIG-FIG)
  num-to-roughnum(round(0.5 * (1 + erf(C)), SIG-FIG))
end

# Consumes a Number betweeen 0 and 1 and produces
# the cutoff for values with the cummulative 
# probabilities less than the given Number
fun InvNormalCDF(p):
  if p < -4: 0
  else if p > 4: 1
  else:
    z-lookup.filter(lam(r): r["CDF"] >= p end).row-n(0)["Z"]
  end
end

InvTCDF :: Number, Number, Number -> Number
fun InvTCDF(df, p, tail):
  if (df < 0) :
    raise(
      "invalid argument : " + 
      num-to-string-digits(df,2) + 
      ", degrees of freedom must be larger than 0." )
  else if
    (p < 0.001 ) or (p > 0.5):
    raise(
      "invalid argument : " + 
      num-to-string-digits(p,2) + 
      ", probability must be between 0.001 and 0.5.")
  else:
    tbl = block:
      if tail == 1: t-1tail
      else if tail == 2: t-2tail
      else: 
        raise(
          "invalid argument : " + 
          num-to-string-digits(tail,1) + 
          ", must select 1 or 2 tails")
      end
    end
    row = tbl.filter(lam(x): x["df"] >= df end).row-n(0)
    col = t-col-dict.filter(lam(x): x["p" ] <= p  end).row-n(0)["col"]
    row[col]
  end
end

###################################################

spacing        = string-repeat("- ", 25) 
NPDF-series    = 
  Ch.from-list.scatter-plot(
    z-lookup.get-column("Z"), z-lookup.get-column("PDF"))
  .color(C.red)  
  .legend("Normal Distribution")
NCDF-series    = 
  Ch.from-list.scatter-plot(
    z-lookup.get-column("Z"), z-lookup.get-column("CDF"))
  .color(C.green)
  .legend("Cummulative Normal Distribution")

# Static graph displaying the Standard Normal PDF and CDF
#
# for an interactive normal curve with
# student's T distribution goto 
# https://www.desmos.com/calculator/6709c5b24b
Normal-chart   = 
  Ch.render-charts([list: NPDF-series, NCDF-series])  
  .title(spacing + "The Normal Distribution " + spacing)  
  .height(1200)
  .width( 1200)
  .x-min(-4.0)
  .x-max( 4.0)
  .y-min(-0.1)
  .y-max( 1.1)
  .x-axis("Z")
  .y-axis("Probaility")
  .get-image()

###################################################

fun random-normal(m,s):
  
  # Find a random element from a normal distribution
  # using InvNormalCDF procedure
  z = InvNormalCDF(num-random(10000) / 10000)
  
  # map the random value into the desired domain
  (z * s) + m
end

# simulate-normal returns a list containing n random 
# samples from the normal distribution with mean=m, SD=s.
fun simulate-normal(m, s, n):
  map(lam(x):random-normal(m, s) end, range-by(0,n + 1,1))
end

   
