# create_db_user.sh 创建数据库，用户名，密码和赋权限的linux脚本

运行：

···
sh create_db_user.sh dbname dbuser dbpassword
···


mysql 数据库备份、恢复

备份mysql数据库linux下命令：

hostname mysql主机地址

dbuser mysql登录用户名

dbpassword mysql 登录密码

c00001-01 备份的数据库 

/srv/c00001-01.sql 导出到c00001-01.sql 文件

``` 
mysqldump -hhostname -p3306  -udbuser -pdbpassword c00001-01>/srv/c00001-01.sql
```

恢复mysql数据库linux命令：

```
先创建数据库

mysql>create database abc;

恢复

mysql -hhostname -p3306  -udbuser -pdbpassword@ c00001-01-test</srv/c00001-01.sql
```

