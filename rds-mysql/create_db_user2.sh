#!/bin/bash
# 创建mysql数据库，数据库用户，密码，以及为用户赋权限
# 三个参数
# dbname 数据库名
# dbuser 数据库用户
# dbpassword 用户密码

MYSQL=`which mysql`
EXPECTED_ARGS=3

# 使用Grant给用户赋予权限，没有此用户自动创建user 
Q1="CREATE DATABASE \`$1\` CHARACTER SET utf8 COLLATE utf8_general_ci;"
# 创建数据库 并设置默认数据库编码集
Q2="GRANT ALL ON \`$1\`.* TO '$2'@'%' IDENTIFIED BY '$3';"
# 刷新权限
Q3="FLUSH PRIVILEGES;"

SQL="${Q1}${Q2}${Q3}"

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage Args: $0 dbname dbuser dbpass"
  exit $E_BADARGS
fi
echo 'Exec SQL SCRIPT:' ${SQL}
# 执行mysql命令
# hostname 登录mysql的地址 
# root 登录mysql服务器的用户，自行替换
# password 登录mysql服务器的密码，自行替换
$MYSQL --host=hostname -P 3306 --user=root --password=password -e "$SQL"


