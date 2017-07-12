function create_domains () {
	while getopts ":u:p:" arg; do
		case "$arg" in
			u)
				user="$OPTARG"
				;;
			p)
				password="$OPTARG"
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
	for domain in "$@"; do
		create_domain "$account_id" "$domain" | jq -r .domain.id
	done
	logout
}
