#!/bin/bash

rows=3
columns=5
index_max=0
index_alloc=0

allocation_values=(0 1 0 2 0 0 3 0 2 2 1 1 0 0 2)
max_values=(7 5 3 3 2 2 9 0 2 2 2 2 4 3 3)
available=(3 3 2)

for ((i=0; i<columns; i++)); do
    finish[$i]=0
    answer[$i]=0
done

format="%-12s"
format_max="%-9s"
format_allocation="%-14s"
format_need="%-9s"

print_header() {
    echo
    printf "$format" "Proccess"
    printf "$format_allocation" "Allocation"
    printf "$format_max" "Max"
    printf "$format_need" "Need"
    printf "Available\n"
    printf "%17s" "A B C"
    printf "%14s" "A B C"
    printf "%9s" "A B C"
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

for ((i=0; i<rows; i++)); do
    for ((j=0; j<columns; j++)); do
	need_array[$((i * columns + j))]=$((max_array[$((i * columns + j))] - alloc_array[$((i * columns + j))]))
    done
done

available_printed=true
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
    printf "$format_max" "$formatted_line"
    formatted_line=""
    for ((l=0; l<rows; l++)); do
	formatted_line+="${need_array[$((i * rows + l))]} "
    done
    printf "$format_need" "$formatted_line"
    formatted_line=""
    if [ "$available_printed" = true ]; then
	for ((m=0; m<rows; m++)); do
	    formatted_line+="${available[$m]} "
	    available_printed=false
	done
	printf "$formatted_line"
    fi
    echo
done

index=0
for ((k=0; k<columns; k++)); do
for ((j=0; j<columns; j++)); do
    if [ ${finish[$j]} -eq 0 ]; then
	flag=0
	for ((l=0; l<rows; l++)); do
	    if [ ${need_array[$((j * rows + l))]} -gt ${available[$l]} ]; then
		echo "${need_array[$((j * rows + l))]}"
		echo "${available[$l]}"
		flag=1
		break;
	    fi
	done
	if [ $flag -eq 0 ]; then
	    answer[$index]=$j
	    ((index++))
	    for ((y=0; y<rows; y++)); do
		available[$y]+=${alloc_array[$((j * columns + y))]}
		finish[$j]=1
	    done
	fi	
    fi
done
done


flag=1

for ((n=0; n<columns; n++)); do
    if [ ${finish[$n]} -eq 0 ]; then
	flag=0
	echo "The given sequence is not safe."
	break;
    fi
done

if [ $flag -eq 1 ]; then
    echo "The following sequence is a safe sequence:"
    for ((m=0; m<$((columns-1)); m++)); do
	echo -n " P${answer[$m]} ->"
    done
    echo -n " P${answer[$((m - 1))]}"
    echo
fi
	 
	 
