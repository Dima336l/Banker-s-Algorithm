#!/bin/bash

function initialize_variables {
    resources=3
    processes=5
    index_max=0
    index_alloc=0
    format="%-12s"
    format_max="%-9s"
    format_allocation="%-14s"
    format_need="%-9s"
    request_flag=0
}

initialize_finish_arrays() {
    for ((i=0; i<processes; i++)); do
	finish[$i]=0
	answer[$i]=0
    done
}

function initialize_arrays {
    read -a allocation_values -p "Enter the number of available resources (separated by space): "
    read -a max_values -p "Enter the maximum demand of each process (separated by space): "
    read -a available -p "Enter available resources (separated by space): "
    for element in "${available[@]}"; do
	initial_available+=("$element")
    done
    for ((i=0; i<resources; i++)); do
	for ((j=0; j<processes; j++)); do
            alloc_array[$((i * processes + j))]=${allocation_values[$index_alloc]}
            ((index_alloc++))
	done
    done
    for ((i=0; i<resources; i++)); do
	for ((j=0; j<processes; j++)); do
            max_array[$((i * processes + j))]=${max_values[$index_max]}
            ((index_max++))
	done
    done
    
    for ((i=0; i<resources; i++)); do
	for ((j=0; j<processes; j++)); do
	    need_array[$((i * processes + j))]=$((max_array[$((i * processes + j))] - alloc_array[$((i * processes + j))]))
	done
    done
    initialize_finish_arrays
}


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

print_table() {
    if [ $request_flag -eq 0 ]; then
    available_printed=true
    print_header
    for ((i=0; i<processes; i++));do
	formatted_line=""
	for ((j=0; j<resources; j++)); do
	    formatted_line+="${alloc_array[$((i * resources + j))]} "
	done
	printf "$format" "P$i"
	printf "$format_allocation" "$formatted_line"
	formatted_line=""
	for ((k=0; k<resources; k++)); do
	    formatted_line+="${max_array[$((i * resources + k))]} "
	done
	printf "$format_max" "$formatted_line"
	formatted_line=""
	for ((l=0; l<resources; l++)); do
	    formatted_line+="${need_array[$((i * resources + l))]} "
	done
	printf "$format_need" "$formatted_line"
	formatted_line=""
	if [ "$available_printed" = true ]; then
	    for ((m=0; m<resources; m++)); do
		formatted_line+="${available[$m]} "
		available_printed=false
	    done
	    printf "$formatted_line"
	fi
	echo
    done
    fi
}

check_if_sequence_safe() {
    index=0
    flag=0
    for ((i=0; i<processes; i++)); do
	for ((m=0; m<processes; m++)); do
	    if [ ${finish[$m]} -eq 0 ]; then
		flag=0
		for ((n=0; n<resources; n++)); do
		    if [ ${need_array[$((m * resources + n))]} -gt ${available[$n]} ]; then
			flag=1
			break
		    fi
		done
		if [ $flag -eq 0 ]; then
       		    answer[$index]=$m
		    ((index++))
		    for ((y=0; y<resources; y++)); do
			available[$y]=$((${available[$y]} + ${alloc_array[$((m * resources + y))]}))
		    done
		    finish[$m]=1
		fi
	    fi
	done
    done
    ((iter++))
}

display_if_safe() {
    flag=1
    echo
    for ((n=0; n<processes; n++)); do
	if [ ${finish[$n]} -eq 0 ]; then
	    flag=0
	    echo "The given sequence is not safe."
	    break;
	fi
    done

    if [ $request_flag -eq 0 ]; then 
    if [ $flag -eq 1 ]; then
	echo "The following sequence is a safe sequence:"
	for ((m=0; m<$((processes-1)); m++)); do
	    echo -n "P${answer[$m]} -> "
	done
	echo -n "P${answer[$((processes - 1))]}"
	echo
    fi
    fi
}

check_new_request() {    
    available=("${initial_available[@]}")
    if [ $flag -eq 1 ]; then
      	echo
	read -a process_num -p "Enter the process number which requests resources: "
	read -a request -p "Enter the requested resources (separated by space): " 
	for ((i=0; i<resources; i++)); do
	    if [ ${request[$i]} -gt ${need_array[$(($process_num * resources + i))]} ]; then
		request_flag=1
		break
	    fi
	done
	if [ $request_flag -eq 0 ]; then
	    for ((j=0; j<resources; j++)); do
		if [ ${request[$j]} -gt ${available[$j]} ]; then
		    request_flag=1
		    break
		fi
	    done
	    echo
	fi

	if [ $request_flag -eq 0 ]; then
            for ((k=0; k<resources; k++)); do 
		available[$k]=$((${available[$k]} - ${request[$k]}))
		alloc_array[$(($process_num * resources + k))]=$((${alloc_array[$(($process_num * resources + k))]} + ${request[$k]}))
		need_array[$(($process_num * resources + k))]=$((${need_array[$(($process_num * resources + k))]} - ${request[$k]}))
	    done
	else
	    echo
	    echo "Request can not be granted"
	fi
    fi

}

initialize_variables
initialize_arrays
print_table
check_if_sequence_safe
display_if_safe
check_new_request
print_table
check_if_sequence_safe
display_if_safe
