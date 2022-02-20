### exporter部署

- 主机exporter

- 大数据框架
  
  - ceph
  
  - kafka
  
  - hadoop

#### 主机exporter

##### docker部署

```bash
docker run -d \
  --net="host" \
  --pid="host" \
  --name=node-exporter \
  -v "/:/host:ro,rslave" \
  common-service.spark-liang:8091/prom/node-exporter \
  --path.rootfs /host


```

##### k8s部署

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
  namespace: kube-system
  labels:
    k8s-app: node-exporter
spec:
  selector:
    matchLabels:
      k8s-app: node-exporter
  template:
    metadata:
      labels:
        k8s-app: node-exporter
    spec:
      imagePullSecrets:
        - name: common-service.spark-liang
      # 配置tolerations允许pod运行在master上
      tolerations:
        - key: node-role.kubernetes.io/master
          operator: Exists
          effect: NoSchedule
      containers:
        - image: common-service.spark-liang:8091/prom/node-exporter
          name: node-exporter
          ports:
            - containerPort: 9100
              protocol: TCP
              name: http
              hostPort: 39100
```
