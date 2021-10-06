# test that qmail-start can boot

user=notqmail-test
dom=example.org
home=$PWD/home
mail=$user@$dom
uid=$(id -u "$user")
gid=$(id -g "$user")
subj="fire of the spawned daemon"

echo "$dom" >control/me
echo "=$user:$user:$uid:$gid:$home:::" >users/assign
echo . >>users/assign
mkdir -p "$home/Maildir/cur" "$home/Maildir/new" "$home/Maildir/tmp"
chown -R "$user" "$home"

qmail-newu
qmail-showctl
qmail-start ./Maildir/ &
trap "kill -9 $!" INT TERM EXIT HUP

su -s /bin/sh "$user" -c "sendmail -f '$mail' '$mail'" <<EOF
Subject: $subj
EOF
sleep 1
grep "$subj" "$home"/Maildir/*/*
