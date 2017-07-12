########################################################################
#
#	Authentication functions for CloudMail API.
#
########################################################################

# Function login takes two arguments:
# $1 - email adress of modyfied/admin account,
# $2 - password of account.
# Log in as given user. Set access_token, account_id, domain_id
# and mailbox_id variables in case of success.
# Exit the script with nonzero exit code and print error
# in case of failure.
function login () {
	check_args "$1" "$2"
	jsonout=$(curl -ks --http1.1 "${URL}/auth/login" \
		-H "Content-Type: application/json" \
		-d @<(cat <<EOF
{ 
	"email": "$1",
	"password": "$2"
}
EOF
))
	errcheck "$jsonout"
	access_token=$(echo "$jsonout" | jq -r .auth.accessToken)
	account_id=$(echo "$jsonout" | jq -r .auth.account.id)
	domain_id=$(echo "$jsonout" | jq -r .auth.mailbox.domainId)
	mailbox_id=$(echo "$jsonout" | jq -r .auth.mailbox.id)
}

# Function logout takes no argument.
# Corectly exit current session.
# Exit the script with nonzero exit code and print error
# in case of failure.
function logout () {
	jsonout=$(curl -ks --http1.1 "${URL}/auth/logout" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer ${access_token}" \
		-d @)
	errcheck "$jsonout"
}
