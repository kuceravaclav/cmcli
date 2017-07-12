function add_forwards () {
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
	mailbox_data=$(get_mailbox "$mailbox_id")
	for forward in "$@"; do
		mailbox_data=$(echo "$mailbox_data" | jq ".mailbox.inboxForwardList += [\"${forward}\"]")
	done
	mailbox_data=$(echo "$mailbox_data" | jq -r .mailbox)
	upgrade_mailbox "$mailbox_id" "$mailbox_data" 1>/dev/null
	logout
}
