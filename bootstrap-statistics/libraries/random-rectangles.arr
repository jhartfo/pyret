use context url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/uniform-distribution.arr")

import url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/uniform-distribution.arr") as UD
provide *
provide from UD: * ,
  type *,
  data *
end

include csv
include data-source

fun random100(n)   : map(lam(x):num-random(100) + 1 end, range-by(0,n,1)) end
fun random20(n)    : map(lam(x):num-random( 20) + 1 end, range-by(0,n,1)) end
fun cluster(row, n): row["cluster"] == n end
fun strata(row, n) : row["strata" ] == n end
fun row-select(row,a): a.member(row["rectangle"]) end
fun truncate(tbl)    : tbl.drop("cluster")
    .drop("strata")#.drop("width") .drop("height") 
end

prefix-url     = "https://raw.githubusercontent.com/jhartfo/pyret/refs/heads/main/bootstrap-statistics/"

sheet-url      = "data/random-rectangles.csv"
random-url     = "images/rr-random-rectangles.png"
clustered-url  = "images/rr-clustered-rectangles.png"
stratified-url = "images/rr-stratified-rectangles.png"

random-rectangles        = scale(0.10,image-url(prefix-url + random-url))
clustered-rectangles     = scale(0.10,image-url(prefix-url + clustered-url))
stratified-rectangles    = scale(0.10,image-url(prefix-url + stratified-url))

# Load your spreadsheet and define your table
rectangle-sheet = csv-table-url(prefix-url + sheet-url, default-options)

master-table             = load-table: 
  rectangle, width, height, area, perimeter, cluster, strata
  source: rectangle-sheet
  sanitize rectangle using num-sanitizer
  sanitize width     using num-sanitizer
  sanitize height    using num-sanitizer
  sanitize area      using num-sanitizer
  sanitize perimeter using num-sanitizer
  sanitize cluster   using num-sanitizer
  sanitize strata    using num-sanitizer
end

#|
weighted-area-table      = load-table: 
  area, frequency, weights
  source: rectangle-sheet.sheet-by-name("weighted area", true)
end.rename-column("weights", "area * (freq / n)")

weighted-perimeter-table = load-table: 
  area, frequency, weights
  source: rectangle-sheet.sheet-by-name("weighted perimeter", true)
end.rename-column("weights", "perimeter * (freq / n)")
|#

########################################################
rectangles-table         = truncate(master-table)
width-height-table       = master-table.drop("cluster").drop("strata")

########################################################

fun rect-to-area(n)     : master-table.row-n(n)["area"] end
fun rect-to-perimeter(n): master-table.row-n(n)["perimeter"] end
  
########################################################
# We can cluster rectangles by where they are geographically 
# on the page
cluster-1  = truncate(master-table.filter(cluster(_, 1)))
cluster-2  = truncate(master-table.filter(cluster(_, 2)))
cluster-3  = truncate(master-table.filter(cluster(_, 3)))
cluster-4  = truncate(master-table.filter(cluster(_, 4)))
cluster-5  = truncate(master-table.filter(cluster(_, 5)))
cluster-6  = truncate(master-table.filter(cluster(_, 6)))
cluster-7  = truncate(master-table.filter(cluster(_, 7)))
cluster-8  = truncate(master-table.filter(cluster(_, 8)))
cluster-9  = truncate(master-table.filter(cluster(_, 9)))
cluster-10 = truncate(master-table.filter(cluster(_,10)))
cluster-11 = truncate(master-table.filter(cluster(_,11)))
cluster-12 = truncate(master-table.filter(cluster(_,12)))
cluster-13 = truncate(master-table.filter(cluster(_,13)))
cluster-14 = truncate(master-table.filter(cluster(_,14)))
cluster-15 = truncate(master-table.filter(cluster(_,15)))
cluster-16 = truncate(master-table.filter(cluster(_,16)))
cluster-17 = truncate(master-table.filter(cluster(_,17)))
cluster-18 = truncate(master-table.filter(cluster(_,18)))
cluster-19 = truncate(master-table.filter(cluster(_,19)))
cluster-20 = truncate(master-table.filter(cluster(_,20)))

########################################################
# We can groups rectangles by size. These types of 
# homogenious groups are called strata

strata-1   = truncate(master-table.filter(strata(_, 1)))
strata-2   = truncate(master-table.filter(strata(_, 2)))
strata-3   = truncate(master-table.filter(strata(_, 3)))
strata-4   = truncate(master-table.filter(strata(_, 4)))
strata-5   = truncate(master-table.filter(strata(_, 5)))

########################################################
fun simple-sample-rectangles(sample-size):
  truncate(random-rows(master-table, sample-size))
end

fun clustered-sample-rectangles(sample-size):
  clusters = [list: 
    cluster-1, cluster-2, cluster-3, cluster-4, cluster-5, 
    cluster-6, cluster-7, cluster-8, cluster-9, cluster-10, 
    cluster-11,cluster-12,cluster-13,cluster-14,cluster-15, 
    cluster-16,cluster-17,cluster-18,cluster-19,cluster-20]
  tbl = clusters.get(num-random(20))
  random-rows(tbl, sample-size)
end

fun stratified-sample-rectangles(sample-size):
  sample = map(
    random-rows(_, sample-size), 
    [list:strata-1,strata-2,strata-3,strata-4,strata-5])
  fold(lam(x,y): x.stack(y) end, strata-1.empty(), sample)
end

fun systematic-sample-rectangles(n): 
  m = num-random(19) + 1
  b = num-random(20)
  i = map(lam(x): (m * x) + b end, arithmetic(0,n,1))
  rectangles-table.filter(row-select(_, i))
end

fun simulate-sample-means(sample-size, sample-type, measure, no-trials):
  map(
    lam(x): 
      list-mean(sample-type(sample-size).get-column(measure))
    end, range-by(0,no-trials,1))
end

########################################################

#num-random-seed(0)

#|

random-rectangles     
clustered-rectangles  
stratified-rectangles 

simple-xbars = simulate-sample-means(
  4, simple-sample-rectangles, "area", 5000)

clustered-xbars = simulate-sample-means(
  4, clustered-sample-rectangles, "area", 5000)

stratified-xbars = simulate-sample-means(
  4, stratified-sample-rectangles, "area", 5000)

systematic-xbars = simulate-sample-means(
  4, systematic-sample-rectangles, "area", 5000)



mu-simple     = list-mean(simple-xbars)
mu-clustered  = list-mean(clustered-xbars)
mu-stratified = list-mean(stratified-xbars)
mu-systematic = list-mean(systematic-xbars)

mu-simple
mu-clustered
mu-stratified
mu-systematic

(mu-simple     / 7.50) - 1
(mu-clustered  / 7.50) - 1
(mu-stratified / 7.50) - 1
(mu-systematic / 7.50) - 1

list-histogram(simple-xbars,1)
list-histogram(clustered-xbars,1)
list-histogram(stratified-xbars,1)
list-histogram(systematic-xbars,1)

#|
A     = get-column(master-table, "area")
P     = get-column(master-table, "perimeter")

A-bar = list-mean(A)
P-bar = list-mean(P)

s-A   = stdDev(A)
s-P   = stdDev(P)

z-A   = z-scores(A)
z-P   = z-scores(P) 

r     = fold(_ + _, 0,map2(_ * _, z-A, z-P)) / (length(A) - 1)

m     = (P-bar / A-bar) * r
b     = P-bar - (m * A-bar)

r
m
b
simple-scatter-plot(width-height-table, "area", "perimeter")

|#

|#




















































































































































































































































































































































































































































































































































































































































































































































































































































































































