include"globals.mzn";
include "alldifferent.mzn";

%include "assignment1_data2.dzn";
include "assignment1_data1.dzn";

int: n;%par
int: n_prefs;
array[1..n_prefs, 1..2] of var int: prefs;
array[1..n] of var 1..n: line;%var(Numbers=persons & value=pos)

%var to calc the dis
function var int: distance(int: i) = abs(line[prefs[i, 1]] - line[prefs[i, 2]]);

array[1..n_prefs] of var int: dist = [distance(i) | i in 1..n_prefs];%store distance

constraint alldifferent(line);

solve minimize max(dist);

output ["Maximal distance: " , show(max(dist))];

%output ["Line: " ++ show(line) ++ "\n" ++
%"Distances = " ++ show(dist) ++ "\n" ++
%"Maximal distance: " ++ show(max(dist))];


%Propagation is the process of using constraints 
%to narrow down the possible values that variables can take.


%Domain Variable Pruning:
%This refers to the process of reducing the domain of
%a variable based on the constraints in the model.



