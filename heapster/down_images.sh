#!/bin/bash

images=(
    heapster-amd64:v1.5.3
    heapster-grafana-amd64:v4.4.3
    heapster-influxdb-amd64:v1.3.3)

for imageName in ${images[@]} ; do
    docker pull registry.cn-qingdao.aliyuncs.com/zhanhaibin/$imageName
    docker tag registry.cn-qingdao.aliyuncs.com/zhanhaibin/$imageName gcr.io/google_containers/$imageName
    docker rmi registry.cn-qingdao.aliyuncs.com/zhanhaibin/$imageName
done
