#!/bin/bash

#RES=`mysql -hP-MySQL.cleversite.ru -Dcleversite -ubitrix -pxirtiB -s -N -e "SELECT count(*) as dialogs FROM chatthread WHERE dtmcreated >= DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -1 MINUTE), '%Y-%m-%d %H:%i:00') AND dtmcreated <= DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -1 MINUTE), '%Y-%m-%d %H:%i:59') ORDER BY dtmcreated"`
#echo "$RES"

MYSQL=/usr/bin/mysql

# Nagios return codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Plugin variable description
PROGNAME=$(basename $0)
RELEASE="Revision 0.1"
AUTHOR="by Aleksey Lavrov "

if [ ! -x $MYSQL ]; then
        echo "UNKNOWN: mysql not found or is not executable by the nagios user."
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
	echo "This plugin will check "
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
			RES_W=$1
			;;
		-c | --critical)
			shift
			RES_C=$1
			;;
                -H | --host)
                        shift
                        HOST=$1
                        ;;
                -d | --base)
                        shift
                        BASE=$1
                        ;;
                -u | --user)
                        shift
                        USER=$1
                        ;;
                -p | --pass)
                        shift
                        PASS=$1
                        ;;
                -e | --execute)
                        shift
                        EXECUTE=$1
                        ;;

		*)  echo "Unknown argument: $1"
			print_usage
			exit $STATE_UNKNOWN
			;;
		esac
shift
done

#RES=`$MYSQL -hP-MySQL.cleversite.ru -Dcleversite -ubitrix -pxirtiB -s -N -e "SELECT count(*) as dialogs FROM chatthread WHERE dtmcreated >= DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -1 MINUTE), '%Y-%m-%d %H:%i:00') AND dtmcreated <= DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -1 MINUTE), '%Y-%m-%d %H:%i:59') ORDER BY dtmcreated"`
RES=`$MYSQL -h$HOST -D$BASE -u$USER -p$PASS -s -N -e "$EXECUTE"`

# Return

if [ ${RES} -ge $RES_C ];
then
	echo "CRITICAL - ${RES}. | users=${RES};$RES_W;$RES_C;"
	exit $STATE_CRITICAL
fi

if [ ${RES} -ge $RES_W ];
then
        echo "WARNING - ${RES}. | users=${RES};$RES_W;$RES_C;"
        exit $STATE_WARNING
fi

echo "OK - ${RES}.|users=${RES};$RES_W;$RES_C;"
exit $STATE_OK

