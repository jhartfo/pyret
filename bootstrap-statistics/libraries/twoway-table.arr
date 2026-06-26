use context starter2024
provide * 

import url( "https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/uniform-distribution.arr") as UD
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

############################################################
# CONSTANTS : size of images

FNT-SZ = 20
SIZE   = FNT-SZ * 2

SIGFIG = 4

############################################################
# CONSTANTS : colors

BG-CLR = "ivory"
FG-CLR = "black"
LN-CLR = "black"
H1-CLR = "sky blue"
H2-CLR = "cornflower-blue"
VENN-B = color(  0,  0,255,0.4)
VENN-R = color(255,  0,  0,0.4)
CLR-R  = 255 # These are the rgb levels for "ivory"
CLR-G  = 255 # for use with .heatmap
CLR-B  = 240 # 

# prob-clr  :: Number -> Color
# htmap-clr :: Number -> Color
# these functions map Numbers to Colors
# either as predefined colors as in prob-clr
# or as gradients as in htmap-clr
fun prob-clr(n):
  if      n == 2: H2-CLR
  else if n == 1: H1-CLR
  else: BG-CLR
  end
end

fun htmap-clr(n):
  color(
    CLR-R - (num-sqrt(n) * CLR-R), 
    CLR-G - (num-sqrt(n) * CLR-G), 
    CLR-B - (num-sqrt(n) * CLR-B), 1)
end

fun htmap-txt(n):
  if (num-sqrt(n) > 0.65):
    "white"
  else:
    LN-CLR
  end
end

fun sums-clr(n):
  ask:
    | n ==  2 then: "yellow"
    | n ==  3 then: "orange"
    | n ==  4 then: "tomato"
    | n ==  5 then: "violet"
    | n ==  6 then: "cornflower-blue"
    | n ==  7 then: "aquamarine"
    | n ==  8 then: "cornflower-blue"
    | n ==  9 then: "violet"
    | n == 10 then: "tomato"
    | n == 11 then: "orange"
    | n == 12 then: "yellow"
    | otherwise: "black"
  end
end

fun sums-txt(n):
  if n > 12:
    "black"
  else:
    LN-CLR
  end
end


############################################################
# Data : Feature
#
# stores inforation of about a categorical variable (String)
# and the possible levels (List)
# 

data Feature:
    feat(
      cat  :: String,
      lvls :: List) 
end

# Consumes a Number and converts it a 
# subscript string
fun digit-to-sub(n):
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

fun num-to-sub(n):
  map(digit-to-sub,string-explode(tostring(n))).join-str("")
end

fun generic-labels(cat, n):
  lbl = block:
    if      cat == "A": "a"
    else if cat == "B": "b"
    else:               "x"
    end
  end
  feat(cat, map(lam(x):lbl + tostring(x) end,range(0,n)))
end

fun fancy-labels(cat, n):
  lbl = block:
    if      cat == "A": "a"
    else if cat == "B": "b"
    else:               "x"
    end
  end
  feat(cat, map(lam(x):lbl + num-to-sub(x) end,range(0,n)))
end


#######################################################
# The Block-Letter datatype wrap over a single character 
# string providing tools to display the string as an
# image of the string set inside of a block

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
      value,#:: Color,
      FG   ,#:: Color,
      BG   ,#:: Color,
      LN   :: String,
      WT   :: Number,
      HT   :: Number
      ) with:
    method display(self):
      text-im = text(self.value, FNT-SZ, self.FG)
      overlay-align("center", "center",
        overlay-align("center", "center", text-im,
          rectangle(self.WT - 2, self.HT - 2, "solid", self.BG)),
        rectangle(self.WT, self.HT, "solid", self.LN))
    end,
    method display-up(self):
      text-im = text(self.value, FNT-SZ, self.FG)
      overlay-align("center", "bottom",
        overlay-align("center", "center", text-im,
          rectangle(self.WT - 2, self.HT - 2, "solid", self.BG)),
        rectangle(self.WT, self.HT, "solid", self.LN))
    end,
    method display-left(self):
      text-im = text(self.value, FNT-SZ, self.FG)
      overlay-align("right", "center",
        overlay-align("center", "center", text-im,
          rectangle(self.WT - 2, self.HT - 2, "solid", self.BG)),
        rectangle(self.WT, self.HT, "solid", self.LN))
    end,
    method _output(self):
      vs-value(self.display())
    end
end

################################################
# custom matrix generators to create 
# arrays of colors for displaying TwoWays

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


################################################
#
# TwoWay is mostly a wrapper around a Matrix 
# with Table-like labels.
# TwoWay .m is an array of values, and provides row
# and column totals. With that information
# various statistics values can be calculated
# and various displays of the TwoWay are available
# 
# Having Feature labels and 'fancy' Features allows
# us to display variables as having special 
# characters like substripts without demanding
# users interact with the TwoWay using those
# special characters.
#
data TwoWay:

    twoway-with-fancy-labels(
      A          :: Feature,
      B          :: Feature,
      Afancy     :: Feature,
      Bfancy     :: Feature,
      m          :: Matrix ) with:
    
    # produces the lists of totals
    # row-totals is the right column of totals
    # col-totals is the bottom row of totals
    method row-totals(self) -> List: 
      map(lam(x):M.sum(mtx-to-list(x)) end, self.m.row-list())
    end,
    method col-totals(self) -> List: 
      map(lam(x):M.sum(mtx-to-list(x)) end, self.m.col-list())
    end,

    # produces the population size depicted in the Two Way Table
    method n(self) -> Number: 
      M.sum(self.col-totals()) 
    end,

    # produces the element at coordinate (a,b)
    method count(self, a,b) -> Number:
      mtx-to-lists(self.m)
        .get(UD.list-index(a,self.A.lvls))
        .get(UD.list-index(b,self.B.lvls))
    end,
    
    # dimensions of the table (without totals)
    method Xlength(self) -> Number: 
      length(self.row-totals()) 
    end,
    method Ylength(self) -> Number: 
      length(self.col-totals()) 
    end,
    
    # produces a Matrix that includes the rows/cols totals
    method withTotals(self) -> Matrix:
      bottom = mtx-augment(
        list-to-row-matrix(self.col-totals()),
        [matrix(1,1): self.n()])
      top = mtx-augment(self.m,
        list-to-col-matrix(self.row-totals()))
      mtx-stack(top,bottom)
    end,  
    
    # methods for rescaling the matrix
    method scale(self, x) -> TwoWay:
      new-mtx = self.m.scale(x)
      twoway-with-fancy-labels(
        self.A, self.B, self.Afancy, self.Bfancy,
        new-mtx)
    end,
    
    # scales the data so that self.n() = 1
    method normalize(self) -> TwoWay: 
      self.scale(1 / self.n()) 
    end,
    
    # scales the data so that row totals are all 1
    method normalize-rows(self) -> TwoWay:
      new-mtx = lists-to-matrix(map2(
        lam(x,y): map(_ / y, x) end,
        mtx-to-lists(self.m),
        self.row-totals()
        ))
      twoway-with-fancy-labels(
        self.A, self.B, self.Afancy, self.Bfancy,
        new-mtx)
    end,
    
    # scales the data so that col totals are all 1
    method normalize-cols(self) -> TwoWay:
      new-mtx = lists-to-matrix(map2(
          lam(x,y): map(_ / y, x) end,
          mtx-to-lists(self.m.transpose()),
        self.col-totals()
          ))
      twoway-with-fancy-labels(
        self.A, self.B, self.Afancy, self.Bfancy,
        new-mtx.transpose())
    end,
    
    # create a new TwoWay by combining cols/rows
    # so that it is a binary TwoWay
    method refractor(self):
      ...
    end,
    
    #################################################
    # this next section provides some useful for statistical 
    # computations
    
    # produces Joint, Marginal, and Conditional Probabilities
    # of the Two Way Table

    # produces n_(ab) / n i.e. p_(ab)
    method jointP(self, a,b) -> Number: 
      self.count(a,b) / self.n() 
    end,

    # produce the appropriate row/col total
    # and divides by n. 
    # n_(a+) / n or n_(+b) / n
    method marginalP(self,cat, lvl) -> Number:
      if      cat == self.A.cat:
        self.row-totals().get(UD.list-index(lvl,self.A.lvls)) / self.n()
      else if cat == self.B.cat:
        self.col-totals().get(UD.list-index(lvl,self.B.lvls)) / self.n()
      else:
        raise(cat + " is not a valid category.")
      end
    end,

    # provides the P(Plvl | Glvl) 
    # Pcat and Gcat identifies which variables are chosen respectfully.
    # This is necessary in case the two variables' 
    # labels shadow each other. For example,  A: (T,F) ,  B: (T,F)
    method conditionalP(self, Pcat, Plvl, Gcat, Glvl): 
      if      Pcat == self.A.cat:
        p = self.count(Plvl,Glvl)
        q =  self.col-totals().get(UD.list-index(Glvl,self.B.lvls))
        p / q
      else if Pcat == self.B.cat:
        p = self.count(Glvl,Plvl)
        q =  self.row-totals().get(UD.list-index(Glvl,self.A.lvls))
        p / q
      else:
        raise("either the probablity must be from variable A " + 
      "and the given must be from variable B, or vice versa.")
      end
    end,
    
    ##########################################
    # misc calculations
    
    method relative-risk(self): ... end,
    method odds-ratio(self): ... end,
    method expected-value(self): 
      A = list-to-col-matrix(self.row-totals())
      B = list-to-row-matrix(self.col-totals())
      (A * B).scale(1 / self.n())
    end,
    method chi-sqr-df(self): 
      (self.Xlength() - 1) * (self.Ylength() - 1) 
    end,
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
    
    method sensativity(self): ... end,
    method specificity(self): ... end,
    
    #######################################
    # This section provides methods to help
    # construct visualizations for the TwoWay
    
    # color matrices for displaying probabilities
    # and heatmaps    
    method display-colors(self) -> List<List>:
      n = self.Xlength() + 1
      m = self.Ylength() + 1
      map(lam(x):repeat(m, BG-CLR) end, range(0,n))
    end,
    
    method joint-colors(self, a, b) -> List<List>:

      x = UD.list-index(a,self.A.lvls)
      y = UD.list-index(b,self.B.lvls)
      n = self.Xlength() + 1
      m = self.Ylength() + 1

      # first we use the matrix structure to identify
      # the levels of the colors and turn the result into 
      # a List of Lists
      clr-mtx = mtx-to-lists(
        fold(_ + _, zero-matrix(n,m), [list:
            matrix-ij(n,m,n - 1, m - 1).scale(2), # total
            matrix-row(n,m, x),                   # given row
            matrix-col(n,m,y)]))                  # given col
      
      # Now we map those levels to specific colours 
      # to the a list of lists 
      map(lam(i): map(prob-clr, i) end, clr-mtx)
    end,
    
    method marginal-colors(self, cat, lvl) -> List<List>:
      n = self.Xlength() + 1
      m = self.Ylength() + 1
      
      # we do this similar to joint-colors; howver, 
      # the contruction will be different depending 
      # on whether we want the marginal probably of
      # A or B. So we create all the matrices at once
      # and bundle them into a list up front.
      # Then we can add them all together.
      mtx-list = block: 
        if cat == self.A.cat:
          a    = UD.list-index(lvl, self.A.lvls) 
          mat1 = matrix-col(n, m, m - 1)         # row totals
          mat2 = matrix-ij( n, m, a, m - 1)      # total of lvl
          mat3 = matrix-ij( n, m, n - 1, m - 1)  # total
          
          [list: mat1, mat2, mat3]
        else if cat == self.B.cat:
          b    = UD.list-index(lvl, self.B.lvls) 
          mat1 = matrix-row(n, m, n - 1)         # col totals
          mat2 = matrix-ij( n, m, n - 1, b)      # total of lvl
          mat3 = matrix-ij( n, m, n - 1, m - 1)  # total
          
          [list: mat1, mat2, mat3]
          else: raise("")
        end
      end
        
      clr-mtx = mtx-to-lists(
        fold(_ + _, zero-matrix(n,m),mtx-list))
      
      # Now we map those levels to specific colours 
      # to the a list of lists 
      map(lam(i): map(prob-clr, i) end, clr-mtx)
    end,
    
    method conditional-colors(self, Pcat, Plvl, Gcat, Glvl) -> List<List>:
      n = self.Xlength() + 1
      m = self.Ylength() + 1
      
      # we do this similar to joint-colors; howver, 
      # the contruction will be different depending 
      # on whether we want the marginal probably of
      # A or B. So we create all the matrices at once
      # and bundle them into a list up front.
      # Then we can add them all together.
      mtx-list = block: 
        if Gcat == self.A.cat:
          a    = UD.list-index(Glvl, self.A.lvls)
          b    = UD.list-index(Plvl, self.B.lvls)
          mat1 = matrix-row(n,m,a)        # row a
          mat2 = matrix-ij(n,m,a, b)      # (a,b)
          mat3 = matrix-ij(n,m,a, m - 1)  # total of a 
          
          [list: mat1, mat2, mat3]
        else:
          a    = UD.list-index(Plvl, self.A.lvls)
          b    = UD.list-index(Glvl, self.B.lvls)
          mat1 = matrix-col(n,m,b)        # col b
          mat2 = matrix-ij(n,m,a, b)      # (a,b)
          mat3 = matrix-ij(n,m,n - 1, b)  # total of b 
          
          [list: mat1, mat2, mat3]
        end
      end
        
      clr-mtx = mtx-to-lists(
        fold(_ + _, zero-matrix(n,m),mtx-list))
      
      # Now we map those levels to specific colours 
      # to the a list of lists 
      map(lam(i): map(prob-clr, i) end, clr-mtx)
    end,
   
    method heatmap-colors(self) -> List<List>:
      clr-mtx = mtx-to-lists(self.normalize().withTotals())
      
      # Now we map those levels to specific colours 
      # to the a list of lists 
      map(lam(i): map(htmap-clr, i) end, clr-mtx)
    end,
    
    method display-text-colors(self) -> List<List>:
      n = self.Xlength() + 1
      m = self.Ylength() + 1
      map(lam(x):repeat(m, FG-CLR) end, range(0,n))
    end,
    
    method heatmap-text-colors(self) -> List<List>:
      clr-mtx = mtx-to-lists(self.normalize().withTotals())
      
      # Now we map those levels to specific colours 
      # to the a list of lists 
      map(lam(i): map(htmap-txt, i) end, clr-mtx)
    end,
    
    method sums-colors(self) -> List<List>:
      clr-mtx = mtx-to-lists(self.withTotals())
      
      # Now we map those levels to specific colours 
      # to the a list of lists 
      map(lam(i): map(sums-clr, i) end, clr-mtx)
    end,
    
    method sums-text-colors(self) -> List<List>:
      clr-mtx = mtx-to-lists(self.withTotals())
      
      # Now we map those levels to specific colours 
      # to the a list of lists 
      map(lam(i): map(sums-txt, i) end, clr-mtx)
    end,
    
    #######################################
    # section, along with the Block-Letter 
    # datatype, provides the building blocks for
    # creating visualizations for the TwoWay Table
    method make-grid(self, clr1, clr2, wt, ht):

      val2 = map(
        lam(r): map(string-number, r) end, 
        mtx-to-lists(self.withTotals())
        )

      rows = map3(lam(x,y,z): 
          fold(beside, empty-image,
            map3(lam(a,b,c): 
                block-letter(a,b,c, LN-CLR, wt, ht).display()
              end,  x,y,z))
        end,
        val2, clr1, clr2)
      
      grid = fold(above, empty-image,rows)
      overlay-align("center", "center", grid,
        rectangle(
          image-width(grid) + 2, 
          image-height(grid) + 2, 
          "solid", LN-CLR))
    end,
    
    method make-top(self, wt, ht):
    
      levels = fold(beside, empty-image, map(
          lam(x):
            block-letter(
              x, FG-CLR, BG-CLR, LN-CLR, wt, ht).display-up() 
          end, self.Bfancy.lvls + [list: "Total"]))

      label = block-letter(
        self.Bfancy.cat, 
        FG-CLR, BG-CLR, LN-CLR,
        image-width(levels), ht).display-up()

      top = above(label, levels)

      overlay-align("center", "bottom",
        top,
        rectangle(
          image-width(top) + 2, 
          image-height(top), 
          "solid",LN-CLR))
    end,

    method make-left(self, wt, ht):
      
      levels = fold(above, empty-image, map(
          lam(x):
            block-letter(
              x, FG-CLR, BG-CLR, LN-CLR, wt, ht).display-left() 
          end, 
          self.Afancy.lvls + [list: "Total"]))
        
      label = block-letter(
        self.Afancy.cat, 
        FG-CLR, BG-CLR, LN-CLR, 
        image-width(levels), image-height(levels)).display-left()
      
      left = beside(label, levels)
      overlay-align("right", "center",
        left,
        rectangle(
          image-width(left), 
          image-height(left) + 2, 
          "solid",LN-CLR))
    end,

    method make-display(self, clr1, clr2):

      # first thing we need to do is find the width of our 
      # grid cells. (height is set by the constants SIZE
      # and FNT-SZ)
      #
      # We need to find the longest between the values in matrix,
      # the B levels, and B.cat / Ylength()
      nums = map(
        lam(x): 
          image-width(text(string-number(x), FNT-SZ, "black"))
        end, 
        mtx-to-list(self.withTotals()))
      
      top-lbls = map(
        lam(x): 
          image-width(text(x, FNT-SZ, "black"))
        end, 
        self.Bfancy.lvls + [list: "Total"])
      
      left-lbls = map(
        lam(x): 
          image-width(text(x, FNT-SZ, "black"))
        end, self.Afancy.lvls + [list: "Total"])

      title-width      = image-width(
        text(self.Bfancy.cat, FNT-SZ, "black")) / 
      UD.list-length(self.Bfancy.lvls)

      longest-nums     = UD.list-maximum(nums)
      longest-top-lbls = UD.list-maximum(top-lbls)

      cell-width       = UD.list-maximum([list:
          title-width,
          longest-nums,
          longest-top-lbls]) + 20

      left-width       = UD.list-maximum(left-lbls) + 20
      
      # Now we can build our display

      grid = self.make-grid(clr1, clr2, cell-width, SIZE)
      top  = self.make-top(cell-width, SIZE)
      left = self.make-left(left-width, SIZE)
      
      beside-align("bottom", left, above(top, grid))
    end,
    
    #######################################
    # this section provides methods to create
    # visualizations for the TwoWay Table
    
    method display(self):
      clr1   = self.display-text-colors()
      clr2   = self.display-colors()
      self.make-display(clr1, clr2)
    end,
        
    method display-jointP(self, a,b):
      clr1   = self.display-text-colors()
      clr2   = self.joint-colors(a, b)
      self.make-display(clr1, clr2)
    end,
    
    method display-marginalP(self, cat,lvl):
      clr1   = self.display-text-colors()
      clr2   = self.marginal-colors(cat, lvl)
      self.make-display(clr1, clr2)
    end,

    method display-conditionalP(self, Pcat, Plvl, Gcat, Glvl):
      clr1   = self.display-text-colors()
      clr2   = self.conditional-colors(Pcat, Plvl, Gcat, Glvl)
      self.make-display(clr1, clr2)
    end,

    method heatmap(self):
      clr1   = self.heatmap-text-colors()
      clr2   = self.heatmap-colors()
      self.make-display(clr1, clr2)
    end,
    
    method sums(self):
      clr1   = self.sums-text-colors()
      clr2   = self.sums-colors()
      self.make-display(clr1, clr2)
    end,
    
    # treats the first level as the affirmative level
    # and the second as the negative

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
    method venn(self):
      if (self.Xlength() == 2) and (self.Ylength() == 2):
        CB     = circle(100, "solid", VENN-R)
        CA     = circle(100, "solid", VENN-B)
        titleA = text(self.A.cat, 30, LN-CLR)
        titleB = text(self.B.cat, 30, LN-CLR)
        BG-WT  = UD.list-maximum([list:
            image-width(titleA) + 
            image-width(titleA) + 20, 400])
        BG-CTR = BG-WT / 2
        BG     = rectangle(BG-WT, 300, "solid", "white")
            
        A      = text(num-to-string(self.m.get(0,0)), FNT-SZ, LN-CLR)
        B      = text(num-to-string(self.m.get(0,1)), FNT-SZ, LN-CLR)
        C      = text(num-to-string(self.m.get(1,0)), FNT-SZ, LN-CLR)
        D      = text(num-to-string(self.m.get(1,1)), FNT-SZ, LN-CLR)

        # remember place-image-align uses screen coordinates 
        put-image(
          A, BG-CTR, 180, put-image(
            B, BG-CTR - 70, 180, put-image(
              C, BG-CTR + 130, 180, put-image(
                D, BG-CTR, 40, place-image-align(
                  titleA, BG-CTR - 40, 40, "right", "center",  
                  place-image-align(
                    titleB, BG-CTR + 40, 40, "left", "center", 
                    put-image(
                      CA, BG-CTR - 60, 180, put-image(
                        CB, BG-CTR + 60, 180, BG))))))))
      else:
        raise(".venn is only valid for binary two way tables.")
      end
    end,
    method _output(self): vs-value(self.display()) end,

end  
    
##########################################

fun twoway(A,B,m):
  twoway-with-fancy-labels(A,B,A,B,m)
end
  
fun tw(m):
  N = mtx-to-lists(m).length()
  M = mtx-to-lists(m).get(0).length()
  twoway-with-fancy-labels(
    generic-labels("A",N),
    generic-labels("B",M), 
    fancy-labels("A",N),
    fancy-labels("B",M), m)
end

fun binary-tw(a,b,c,d):
  twoway-with-fancy-labels(
    feat("A", [list: "A", "~A"]),
    feat("B", [list: "B", "~B"]),
    feat("A", [list: "A", "~A"]),
    feat("B", [list: "B", "~B"]),
    [matrix(2,2): a,b,c,d]
    )
end

fun twoD6(style):
  m = block: 
    if style == "probability":
      build-matrix(6,6, lam(i,j): 1/36 end) 
    else if style == "sums":
      build-matrix(6,6, lam(i,j): i + j + 2 end)
    else:
      build-matrix(6,6, lam(i,j): 1 end) 
    end
  end
  A = feat("Die A", map(tostring, range(1,7)))
  B = feat("Die B", map(tostring, range(1,7)))
  
  twoway-with-fancy-labels(A,B,A,B,m)
end

# z-test analysis
# this may not make sense to develop...still thinking
# about it....
fun zt(): ... end

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
  
  Afeat = feat(A, Alevels)
  Bfeat = feat(B, Blevels)
  twoway-with-fancy-labels(Afeat,Bfeat, Afeat, Bfeat, m)
end

fun table-to-confusion-matrix(T, col, classifier):
  PT      = T.build-column("predicted", classifier)
  levels = UD.count(PT, col).get-column(col)
  m       = lists-to-matrix(
    map(
      lam(a): 
        map(lam(b): 
            PT
              .filter-by(col, lam(x): x == a end)
              .filter-by("predicted", lam(x): x == b end).length()
          end, levels)
      end,levels))
  A = feat("Actual"   , map(tostring,levels))
  B = feat("Predicted", map(tostring,levels))
  twoway-with-fancy-labels(A,B,A,B,m)
end

# synonym for twoway-from-table
# for some reason pyret does not like 
# table-to-twoway = twoway-from-table
fun table-to-twoway(tbl, A, B): 
  twoway-from-table(tbl, A, B)
end


########################################

test1 = twoway-with-fancy-labels(
  generic-labels("A",2),
  generic-labels("B",3), 
  fancy-labels("A",2),
  fancy-labels("B",3),
  [matrix(2,3): 1,2,3,4,5,6]
  )

test2 = twoway-with-fancy-labels(
  generic-labels("AAAAAAA",2),
  generic-labels("BBBBBB",2), 
  fancy-labels("A",2),
  fancy-labels("B",2),
  [matrix(2,2): 1,2,3,4]
  )
