########################################################################
#
#	Functions for manipulation with domain via CloudMail API.
#
########################################################################

# Function create_domain takes two arguments:
# $1 - account ID,
# $2 - domain.tld.
# Function creates given domain under account with given ID.
function create_domain () {
	check_args "$1" "$2"
	jsonout=$(curl -ks --http1.1 -XPOST ${URL}/domain \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer ${access_token}" \
		-d @<(cat <<EOF
{  
   "accountId":"$1",
   "name":"$2"
}
EOF
))
	errcheck "$jsonout"
	echo "$jsonout"
}
