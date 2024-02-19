include "globals.mzn";
include "alldifferent.mzn";
%include "assignment1_data2.dzn";
include "assignment1_data1.dzn";

int: n;
int: n_prefs;
array[1..n_prefs, 1..2] of var int: prefs;%prefrences
array[1..n] of var 1..n: line;%people in line(number=persons, value= pos)

var int: distance(int: i) = abs(line[prefs[i, 1]] - line[prefs[i, 2]]);%1 or more

array[1..n_prefs] of var 0..n : dist = [distance(i) | i in 1..n_prefs];

constraint alldifferent(line);
  
var int: sat_prefs =
  sum(i in 1..n_prefs)(
    dist[i] = 1 %if 1, we got it
  );

solve maximize sat_prefs;

output ["Number of satisfied preferences: " , show(sat_prefs)];

%output ["Line: " ++ show(line) ++ "\n" ++ 
%"Nr of satisfied preferences: " ++ show(sat_prefs)];
