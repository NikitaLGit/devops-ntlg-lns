## Задание 1

применим конфиг

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: volumes-test
  namespace: volume1
spec:
  selector:
    matchLabels:
      app: volumes1
  replicas: 1
  template:
    metadata:
      labels:
        app: volumes1
    spec:
      containers:
      - name: busybox
        image: busybox:1.28
        command: ['sh', '-c', 'mkdir -p /testvolume && while true; do echo "$(date) - Test message" >> /testvolume/success.txt; sleep 5; done']
        volumeMounts:
        - name: volume
          mountPath: /testvolume
      - name: multitool
        image: wbitt/network-multitool
        command: ['sh', '-c', 'tail -f /testvolume/success.txt']
        volumeMounts:
        - name: volume
          mountPath: /testvolume
      volumes:
      - name: volume
        emptyDir: {}
```

Проверим вывод в файле в контейнере multitool

<img width="1238" height="277" alt="image" src="https://github.com/user-attachments/assets/5c3fb2a6-e1db-4176-b7bd-88503b18b40d" />

и в busybox

<img width="1305" height="181" alt="image" src="https://github.com/user-attachments/assets/2fa08df2-2043-41ae-9566-3363486a1750" />

Все работает. Из обоих контейнеров пода файл доступен, в него действительно записываются данные каждые 5 секунд

## Задание 2

напишем yaml

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: test-daemonset
  namespace: volume1
  labels:
    app: multitool
spec:
  selector:
    matchLabels:
      name: test-daemonset
  template:
    metadata:
      labels:
        name: test-daemonset
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool
        volumeMounts:
        - name: logdir
          mountPath: /nodes-logs/syslog
          subPath: syslog
        - name: varlog
          mountPath: /var/log/syslog
          readOnly: true
      terminationGracePeriodSeconds: 30
      volumes:
      - name: logdir
        hostPath:
          path: /var/log
      - name: varlog
        hostPath:
          path: /var/log
```

<img width="1004" height="130" alt="image" src="https://github.com/user-attachments/assets/5f30bbc4-2578-49a9-977e-d74abc26177b" />

* Для предоставления доступа к файлу /var/log/syslog кластера MicroK8S изнутри контейнера, будет применен параметр subPath. Это позволит монтировать не всю директорию /var/log хоста, а исключительно файл syslog. Дополнительно, для предотвращения потенциальных проблем с правами доступа к файлу на хосте, будет установлен параметр readOnly.

* <img width="1541" height="331" alt="image" src="https://github.com/user-attachments/assets/aafbf452-51df-41ad-a7ef-ac13c7cbdf69" />
