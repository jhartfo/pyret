provide *
include shared-gdrive("being.arr", "124XBkYK4VLORa9v98QW_z39NumY1fnM4")

include image




data Posn:
  | posn(x :: Number, y :: Number) 
end

data Being:
  | being(
      posn    :: Posn, 
      costume :: Image,
      special 
      ) 
end


init = posn(0,1)
danger  = being(init,     triangle(50, "solid", "blue"), 0)
danger2 = being(posn(0,0),triangle(50, "solid", "blue"), 0)


