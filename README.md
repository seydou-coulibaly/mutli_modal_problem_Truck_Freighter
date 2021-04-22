# mutli_modal_problem_Truck_Freighter
Solving multi-modal optimization problem (Truck and Freighter) during master 2 class about transport optimization

## Disclaimer
This project was carried out in tandem with Hector Gatt, whom is now (april 2021), optimization engineer at Lumiplan


## Problem description

The truck-and-freighter routing problem consists in delivering goods starting from a principal
distribution center to the multiple customers in a city. The specificity of the problem is that
the delivery of goods is performed by an innovative type of truck 1 , where a small electric truck
(called city freighter) can travel inside a larger truck (called truck in the following). The city
implements an innovative logistics delivery policy and some streets are forbidden to traditional
trucks. As a result, some customers can be served only by the city freighter.
In the Truck&Freighter Routing Problem (TFRP), customers are all delivered from a depot
located outside of the city. To travel to the city center, the large truck leaves this depot, carrying
the city freighter. Both vehicles can separate and join again at dedicated parking areas. In terms
of capacity, the large truck can be considered as having an infinite capacity. The city freighter
has a more limited capacity, but it can be resupplied several times by the large truck at parking
areas. The day is considered to start at time 0 and end at the end of the time horizon T . All
trucks should be back at the depot by this time.
Each customer has a location, a quantity and a time window. All customer should be served
before the end of their time window. If a truck arrives at a customer before the opening of the
time window, it has to wait until this time.
The routing costs are considered to be equal to the sum of vehicle routing traveling times.
Note that no cost is accounted for when the small city freighter travels within the large truck.
The problem consists of designing the routes of the truck and city freighter, including deter-
mining when they travel together and separately and where they separate and join, such that all
routes start and end at the depot, customers are served within their respective time windows,
vehicles capacity are respected, and traveling costs are minimized.

## [Report](./rapport.pdf)

## Kind of solution proposed after optimization
![solution's visualisation](img/instance_r1_3_10.png)
