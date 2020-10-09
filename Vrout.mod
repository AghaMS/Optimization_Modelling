# Vehicle routing code - Subsection 6.6
# MA424 Final project - 2019/20
# Author: 46286

reset;

# Parameters
param F; # Number of potential facilities 
param C; # Number of clients
param period;

# Set of potential facilities and clients
set facilities:= 1..F;
set clients:= 1..C;

# Set of coordinates
set coordinates;


# Defining parameters
param location {clients union {0}, coordinates};

param distance {i in clients union {0}, j in clients union {0}}:= 
        sqrt(sum{k in coordinates} (location[i,k] - location[j,k])^2);
 
# variables encoding the tour per period
var x {clients union {0}, clients union {0}} binary;
# variables encoding the position in the tour
var u {clients union {0}} >= 0;


minimize tourLength: sum {i in clients union {0}, j in  clients union {0}} distance[i,j] * x[i,j];

subject to
  
	
	# degree constraints
	indegree {j in clients union {0}}: sum {i in clients union {0}} x[i,j] = 1;
	outdegree {j in clients union {0}}: sum {i in clients union {0}} x[j,i] = 1;
	# position in the tour
	start: u[0] = 1;
	position {i in clients union {0}, j in clients}: u[i]-u[j]+1 <= C*(1-x[i,j]);
	
option solver gurobi;
        