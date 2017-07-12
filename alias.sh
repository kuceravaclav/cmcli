function alias () {
	while getopts ":u:p:a:" arg; do
		case "$arg" in
			u)
				user="$OPTARG"
				;;
			p)
				password="$OPTARG"
				;;
			a)
				alias="$OPTARG"
				;;
			\?)
				die "Invalid option -$OPTARG."
				;;
			:)
				die "Option -$OPTARG requires an argument."
				;;
		esac
	done
	shift $((OPTIND-1))

	login "$user" "$password"
	group_data='{"groupContentEmailList": []}'
	for dest in "$@"; do
		group_data=$(echo "$group_data" | jq ".groupContentEmailList += [\"${dest}\"]")
	done
	create_group "$domain_id" "$alias" "$(echo $group_data | jq .groupContentEmailList)" 1>/dev/null
	logout
}
