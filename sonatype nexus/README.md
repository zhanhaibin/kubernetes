# 配置nexus-cli 
./nexus-cli configure
Enter Nexus Host: **************************
Enter Nexus Repository Name: avacloud
Enter Nexus Username: admin
Enter Nexus Password: ******************

# 查看已存在镜像列表
./nexus-cli image ls

# 删除image 保留最后一个
./nexus-cli image delete -name c00002/platform/ps-ava-platform/tomcat -keep 1