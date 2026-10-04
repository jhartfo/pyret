use context starter2024


#########################################

# list-fold-XX :: (A -> B), A, List<A> -> B

# Here, we first combine the first element with the base 
# element, then accumulating to the left.
#
# elt-n + ... + elt-1 + elt-0 + base
#
fun list-fold-l1(f, x, lst):
  if lst == empty: x
  else:
    list-fold-l1(f, f(lst.first, x), lst.rest)
  end
end

# Here, we first combine the first element with the base 
# element, then accumulating to the right
# (because the acc'd value is now on the left of the 
# next element, note this can also be accomplished by swapping
# the elements in the given function --- compare plus-1 
# and plus-2, below)
#
# base + elt-0 + elt-1 + ... + elt-n
#
fun list-fold-l2(f, x, lst):
  if lst == empty: x
  else:
    list-fold-l2(f, f(x, lst.first), lst.rest)
  end
end

# Here, the first element is combined with the 
# results of fold-ing the rest of the list
# until we finally get down the to the final element 
# and then the base element. We accumulate to right
# since the acc'd value is on the left.
#
# elt-0 + elt-1 + ... + elt-n + base
#
fun list-fold-r1(f, x, lst):
  if lst == empty: x
  else:
    f(lst.first, list-fold-r1(f, x, lst.rest))
  end
end

# Here we accumulate just like with list-fold-r1
# but now the acc'd value is on the right; so,
# we will accumulate to the left. (Note this can
# be accomplished by swapping the elements in the 
# given function --- compare plus-1 and plus-2, below.)
#
# base + elt-n + ... + elt-1 + elt-0
#
fun list-fold-r2(f, x, lst):
  if lst == empty: x
  else:
    f(list-fold-r2(f, x, lst.rest), lst.first)
  end
end

#########################################

lst = [list: "a", "b", "c", "d"]

# plus-1 :: String, String -> String
# plus-2 :: String, String -> String
fun plus-1(a,b): a + b end
fun plus-2(a,b): b + a end

#########################################
#
# display some examples
fun skip(n)        : square(n, "solid","transparent") end
fun disp(clr, txt) : text(txt, 20, clr) end  


# the input function using underscore notation
beside(  
  disp("magenta", "list-fold-l1 w/ _ + _ :  " ),
  disp("black"   , 
    list-fold-l1(_ + _, ".", lst) 
    )  
  )
beside(
  disp("magenta", "list-fold-r1 w/ _ + _ :  " ),
  disp("black"   , 
    list-fold-r1(_ + _, ".", lst) 
    )
  )
beside(
  disp("magenta", "list-fold-l2 w/ _ + _ :  " ),
  disp("black"   , 
    list-fold-l2(_ + _, ".", lst) 
    )
  )
beside(
  disp("magenta", "list-fold-r2 w/ _ + _ :  " ),
  disp("black"   , 
    list-fold-r2(_ + _, ".", lst) 
    )
  )

skip(40)

# using the pre-defined plus-1
# this is equivalent to the underscore anonymous function
beside(
  disp("magenta", "list-fold-l1 w/ plus-1 :  "),
  disp("black"   , 
    list-fold-l1(plus-1, ".", lst) 
    )
  )
beside(
  disp("magenta", "list-fold-r1 w/ plus-1 :  "),
  disp("black"   , 
    list-fold-r1(plus-1, ".", lst) 
    )
  )
beside(
  disp("magenta", "list-fold-l2 w/ plus-1 :  "),
  disp("black"   , 
    list-fold-l2(plus-1, ".", lst) 
    )
  )
beside(
  disp("magenta", "list-fold-r2 w/ plus-1 :  "),
  disp("black"   , 
    list-fold-r2(plus-1, ".", lst) 
    )
  )

skip(40)

# using the pre-defined plus-2
# see how the following configurations are equivalent:
check:
  list-fold-l1(plus-1, ".", lst) is list-fold-l2(plus-2, ".", lst)
  list-fold-l2(plus-1, ".", lst) is list-fold-l1(plus-2, ".", lst)
  list-fold-r1(plus-1, ".", lst) is list-fold-r2(plus-2, ".", lst)
  list-fold-r2(plus-1, ".", lst) is list-fold-r1(plus-2, ".", lst)
end

beside(
  disp("magenta", "list-fold-l1 w/ plus-2 :  "),
  disp("black"   , 
    list-fold-l1(plus-2, ".", lst) 
    )
  )
beside(
  disp("magenta", "list-fold-r1 w/ plus-2 :  "),
  disp("black"   , 
    list-fold-r1(plus-2, ".", lst) 
    )
  )
beside(
  disp("magenta", "list-fold-l2 w/ plus-2 :  "),
  disp("black"   , 
    list-fold-l2(plus-2, ".", lst) 
    )
  )
beside(
  disp("magenta", "list-fold-r2 w/ plus-2 :  "),
  disp("black"   , 
    list-fold-r2(plus-2, ".", lst) 
    )
  )

skip(40)

# using pyret's built-in functions
# and plus-1
beside(
  disp("magenta", "Pyret's fold w/ plus-1 :  "),
  disp("black"   , 
    fold(plus-1, ".", lst) 
    )
  )

skip(0)

beside(
  disp("magenta", "Pyret's foldl w/ plus-1 :  "),
  disp("black"   , 
    foldl(plus-1, ".", lst) 
    )
  )
beside(
  disp("magenta", "Pyret's foldr w/ plus-1 :  "),
  disp("black"   , 
    foldr(plus-1, ".", lst) 
    )
  )

# While it would make sense, from 
# a human point of view, to define:
# foldl as the function that would produce "dcba." and
# foldr as the function that would produce ".abcd", 
# the above examples show us that this 
# effect can be achieved simply by 
# rearranging the arguments in the function
# that is passed to fold-X. So instead, Pyret has 
# chosen to define foldl as stated above and 
# foldr as the function that will produce "abcd."

# So now, we can accomplish all four outputs 
# with Pyret's two built-in fold functions,
# if we are able to modify the arguments
# in the passed function, as in plus-1 and
# plus-2.
beside(
  disp("magenta", "Pyret's foldl w/ plus-2 :  "),
  disp("black"   , 
    foldl(plus-2, ".", lst) 
    )
  )
beside(
  disp("magenta", "Pyret's foldr w/ plus-2 :  "),
  disp("black"   , 
    foldr(plus-2, ".", lst) 
    )
  )


