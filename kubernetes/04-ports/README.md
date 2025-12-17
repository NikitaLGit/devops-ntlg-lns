## Задание 1

Деплоймент:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginxtool
  namespace: netology
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginxtool
  template:
    metadata:
      labels:
        app: nginxtool
    spec:
      containers:
      - name: nginx
        image: nginx:1.25.4
        ports:
        - containerPort: 80

      - name: multitool
        image: wbitt/network-multitool
        ports:
        - containerPort: 8080
        env: 
          - name: HTTP_PORT
            value: "8080"
```

2 сервиса для доступа из кластера и извне:

```
apiVersion: v1
kind: Service
metadata:
  name: nginxtool-svc
  namespace: netology
spec:
  selector: 
    app: nginxtool
  ports:
    - name: nginxhttp
      protocol: TCP
      port: 9001
      targetPort: 80
    - name: miltitool
      protocol: TCP
      port: 9002
      targetPort: 8080
```

<img width="1018" height="65" alt="image" src="https://github.com/user-attachments/assets/24ea414d-e8df-4ab4-90f6-9ceade17859e" />

Получаем на 9001 и 9002 кластерных портах:

<img width="1258" height="458" alt="image" src="https://github.com/user-attachments/assets/61e23e80-bc90-4122-8bb5-49962d40fbff" />

Для внешнего доступа:

```
apiVersion: v1
kind: Service
metadata:
  name: nginxtool-nodeport
  namespace: netology
spec:
  type: NodePort
  selector: 
    app: nginxtool
  ports:
    - name: nginx
      port: 80
      targetPort: 80
      nodePort: 30001
    - name: multitool
      port: 8080
      targetPort: 8080
      nodePort: 30002
```

Получим извне

<img width="1141" height="559" alt="image" src="https://github.com/user-attachments/assets/9020d51d-5e2f-4425-965b-65f832c5a507" />

## задание 2
