include "globals.mzn";

int : del_add;
int : del_mul;
int : number_add;
int : number_mul;
int : n;
set of int : last;
set of int : add;
set of int : mul;
array[1..n] of set of 1..n : dependencies;

int : max_cycles = n * max(del_add, del_mul);

% Start times
array[1..length(add)] of var 0..max_cycles : start_add;
array[1..length(mul)] of var 0..max_cycles : start_mul;
array[1..n] of var 0..max_cycles : start_all;

% Height
array[1..length(add)] of var 1..number_add : H_add;
array[1..length(mul)] of var number_add + 1..number_mul+number_add : H_mull;
array[1..n] of var int : H_all;

% Durations
array[1..length(add)] of int : dur_add = [ del_add | i in 1..length(add) ];
array[1..length(mul)] of int : dur_mul = [ del_mul | i in 1..length(mul) ];
array[1..n] of int : dur_all = [ if i in add then del_add else del_mul endif | i in 1..n ];

% resurses that are used by each op
array[1..length(add)] of int : height_add = [ 1 | i in 1..length(add) ];
array[1..length(mul)] of int : height_mul = [ 1 | i in 1..length(mul) ];
array[1..n] of int : height_all = [ 1 | i in 1..n ];

constraint forall ( i in 1..length(add) )
 (H_all[add[i]] = H_add[i] /\ start_all[add[i]] = start_add[i] /\ dur_all[add[i]] = del_add );

constraint forall ( i in 1..length(mul) )
 (H_all[mul[i]] = H_mull[i] /\ start_all[mul[i]] = start_mul[i] /\ dur_all[mul[i]] = del_mul );

%controll resurses so it dont exceed
constraint cumulative(start_add, dur_add, height_add, number_add);
constraint cumulative(start_mul, dur_mul, height_mul, number_mul);

%tasks should not overlaps
constraint diffn(start_all, H_all, dur_all, height_all);

%schedule based on dependencies
%If j is in dependencies[i], it means operation i depends on the result of operation j
constraint forall ( i in 1..n, j in dependencies[i] )
(start_all[i] + dur_all[i] <= start_all[j] );

var 1..max_cycles : schedule_end;

constraint forall ( i in last )
(start_all[i] + dur_all[i] <= schedule_end );

%annotated search
solve :: int_search(start_all, first_fail, indomain_min)
 minimize schedule_end;

output [
    
    "Addition assignment: \([i | i in H_add])\n",
    "Multiplication assignment: \([i-number_add | i in H_mull])\n",
    "Schedule length: \(schedule_end)\n",
];
























































%Which multiplier and adder each operation is assigned to
%var 1..number_mul : mul_dom;
%var (number_mul + 1)..(number_mul + number_add) : add_dom;


%ann: search_ann = int_search(start_all, first_fail, indomain_min);
%solve :: search_ann minimize schedule_end;


%output [
 %   "Schedule end: \(schedule_end)\n",
 %   "Add domain: 1..\(number_add)\n",
  %  "\([i | i in add])\n\([i | i in H_add])\n",
   % "Mul domain: \(1)..\(number_mul)\n",
    %"\([i | i in mul])\n\([i-number_add | i in H_mull])\n",

  %];%
  
  