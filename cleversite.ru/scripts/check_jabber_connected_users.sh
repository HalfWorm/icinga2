#!/bin/bash
# ========================================================================================
#/sbin/ejabberdctl  connected_users_number

# CPU Utilization Statistics plugin for Nagios
#
# Written by    : Aleksey Lavrov
# Release       : 0.1
# Creation date : 3 May 2008
# Package       : DTB Nagios Plugin
# Description   : Nagios plugin (script) to check xxxxxxxxxxxxxxxx.
#               xxxxxxxxxxxxxxxxxxxxxxxx
#
# Usage         : ./check_cpu.sh [-w <warn>] [-c <crit]
#                                [-uw <user_cpu warn>] [-uc <user_cpu crit>]
#                                [-sw <sys_cpu warn>] [-sc <sys_cpu crit>]
#                                [-iw <io_wait_cpu warn>] [-ic <io_wait_cpu crit>]
#                                [-i <intervals in second>] [-n <report number>]
# ----------------------------------------------------------------------------------------
# Paths to commands used in this script.  These may have to be modified to match your system setup.

##echo  "$USER" > /tmp/11
##exit $STATE_OK

EJABBERDCTL=/sbin/ejabberdctl

# Nagios return codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Plugin variable description
PROGNAME=$(basename $0)
RELEASE="Revision 0.1"
AUTHOR="by Aleksey Lavrov "

##if [ ! -x $EJABBERDCTL ]; then
##        echo "UNKNOWN: ejabberdctl not found or is not executable by the nagios user."
##        exit $STATE_UNKNOWN
##fi

# Functions plugin usage
print_release() {
    echo "$RELEASE $AUTHOR"
}

print_usage() {
	echo ""
	echo "$PROGNAME $RELEASE - jabber connected users check script for iCinga"
	echo ""
	echo "Usage: check_jabber_connected_users.sh [flags]"
	echo ""
	echo "Flags:"
	echo "  -w  <number> : Global Warning level in % for "
	echo "  -c  <number> : Global Critical level in % for "
	echo "  -h | --help  Show this page"
	echo "  -v | --version  Show version"
	echo ""
	echo "Usage: $PROGNAME"
	echo "Usage: $PROGNAME --help"
	echo ""
}

print_help() {
	print_usage
	echo ""
	echo "This plugin will check cpu utilization (user,system,iowait,idle in %)"
	echo ""
	exit 0
}

# Parse parameters
while [ $# -gt 0 ]; do
	case "$1" in
		-h | --help)
			print_help
			exit $STATE_OK
			;;
		-v | --version)
			print_release
			exit $STATE_OK
			;;
		-w | --warning)
			shift
			USERS_W=$1
			;;
		-c | --critical)
			shift
			USERS_C=$1
			;;

		*)  echo "Unknown argument: $1"
			print_usage
			exit $STATE_UNKNOWN
			;;
		esac
shift
done

USERS=`sudo $EJABBERDCTL connected_users_number`
# Return

if [ ${USERS} -ge $USERS_C ];
then
	echo "CRITICAL - ${USERS}. | users=${USERS};$USERS_W;$USERS_C;"
	exit $STATE_CRITICAL
fi

if [ ${USERS} -ge $USERS_W ];
then
        echo "WARNING - ${USERS}. | users=${USERS};$USERS_W;$USERS_C;"
        exit $STATE_WARNING
fi

echo "OK - ${USERS}. | users=${USERS};$USERS_W;$USERS_C;"
exit $STATE_OK
