#/bin/sh

kubectl create secret tls byd-tls --key  /mnt/ibas/certs/byd.avacloud.com.cn/2683050_byd.avacloud.com.cn.key --cert /mnt/ibas/certs/byd.avacloud.com.cn/2683050_byd.avacloud.com.cn.pem -n api
