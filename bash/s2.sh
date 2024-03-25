#!/bin/bash

if [ "$#" -ne "3" ]; then
	echo "Wrong number of arguments! Expected 3" >&2
	exit 1 
fi 

[ "${1::1}" = "/" ] && source_file="$1" || source_file="${PWD}/$1"
[ "${2::1}" = "/" ] && source_dir="$2" || source_dir="${PWD}/$2"
[ "${3::1}" = "/" ] && target_dir="$3" || target_dir="${PWD}/$3"


[ ! -e "${source_file}" ] && echo "Given source file does not exists. EXIT" && exit 1
[ ! -e "${source_dir}" ] && echo "Given source dir does not exists. EXIT" && exit 1
[ ! -d "${source_dir}" ] && echo "Given source dir is not a directory. EXIT" && exit 1
[ ! -e "${target_dir}" ] && mkdir "${target_dir}"
[ ! -d "${target_dir}" ] && echo "Given target dir is not a directory. EXIT" && exit 1


function search_all() { 
	#$1 is courses.txt
	#$2 is source folder
	#$3 is target folder


	echo "Creating University folder"
	mkdir -p "$3/University"
	local out_file="$3/University/log.out"
 
	echo "Creating/overwriting empty log file"
	echo "" > $out_file 
	

	echo " " #Space line for readability

	#for each course 
	while read course; do 
		
		local destination="$3/University/$course"

		echo "Creating $course folder"
	    	mkdir -p $destination

		echo "Searching $course files"
		local results_names="$(find $2 -type f -iname *$course* )"
		local results_files="$(grep -i -r ".*$course.*" $2 | cut -d: -f1)"
		
		echo "Copying $course files"
		#for each file found
		for line in $results_names $results_files; do
			cp $line $destination
			echo -e "FROM $line \n\t TO $destination \n" >> $out_file   
		done	
	
		echo "Log registered"
		echo " " #Space line for readability 
		
	done < $1 

}


search_all ${source_file} ${source_dir} ${target_dir}

exit 0