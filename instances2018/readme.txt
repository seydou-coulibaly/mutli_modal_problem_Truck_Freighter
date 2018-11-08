
This document explains the instance file for the truck and freighter routing problem. 

Each instance includes a time matrix (in seconds) which is provided as a separate file, potentialy including more vertices than the instance itself. 
The time matrix is also used as cost.

The instance file is made of a vertex list, formatted so that it can be easily loaded in a dataframe.

VERTEX LIST:

example
CUSTNO	DEMAND	VERTEX_TYPE	LATITUDE	LONGITUDE	TW_OPENING
1	0	D	47.282609	-1.520303	0
15	0	P	47.234018	-1.535018	0
...
3	40	S	47.214248	-1.557261	10800
...
2	20	LS	47.256911	-1.513408	23400
...

FIELDS:
1 - CUSTNO index of the vertex (also the index in the time matrix)
2 - DEMAND	quantity ordered by customers, 
3 - VERTEX_TYPE D for depot, P for parkings, S for customers delivered only by the small truck, L for customers of the big truck and LS if the customer can be served by both types. 
4 - LATITUDE
5 - LONGITUDE
6 - TW_OPENING Time at which the service can start at the vertex. 

The depot and the parkings have a time window width equal to the time horizon, customers have the width that is specified in the header
