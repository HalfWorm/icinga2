#!/bin/bash
# ========================================================================================
#netstat -at | grep ":xmpp-client" | grep "ESTABLISHED" | wc -l
#
# Written by    : Aleksey Lavrov
# Release       : 0.1
# Creation date : 7 Mxx 2xxx
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

#EJABBERDCTL=/sbin/ejabberdctl
#ASTERISK=/usr/sbin/asterisk

# Nagios return codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Plugin variable description
PROGNAME=$(basename $0)
RELEASE="Revision 0.1"
AUTHOR="by Aleksey Lavrov "

if [ ! -x $ASTERISK ]; then
        echo "UNKNOWN: asterisk not found or is not executable by the nagios user."
        exit $STATE_UNKNOWN
fi

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

                *)  echo "Unknown argument: $1"
                        print_usage
                        exit $STATE_UNKNOWN
                        ;;
                esac
shift
done

#REGISTRY=`sudo $ASTERISK -rx 'sip show registry' | grep -i "Registered" | wc -l`
CONNECTED=`netstat -a | grep ":xmpp-client" | grep "ESTABLISHED" | wc -l`
# Return
echo "OK - ${CONNECTED}. | CONNECTED=${CONNECTED}"
exit $STATE_OK
