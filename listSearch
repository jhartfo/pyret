use context starter2024


#################################################
#
# SEARCH ALGORITHMS
#

#
#

#################################################
#
# BOOLEAN FUNCTION 
# provided for an example block
#

# less-than-3 :: Number -> Boolean
# consumes a Number and compares it to 3. If the 
# Number is less than 3 
# return true, otherwise return false
examples: 
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

# list-filter :: List, (Any -> Boolean)  -> List
# consumes a List and a Function with a Boolean Range. 
# Recursively, we check if each element returns true 
# when applied the Function is applied. If it does not, 
# the element is removed from the new outputed List.
examples:
  list-filter(less-than-3, [list:]) is empty 
  list-filter(less-than-3, [list: 3,1,4,1,5,9,2,6]) is [list: 1,1,2]
end
fun list-filter(fn, lst):
  
  # base cases
  if lst == empty: empty
  else if fn(lst.first):
    link(lst.first, list-filter(fn, lst.rest))

  # recursive algorithm  
  else:
    list-filter(fn, lst.rest)
  end
end

# list-min :: List -> Any
# consumes a list and returns the largest 
# element as compared using "<"
examples:
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
  if lst.rest == empty:
    lst.first
  else:
    num-min(lst.first, list-min(lst.rest))
  end
end

# list-max :: List -> Any
# consumes a list and returns the largest 
# element as compared using ">"
examples:
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
  if lst.rest == empty:
    lst.first
  else:
    num-max(lst.first, list-max(lst.rest))
  end
end

# short-sort :: List -> List
# consumes a List. If the List is empty or has a single elemetn
# the function produces the original list. If there are two
# elements, the functions will swap the elements. NOTE:
# this function is intentded for elements of 0, 1, or 2.
# However, there is no validity check. So, if the List has more than 
# elements the poduced list wil only have the first two 
# elements will be reversed. All other elements will be dropped.
# 
# intended to only sort a list of 2 or fewer elements 
examples: 
  short-sort(empty)           is [list: ]
  short-sort([list: 1])       is [list:1]
  short-sort([list: 2, 1])    is [list: 1,2]
  short-sort([list: 1, 2])    is [list: 1,2]
  short-sort([list: 3,2,1,4]) is [list: 2,3]
end
fun short-sort(lst):
  if lst.length() < 2: lst
  else:
    a = lst.rest.first
    b = lst.first
    if a < b: [list: a,b]
    else: [list:b,a]
    end
  end
end

# three-way-split :: List, Any -> List<List>
# consumes a homogeneous List and a single Element
# and produces a List of three Lists: 
# a List of Elements    less than the Element,
# a List of Elements     equal to the Element, and
# a List of Elements greater than the Element.
examples:
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

fun linear-search(lst, start, value):
  indices = range(start,start + lst.length())
  i = filter(_ < value, lst).length()
  if lst.get(i) == value:
    indices.get(i)
  else:
    "not a member"
  end
end
  
fun binary-search(lst, start, value):
  #a = print(lst)
  len  = lst.length() 
  half = num-floor(len / 2) 
  if (value < list-min(lst)) or (value > list-max(lst)):
    "not a member"
  else if len <= 4:
    linear-search(lst, start, value)
  else:
    if lst.get(half) >= value:
      binary-search(lst.take(half + 1), start, value)
    else:
      binary-search(lst.drop(half), start + half, value)
    end
  end
end

fun terinary-search(lst, start, value):
  #a = print(lst)
  len   = lst.length() 
  third = num-floor(len / 3) 
  if (value < list-min(lst)) or (value > list-max(lst)):
    "not a member"
  else if len <= 4:
    linear-search(lst, start, value)
  else:
    if lst.get(third) >= value:
      binary-search(lst.take(third + 1), start, value)
    else if lst.get(2 * third) >= value:
      binary-search(lst.take((2 * third) + 1), start + third, value)
    else:
      binary-search(lst.drop(third), start + (2 * third), value)
    end
  end
end


