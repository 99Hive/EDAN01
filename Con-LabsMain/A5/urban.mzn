include "globals.mzn";

%Var
int : n;
int : n_commercial;
int : n_residential;

array[1..n+1] of int : point_distribution;%Assigns points to different placement configurations.
array[1..n, 1..n] of var 0..1 : placements;%Indicating whether a building is placed or not(1 or 0).
array[1..n*2] of var int : points = [point_distribution[sum(z in 1..n)
  (if i <= n then placements[i,z] else placements[z, i-n] endif) + 1] | i in 1..n*2];%Stores the points obtained for each placement configuration.

constraint lex2(placements);
constraint sum(placements) = n_residential;

solve :: int_search(placements, first_fail, indomain_max, complete) maximize sum(points);

output["Max points = \(sum(points))"];