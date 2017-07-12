########################################################################
#
#	Functions for manipulation with mail groups (aliases)
#	via CloudMail API.
#
########################################################################

# Function create_group takes three arguments:
# $1 - domain ID,
# $2 - grou name (without domain name),
# $3 - list of alias targets in JSON format (including [] brackets).
# Function creates email alias with given targets.
function create_group () {
	check_args "$1" "$2" "$3"
	jsonout=$(curl -ks -XPOST --http1.1 "${URL}/mail-group" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer ${access_token}" \
		-d @<(cat <<EOF
{
	"domainId": "$1",
	"groupEmailLocalPart": "$2",
	"groupContentEmailList": $3
}
EOF
))
	errcheck "$jsonout"
	echo "$jsonout"
}

# Function get_group takes one argument:
# $1 - ID of mail group.
# In case of success prints mail group data to stdin.
function get_mailgroup () {
	check_args "$1"
	jsonout=$(curl -ks --http1.1 "${URL}/mail-group/$1" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer ${access_token}")
	errcheck "$jsonout"
	echo "$jsonout"
}

# Function upgrade_mailgroup takes two arguments:
# $1 - ID of mail group,
# $2 - mail group data (.mailbox section in JSON format).
# Send given data to CloudMail servers to upgrade mail group.
function upgrade_mailgroup () {
	check_args "$1" "$2"
	jsonout=$(curl -ks --http1.1 -XPUT "${URL}/mail-group/$1" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer ${access_token}" \
		-d @<(cat <<EOF
$2
EOF
))
	errcheck "$jsonout"
	echo "$jsonout"
}
