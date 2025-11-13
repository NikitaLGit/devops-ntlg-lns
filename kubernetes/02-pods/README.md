## 1. Поднимем деплоймент с подом `hello-world`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: echoserver
        image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
        ports:
        - containerPort: 8080
```

* Получим

<img width="885" height="53" alt="image" src="https://github.com/user-attachments/assets/160c1e1f-be35-4886-80a6-dcad71515211" />
<img width="785" height="65" alt="image" src="https://github.com/user-attachments/assets/748b7bcc-311d-4bc1-b1d2-25f8fad24027" />

* Сделаем проброс портов

<img width="1164" height="73" alt="image" src="https://github.com/user-attachments/assets/637df0dd-2057-47ef-83d9-8837fbf2f12f" />

* При запросе curl

<img width="942" height="445" alt="image" src="https://github.com/user-attachments/assets/b66235f2-076e-48ae-9500-ac768c80f9d3" />

## 2. Поднимем деплоймент с подом `netology-web` и сервис `netology-svc`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: netology-web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: netology-web
  template:
    metadata:
      labels:
        app: netology-web
    spec:
      containers:
      - name: echoserver
        image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
        ports:
        - containerPort: 8080

---

apiVersion: v1
kind: Service
metadata:
  name: netology-svc
spec:
  selector: 
    app: netology-web
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

<img width="903" height="50" alt="image" src="https://github.com/user-attachments/assets/0c1da74f-cadb-4db9-ae7d-92ca0822e57d" />

Прокинем локальный 8080 порт на 80 порт сервиса и получим

<img width="904" height="446" alt="image" src="https://github.com/user-attachments/assets/4d7f9855-0986-4889-a904-e5db9546b4f4" />
