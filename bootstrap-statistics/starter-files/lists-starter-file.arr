use context url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/core-bss.arr")

# in Pyret, Lists are an ordered container that holds 
# information from other data types
[list: 1, true, "dog", circle(10, "solid", "red" ), -1, num-sqrt(2), 17/23]

######################################
# A few pre-define images
rc = overlay(circle(50, "outline", "black"),circle(50, "solid", "red"))
wc = overlay(circle(50, "outline", "black"),circle(50, "solid", "white"))
bc = overlay(circle(50, "outline", "black"),circle(50, "solid", "blue"))
rr = rectangle(300, 10, "solid", "red")
wr = rectangle(300, 10, "solid", "white")
br = rectangle(300, 10, "solid", "blue")

######################################
# These functions consume a Number in degrees 
# Fahrenheit or Celsius and produces the Number converted to 
# the other temperature scale

# c-to-f :: Number -> Number 
fun f-to-c(f): 5/9 * (f - 32) end # Fahrenheit to Celsius
# f-to-c :: Number -> Number
fun c-to-f(c): (9/5 * c) + 32 end # Celsius to Fahrenheit

######################################
# Below we have defined a few example lists defined

list-0 = empty
list-1 = [list: 0, 1, 2, 3, 4, 5]
list-2 = [list: 1, 2, 3, 4, 5, 6]
list-3 = [list: 3, 1, 4, 1, 5, 9, 2]
list-4 = [list: -0.2, 0.7, -0.1, 0.8, -0.2, 0.8, -0.1, 0.8]
list-5 = [list: "black", "white", "red", "orange", "yellow", "green", "blue", "indigo", "violet"]
list-6 = [list: "'Strive ",  "not ", "to ", "be ", "a ", "success, ", "but ", "rather ", "to ", "be ", "of ", "value.' ", "-", "Albert ", "Einstein"]
list-7 = [list: true, false, true, true, false, true, true]
list-8 = [list: rc, wc, bc]
list-9 = [list: rr, wr, rr, wr, rr, wr, rr, wr, rr, wr, rr, wr, rr]
list-d = [list: 0, 100, 32, 212]





