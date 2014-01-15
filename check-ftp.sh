#!/bin/bash

SITE=$1
FN=$SITE".ls.txt"

mkdir -p good no-login no-perms timeout no-connect other-fail

ncftpls -t 2 -r 0 -E -m -lR -u anonymous -p 'foo.bar@baz.quux.com' "ftp://"$SITE"/" > $FN

FTP_STATUS=$?

case "$FTP_STATUS" in
	0) # success!
		echo $SITE looks good $FTP_STATUS
		mv $FN "good/"
		host $SITE > "good/"$SITE".hostname"
		;;
	1) # no connect
		echo $SITE no-connect $FTP_STATUS
		mv $FN "no-connect/"
		;;
	2) # connect timeout
		echo $SITE no-connect/timeout $FTP_STATUS
		mv $FN "no-connect/"
		;;
	3) # transfer fail
		echo $SITE transfer-fail $FTP_STATUS
		mv $FN "other-fail/"
		;;
	4) # transfer timeout
		echo $SITE transfer-fail/timeout $FTP_STATUS
		mv $FN "timeout/"
		host $SITE > "good/"$SITE".hostname"
		;;
	5) # directory change failed
		echo $SITE directory-fail $FTP_STATUS
		mv $FN "no-perms/"
		;;
	6) # directory change timeout
		echo $SITE directory-fail/timeout $FTP_STATUS
		mv $FN "timeout/"
		host $SITE > "good/"$SITE".hostname"
		;;
	*) # remaining are misc failures, mostly usage-related
		echo $SITE fail/other $FTP_STATUS
		mv $FN "other-fail/"
		;;
esac
