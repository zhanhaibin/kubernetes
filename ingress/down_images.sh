#!/bin/bash

images=(
    nginx-ingress-controller:0.9.0-beta.10 
    defaultbackend:1.0)

for imageName in ${images[@]} ; do
    docker pull registry.cn-qingdao.aliyuncs.com/zhanhaibin/$imageName
    docker tag registry.cn-qingdao.aliyuncs.com/zhanhaibin/$imageName gcr.io/google_containers/$imageName
    docker rmi registry.cn-qingdao.aliyuncs.com/zhanhaibin/$imageName
done   
