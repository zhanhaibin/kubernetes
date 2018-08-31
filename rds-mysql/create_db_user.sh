#!/bin/sh

MYSQL=`which mysql`
EXPECTED_ARGS=5
# 创建用户和密码
# $4 用户
# $5 密码
# S6 账套
SQL="GRANT  all privileges ON \`$6_%\`.* TO '$4'@'%' IDENTIFIED BY '$5';"

# 登陆mysql
# $1 登录mysql的地址 
# $2 登录mysql服务器的用户，自行替换
# $3 登录mysql服务器的密码，自行替换
if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage Args: $0 hostname dbuser dbpass createuser,createpass,account"
  exit $E_BADARGS
fi

echo $MYSQL --host=$1 -P 3306 --user=$2 --password=$3 -e "$SQL"
result="$($MYSQL --host=$1 -P 3306 --user=$2 --password=$3 -e "$SQL")"
echo -e "$result"

 



