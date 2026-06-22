use context starter2024
provide * 

import url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/uniform-distribution.arr") as UD
provide from UD: * ,
  type *,
  data *
end

include valueskeleton
include matrices

import math as M
#include gdrive-sheets
import sets as Sets
import color as C
shadow color = C.color

FNT-SZ = 20
SIZE   = FNT-SZ * 2

BG-CLR = "ivory"
LN-CLR = "black"
H1-CLR = "sky blue"
H2-CLR = "cornflower-blue"
VENN-B = color(  0,  0,255,0.4)
VENN-R = color(255,  0,  0,0.4)
CLR-R  = 255 # These are the rgb levels for "ivory"
CLR-G  = 255 # for use with .heatmap
CLR-B  = 240 # 

# TwoWay is mostly a wraper around a Matrix
# TwoWay treats the underlying matrix
# (.matrix() or .m in most cases)
# as an array of values, and provides row
# and column totals. With that information
# various probabilities can be calculated
# and various displays of the TwoWay are available
# 
# twoway simply takes in a matrix
# twoway-with-labels allows the user to include 
#    custom labels for the horizontal and 
#    vertical axis.
# binaryTW assumes a 2x2 twoway table, and allows 
#    the user to simply enter the four values, by rows.
#    the default labels are A, ~A, B, ~B.
#    There is an additional method .venn() available
#    to display a Venn Diagram of the TwoWay
# binaryCM is similar to binaryTW, but we are asuuming
#     the TwoWay is depicting a Confusion Matrix.
#     There is additional methods .sensativity()
#     and .specificity()
# ZT is for hypetheses z-test and still in progress
data TwoWay:
    
    ####
  |twoway(m) with:
    method matrix(self): self.m end,
    method Alevels(self): [list: "A"]
        .append(generic-labels("a",self.Xlength()))
    end,
    method Blevels(self): [list: "B"]
        .append(generic-labels("b",self.Ylength()))
    end,
    method Afancy(self):
      [list: "A"]
        .append(generic-fancy-labels("a",self.Ylength()))
    end,
    method Bfancy(self):[list: "B"]
        .append(generic-fancy-labels("b",self.Ylength()))
    end,
    
    ####
  |twoway-with-labels(m,a,b) with:
    method matrix(self): self.m end,
    method Alevels(self): self.a end,
    method Blevels(self): self.b end,
    method Afancy(self): self.Alevels() end,
    method Bfancy(self): self.Blevels() end,    
    
    ####
  |binaryTW(AB, AnotB, notAB, notAnotB) with:
    method matrix(self): 
      [matrix(2,2): self.AB, self.AnotB, self.notAB, self.notAnotB]
    end,
    method Alevels(self): [list: "A", "A", "~A"] end,
    method Blevels(self): [list: "B", "B", "~B"] end,
    method Afancy(self): self.Alevels() end,
    method Bfancy(self): self.Blevels() end,
    method venn(self): venn(self.matrix()) end,
    
    ####
  |binaryCM(AB, AnotB, notAB, notAnotB) with:
    method matrix(self): 
      [matrix(2,2): self.AB, self.AnotB, self.notAB, self.notAnotB]
    end,
    method Alevels(self): [list: "True Status", "Yes", "No"] end,
    method Blevels(self): [list: "Diagnosis", "+", "-"] end,
    method Afancy(self): self.Alevels() end,
    method Bfancy(self): self.Blevels() end,
    method sensativity(self): self.conditionalP(0,0,"row") end,
    method specificity(self): self.conditionalP(1,1,"row") end,

    ####
  |ZT(AB, AnotB, notAB, notAnotB) with:
    method matrix(self): 
      [matrix(2,2): self.AB, self.AnotB, self.notAB, self.notAnotB]
    end,
    method Alevels(self): [list: "True Value", "Hₒ", "Hₐ"] end,
    method Blevels(self): 
      [list: "Hypothesis Test", "Reject Hₒ", "Fail to Reject"]
    end,
    method Afancy(self): self.Alevels() end,
    method Bfancy(self): self.Blevels() end,
    
  |twoD6(style) with:
    method matrix(self): 
      if self.style == "probability":
        build-matrix(6,6, lam(i,j): 1/36 end) 
      else:
        build-matrix(6,6, lam(i,j): 1 end) 
      end
    end,
    method Alevels(self): map(num-to-string, UD.arithmetic(1,7,1))
      .push("Dice A") end,
    method Blevels(self): map(num-to-string, UD.arithmetic(1,7,1))
      .push("Dice B") end,
    method Afancy(self): self.Alevels() end,
    method Bfancy(self): self.Blevels() end, 
    method sumP(self,n):
      numerator = ask:
        |n == 2  then: 1
        |n == 3  then: 2
        |n == 4  then: 3
        |n == 5  then: 4
        |n == 6  then: 5
        |n == 7  then: 6
        |n == 8  then: 5
        |n == 9  then: 4
        |n == 10 then: 3
        |n == 11 then: 2
        |n == 12 then: 1
        |otherwise: 0
      end
      numerator / 36
    end,
    method displaySums(self, n):
      m = if not(num-is-integer(n)) or (n < 2) or (n > 12):
          raise("when adding two D6s, the sum is an integer from 2 to 12.")
      else:
        build-matrix(7,7,lam(i,j): 
            if (((i + 1) + (j + 1)) == n) and (j < 6) and (i < 6): 1
            else if (i == 6) and (j == 6):2
            else: 0 end 
          end)
      end      
      build-table(
      self.withTotals(), m,
      self.Afancy(), self.Bfancy(), false)
    end
    
sharing: 
  # rescales the two way table
  method scale(self, x):
    m = self.matrix().scale(x)
    twoway-with-labels(m, self.Alevels(), self.Blevels())
  end,
  method normalize(self): self.scale(1 / self.n()) end,
  
  # dimensions of the table (without totals)
  method Xlength(self): length(self.row-totals()) end,
  method Ylength(self): length(self.col-totals()) end,
  
  # produces a Matrix that include the total rows/cols
  method withTotals(self):
    bottom = mtx-augment(
      list-to-row-matrix(self.col-totals()),
      [matrix(1,1): self.n()])
    top = mtx-augment(self.matrix(),
      list-to-col-matrix(self.row-totals()))
    mtx-stack(top,bottom)
  end,

  # produces the lists of totals
  # row-totals is the right column of totals
  # col-totals is the bottom row of totals
  method row-totals(self): 
    map(lam(x):M.sum(mtx-to-list(x)) end, self.matrix().row-list())
  end,
  method col-totals(self): 
    map(lam(x):M.sum(mtx-to-list(x)) end, self.matrix().col-list())
  end,
  
  # produces the population size depicted in the Two Way Table
  method n(self): M.sum(self.col-totals()) end,
 
  # takes in a level from variable A and a level from variable B
  # and produces the frequency, n_(ab)
  method count(self, a,b):
  if any(lam(x): x == a end, self.Alevels()): block:
      if any(lam(x): x == b end, self.Blevels()):
          i = UD.list-index(self.Alevels().drop(1), a)
          j = UD.list-index(self.Blevels().drop(1), b)
          self.matrix().get(i,j)
    else:
          B = self.Blevels().get(0)
          raise("'" + tostring(b) + "' is not a category of '" + B + "'")
      end
    end
    else:
      A = self.Alevels().get(0)
      raise("'" + tostring(a) + "' is not a category of '" + A + "'")
    end
  end,

  # produces Joint, Marginal, and Conditional Probabilities
  # of the Two Way Table
  
  # produces n_(ab) / n i.e. p_(ab)
  method jointP(self, a,b): 
    self.count(a,b) / self.n() 
  end,
  
  # v identifies which variable (A or B) being totaled
  # lvl identifies which lvl of v is being totaled
  method marginalP(self,v,lvl):
    A = self.Alevels()
    B = self.Blevels()
    a = A.get(0)
    b = B.get(0)
    n = block: 
      if v == a:
        if any(lam(x): x == lvl end, A):
          idx = UD.list-index(A, lvl) - 1
          self.row-totals().get(idx)
        else:
          raise("'" + tostring(lvl) + "' is not a category of '" + A + "'")
        end
      else if v == b:
        if any(lam(x): x == lvl end, B):
          idx = UD.list-index(B, lvl) - 1
          self.col-totals().get(idx)
        else:
          raise("'" + tostring(lvl) + "' is not a category of '" + A + "'")
        end
      else:
        raise("'" + tostring(v) + " is not a valid variable.")
      end
    end
    n / self.n()
  end,
  
  # provides the P(Plvl | Glvl) 
  # Pv and Gv identifies which variables are chosen respectfully.
  # This is necessary in case the two variables' 
  # labels shadow each other. For example,  A: (T,F) ,  B: (T,F)
  method conditionalP(self, Pv, Plvl, Gv, Glvl): 
    A = self.Alevels()
    B = self.Blevels()
    a = A.get(0)
    b = B.get(0)
    message = 
        "either the probablity must be from variable A " + 
        "and the given must be from variable B, or vice versa."
    if (Gv == a) and (Pv == b):
      if any(lam(x): x == Glvl end, A) and any(lam(x): x == Plvl end, B):
        Gidx = UD.list-index(A.drop(1), Glvl)
        n    = self.count(Glvl, Plvl)
        N    = self.row-totals().get(Gidx) 
        n / N
      else:
        raise(message)
      end
    else if (Gv == b) and (Pv == a):
      if any(lam(x): x == Glvl end, B) and any(lam(x): x == Plvl end, A):
        Gidx = UD.list-index(B.drop(1), Glvl)
        N    = self.col-totals().get(Gidx) 
        n    = self.count(Plvl, Glvl)
        n / N
      else:
        raise(message)
      end
    else:
      raise(message)
    end
  end,
  
  # displays the actual Two Way Table
  # .heatmap produces a heatmap
  # .display is plain table.
  # .displayJointP, .displayConditionalP, and displayMarginal
  # display the given probability
  
  method display(self):
    n    = self.Xlength() + 1
    m    = self.Ylength() + 1
    build-table(
      self.withTotals(), 
      zero-matrix(n,m),
      self.Afancy(), self.Bfancy(), false)
  end,
  method _output(self):
    vs-value(self.display())
  end,
  
  method displayJointP(self,a-str,b-str):
    n    = self.Xlength() + 1
    m    = self.Ylength() + 1
    a    = block:
      if any(lam(x): x == a-str end, self.Alevels()):
        UD.list-index(self.Alevels(), a-str) - 1
      else:
        raise("'" + a-str + "' is not a valid category.")
      end
    end
    b    = block:
      if any(lam(x): x == b-str end, self.Blevels()):
        UD.list-index(self.Blevels(), b-str) - 1
      else:
        raise("'" + b-str + "' is not a valid category.")
      end
    end
    clrs = fold(_ + _, zero-matrix(n,m), [list:
        matrix-ij(n,m,n - 1,m - 1).scale(2),
        matrix-row(n,m, a),
        matrix-col(n,m,b)])
    build-table(
      self.withTotals(), 
      clrs, self.Afancy(), self.Bfancy(), false)
  end,
  
  method displayMarginalP(self,v, lvl):
    n      = self.Xlength() + 1
    m      = self.Ylength() + 1  
    mat1   = block:
      if v == self.Alevels().get(0):
        idx = UD.list-index(self.Alevels().drop(1), lvl)
        matrix-ij(n,m,idx, m - 1)
      else if v == self.Blevels().get(0):
        idx = UD.list-index(self.Blevels().drop(1), lvl)
        matrix-ij(n,m, n - 1, idx)
      else:
        raise("'" + lvl + "' is not a valid category.")
      end
    end
    mat2   = block:
      if v == self.Alevels().get(0):
        matrix-col(n,m,m - 1)
      else:
        matrix-row(n,m,n - 1)
      end
    end
    clrs = fold(_ + _, zero-matrix(n,m), [list:
        mat1, mat2,
        matrix-ij(n,m,n - 1,m - 1)])
    build-table(
      self.withTotals(), 
      clrs, self.Afancy(), self.Bfancy(), false)
  end,
  
  method displayConditionalP(self, Pv, Plvl, Gv, Glvl):
    n       = self.Xlength() + 1
    m       = self.Ylength() + 1
    A       = self.Alevels()
    B       = self.Blevels()
    message = 
        "either the probablity must be from variable A " + 
        "and the given must be from variable B, or vice versa."
    mat1    = block:
      if (Gv == A.get(0)) and (Pv == B.get(0)):
        a = UD.list-index(A.drop(1), Glvl)
        matrix-row(n,m,a)
      else if (Pv == A.get(0)) and (Gv == B.get(0)):
        b = UD.list-index(B.drop(1), Glvl)
        matrix-col(n,m,b)
      else:
        raise(message)
      end
    end
    mat2   = block:
      if (Gv == A.get(0)) and (Pv == B.get(0)):
        a = UD.list-index(A.drop(1), Glvl)
        matrix-ij(n,m, a, m - 1)
      else:
        b = UD.list-index(B.drop(1), Glvl)
        matrix-ij(n,m,n - 1,b)
      end
    end
    mat3   = block:
      if (Gv == A.get(0)) and (Pv == B.get(0)):
        a = UD.list-index(A.drop(1), Glvl)
        b = UD.list-index(B.drop(1), Plvl)
        matrix-ij(n,m, a, b)
      else:
        a = UD.list-index(A.drop(1), Plvl)
        b = UD.list-index(B.drop(1), Glvl)
        matrix-ij(n,m,a,b)
      end
    end
    clrs = mat1 + mat2 + mat3
    build-table(
      self.withTotals(), 
      clrs, self.Afancy(), self.Bfancy(), false)
  end,
  
  method heatmap(self):
    build-table(
      self.withTotals(),
      self.normalize().withTotals(),
      self.Afancy(), self.Bfancy(), true)
  end,
  
  method relative-risk(self): 0 end,
  method odds-ratio(self): 0 end,
  method expected-value(self): 
    A = list-to-col-matrix(self.row-totals())
    B = list-to-row-matrix(self.col-totals())
    (A * B).scale(1 / self.n())
  end,
  method chi-sqr-df(self): (self.Xlength() - 1) * (self.Ylength() - 1) end,
  method chi-sqr-stdDev(self): num-sqrt(2 * self.chi-sqr-df()) end, 
  method chi-sqr(self):
    M.sum(map( M.sum,
      self.matrix().map2(
          self.expected-value(), lam(x,y): num-sqr(x - y) / y end)
          .to-lists()))
  end,
  
  method fisher(self): 
    a = UD.combination(
      self.row-totals().get(0), 
      self.matrix().get(0,0))
    b = UD.combination(
      self.row-totals().get(1), 
      self.col-totals().get(0) - self.matrix().get(0,0))
    c = UD.combination(
      self.n(),
      self.col-totals().get(0))
    (a * b) / c
  end,
end

# twoway-from-table :: Table, String, String -> TwoWay
# Consumes a Table and two column names (Strings) and
# produces a TwoWay frequency table
fun twoway-from-table(tbl, A, B):
  Alevels = UD.count(tbl, A).get-column(A)
  Blevels = UD.count(tbl, B).get-column(B)
  m       = lists-to-matrix(
    map(
      lam(a): 
        map(lam(b): 
            tbl
              .filter-by(A, lam(x): x == a end)
              .filter-by(B, lam(x): x == b end).length()
          end, Blevels)
      end,Alevels))
  twoway-with-labels(
    m,
    [list:A].append(map(tostring,Alevels)),
    [list:B].append(map(tostring,Blevels)))
end

fun table-to-confusion-matrix(T, col, classifier):
  PT      = T.build-column("predicted", classifier)
  Alevels = UD.count(PT, col).get-column(col)
  Blevels = UD.count(PT, "predicted").get-column("predicted")
  m       = lists-to-matrix(
    map(
      lam(a): 
        map(lam(b): 
            PT
              .filter-by(col, lam(x): x == a end)
              .filter-by("predicted", lam(x): x == b end).length()
          end, Blevels)
      end,Alevels))
  twoway-with-labels(
    m,
    [list:"actual"   ].append(map(tostring,Alevels)),
    [list:"predicted"].append(map(tostring,Blevels)))
end

# synonym for twoway-from-table
# for some reason pyret does not like 
# table-to-twoway = twoway-from-table
fun table-to-twoway(tbl, A, B): 
  twoway-from-table(tbl, A, B)
end

###############################
# displays binary two way tables as a venn diagram

# note to self:
# single set-bubble along with its complement
# is the visualization for a binary frequency table.
# That is  a 2-Vector.
#
# a two-bubble venn diagram is 
# the visualization for a binary two way 
# table (a 2x2 2D-array).
# That is a 2-square Matrix
#
# a three-bubble venn diagram is
# the visualization for a binary three way
# table (a 2x2x2 3D-array).
# That is a Rank-3 Tensor.
# 
# etc

fun venn(m):
  CB     = circle(100, "solid", VENN-R)
  CA     = circle(100, "solid", VENN-B)
  BG     = rectangle(400, 300, "solid", "white")
  titleA = text("-A-", 30, "black")
  titleB = text("-B-", 30, "black")
  A      = text(num-to-string(m.get(0,0)), FNT-SZ, "black")
  B      = text(num-to-string(m.get(0,1)), FNT-SZ, "black")
  C      = text(num-to-string(m.get(1,0)), FNT-SZ, "black")
  D      = text(num-to-string(m.get(1,1)), FNT-SZ, "black")
  
  put-image(
    A, 200, 180, put-image(
      B, 70, 180, put-image(
        C, 330, 180, put-image(
          D, 200, 40, put-image(
            titleA, 140, 260, put-image(
              titleB, 260, 260, put-image(
                CA, 140, 180, put-image(
                  CB, 260, 180, BG))))))))
end

###############################
# Functions for creating the TwoWay displays

# Consumes a Number and converts it a 
# subscript string
fun number-to-subscript(n):
  ask:
    | n == "0" then: "₀"
    | n == "1" then: "₁"
    | n == "2" then: "₂"
    | n == "3" then: "₃"
    | n == "4" then: "₄"
    | n == "5" then: "₅"
    | n == "6" then: "₆"
    | n == "7" then: "₇"
    | n == "8" then: "₈"
    | n == "9" then: "₉"
    | otherwise: "not valid input"
  end
end

# Consumes a sequence name and a Number
# and produces the label for the nth element
# for the sequence
fun number-to-sequence(seq, n):
  digits = string-explode(num-to-string(n))
  seq + map(number-to-subscript, digits).join-str("")
end

# labels for the TwoWay Table for variable lookup when labels are not given 
fun generic-labels(seq, n):
  map(lam(x): seq + num-to-string(x) end, range-by(0,n,1))
end

# labels for the TwoWay Table display when labels are not given 
fun generic-fancy-labels(seq, n):
  map(lam(x): number-to-sequence(seq, x) end, range-by(0,n,1))
end
  
# Produces a single cell in the TwoWay Table Display
fun build-data-block(n,c, w, sigfigs, htmap):
  clr = block:
    if htmap:
      color(
        CLR-R - (num-sqrt(c) * CLR-R), 
        CLR-G - (num-sqrt(c) * CLR-G), 
        CLR-B - (num-sqrt(c) * CLR-B), 1)
    else:
      if c == 0: BG-CLR
      else if c == 1: H1-CLR
      else: H2-CLR
      end
    end
  end
  txt-clr = block:
    if htmap and (num-sqrt(c) > 0.65):
      "white"
    else:
      LN-CLR
    end
  end
  
  overlay(
    text(num-to-string-digits(n,sigfigs), FNT-SZ, txt-clr),
    overlay(
      rectangle(w * SIZE, SIZE, "outline", LN-CLR),
      rectangle(w * SIZE, SIZE, "solid", clr)
      ))
end

# Produces the entire data portion of the TwoWay Table Display
fun build-data-row(N,C, w, sigfigs, htmap):
  fold(
    beside, 
    empty-image, 
    map2(lam(x,y):build-data-block(x,y,w, sigfigs, htmap) end, N,C))
end

# Produces a single LABEL cell in the TwoWay Table Display
fun build-label-blocks(s,w):
  overlay(
    text(s, FNT-SZ, LN-CLR),
    overlay(
      rectangle(w * SIZE, SIZE, "outline", LN-CLR),
      rectangle(w * SIZE, SIZE, "solid", BG-CLR)
      ))
end

# produces the TwoWay Table display
fun build-table(the-data, the-clrs, Xlabels, Ylabels, htmap):

  max-wts = UD.list-maximum(
    map(
      string-length, 
      Xlabels
        .append(Ylabels)
        .append([list: "Totals"]))) * 0.3

  T       = [list: "Totals"]
  A       = Xlabels.split-at(1).prefix.get(0)
  a       = Xlabels.split-at(1).suffix.append(T)
  B       = Ylabels.split-at(1).prefix.get(0)
  b       = Ylabels.split-at(1).suffix.append(T)
  Alabels = map(lam(x): build-label-blocks(x,max-wts) end, a)
  Blabels = map(lam(x): build-label-blocks(x,max-wts) end, b)
  rows    = mtx-to-lists(the-data)
  cols    = mtx-to-lists(the-data.transpose())
  clrs    = mtx-to-lists(the-clrs)
  n       = cols.get(0).length()
  m       = rows.get(0).length()
 
  sigfigs = block:
    if the-data.get(n - 1, m - 1) <= 1:4
    else: 0
    end
  end
  
  right = above(
    rectangle(2 * SIZE * max-wts, 2 * SIZE,"solid",BG-CLR),
    beside(
      overlay(
        text(A, FNT-SZ, LN-CLR),
        overlay(
          rectangle(max-wts * SIZE, n * SIZE, "outline", LN-CLR),
          rectangle(max-wts * SIZE, n * SIZE, "solid", BG-CLR)
          )),
      fold(above, empty-image,Alabels)))
 
  grid  = fold(
    above, 
    empty-image, 
    map2(
      lam(x,y):build-data-row(x,y,max-wts, sigfigs, htmap) end, 
      rows, 
      clrs))
  beside(right,
    above(
      above(
        build-label-blocks(B,m * max-wts),
        fold(beside, empty-image, Blabels)),
      grid))
end

# produces a nxm matrix with ones in row a
# and zero everywhere else
fun matrix-row(n,m,a):
  build-matrix(n,m, lam(i,j): 
      if (i == a):1 
      else: 0 end 
    end)
  end

# produces a nxm matrix with ones in column b
# and zero everywhere else
fun matrix-col(n,m,b):
  build-matrix(n,m, lam(i,j): 
      if (j == b):1 
      else: 0 end 
    end)
  end

# produces a nxm matrix with a one for element (a,b)
# and zero everywhere else
fun matrix-ij(n,m,a,b):
  build-matrix(n,m, lam(i,j): 
      if (i == a) and (j == b):1 
      else: 0 end 
    end)
  end


##############################################################


HYPO-WT = 3
hypo-test-display-elements = 
  [list:
    [list:
      rectangle(HYPO-WT * SIZE, SIZE, "solid", BG-CLR),
      build-label-blocks("Hypothesis Test", HYPO-WT * 3)],
    [list:
      rectangle(HYPO-WT * SIZE, SIZE, "solid", BG-CLR),
      build-label-blocks("Reject Hₒ"      , HYPO-WT),    
      build-label-blocks("Fail to Reject" , HYPO-WT),    
      build-label-blocks("Totals"         , HYPO-WT)],
    [list:
      build-label-blocks("Hₒ"             , HYPO-WT), 
      build-label-blocks("α"              , HYPO-WT), 
      build-label-blocks("1 - α"          , HYPO-WT), 
      build-label-blocks("α + 1 - α = 1"  , HYPO-WT)],
    [list:
      build-label-blocks("Hₐ"             , HYPO-WT), 
      build-label-blocks("1 - β"          , HYPO-WT),
      build-label-blocks("β"              , HYPO-WT),
      build-label-blocks("1 - β + β = 1"  , HYPO-WT)],
    [list:
      build-label-blocks("Totals"         , HYPO-WT), 
      build-label-blocks("- - - -"        , HYPO-WT),
      build-label-blocks("- - - -"        , HYPO-WT),
      build-label-blocks("2.00"        , HYPO-WT)]
  ]
hypo-test-display = 
  fold(
    above,
    empty-image,
    map(
      lam(x): fold(beside, empty-image,x)end,
      hypo-test-display-elements))


#######################################################

fun strip-roughnum-prefix(s :: String) -> String:
  string-substring(s, 1, string-length(s))
end

fun round-n(n,d):
  num-round(n * num-expt(10,d)) / num-expt(10,d)
end

fun string-number(x:: Number) -> String :
  if num-is-integer(x):
    num-to-string(x)
  else:
    UD.normalize-exponent(
      strip-roughnum-prefix(
        UD.num-to-string(
          UD.num-to-roughnum(
            round-n(x,SIGFIG)
            ))))
  end
end
    
data Block-Letter:
    block-letter(
      value:: String,
      FG   :: String,
      BG   :: String,
      BR   :: String,
      WT   :: Number,
      HT   :: Number
      ) with:
    method display(self):
      text-im = text(self.value, FNT-SZ, self.FG)
      overlay-align("center", "center",
        overlay-align("center", "center", text-im,
          rectangle(self.WT - 2, self.HT - 2, "solid", self.BG)),
        rectangle(self.WT, self.HT, "solid", self.BR))
    end,
    method display-up(self):
      text-im = text(self.value, FNT-SZ, self.FG)
      overlay-align("center", "bottom",
        overlay-align("center", "center", text-im,
          rectangle(self.WT - 2, self.HT - 2, "solid", self.BG)),
        rectangle(self.WT, self.HT, "solid", self.BR))
    end,
    method display-left(self):
      text-im = text(self.value, FNT-SZ, self.FG)
      overlay-align("right", "center",
        overlay-align("center", "center", text-im,
          rectangle(self.WT - 2, self.HT - 2, "solid", self.BG)),
        rectangle(self.WT, self.HT, "solid", self.BR))
    end,
    method _output(self):
      vs-value(self.display())
    end
end
      
fun clr2-fn(x): "ivory" end
fun clr1-fn(x): "black" end

fun make-grid(m1, m2, wt, ht, c1, c2):
  values = mtx-to-lists(m1)
  colors = mtx-to-lists(m2)
  
  val2 = map(lam(r): map(string-number, r) end, values)
  
  clr2 = map(lam(r): map(c1, r) end, values)
  clr3 = map(lam(r): map(c2, r) end, values)
  
  rows = map3(lam(x,y,z): 
      fold(beside, empty-image,
      map3(lam(a,b,c): 
            block-letter(a,b,c, "black", wt, ht).display()
          end,  x,y,z))
    end,
    val2, clr2, clr3)
  grid = fold(above, empty-image,rows)
  overlay-align("center", "center", grid,
    rectangle(
      image-width(grid) + 2, 
      image-height(grid) + 2, 
      "solid", "black"))
end

fun make-top(top-title, top-levels, wt, ht):
  levels = fold(beside, empty-image, map(
      lam(x):
        block-letter(
          x, "black", "ivory", "black", wt, ht).display-up() 
      end, top-levels))
  
  label = block-letter(
    top-title, 
    "black", 
    "ivory", 
    "black", 
    image-width(levels), ht).display-up()
  
  top = above(label, levels)
  
  overlay-align("center", "bottom",
    top,
    rectangle(image-width(top) + 2, image-height(top), "solid","black"))
end

fun make-left(left-title, left-levels, wt, ht):
  levels = fold(above, empty-image, map(
      lam(x):
        block-letter(
          x, "black", "ivory", "black", wt, ht).display-left() 
      end, 
      left-levels))
  
  label = block-letter(
    left-title, 
    "black", 
    "ivory", 
    "black", 
    image-width(levels), image-height(levels)).display-left()
  
  left = beside(label, levels)
  overlay-align("right", "center",
    left,
    rectangle(image-width(left), image-height(left) + 2, "solid","black"))
end

fun make-display(A, B, m1,m2):
  top-title   = A.get(0)
  top-levels  = A.drop(1)
  left-title  = B.get(0)
  left-levels = B.drop(1)
  
  nums = map(
    lam(x): 
      image-width(text(string-number(x), FNT-SZ, "black"))
    end, 
    mtx-to-list(m1))
  top-lbls = map(
    lam(x): 
      image-width(text(x, FNT-SZ, "black"))
    end, 
    top-levels)
  left-lbls = map(
    lam(x): 
      image-width(text(x, FNT-SZ, "black"))
    end, A)

  title-width      = image-width(text(top-title, FNT-SZ, "black")) / 
  UD.list-length(top-levels)
  
  longest-nums     = UD.list-maximum(nums)
  longest-top-lbls = UD.list-maximum(top-lbls)

  cell-width       = UD.list-maximum([list:
      title-width,
      longest-nums,
      longest-top-lbls]) + 20

  left-width       = UD.list-maximum(left-lbls) + 20
  
  grid             = make-grid(m1,m2, 
    cell-width, 
    SIZE, 
    clr1-fn, clr2-fn)
  
  top              = make-top(
    top-title, 
    top-levels, 
    cell-width, SIZE)
  
  left             = make-left(
    left-title, 
    left-levels,
    left-width, SIZE)
  beside-align("bottom", left, above(top, grid))
end















