use context starter2024

# try typing "matrix-demo(Mx-equals-b)"
# try typing "matrix-demo(AB-equals-C)"

include reactors

TX-CLR  = "black"
BG-CLR  = "ivory"
BR-CLR  = "antique-white"
HL-CLR  = "cornflower blue"
SIZE    = 100
TX-SZE  = SIZE / 2

VT-BAR  = rectangle(0.1 * SIZE, 3.0 * SIZE, "solid", TX-CLR)
TAB     = rectangle(0.2 * SIZE, 0.1 * SIZE, "solid", TX-CLR)
SIDE-BK = rectangle(0.1 * SIZE, 3.0 * SIZE, "solid", BG-CLR)
LT-BRKT = overlay-align("left", "center", 
  VT-BAR, overlay-align("center", "top",
    TAB, overlay-align("center", "bottom",
      TAB, SIDE-BK)))
RT-BRKT = flip-horizontal(LT-BRKT)

  fun num-to-sub(n):
  ask:
    |n == 0 then:"\u2080"
    | n == 1 then:"\u2081"
    | n == 2 then:"\u2082"
    | n == 3 then:"\u2083"
    | n == 4 then:"\u2084"
    | n == 5 then:"\u2085"
    | n == 6 then:"\u2086"
    | n == 7 then:"\u2087"
    | n == 8 then:"\u2088"
    | n == 9 then:"\u2089"
    | otherwise: raise("")
  end
end

fun coord(a,r,c):
  a + num-to-sub(r) + num-to-sub(c)
end

fun coordv(a,r):
  a + num-to-sub(r)
end

a00 = coord("a", 0,0)
a01 = coord("a", 0,1)
a02 = coord("a", 0,2)
a10 = coord("a", 1,0)
a11 = coord("a", 1,1)
a12 = coord("a", 1,2)
a20 = coord("a", 2,0)
a21 = coord("a", 2,1)
a22 = coord("a", 2,2)

b00 = coord("b", 0,0)
b01 = coord("b", 0,1)
b02 = coord("b", 0,2)
b10 = coord("b", 1,0)
b11 = coord("b", 1,1)
b12 = coord("b", 1,2)
b20 = coord("b", 2,0)
b21 = coord("b", 2,1)
b22 = coord("b", 2,2)

c00 = coord("c", 0,0)
c01 = coord("c", 0,1)
c02 = coord("c", 0,2)
c10 = coord("c", 1,0)
c11 = coord("c", 1,1)
c12 = coord("c", 1,2)
c20 = coord("c", 2,0)
c21 = coord("c", 2,1)
c22 = coord("c", 2,2)

m00 = coord("m", 0,0)
m01 = coord("m", 0,1)
m02 = coord("m", 0,2)
m10 = coord("m", 1,0)
m11 = coord("m", 1,1)
m12 = coord("m", 1,2)
m20 = coord("m", 2,0)
m21 = coord("m", 2,1)
m22 = coord("m", 2,2)

vx0  = coordv("x", 0)
vx1  = coordv("x", 1)
vx2  = coordv("x", 2)

vb0  = coordv("b", 0)
vb1  = coordv("b", 1)
vb2  = coordv("b", 2)

Ma = [list: 
  [list: a00, a01, a02],
  [list: a10, a11, a12],
  [list: a20, a21, a22]]

Mb = [list: 
  [list: b00, b01, b02],
  [list: b10, b11, b12],
  [list: b20, b21, b22]]

Mc = [list: 
  [list: c00, c01, c02],
  [list: c10, c11, c12],
  [list: c20, c21, c22]]

Mm = [list: 
  [list: m00, m01, m02],
  [list: m10, m11, m12],
  [list: m20, m21, m22]]

Vx = [list:
  [list:vx0],
  [list:vx1],
  [list:vx2]]

Vb = [list:
  [list:vb0],
  [list:vb1],
  [list:vb2]]

fun Ca(r,c):
  BGR = [list:BG-CLR,BG-CLR,BG-CLR]
  HLR = [list:HL-CLR,HL-CLR,HL-CLR]
  if (c == 0) or (c == 1) or (c == 2):
    if      r == 0: [list: HLR, BGR, BGR]
    else if r == 1: [list: BGR, HLR, BGR]
    else if r == 2: [list: BGR, BGR, HLR]
    else:           [list: BGR, BGR, BGR]
    end
  else:
    [list: BGR, BGR, BGR]
  end
end

fun Cb(r,c):
  row = block:
    if (r == 0) or (r == 1) or (r == 2):
      if      c == 0: [list:HL-CLR,BG-CLR,BG-CLR]
      else if c == 1: [list:BG-CLR,HL-CLR,BG-CLR]
      else if c == 2: [list:BG-CLR,BG-CLR,HL-CLR]
      else:           [list:BG-CLR,BG-CLR,BG-CLR]
      end
    else:
      [list:BG-CLR,BG-CLR,BG-CLR]
    end
  end
    [list: row, row, row]
end

fun Cc(r,c):
  repeat(3, repeat(3, BG-CLR))
end
  
fun box(x, clr):
  overlay-align("center", "center",
    overlay-align("center", "center",
      text(x, TX-SZE,TX-CLR),
      square(SIZE, "outline", BR-CLR)  ),
    square(SIZE, "solid", clr)
    )
end

fun Cx(r,c):
  if ((r == 0) or (r == 1) or (r == 2)) and
    (c == 0):
    repeat(3,[list:HL-CLR])
  else:
    repeat(3,[list:BG-CLR])
  end
end

fun Cv(r,c):
  repeat(3, [list:BG-CLR])
end

fun grid(M,C):
  fold(above,empty-image,
  map2(
    lam(r,rc): 
        fold(beside,empty-image,
          map2(lam(m,c):box(m,c) end, r,rc))  
          end, 
          M,C))
    end

fun draw-matrix(M,C):  
  beside(beside(LT-BRKT, grid(M, C)), RT-BRKT)
end

fun AB-expression(r,c):
  a0 = coord("a", r,0)
  a1 = coord("a", r,1)
  a2 = coord("a", r,2)
  b0 = coord("b", 0,c)
  b1 = coord("b", 1,c)
  b2 = coord("b", 2,c)
  
  term0 = a0 + "\u00B7" + b0
  term1 = a1 + "\u00B7" + b1
  term2 = a2 + "\u00B7" + b2
  
  expr = term0 + " + " + term1 + " + " + term2
  if 
    ((r == 0) or (r == 1) or (r == 2)) and 
    ((c == 0) or (c == 1) or (c == 2)):
    text(expr, SIZE / 3, TX-CLR)
  else:
    text(expr, SIZE / 3, BG-CLR)
  end
end

fun Ax-expression(r,c):
  m0 = coord("m", r,0)
  m1 = coord("m", r,1)
  m2 = coord("m", r,2)
  b0 = coordv("x", 0)
  b1 = coordv("x", 1)
  b2 = coordv("x", 2)
  
  term0 = m0 + "\u00B7" + b0
  term1 = m1 + "\u00B7" + b1
  term2 = m2 + "\u00B7" + b2
  
  expr = term0 + " + " + term1 + " + " + term2
  if 
    ((r == 0) or (r == 1) or (r == 2)) and 
    ((c == 0) or (c == 1) or (c == 2)):
    text(expr, SIZE / 3, TX-CLR)
  else:
    text(expr, SIZE / 3, BG-CLR)
  end
end

fun C-element(r,c):
  if 
    ((r == 0) or (r == 1) or (r == 2)) and 
    ((c == 0) or (c == 1) or (c == 2)):
    text(coord("c", r,c), SIZE / 3, TX-CLR)
  else:
    text(coord("c", r,c), SIZE / 3, BG-CLR)
  end
end

fun b-element(r,c):
  if 
    ((r == 0) or (r == 1) or (r == 2)) and 
    ((c == 0) or (c == 1) or (c == 2)):
    text(coordv("b", r), SIZE / 3, TX-CLR)
  else:
    text(coordv("b", r), SIZE / 3, BG-CLR)
  end
end

fun draw-AB(r,c):
  above(
    beside(beside(
        draw-matrix(Ma, Ca(r,c)),
        overlay(
          circle(SIZE / 15, "solid", "black"), 
          rectangle(SIZE / 2.25, SIZE * 3, "solid", BG-CLR))
        ),
      draw-matrix(Mb, Cb(r,c))
      ),
    overlay(
      AB-expression(r,c),
      rectangle(SIZE * 7, SIZE, "solid", BG-CLR)
      )
    )
end

fun draw-Ax(r,c):
  above(
    beside(beside(
        draw-matrix(Mm, Ca(r,c)),
        overlay(
          circle(SIZE / 15, "solid", "black"), 
          rectangle(SIZE / 2.25, SIZE * 3, "solid", BG-CLR))
        ),
      draw-matrix(Vx, Cx(r,c))
      ),
    overlay(
      Ax-expression(r,c),
      rectangle(SIZE * 5, SIZE, "solid", BG-CLR)
      )
    )
end

fun draw-C(r,c):
  above(
    beside(
      overlay-align("center", "center",
        text("=", SIZE, "black"), 
        rectangle(SIZE * 2, SIZE * 3, "solid", BG-CLR)),
      draw-matrix(Mc,Cc(r,c))
      ),
    beside(
      rectangle(SIZE * 2, SIZE, "solid", BG-CLR),
        overlay(
        C-element(r,c),
          rectangle(SIZE * 3, SIZE, "solid", BG-CLR)
          )
        ))
end

fun draw-b(r,c):
  above(
    beside(
      overlay-align("center", "center",
        text("=", SIZE, "black"), 
        rectangle(SIZE * 2, SIZE * 3, "solid", BG-CLR)),
      draw-matrix(Vb,Cv(r,c))
      ),
    beside(
      rectangle(SIZE * 2, SIZE, "solid", BG-CLR),
        overlay(
        b-element(r,c),
        rectangle(SIZE * 1, SIZE, "solid", BG-CLR)
          )
        ))
end

fun draw-AB-equals-C(state):
  overlay-align("center", "center",
    beside(draw-AB(state.r,state.c), draw-C(state.r,state.c)),
    rectangle(SIZE * 13, SIZE * 5, "solid", BG-CLR)
      )
end

fun draw-Ax-equals-b(state):
  overlay-align("center", "center",
    beside(draw-Ax(state.r,state.c), draw-b(state.r,state.c)),
    rectangle(SIZE * 9, SIZE * 5, "solid", BG-CLR)
      )
end

data RowCol:
    rowcol(r,c)
end

fun update-AB(state, x, y, e):
  c = ask: 
    | x > ((9.65 * SIZE) + (SIZE * 3)) then: 3
    | x > ((9.65 * SIZE) + (SIZE * 2)) then: 2
    | x > ((9.65 * SIZE) + (SIZE * 1)) then: 1
    | x > ((9.65 * SIZE) + (SIZE * 0)) then: 0
    | otherwise: 3
  end
  r = ask: 
    | y > ((1.50 * SIZE) + (SIZE *  2)) then: 3
    | y > ((1.50 * SIZE) + (SIZE *  1)) then: 2
    | y > ((1.50 * SIZE) + (SIZE *  0)) then: 1
    | y > ((1.50 * SIZE) + (SIZE * -1)) then: 0
    | otherwise: 3
  end
  rowcol(r,c)
end

fun update-Ax(state, x, y, e):
  c = ask: 
    | x > ((7.65 * SIZE) + (SIZE * 3)) then: 3
    | x > ((7.65 * SIZE) + (SIZE * 2)) then: 2
    | x > ((7.65 * SIZE) + (SIZE * 1)) then: 1
    | x > ((7.65 * SIZE) + (SIZE * 0)) then: 0
    | otherwise: 3
  end
  r = ask: 
    | y > ((1.50 * SIZE) + (SIZE *  2)) then: 3
    | y > ((1.50 * SIZE) + (SIZE *  1)) then: 2
    | y > ((1.50 * SIZE) + (SIZE *  0)) then: 1
    | y > ((1.50 * SIZE) + (SIZE * -1)) then: 0
    | otherwise: 3
  end
  rowcol(r,c)
end

AB-equals-C = reactor:
  init: rowcol(3,3),
  on-mouse: update-AB,
  to-draw: draw-AB-equals-C
end

Mx-equals-b = reactor:
  init: rowcol(3,3),
  on-mouse: update-Ax,
  to-draw: draw-Ax-equals-b
end

# x: 9.62
# y: 1.5


matrix-demo = interact




