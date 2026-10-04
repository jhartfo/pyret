use context starter2024


include reactors

TX-CLR = "black"
BG-CLR = "ivory"
BR-CLR = "antique-white"
HL-CLR = "cornflower blue"
SIZE    = 80
TX-SZE  = SIZE / 2


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
  left-bracket = 
    beside(
      rectangle(0.1 * SIZE, 3 * SIZE, "solid", TX-CLR),
      overlay-align("center", "center",
        rectangle(0.1 * SIZE, 2.8 * SIZE, "solid", BG-CLR),  
        rectangle(0.1 * SIZE, 3 * SIZE, "solid", TX-CLR)
        )
      )
  
  right-bracket = flip-horizontal(left-bracket)
  
  beside(beside(left-bracket, grid(M, C)),right-bracket)
end

fun expression(r,c):
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

fun c-element(r,c):
  if 
    ((r == 0) or (r == 1) or (r == 2)) and 
    ((c == 0) or (c == 1) or (c == 2)):
    text(coord("c", r,c), SIZE / 3, TX-CLR)
  else:
    text(coord("c", r,c), SIZE / 3, BG-CLR)
  end
end

fun LHS(r,c):
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
      expression(r,c),
      rectangle(SIZE * 7, SIZE, "solid", BG-CLR)
      )
    )
end

fun RHS(r,c):
  above(
    beside(
      overlay(
        text("=", SIZE, "black"), 
        rectangle(SIZE * 2, SIZE * 3, "solid", BG-CLR)),
      draw-matrix(Mc,Cc(r,c))
      ),
    beside(
      rectangle(SIZE * 2, SIZE, "solid", BG-CLR),
        overlay(
          c-element(r,c),
          rectangle(SIZE * 3, SIZE, "solid", BG-CLR)
          )
        ))
end

fun draw-scene(state):
  overlay-align("center", "center",
    beside(LHS(state.r,state.c), RHS(state.r,state.c)),
    rectangle(SIZE * 13, SIZE * 5, "solid", BG-CLR)
      )
end

data RowCol:
    rowcol(r,c)
end

fun update(state, x, y, e):
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

matrix-demo = reactor:
  init: rowcol(3,3),
  on-mouse: update,
  to-draw: draw-scene
end


# x: 9.62
# y: 1.5


interact(matrix-demo)
