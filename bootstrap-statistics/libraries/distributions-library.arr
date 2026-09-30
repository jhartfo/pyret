use context starter2024

provide:
  mystery01, mystery02, mystery03, mystery04,
  mystery05, mystery06, mystery07, mystery08,
  mystery09, mystery10, mystery11, mystery12,
  mystery13, mystery14, mystery15, mystery16,
  dists
end

import url-file(
    "https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/", "core-bss.arr") as Core

provide from Core:
    * hiding(dilate),
end

include csv
include data-source

url-prefix = 
  "https://raw.githubusercontent.com/jhartfo/pyret/" 
  + "main/bootstrap-statistics/data/"

CSVs = [list:
  "random-X2-n-1.csv",
  "random-X2-n-2.csv",
  "random-X2-n-3.csv",
  "random-X2-n-9.csv",
  "random-binomial-10-10.csv",
  "random-binomial-50-10.csv",
  "random-binomial-90-10.csv",
  "random-normal-0-1.csv",
  "random-normal-10-1.csv",
  "random-normal-70-10.csv",
  "random-uniform-0-1.csv",
  "random-uniform-0-10.csv",
  "random-uniform-0-100.csv",
  "random-uniform-10-20.csv",
  "bimodal-328.csv",
  "bimodal-819.csv",
]

fun csv-load(CSV): 
  csv-table-url(url-prefix + CSV , { header-row: false }) 
end

fun csv-to-table(CSV):
  load-table: x
  sanitize x  using num-sanitizer
    source: CSV
  end
end

dists = shuffle(map(
  lam(x):
    csv-to-table(csv-load(x)).get-column("x")
  end, 
    CSVs))

mystery01 = dists.get(0)
mystery02 = dists.get(1)
mystery03 = dists.get(2)
mystery04 = dists.get(3)
mystery05 = dists.get(4)
mystery06 = dists.get(5)
mystery07 = dists.get(6)
mystery08 = dists.get(7)
mystery09 = dists.get(8)
mystery10 = dists.get(9)
mystery11 = dists.get(10)
mystery12 = dists.get(11)
mystery13 = dists.get(12)
mystery14 = dists.get(13)
mystery15 = dists.get(14)
mystery16 = dists.get(15)

#|
# load the bimodal distribution and create a sample
   
import url("https://raw.githubusercontent.com/jhartfo/pyret/main/bootstrap-statistics/libraries/uniform-distribution.arr") as CB


bimodal = csv-load("bimodal-distribution.csv")
bimodal-table = load-table: x, pdf, cdf
  sanitize x   using num-sanitizer
  sanitize pdf using num-sanitizer
  sanitize cdf using num-sanitizer
  source: bimodal
  end

a = map(
  lam(x): 
    filter(bimodal-table, lam(r): r["cdf"] > x end).row-n(0)["x"]
  end,
  simulate-uniform(0,4,4,818)
  )
|#



