#!/bin/bash
# ========================================================================================
#/usr/sbin/asterisk -rx 'core show channels' | grep -i "active calls"
#/usr/sbin/asterisk -rx 'core show channels' | grep -i "active calls" | sed "s/active calls//g"
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

ASTERISK=/usr/sbin/asterisk

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
                        ACTIVE_W=$1
                        ;;
                -c | --critical)
                        shift
                        ACTIVE_C=$1
                        ;;

                *)  echo "Unknown argument: $1"
                        print_usage
                        exit $STATE_UNKNOWN
                        ;;
                esac
shift
done

ACTIVE=`sudo $ASTERISK -rx 'core show channels' | grep -i "active calls" | sed "s/ active calls//g"`
# Return

if [ ${ACTIVE} -gt $ACTIVE_C ];
then
        echo "CRITICAL - ${ACTIVE}. | active calls=${ACTIVE};$ACTIVE_W;$ACTIVE_C;"
        exit $STATE_CRITICAL
fi

if [ ${ACTIVE} -gt $ACTIVE_W ];
then
        echo "WARNING - ${ACTIVE}. | active calls=${ACTIVE};$ACTIVE_W;$ACTIVE_C;"
        exit $STATE_WARNING
fi

echo "OK - ${ACTIVE}. | active calls=${ACTIVE};$ACTIVE_W;$ACTIVE_C;"
exit $STATE_OK

