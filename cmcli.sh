#!/bin/bash

#=======================================================================
# Title:        cmcli
# Description:  cli to manage CloudMail service
# Author:       Vaclav Kucera
# Email:        kucera@vshosting.cz
# Company:      Vshosting s.r.o.
# Version:      1.0
# Bash_version: 4.4
# Usage:        cmcli [TODO]
#=======================================================================

DEBUG=
if [ "$DEBUG" ]; then
	printf "%s\n" "Debug mode!"
	set -o errexit  # exit if any command fail
	set -o nounset  # exit if unset variable is used
	set -o pipefail # catch failure in pipe
#	set -o xtrace   # print executing commands to stdout
fi

basedir=$(dirname $(realpath $0))

# Load functions required by cmcli
source "$basedir/cmfunctions.sh"

# Load functions for work with CloudMail API.
source "$basedir/cmapi/auth.sh"
source "$basedir/cmapi/domain.sh"
source "$basedir/cmapi/mailbox.sh"
source "$basedir/cmapi/mailgroup.sh"

# Load cmcli modules
source "$basedir/add_forwards.sh"
source "$basedir/alias.sh"
source "$basedir/create_domains.sh"
source "$basedir/create_mailboxes.sh"

########################################################################
#
#		Global constants and variables
#
########################################################################

# Access token of current session
declare access_token
declare account_id

# CloudMail API URL
URL="https://mailapi.vshosting.cloud"

########################################################################
#
#		MAIN
#
########################################################################

# Check for mandatory argument
if [ "$#" -lt 1 ]; then
	die 'No command given!'
fi

command=$1
shift

case "$command" in
	add_forwards)
		add_forwards "$@"
		;;
	alias)
		alias "$@"
		;;
	create_domains)
		create_domains "$@"
		;;
	create_mailboxes)
		create_mailboxes "$@"
		;;
	*)
		die "Invalid command $command."
		;;
esac
exit 0
