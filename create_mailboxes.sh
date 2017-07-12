function create_mailboxes () {
	while getopts ":u:p:i:" arg; do
		case "$arg" in
			u)
				user="$OPTARG"
				;;
			p)
				password="$OPTARG"
				;;
			i)
				ID="$OPTARG"
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
	if [ ! -z "$ID" ]; then
		domain_id="$ID"
	fi
	
	for mailbox in "$@"; do
		password=$(pwgen 16 1)
		create_mailbox "$domain_id" "$mailbox" "$password" 1>/dev/null
		printf "$mailbox $password\n"
	done
	logout
}
