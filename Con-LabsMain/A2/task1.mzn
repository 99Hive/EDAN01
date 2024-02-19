include "subcircuit.mzn";

int: graph_size;
int: start;
int: n_dests;
int: n_edges;
array[1..n_dests] of int: dests;

% arrays to store the starting and ending points of edges
array[1..n_edges] of int: cities_1;
array[1..n_edges] of int: cities_2;

% store the costs associated with each edge
array[1..n_edges] of int: costs;

% represents the paths in the graph.
%Each row in the circuits array represents a
%path that starts from the given city and visits all the destinations.
array[1..n_dests, 1..graph_size] of var 1..graph_size: circuits;

% Declare a set of domains for each node in the graph
array[1..graph_size] of set of 1..graph_size:
  domains = [{i} union {cities_1[j] | j in 1..n_edges where cities_2[j] = i} 
                 union {cities_2[j] | j in 1..n_edges where cities_1[j] = i} 
                 union {start | j in 1..n_dests where dests[j] = i} | i in 1..graph_size];

%  store the cost for each destination
array[1..n_dests] of var int: cost_vector = [cost(n) | n in 1..n_dests];

% calculate the cost for a given destination
% i = Nodes, j = edges, true -> add
function var int: cost(int: n) =
    sum(i in 1..graph_size, j in 1..n_edges)(
        if n > 1 /\ 
            forall(m in 0..n-1)(
                (circuits[n-m,i] = cities_2[j] /\ i = cities_1[j]) \/ 
                (circuits[n-m,i] = cities_1[j] /\ i = cities_2[j])
            )
        then 0
          elseif
              (circuits[n,i] = cities_2[j] /\ i = cities_1[j]) \/ 
              (circuits[n,i] = cities_1[j] /\ i = cities_2[j]) 
          then costs[j]
          else 0 
        endif);

% Constrain that each element in circuits is within its corresponding domain
constraint forall(i in 1..graph_size, j in 1..n_dests)(circuits[j,i] in domains[i]);

 % Each row in circuits creates a subcircuit
constraint forall(j in 1..n_dests)(subcircuit(circuits[j,..]));

% Constrain that there is a path between start and dest to complete the circuit
constraint forall(i in 1..n_dests)(circuits[i,dests[i]] = start);

solve minimize sum(cost_vector);

output["Subcircuits = " , show(circuits),"\n","Total cost: ", show(sum(cost_vector))];
