#!/bin/bash

cat > nexus-builder.yaml << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: nexus
---
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  labels:
    app: nexus3
    name: nexus3
    namespace: nexus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nexus3
  template:
    metadata:
      labels:
        app: nexus3
    spec:
      containers:
      - name: nexus3
        image: sonatype/nexus3:latest
        ports:
        - containerPort: 8081
          protocol: TCP
        volumeMounts:
        - name: nexus-data
          mountPath: /nexus-data
      volumes:
        - name: nexus-data
          hostPath:
            path: /vagrant/nexus-data
---
kind: Service
apiVersion: v1
metadata:
  labels:
    app: nexus3
  name: nexus3
  namespace: nexus
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 8081
  selector:
    app: nexus3
EOF

kubectl create -f ./nexus-builder.yaml

HostIP=`hostname -i`
EndPort=`kubectl describe svc -n nexus nexus3 | grep 'NodePort:' | awk '{print $3}'`
HostName=`kubectl get pods -n nexus -o wide | grep 'nexus3' | awk '{print $7}'`
echo "Now Nexus running on ${HostName}:${HostIP} : ${EndPort%/*}"
echo "Note:If the page can't be accessed,please wait a few minutes and refresh the page."

sudo rm -f ./nexus-builder.yaml
