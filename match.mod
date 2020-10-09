# Stable Matching code - Subsection 6.9
# MA424 Final project - 2019/20
# Author: 46286

reset;

param n; # number of internships
param m; # number of applicants / students

set internships:= 1..n;
set students:= 1..m;

# Declaring the preference of both sides of the matching challenge
param IntPref{i in internships, j in students};
param StdPref{i in students, j in internships};
#param StdPref{i in internships, j in students};

# Declaring the variable
var x{internships, students} binary;
#var y{students, internships} binary;

# Objective is to minimize rogue matching
minimize cost: 
sum{i in students, j in internships}  (IntPref[i,j] + StdPref[i,j])*x[i,j];

subject to

# For each internship, exactly one appliant is assigned
OneApplicant{i in internships}: sum{j in students} x[i,j] = 1;

# For each applicant,they can get at most one internship. Some might get none
BestMatch{j in students}: sum{i in internships} x[i,j] <= 1;

#Stable Matching
StableMatch{i in internships, k in internships, j in students, z in students:
(IntPref[i,z] < IntPref[i,j]) and (StdPref[i,z] < StdPref[k,z])}: x[i,z] + x[k,z] <= 1;


option solver cplex;