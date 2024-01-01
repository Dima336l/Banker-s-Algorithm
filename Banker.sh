#!/bin/bash

rows=3
columns=5
index_max=0
index_alloc=0

allocation_values=(1 1 0 2 0 0 3 0 2 2 1 1 0 0 2)
max_values=(7 5 3 3 2 2 9 0 2 2 2 2 4 3 3)
available=(3 3 2)

for ((i=0; i<columns; i++)); do
    finish[$i]=0
    answer[$i]=0
done

format="%-12s"
format_available="%-13s"
format_allocation="%-14s"
format_need="%-13s"

print_header() {
    echo
    printf "$format" "Proccess"
    printf "$format_allocation" "Allocation"
    printf "$format_available" "Available"
    printf "Need\n"
    printf "%17s" "A B C"
    printf "%14s" "A B C"
    printf "%13s\n" "A B C"
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

for ((i=0; i<rows; i++)); do
    for ((j=0; j<columns; j++)); do
	need_array[$((i * columns + j))]=$((max_array[$((i * columns + j))] - alloc_array[$((i * columns + j))]))
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
    for ((l=0; l<rows; l++)); do
	formatted_line+="${need_array[$((i * rows + l))]} "
    done
    printf "$formatted_line"
    echo
done

index=0
for ((k=0; k<columns; k++)); do
    for ((j=0; j<columns; j++)); do
	if [ ${finish[$j]} -eq 0 ]; then
	    flag=0
	    for ((l=0; l<rows; l++)); do
		if [ ${need_array[$((j * rows + l))]} -gt ${available[$l]} ]; then
		    flag=1
		    break;
		fi
	    done
	    if [ $flag -eq 0 ]; then
		answer[$index]=$k
		((index++))
		for ((y=0; y<rows; y++)); do
		    echo ":D"
		done
	    fi
	    
	fi
    done
done
	      
