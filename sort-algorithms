use context starter2024

include timing #used for testing at the end

#################################################
#
# SORT ALGORITHMS
#

# These functions should be considered prototypical;
# there is little in the way of error handling.
#
# Additionally, these functions have only been 
# verified on homogenious Lists containing  
# Exactnums (not irrational values).
#
# These functions are intended to work without any 
# dependency other than what is standard within 
# context starter2024 and without use of other Pyret
# feature like lambda functions, underscore notation,
# structurd data, and dot notation. Mutable values
# have also been avoided.
#
# An easy optimization would be to explore 
# the link-list properties and replace many
# of the get and drop expressions with .first
# and .rest

#################################################
#
# BOOLEAN FUNCTION 
# provided for an example block, below
#

less-than-3 :: Number -> Boolean
# consumes a Number and compares it to 3. If the 
# Number is less than 3 
# return true, otherwise return false
examples "less-than-3": 
  less-than-3(-10000) is true
  less-than-3( 10000) is false
  less-than-3(     3) is false
end
fun less-than-3(x): x < 3 end
  
######################################################
#
# UTILITY FUNCITONS
# needed to execute the below sort algorithms
#

# The list-filter, list-min, list-max functions, 
# their examples, and definitions are taken 
# directly from dcic-world.org. 
# In particular:
# <https://dcic-world.org/2025-08-27/processing-lists.html> 
#


list-filter :: (Any -> Boolean), List  -> List
# consumes a List and a Function with a Boolean Range. 
# Recursively, we check if each element returns true 
# when applied the Function is applied. If it does not, 
# the element is removed from the new outputed List.
examples "list-filter":
  list-filter(less-than-3, [list: 3,1,4,1,5,9,2,6]) is [list: 1,1,2]

  list-filter(less-than-3, [list:])     is empty 
  list-filter(less-than-3, [list: 3])   is empty
  list-filter(less-than-3, [list: 2])   is [list: 2]
  
  list-filter(less-than-3, [list: 2,3]) is 
  link(2, list-filter(less-than-3, drop(1,[list:2,3])))
  list-filter(less-than-3, [list: 3,2]) is 
  list-filter(less-than-3, drop(1,[list:3,2]))
end
fun list-filter(fn, lst):
  
  # base cases
  if lst == empty: empty
    
  # recursive algorithm
  else if fn(get(lst,0)):
    link(get(lst,0), list-filter(fn, drop(1,lst)))  
  else:
    list-filter(fn, drop(1,lst))
  end
end

list-min :: List -> Any
# consumes a list and returns the largest 
# element as compared using "<"
examples "list-min":
  list-min([list: 2, 1, 4, 3, 2]) is 1
  list-min([list:    1, 4, 3, 2]) is 1
  list-min([list:       4, 3, 2]) is 2
  list-min([list:          3, 2]) is 2
  list-min([list:             2]) is 2
  
  list-min([list: 2, 1, 4, 3, 2]) is num-min(2, list-min([list: 1, 4, 3, 2]))
  list-min([list:    1, 4, 3, 2]) is num-min(1, list-min([list:    4, 3, 2]))
  list-min([list:       4, 3, 2]) is num-min(4, list-min([list:       3, 2]))
  list-min([list:          3, 2]) is num-min(3, list-min([list:          2]))
end
fun list-min(lst):
  if drop(1,lst) == empty:
    get(lst,0)
  else:
    num-min(get(lst,0), list-min(drop(1,lst)))
  end
end

list-max :: List -> Any
# consumes a list and returns the largest 
# element as compared using ">"
examples "list-max":
  list-max([list: 2, 1, 4, 3, 2]) is 4
  list-max([list:    1, 4, 3, 2]) is 4
  list-max([list:       4, 3, 2]) is 4
  list-max([list:          3, 2]) is 3
  list-max([list:             2]) is 2
  
  list-max([list: 2, 1, 4, 3, 2]) is num-max(2, list-max([list: 1, 4, 3, 2]))
  list-max([list:    1, 4, 3, 2]) is num-max(1, list-max([list:    4, 3, 2]))
  list-max([list:       4, 3, 2]) is num-max(4, list-max([list:       3, 2]))
  list-max([list:          3, 2]) is num-max(3, list-max([list:          2]))
end
fun list-max(lst):
  if drop(1,lst) == empty:
    get(lst,0)
  else:
    num-max(get(lst,0), list-max(drop(1,lst)))
  end
end

short-sort :: List -> List
# consumes a List. If the List is empty or has a single elemnet
# the function produces the original list. If there are two
# elements, the function will return the first two elements sorted. NOTE:
# this function is intentded for elements of 0, 1, or 2.
# However, there is no validity check. So, if the List has more than 
# elements the poduced list wil only have the first two 
# elements, all other elements will be dropped.
# 
# intended to only sort a list of 2 or fewer elements 
examples "short-sort": 
  short-sort(empty)           is [list: ]
  short-sort([list: 1])       is [list:1]
  short-sort([list: 2, 1])    is [list: 1,2]
  short-sort([list: 1, 2])    is [list: 1,2]
  short-sort([list: 3,2,1,4]) is [list: 2,3]
end
fun short-sort(lst):
  if length(lst) < 2: lst
  else:
    a = get(lst,0)
    b = get(lst,1)
    if a < b: [list: a,b]
    else: [list:b,a]
    end
  end
end

three-way-split :: List, Any -> List<List>
# consumes a homogeneous List and a single Element
# and produces a List of three Lists: 
# a List of Elements    less than the Element,
# a List of Elements     equal to the Element, and
# a List of Elements greater than the Element.
examples "three-way-split":
  three-way-split([list:2,4,6],0) is [list: [list:     ], [list: ],[list:2,4,6]]
  three-way-split([list:2,4,6],2) is [list: [list:     ], [list:2],[list:  4,6]]
  three-way-split([list:2,4,6],3) is [list: [list:    2], [list: ],[list:  4,6]]
  three-way-split([list:2,4,6],4) is [list: [list:    2], [list:4],[list:    6]]
  three-way-split([list:2,4,6],5) is [list: [list:  2,4], [list: ],[list:    6]]
  three-way-split([list:2,4,6],6) is [list: [list:  2,4], [list:6],[list:     ]]
  three-way-split([list:2,4,6],8) is [list: [list:2,4,6], [list: ],[list:     ]]
  three-way-split([list:     ],0) is [list: [list:     ], [list: ],[list:     ]]
end
fun three-way-split(lst, v):
  fun less-than(x)   : x  < v end
  fun equal-to(x)    : x == v end
  fun greater-than(x): x  > v end
  head = list-filter(less-than   , lst)
  cntr = list-filter(equal-to    , lst)
  tail = list-filter(greater-than, lst)
  [list: head, cntr, tail]
end

######################################################
#
# PSEUDO-BUBBLE SORT
#

# pseudo-bubble-sort :: List -> List
# A true bubble swaps pairs of elements 
# until the smallest elements slowly shift 
# towards head of the list and the largests 
# elements slowly shift towards the tail.
# Here, we recursively gather up the miniumum 
# elements and move them to the front of the line
# all at once.

# since we are gathering all of the least elements at once,
# this is ultimately faster than the true bubble-sort.

# A true bubble-sort would require swapping elements 
# in place. This would further require mutable lists, 
# which we have chosen to avoid. 
examples "pseudo-bubble-sort":
  pseudo-bubble-sort([list:3,2,1,4]) is append([list:1],pseudo-bubble-sort([list:3,2,4])) 
  pseudo-bubble-sort([list:3,2,4])   is append([list:2],pseudo-bubble-sort([list:3,4]))  
  pseudo-bubble-sort([list:3,4])     is append([list:3],pseudo-bubble-sort([list:4]))   
  pseudo-bubble-sort([list:4])       is append([list:4],pseudo-bubble-sort([list:]))   
  pseudo-bubble-sort([list:])        is [list:]
end
fun pseudo-bubble-sort(lst):
  # base case
  if length(lst) < 1: empty
  
  # recursive algorithm
  else:
    fun equal-to(x) : x == list-min(lst) end
    fun not-equal(x): x <> list-min(lst) end
    head = list-filter(equal-to , lst)
    tail = list-filter(not-equal, lst)
    
    #| 
       using this method can cut the sort time in
       almost a half.
       
    p = partition(equal-to, lst)
    head = p.is-true
    tail = p.is-false
    |#
    head.append(pseudo-bubble-sort(tail))
  end
end

######################################################
#
# INSERTION SORT
#

insert-one :: List, Any -> List
# consumes a pre-sorted least-to-greatest List and a value,
# and produces a new List with the value inserted into the 
# appropriate position within the new List
examples "insert-one":  
  insert-one([list: 1,2,3], -1 ) is link(-1, [list: 1,2,3])
  insert-one([list: 1,2,3], 1.5) is link(1,link(1.5,[list: 2,3]))
  insert-one([list: 1,2,3], 2  ) is link(1,link(2,link(2, [list: 3])))
  insert-one([list: 1,2,3], 3  ) is link(1,link(2,link(3, link(3,[list: ]))))
  insert-one([list: 1,2,3], 4  ) is link(1,link(2,link(3, link(4, [list: ]))))
end
fun insert-one(lst, value):
  # base case
  if length(lst) < 2:
    short-sort(push(lst, value))
    
  # recurvise algorithm
  else if (get(lst,0) > value): 
    link(value, lst)
  else:
    link(get(lst,0), insert-one(drop(1,lst), value))
  end
end

insertion-sort :: List -> List
# consumes a List and produces the List sorted,
# using the insertion algorithm. This implemented by  
# starting with an empty List and the original List
# Using the fold function each element of the original 
# List is inserted into the new List using the 
# above insert-one function.
examples "insertion-sort" :
  insertion-sort([list: ])        is empty
  insertion-sort([list: 1])       is [list: 1]
  insertion-sort([list: 2, 1])    is [list: 1,2]
  insertion-sort([list: 3, 2, 1]) is [list: 1,2,3]
end
fun insertion-sort(lst):
  fold(insert-one, empty, lst)
end

######################################################
#
# QUICK SORT
#

quick-sort :: List -> List
# consumes a list and using the Quick Sort Algoithm,
# we recursively produce the sorted list. Elements need to 
# be homogenious and of a datatype that supports boolean
# operatos (< , > , == ). Quick support requires the 
# identification of a pivot element. In the function the 
# location of this pivot is identified as the value pos. 
# We can always choose the first element, last element,
# pick an element at random, or any other selction scheme. 
examples " quick-sort":
  # assuming pos = 0
  quick-sort([list: 1])       is [list:1]
  quick-sort(empty)           is [list: ]
  quick-sort([list: 3,2,1,4]) is 
  append(quick-sort([list:2,1]), append([list:3],quick-sort([list:4])))
  
end
fun quick-sort(lst):
  # possible pivot schemes
  #pos = 0                                 # always pick first element
  #pos = num-floor((length(lst) - 1) / 2)  # always pick the semi-center element
  #pos = length(lst) - 1                   # always pick last element
  pos = num-random(length(lst) - 1)       # pick a random element
  
  # base case
  if length(lst) < 2: 
    lst
  # recursive algorithm
  else:
    pivot     = get(lst, pos)
    sub-lists = three-way-split(lst, pivot)
    head      = get(sub-lists, 0)
    cntr      = get(sub-lists, 1)
    tail      = get(sub-lists, 2)
    append(quick-sort(head), append(cntr, quick-sort(tail)))
  end
end

######################################################
#
# MERGE SORT
#

drop-and-append :: List, List -> List
# consumes two pre-sorted Lists and produces a new List by
# recursively comparing the first element in each List. The
# minimum value is removed from its respective List and added to 
# the new List
examples "drop-and-append":
  drop-and-append(empty, empty)             is empty
  drop-and-append([list: 1], empty)         is link(1, empty)
  drop-and-append(empty, [list: 1])         is link(1, empty)
  drop-and-append(empty, [list: 1,2])       is link(1, link(2, empty))
  drop-and-append([list: 1,3], [list: 2,4]) is 
  link(1, link(2, link(3, link(4, empty))))
  
  drop-and-append([list: 1,3], [list: 2,4]) is 
  link(1, drop-and-append([list: 3],[list: 2,4]))
end

fun drop-and-append(A,B):
  
  # base case, the case where there is no elements to compare at all
  if (A == empty) and (B == empty):
    empty
    
  # recursive algorithm, 
  # we first handle the case where there is no first element 
  # in one of the lists to compare.
  #
  # We add the smallest available element and drop it from
  # the feeder List. Finally, we call the the function 
  # again with the remaining elements in A and B to find
  # the next element.
  else if (B == empty):
    link( get(A,0) , drop-and-append( drop(1,A), B ) )
  
  else if (A == empty):
    link( get(B,0) , drop-and-append( A, drop(1,B) ) )
  
  # now we know both Lists have a first element
  # so we compare them, and add the smaller value, drop it
  # from the feeder List, and finally call the function again 
  # with the remaining elements to find the next element.
  else if (get(A,0) < get(B,0)):
      link( get(A,0) , drop-and-append( drop(1,A), B ) )
    
  else: 
      link( get(B,0) , drop-and-append( A, drop(1,B) ) )
  end
end

merge-sort :: List -> List
# consumes a List and produces the List sorted,
# using a top-down merge algorithm. This implemented by
# recursively dividing the List in halves until we have 
# sub-Lists of size 2. This deviates from usual merge 
# sorts in that we stop when list are a length of 2 
# (instead of 1), at which time we do a short-sort. 
#
# The sub-Lists are re-merged using the above drop-and-append
# function.
examples "merge-sort" :
  merge-sort([list: ])        is empty
  merge-sort([list: 1])       is [list: 1]
  merge-sort([list: 2, 1])    is [list: 1,2]
  merge-sort([list: 3, 2, 1]) is [list: 1,2,3]
  
  merge-sort([list:5,3,9,1])  is 
  drop-and-append(merge-sort([list:5,3]), merge-sort([list: 9,1]))
end
fun merge-sort(lst):
  len  = length(lst)
  half = num-floor(len / 2) 

  # Base case
  if len < 2: short-sort(lst)
  
  # Recursive algorithm
  else:
    A  = take(half,lst)
    B  = drop(half,lst)
    
    drop-and-append( merge-sort(A) , merge-sort(B) )
  end
end

######################################################

######################################################
#
# Test Lists
#

L = [list: 3,1,4,1,5,9,2,6]
M = [list: 9,8,7,6,5,4,3,2]
X = [list: -1 * 1/2, -17, 3000, 22/7, 5, -999]

R = range(0,100)
S = shuffle(R)

######################################################
#

sort-test :: (List -> List) , List -> (-> List)
# sort-test wraps the given sort algorithm 
# in a function with no arguments that will sort 
# the given List (lst). This will allow us to 
# use time-value to test our algorithms below.
fun sort-test(algorithm, lst):
  lam(): algorithm(lst) end
end

######################################################
#
# Testing
#

# time-value generates a pair of outputs 
# The time is took to execute the function, and
# The value outputed by the function.
#
# Below, 
# the time is defined as t#, and 
# the value is defined as v#.
{t1; v1} = time-value( sort-test( pseudo-bubble-sort , S))
{t2; v2} = time-value( sort-test( insertion-sort     , S))
{t3; v3} = time-value( sort-test( quick-sort         , S))
{t4; v4} = time-value( sort-test( merge-sort         , S))
{t5; v5} = time-value( sort-test( sort               , S)) # pyret's built in sort

"pseudo-bubble-sort    : " + num-to-string(t1)
"insertion-sort        : " + num-to-string(t2)
"quick-sort            : " + num-to-string(t3)
"merge-sort            : " + num-to-string(t4)
"Pyret's built-in sort : " + num-to-string(t5)

# after sorting (S), does all elements 
# match the original list (R) ?
check "Testing the Sort Algorithms for Accuracy":
  v1 is R
  v2 is R
  v3 is R
  v4 is R
  v5 is R
end







