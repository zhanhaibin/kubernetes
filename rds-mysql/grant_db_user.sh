#!/bin/sh

MYSQL=`which mysql`
EXPECTED_ARGS=5
# 分配权限 
# $5 分配账套
# $4 分配用户
SQL="GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP ON \`$5\`.* TO '$4'@'%';"

# 登陆mysql
# $1 登录mysql的地址 
# $2 登录mysql服务器的用户，自行替换
# $3 登录mysql服务器的密码，自行替换
if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage Args: $0 hostname dbuser dbpass grantuser,grantdb"
  exit $E_BADARGS
fi

#$MYSQL --host=$1 -P 3306 --user=$2 --password=$3 -e "select * from mysql.`user` where `user`='$4'; "

echo $MYSQL --host=$1 -P 3306 --user=$2 --password=$3 -e "$SQL"
result="$($MYSQL --host=$1 -P 3306 --user=$2 --password=$3 -e "$SQL")"
echo -e "$result"

