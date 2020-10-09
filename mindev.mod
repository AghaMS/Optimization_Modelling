# Load-balancing code - Subsection 6.4 in Technical Appendix  
# MA424 Final project - 2019/20
# Author: 46286

reset;

# Parameters
param F; # Number of potential facilities 
param C; # Number of clients

# Dimension 
param D;

# Set of potential facilities
set facilities:= 1..F;

# Set of clients
set clients:= 1..C;

# Set of coordinates
set coordinates:= 1..D;


# Read locations
param locationF {facilities, coordinates};
param locationC {clients, coordinates};

# Compute distances
param assignCost {i in facilities, c in clients}:=
	sum{k in coordinates} abs(locationF[i,k] - locationC[c,k]);



# Compute L1 Norm per facility
param fmagnitude {i in facilities}:=
	sqrt(sum{k in coordinates} (locationF[i,k])^2);


# opening costs for the facilities
param f{i in facilities}:= 100*(3^(-1*fmagnitude[i]));

# Facilities' associated capacities
param capacity{i in facilities}:= 100*(2^(fmagnitude[i]));

# Clients Demand
param demand{clients};

# Big M
param M:= 5;


# variables 
var y{facilities} binary; # per facility
var x{facilities, clients} binary; # assigning clients to facilities
var delta{facilities} >= 0;

# objective function: minimizing opening costs, distance and excess capacity
minimize total_cost:
	sum {i in facilities} y[i] * f[i] + 
	sum {i in  facilities, j in clients} x[i,j] * assignCost[i,j] +
	sum {i in facilities} M * delta[i];
	
# constraints
subject to
	
	#every client will be assigned to some facility
	assignment {j in clients}:
	sum {i in facilities} x[i,j] = 1;
	
	# Minmum number of warehouses
	minWarehouseNum: 
	sum{i in facilities} y[i] >= 1;
	
	# Minmum number of warehouses
	maxWarehouseNum: 
	sum{i in facilities} y[i] <= F;
	
	
	# Capacitated version
	satisfyCapacity {i in facilities}: 
	capacity[i] * y[i] = sum {j in clients} (demand[j]*x[i,j]) + delta[i];
 	
option solver cplex;
option omit_zero_rows 1;		
	