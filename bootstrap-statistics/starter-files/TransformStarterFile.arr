use context shared-gdrive("BSS-2 (v1.0).arr", "1Tya-CLogHw8oiT8BAfDBFyppo1qsCtG5")


fun add5(x): 
  x + 5
end

fun divideby100(x):
  x / 100
end

fun CtoF(d):
  (5/9) * (d - 32)
end

fun FtoC(d):
  ((9/5) * d) + 32
end

scores = [list: 
  79,81,80,77,73,83,74,93,78,80,75,67,73,
  77,83,86,90,79,85,83,89,84,82,77,72]

ages = [list: 
  10, 16, 14, 15, 20, 31, 32]

temps-in-F = [list: 
  12,17,21,25,29,31,32,32,34,35,35,36,36,37,37,
  37,38,38,38,38,40,40,41,42,43,44,45,45,45,48]

ages
map(add5, ages)


# simple arithemetic model
# pyret allows us to create functions that involve one operator on the fly
# the can be achieved by placing blanks (or underscores "_" where the numbers go

# if we needed to define a function by x + 5, we could simply type "_ + 5"






