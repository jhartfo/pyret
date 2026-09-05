use context starter2024
provide *

include gdrive-sheets

import starter2024 as Starter 
provide from Starter: *,
  type * ,
  data *
end
import lists as L
provide from L: *,
  type * ,
  data *
end

############################################
# Some Constants: 

BG-CLR = "ivory"
KO-CLR = "red"
WN-CLR = "dark green"

############################################
# these functions will draw our hangman 
# and the gallows

# the general philosophy is all elements 
# are always present, they are just 'transparent'
# until the they are needed

fun gallows(clr):
  put-image(
    put-image(
      overlay-align("left", "top",
        rectangle(10,30, "solid", "black"), 
        rectangle(50,10, "solid", "black")), 
      80, 185,
      overlay-align("center", "bottom",
        rectangle(200, 10, "solid", "black"),
        rectangle(10, 200, "solid", "black")
        )), 140,100,
    rectangle(600,200, "solid", clr)  
  )
end


head :: String -> Image
fun head(clr):
  overlay-align("center", "bottom",
    rectangle(10,3, "solid", clr),
    ellipse(20,35, "solid", clr)
    )
end

body :: String -> Image
fun body(clr):
  point-polygon(
    [list: 
      point( 10,  0), point(  0, 50),
      point( 20, 50), point( 20, 52), 
      point( 30, 52), point( 30, 50),
      point( 50, 50), point( 40,  0), 
      point( 40,-10), point(10,-10) 
    ],
    "solid", clr)
end

leg :: String -> Image
fun leg(clr): 
  rectangle(10, 60, "solid", clr) 
end

left-arm :: String -> Image
fun left-arm(clr):
  rotate(-10, rectangle(10, 50, "solid", clr))
end

right-arm :: String -> Image
fun right-arm(clr):
  rotate(10, rectangle(10, 50, "solid", clr))
end

fun man(clr): 
  put-image(
    leg(clr.l-leg), 40, 31, put-image(
      leg(clr.r-leg), 60, 31, put-image(
        right-arm(clr.r-arm), 75, 95, put-image(
          left-arm(clr.l-arm), 25, 95, put-image(
            above(head(clr.head), body(clr.body)), 50,110,
            rectangle(100,160, "solid", "transparent"))))))
end

data Hangman:
    hangman(
      status :: Number,
      head   :: String,
      body   :: String,
      l-arm  :: String,
      l-leg  :: String,
      r-arm  :: String,
      r-leg  :: String
      ) with:
    method display(self):
      man(self) 
    end,
    method advance(self):
      ask :
        | self.status == 0 then: build-hangman(1)
        | self.status == 1 then: build-hangman(2)
        | self.status == 2 then: build-hangman(3)
        | self.status == 3 then: build-hangman(4)
        | self.status == 4 then: build-hangman(5)
        | self.status == 5 then: build-hangman(6)
        | otherwise: self
      end
    end
end

fun list-to-hangman(lst):
  if length(lst) == 7:
    hangman(
      lst.get(0), lst.get(1), lst.get(2), lst.get(3), 
      lst.get(4), lst.get(5), lst.get(6))
  else:
    raise("Hangman has 7 properties")
  end
end

fun build-hangman(n):
  list-to-hangman(
    [list: n] + repeat(n, "black") + repeat(6 - n, "transparent"))
end
  
hangman-0 = build-hangman(0)
hangman-1 = build-hangman(1)
hangman-2 = build-hangman(2)
hangman-3 = build-hangman(3)
hangman-4 = build-hangman(4)
hangman-5 = build-hangman(5)
hangman-6 = build-hangman(6)

############################################
# Table of 3000 words and a list of letters
# from https:

sheet = load-spreadsheet("1qn8OD6qr_DFva2sY3p03NI2l2ZjuzuiuUxBBedrMMns")
table = load-table: word
  source: sheet.sheet-by-name("Sheet1", false)
end
  .build-column("characters", lam(r): 
    string-explode(string-toupper(r["word"])) 
  end)
  .build-column("length", lam(r): string-length(r["word"]) end )

fun view-used-letter(ltr, clr):
  beside(
    overlay-align("center", "center",
      text(ltr, 15, "black"),
      rectangle(20,20, "solid", clr)
      ),
    rectangle(3, 20, "solid", "transparent")
    )
end

fun view-word-letter(ltr, clr):
  beside(
    overlay-align("center", "center",
      text(ltr, 28, clr),
      overlay-align("center", "bottom",
        rectangle(30, 2, "solid", "black"),
        rectangle(33,30, "solid", "white"))),
    rectangle(2, 30, "solid", "transparent")
    )
end


