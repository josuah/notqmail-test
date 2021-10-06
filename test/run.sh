# test that qmail-start can boot

hostname >control/me

qmail-showctl
qmail-start & pid=$!
sleep 1

kill $pid
