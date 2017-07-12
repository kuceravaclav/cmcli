function errcheck {
	jsonerror=$(echo "$1" | jq -r .error.message)
	if [ "$jsonerror" != "null" ]
	then	
		die "$jsonerror"
	fi
	return 0
}

function die () {
	printf "$1\n" >&2
	logout
	exit 1
}

function check_args () {
	for arg in "$@"; do
		if [ ! "$arg" ]; then
			die "Empty argument in function ${FUNCNAME[1]}!"
		fi
	done
}
