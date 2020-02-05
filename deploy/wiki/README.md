# 获取镜像

docker pull squidfunk/mkdocs-material

# 开始部署

# 生成项目目录

docker run -it --rm -v /mnt/ibas/wiki/docs:/docs squidfunk/mkdocs-material new vstore-wiki

docker run -it --name vstore-wiki --rm -v /mnt/ibas/wiki/docs:/docs --workdir /docs/vstore-wiki  -p 8000:8000 squidfunk/mkdocs-material
# 运行

docker rm -f vstore-wiki

docker run -d --name vstore-wiki --rm -v /mnt/ibas/wiki/docs:/docs --workdir /docs/vstore-wiki  -p 8000:8000 squidfunk/mkdocs-material

https://www.mkdocs.org/#getting-started


https://hub.docker.com/r/squidfunk/mkdocs-material/