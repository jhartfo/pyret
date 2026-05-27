use context starter2024

reverse-put-image = lam(bs,x,y,im): put-image(im,x,y,bs) end

die-color = "black"
pip-color = "orange"

## Building Standard Die

em    = empty-image                      # represents a missing pip
pip   = circle( 5, "solid", pip-color)   # a pip
ems   = lam(x): repeat(x,em ) end        # list of missing pips
pips  = lam(x): repeat(x,pip) end        # list of pips

face  = point-polygon([list:             # beveled square to 
    point( 5.0, 0.0),                    # represent 1 die
    point( 3.0, 0.5),  
    point( 1.5, 1.5),
    point( 0.5, 3.0),
    point( 0.0, 5.0),
    point( 0.0,45.0),
    point( 0.5,47.0),
    point( 1.5,48.5),
    point( 3.5,49.5),
    point( 5.0,50.0),
    point(45.0,50.0),
    point(47.0,49.5),
    point(48.5,48.5),
    point(49.5,47.0),
    point(50.0,45.0),
    point(50.0, 5.0),
    point(49.5, 3.0),
    point(48.5, 1.5),
    point(47.0, 0.5),  
    point(45.0, 0.0),
  ],
  "solid", die-color)

# there are 9 different available positions we can place pips
# with the following coordinates
pipX  = [list: 10,25,40,10,25,40,10,25,40]
pipY  = [list: 10,10,10,25,25,25,40,40,40]

# are the lists of pips/missing pips for each dice value
pips1 = ems(4)  + pips(1) + ems(4)
pips2 = pips(1) + ems(7)  + pips(1)
pips3 = pips(1) + ems(3) + pips(1) + ems(3) + pips(1)
pips4 = pips(1) + ems(1) + pips(1) + ems(3) + pips(1) + ems(1) + pips(1)
pips5 = fold(append,pips(1), repeat(4, ems(1) + pips(1)))
pips6 = fold(append,[list:],repeat(3,pips(1) + ems(1) + pips(1)))
pips7 = pips(1) + ems(1) + pips(5) + ems(1) + pips(1)
pips8 = pips(4) + ems(1) + pips(4)
pips9 = pips(9)

# with all the building blocks, we can build our dice
d-one = fold3(reverse-put-image,face, pipX,pipY,pips1)
d-two = fold3(reverse-put-image,face, pipX,pipY,pips2)
d-thr = fold3(reverse-put-image,face, pipX,pipY,pips3)
d-fou = fold3(reverse-put-image,face, pipX,pipY,pips4)
d-fiv = fold3(reverse-put-image,face, pipX,pipY,pips5)
d-six = fold3(reverse-put-image,face, pipX,pipY,pips6)
d-sev = fold3(reverse-put-image,face, pipX,pipY,pips7)
d-eig = fold3(reverse-put-image,face, pipX,pipY,pips8)
d-nin = fold3(reverse-put-image,face, pipX,pipY,pips9)

# a function to build the any dice face
fun build-dice(x):
  ask:
    | (x == 1) then: d-one
    | (x == 2) then: d-two
    | (x == 3) then: d-thr
    | (x == 4) then: d-fou
    | (x == 5) then: d-fiv
    | (x == 6) then: d-six
    | (x == 7) then: d-sev
    | (x == 8) then: d-eig
    | (x == 9) then: d-nin
  end
end


## Building Standard Die

spip  = ellipse(9,13,"solid", pip-color) # a skewed pip
spips = lam(x): repeat(x,spip) end       # list of pips

skew  = point-polygon([list:             # a skewed shape to 
    point( 5.0, 0.0),                    # represent 1 die
    point( 3.0, 0.5),  
    point( 1.5, 1.5),
    point( 0.5, 3.0),
    point( 0.0, 5.0),
    point( 0.0,65.0),
    point( 0.5,67.0),
    point( 1.5,68.5),
    point( 3.5,69.5),
    point( 5.0,70.0),
    point(60.0,50.0),
    point(62.0,49.5),
    point(63.5,48.5),
    point(64.5,47.0),
    point(65.0,45.0),
    point(50.0, 5.0),
    point(49.5, 3.0),
    point(48.5, 1.5),
    point(47.0, 0.5),  
    point(45.0, 0.0),
  ],
  "solid", die-color)

# there are 9 different available positions we can place pips
# with the following coordinates
spipX = [list: 10,25,40,10,27,45,10,30,50]
spipY = [list: 10,10,10,32,28,25,55,47,40]

# are the lists of pips/missing pips for each dice value
spips1= ems(4)  + spips(1) + ems(4)
spips2= spips(1) + ems(7)  + spips(1)
spips3= spips(1) + ems(3) + spips(1) + ems(3) + spips(1)
spips4= spips(1) + ems(1) + spips(1) + ems(3) + spips(1) + ems(1) + spips(1)
spips5= fold(append,spips(1), repeat(4, ems(1) + spips(1)))
spips6= fold(append,[list:],repeat(3,spips(1) + ems(1) + spips(1)))
spips7= spips(1) + ems(1) + spips(5) + ems(1) + spips(1)
spips8= spips(4) + ems(1) + spips(4)
spips9= spips(9)

# with all the building blocks, we can build our dice
s-one = fold3(reverse-put-image,skew, spipX,spipY,spips1)
s-two = fold3(reverse-put-image,skew, spipX,spipY,spips2)
s-thr = fold3(reverse-put-image,skew, spipX,spipY,spips3)
s-fou = fold3(reverse-put-image,skew, spipX,spipY,spips4)
s-fiv = fold3(reverse-put-image,skew, spipX,spipY,spips5)
s-six = fold3(reverse-put-image,skew, spipX,spipY,spips6)
s-sev = fold3(reverse-put-image,skew, spipX,spipY,spips7)
s-eig = fold3(reverse-put-image,skew, spipX,spipY,spips8)
s-nin = fold3(reverse-put-image,skew, spipX,spipY,spips9)

# a function to build the any dice face
fun build-skew-dice(x):
  ask:
    | (x == 1) then: s-one
    | (x == 2) then: s-two
    | (x == 3) then: s-thr
    | (x == 4) then: s-fou
    | (x == 5) then: s-fiv
    | (x == 6) then: s-six
    | (x == 7) then: s-sev
    | (x == 8) then: s-eig
    | (x == 9) then: s-nin
  end
end

###############################################

# new class that allows us to store a die's image and value
data Dice:
    die(value :: Number) with:
    method image(self): build-dice(self.value) end 
end


# roll a single dice resulting in a random Dice instance, 
# rotated randomly
# n is a dumby variable
#|
fun single(n):
  r = num-random(6)
  d = num-random(4)
  if      r == 0: rotate(d * 90, d-one)
  else if r == 1: rotate(d * 90, d-two)
  else if r == 2: rotate(d * 90, d-thr)
  else if r == 3: rotate(d * 90, d-fou)
  else if r == 4: rotate(d * 90, d-fiv)
  else:           rotate(d * 90, d-six)
  end
end
|#

fun single(n):
  r = num-random(6)
  die(r + 1)
end

# creates a roll of n dice
fun roll(n):
  map(single, range(0,n))
end
  
fun show-roll(a-roll):
  map(lam(X): X.image() end,a-roll)
end
  
fun roll-sum(a-roll):
  fold(_ + _, 0, (map(lam(x): x.value end, a-roll)))
end

  
# what follows is some yahtzee controls
# and a single round generating a Full House
fun keep(dice, lst):
  map(lam(x): dice.get(x) end, lst)
end

fun toss-out(dice, lst):
  n = length(dice)
  keep-list = filter(lam(x): not(lst.member(x)) end, range(0,n) )
  map(lam(x): dice.get(x) end, keep-list)
end

var hand = [list:]
var r1 = [list:]
var r2 = [list:]
var r3 = [list:]
  
num-random-seed(20)  

r1 := roll(5)
show-roll(r1)
hand := hand.append(toss-out(r1,[list:2,3]))
show-roll(hand)

r2 := roll(3)
show-roll(r2)
hand := hand.append(toss-out(r2,[list:0,1]))
show-roll(hand)

r3 := roll(1)
show-roll(r3)

hand := hand.append(toss-out(r3,[list:]))
show-roll(hand)

roll-sum(hand)
roll-sum(r1)
