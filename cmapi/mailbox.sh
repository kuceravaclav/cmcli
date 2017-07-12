########################################################################
#
#	Functions for manipulation with mailbox via CloudMail API.
#
########################################################################

# Function create_mailbox takes three mandatory arguments:
# $1 - domain ID,
# $2 - mailbox name (without domain name),
# $3 - password.
# There are also two optional arguments:
# $4 - language code (default is CS),
# $5 - relo code (dafault is BASIC_USER).
# If used, both optional arguments must be given.
# Function creates given mailbox in domain with given ID.
function create_mailbox () {
	check_args "$1" "$2" "$3"
	jsonout=$(curl -ks --http1.1 -XPOST ${URL}/mailbox \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer ${access_token}" \
		-d @<(cat <<EOF
{  
   "domainId":"$1",
   "emailLocalPart":"$2",
   "password":"$3",
   "languageCode": "${4:-CS}",
   "roleCode": "${5:-BASIC_USER}"
}
EOF
))
	errcheck "$jsonout"
	echo "$jsonout"
}

# Function get_mailbox takes one argument:
# $1 - ID of mailbox.
# In case of success print mailbox data to stdin.
function get_mailbox () {
	check_args "$1"
	jsonout=$(curl -ks --http1.1 "${URL}/mailbox/$1" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer ${access_token}")
	errcheck "$jsonout"
	echo "$jsonout"
}

# Function upgrade_mailbox takes two arguments:
# $1 - ID of mailbox,
# $2 - mailbox data (.mailbox section in JSON format).
# Send given data to CloudMail servers to upgrade mailbox.
function upgrade_mailbox () {
	check_args "$1" "$2"
	jsonout=$(curl -ks --http1.1 -XPUT "${URL}/mailbox/$1" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer ${access_token}" \
		-d @<(cat <<EOF
$2
EOF
))
	errcheck "$jsonout"
	echo "$jsonout"
}

# Function mailbox_password takes two arguments:
# $1 - ID of mailbox,
# $2 - new password.
# Change mailbox password to given one.
function mailbox_password () {
	check_args "$1" "$2"
	jsonout=$(curl -ks --http1.1 -XPUT "${URL}/mailbox/$1/password" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer ${access_token}" \
		-d @<(cat <<EOF
{  
   "password":"$2"
}
EOF
))
	errcheck "$jsonout"
	echo "$jsonout"
}
