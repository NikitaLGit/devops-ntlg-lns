## Задание 1

Создадим деплоймент приложения из двух контейнеров
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginxtool1
  namespace: netology
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginxtool1
  template:
    metadata:
      labels:
        app: nginxtool1
    spec:
      containers:
      - name: nginx
        image: nginx:1.25.4
        ports:
        - containerPort: 80

      - name: multitool
        image: wbitt/network-multitool
        ports:
        - containerPort: 1180
        env: 
          - name: HTTP_PORT
            value: "1180"
```

<img width="1008" height="52" alt="image" src="https://github.com/user-attachments/assets/83fbbb5e-51d5-4b63-91ad-e7b8c1fc404c" />
<img width="916" height="115" alt="image" src="https://github.com/user-attachments/assets/733b682c-a88f-4214-9ccb-e9feeca25344" />

Масштабируем до 2 реплик

<img width="1192" height="134" alt="image" src="https://github.com/user-attachments/assets/589855fd-71d7-4a8a-a22d-c036141f63fd" />

Создадим сервис для доступа к контейнерам в поде

```
apiVersion: v1
kind: Service
metadata:
  name: nginxtool1-svc
  namespace: netology
spec:
  selector: 
    app: nginxtool1
  ports:
    - name: nginxhttp
      protocol: TCP
      port: 8081
      targetPort: 80
    - name: miltitool
      protocol: TCP
      port: 8082
      targetPort: 1180
```

Создадим отдельный под `multitool` и с помощью `curl` проверим доступность до контейнеров через сервис

```
apiVersion: v1
kind: Pod
metadata:
   name: multitool1
   namespace: netology
spec:
   containers:
     - name: multitool1
       image: wbitt/network-multitool
       ports:
        - containerPort: 1180
```

<img width="868" height="167" alt="image" src="https://github.com/user-attachments/assets/4061c5cb-fe64-4cc3-a275-0d9ef435ac73" />
<img width="1162" height="447" alt="image" src="https://github.com/user-attachments/assets/927e4a09-12cf-483f-8eb6-8e63b6670c97" />

## Задание 2

Манифест:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginxtool2
  namespace: netology
spec:
  selector:
    matchLabels:
      app: nginxtool2
  replicas: 1
  template:
    metadata:
      labels:
        app: nginxtool2
    spec:
      containers:
      - name: nginx
        image: nginx:1.25.4
        ports:
        - containerPort: 80
      initContainers:
      - name: delay
        image: busybox
        command: ['sh', '-c', "until nslookup nginxtool2-svc.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for nginxtool2-svc; sleep 2; done"]
---
apiVersion: v1
kind: Service
metadata:
  name: nginxtool2-svc
  namespace: netology
spec:
  ports:
    - name: nginxtool2
      port: 80
  selector:
    app: nginxtool2
```

Идет проверка на запуск сервиса и после этого только запускается под

<img width="933" height="153" alt="image" src="https://github.com/user-attachments/assets/5c480c22-35a6-4f77-bfd9-f896a5a62b27" />
