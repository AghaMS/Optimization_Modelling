# Multiple Vehicle routing code - Subsection 6.7
# MA424 Final project - 2019/20
# Author: 46286

reset;

# Parameters
param C; # Number of clients
param V; # Number of Vehicles



# Set of potential clients and vehicles
set clients:= 1..C;
set vehicles:= 1..V;

# Set of coordinates
set coordinates;

# Defining parameters
param location {clients union {0}, coordinates};

param distance {i in clients union {0}, j in clients union {0}}:= 
        sqrt(sum{k in coordinates} (location[i,k] - location[j,k])^2);
     
# variables encoding the tour per vehicle
var x {clients union {0}, clients union {0}, v in vehicles} binary;
# variables encoding the position in the tour
var u {clients union {0}, v in vehicles} >= 0;
# variable encoding the assigned vehicle;
var y {clients union {0}, v in vehicles} binary;

minimize Cost: sum {i in clients union {0}, j in  clients union {0}, v in vehicles} distance[i,j] * x[i,j,v];

subject to

	# Vehicles are initialized without forcing a fixed number of vehicles to be dispatched
	allVehicles1: sum {v in vehicles} y[0,v] >= 1;
	allVehicles2: sum {v in vehicles} y[0,v] <= 3;
	
 	# clients only assigned to one vehicle
	SameVehivle {j in clients}: sum {v in vehicles} y[j,v] = 1;	
	
	# degree constraints
    indegree {j in clients union{0}, v in vehicles}: sum {i in clients union {0}} x[i,j,v] = y[j,v];
	outdegree {j in clients union {0}, v in vehicles}: sum {i in clients union {0}} x[j,i,v] = y[j,v];	
	
	# position in the tour
	start {v in vehicles}: u[0,v] = 1;
	#sequence{v in vehicles, i in clients}: u[i,v] - u[i-1,v] >= 0;
	position {v in vehicles, i in clients union {0}, j in clients}: u[i,v]-u[j,v]+1 <= C*(1-x[i,j,v]);

	
option solver cplex;
        