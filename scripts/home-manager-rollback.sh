#!/usr/bin/env bash

Help()
{
	echo "Syntax: home-manager-rollback.sh [options]"
	echo "Options:"
	echo -e "  -h      Show this help message and exit"
	echo -e "  -l NUM  Show the IDs and creation times of the last NUM generations, default 10"
	echo -e "  -r ID   Return the script path to rollback to generation ID, no effect if ID is not given"
}

while getopts ":hlr:" option; do
	case $option in 
		h) 
			Help 
			exit 0
			;;
		l)	
			# check if an argument was provided
			eval nextopt=\${$OPTIND}
    		# existing or starting with dash?
    		if [[ -n $nextopt && $nextopt != -* ]] ; then
      			OPTIND=$((OPTIND + 1))
      			lines=$nextopt
    		else
      			lines=10
      		fi
			
			home-manager generations | sed -n '1,'$lines' s/ ->.*$//p'
			exit 0
			;;
		r)
			if [ -z $OPTARG ]; then
				echo "Generation ID for rollback missing"
				exit 1
			else
				generationPath=$(home-manager generations | rg 'id '$OPTARG | sed 's/.*-> //')
				echo $generationPath"/activate"
			fi
			exit 0
			;;
		?)
			echo "Invalid option. Use -h for help."
			exit 1
			;;
	esac
done

