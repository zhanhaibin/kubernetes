# 先在dyups文件夹下，构建基础镜像 colorcoding/openresty-dyups 
docker build -t colorcoding/openresty-dyups:latest -f Dockerfile .

# 在nginx.ibas文件夹下，构建应用镜像 docker.avacloud.com.cn/openresty-dyups/nginx 
./build_dockerfile.sh

