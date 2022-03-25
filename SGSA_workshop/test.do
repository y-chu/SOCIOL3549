clear 

input str13 name1 str14 city1 byte age1
"John Doe"      "Atlanta"        28
"William Green" "Seattle"        22
"Emily Jones"   "Denver"         48
"Sarah Brown"   "Chicago"        60
"Dan Kennedy"   "Washington, DC" 12
end
gen id1=_n
tempfile file1
save `file1', replace

clear
input str14 name2 str10 city2 byte age2
"Doe, Jon"       "ATL"        27
"Will Green"     "SEA"        23
"Jone, Emily"    "denver"     46
"Sara Brown"     "chicago"    62
"Daniel Kennedy" "WASHINGTON" 12
end
gen id2=_n
tempfile file2
save `file2', replace
