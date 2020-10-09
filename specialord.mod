# Routing Special Orders code - Subsection 6.8
# MA424 Final project - 2019/20
# Author: 46286

reset;

# Parameters
param C; # Total Number of clients
param L; # Number of normal clients

# Dimension 
param D;

# Set of potential clients
set Total:= 1..C;
set clients:= 1..L;
set SpecialClients:= L+1..C; 


# Set of coordinates
set coordinates:= 1..D;


# Defining parameters
param location {Total union {0}, coordinates};

param distance {i in Total union {0}, j in Total union {0}}:= 
	sum{k in coordinates} abs(location[i,k] - location[j,k]);

        
        

# variables encoding the tour per period
var x {Total union {0}, Total union {0}} binary;

var u {Total union {0}} >= 0;


minimize PathLength: sum {i in Total union {0}, j in  Total union {0}} distance[i,j] * x[i,j];

subject to

# Tour starts from the depot
Source: sum{i in clients} x[0,i] = 1;

# Disconnecting Special clients from depot;
Disconnect {j in SpecialClients}: x[0,j] = 0;
Disconnect1 {j in SpecialClients}: x[j,0] = 0;

begin: u[0] = 1;

# Special Clients included in tour
Enter {i in SpecialClients}: sum{j in clients} x[j,i] = 1;
#Leave {i in SpecialClients}: sum{j in clients} x[i,j] = 1;

MaxClients: sum {i in Total union {0}, j in Total union {0}} x[i,j] <= 6;

# Network Balance
Balance {i in Total union {0}}: sum{j in Total union {0}} x[j,i] = sum{j in Total union {0}} x[i,j];

# No tour from one node to itself
No {i in Total union {0}}: x[i,i] = 0;

#NoSubTours {i in Total union {0}, j in Total union {0}: x[i,j] > x[j,i];
position {i in Total union {0}, j in Total}: u[i]-u[j]+1 <= C*(1-x[i,j]);

		
option solver cplex;
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		