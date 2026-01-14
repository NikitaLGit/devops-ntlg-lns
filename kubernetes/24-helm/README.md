Создадим `helm chart`
<img width="1007" height="435" alt="image" src="https://github.com/user-attachments/assets/4f34a8b0-b9df-4ed3-af13-662f0eef4951" />

В `values.yaml` укажем основные переменные 

```yaml
replicaCount: 1

image:
  repository: nginx
  tag: "1.25"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80
```

Проверим чарт
<img width="980" height="111" alt="image" src="https://github.com/user-attachments/assets/87d0c83e-b59c-4104-8088-c83bfa46fbf5" />

создадим 2 namespace
<img width="953" height="75" alt="image" src="https://github.com/user-attachments/assets/5efb0d5d-455a-444a-92f9-a619a6c094bc" />

запустим первую версию приложения 
<img width="1349" height="244" alt="image" src="https://github.com/user-attachments/assets/b65fe494-3789-4a04-9761-b62d21f66a4c" />

И вторую
<img width="1342" height="246" alt="image" src="https://github.com/user-attachments/assets/5938688d-b7e4-4d17-8690-95871aa07d40" />

Третью версию для второго namespace
<img width="1346" height="244" alt="image" src="https://github.com/user-attachments/assets/c5992706-549e-481a-a87e-3240da1249f2" />

Проверим верность
<img width="1154" height="117" alt="image" src="https://github.com/user-attachments/assets/45e07f0b-1463-4374-9503-72a3d0166932" />
<img width="1108" height="115" alt="image" src="https://github.com/user-attachments/assets/9ca28df6-6c0f-49c5-9e86-d009be25d7a2" />
<img width="1354" height="205" alt="image" src="https://github.com/user-attachments/assets/743773b8-bda3-45d8-bce8-5b06bab22bae" />

Все верно
