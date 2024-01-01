#!/bin/bash


rows=3
columns=5
index_max=0
format_index=0
index_alloc=0

allocation_values=(1 1 0 2 0 0 3 0 2 2 1 1 0 0 2)
max_values=(7 5 3 3 2 2 9 0 2 2 2 2 4 3 3)
available=(3 3 2)
header=("Process" "Allocation" "Max" "Available")

for ((i=0; i<rows; i++)); do
    finish[$i]=0
    answer[$i]=0
done

format="%-12s"
format_available="%-8s"
format_allocation="%-14s"
format_need="%-9s"

print_header() {
    echo
    printf "$format" "Proccess"
    printf "$format_allocation" "Allocation"
    printf "$format_need" "Need"
    printf "$format_available\n" "Available"
    printf "%17s" "A B C"
    printf "%14s" "A B C"
    printf "%9s\n" "A B C"
}


for ((i=0; i<rows; i++)); do
    for ((j=0; j<columns; j++)); do
        alloc_array[$((i * columns + j))]=${allocation_values[$index_alloc]}
        ((index_alloc++))
    done
done
for ((i=0; i<rows; i++)); do
    for ((j=0; j<columns; j++)); do
        max_array[$((i * columns + j))]=${max_values[$index_max]}
        ((index_max++))
    done
done

print_header

for ((i=0; i<columns; i++));do
    formatted_line=""
    for ((j=0; j<rows; j++)); do
	formatted_line+="${alloc_array[$((i * rows + j))]} "
    done
    printf "$format" "P$i"
    printf "$format_allocation" "$formatted_line"
    formatted_line=""
for ((k=0; k<rows; k++)); do
	formatted_line+="${max_array[$((i * rows + k))]} "
   done
   printf "$format_need" "$formatted_line"
   formatted_line=""
   echo
done
 #   for ((j=0; j<columns; j++)); do
#	formatted_line+="${need_array[$i,$j]}"
   # done
   # echo "$formatted_line"
#done 

				    
