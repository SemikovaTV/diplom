# Дипломный практикум в Yandex.Cloud
# Выполнила студентка группы FOPS-9 Семикова Т.В
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)  
3. Создайте VPC с подсетями в разных зонах доступности.
4. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
5. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

### Ответ

#### Конфигурация системы:
```bash
Ubuntu 24.04
Yandex Cloud CLI 0.130.0 linux/amd64
Terraform v1.5.5
ansible [core 2.16.3]
python version = 3.12.3
kubectl v1.30.0
```
1. Создаю сервисный аккаунт и выдаю ему роль:

![изображение](https://github.com/user-attachments/assets/8e13d627-2ef6-4b43-b5e4-d5bcc964fc24)

![изображение](https://github.com/user-attachments/assets/72371671-6e09-412c-929d-fc22cb8d5069)

2. Подготавливаю backend для terraform, буду использовать рекомендованный вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)

![изображение](https://github.com/user-attachments/assets/22033844-1836-42d3-8ac1-511f0ea4479a)

3. Создаю VPC с подсетями в разных зонах доступности:

![image](https://github.com/user-attachments/assets/3d4cea6f-3d9c-45cd-8d4f-1b209971ca94)


4. Повторное выполнение команды `terraform apply` :

![изображение](https://github.com/user-attachments/assets/242f2e6b-b7e4-41fe-bef0-b1a35cde5f04)



---
### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.


### Ответ
Создаю три виртуальных машины в разных зонах доступности:

![image](https://github.com/user-attachments/assets/b498b949-9929-4bad-a0bd-0a2d68e616da)

Для подготовки ansible-конфигурации буду использовать kubespray. Для этого подниму еще одну виртуальную машину в одной подсети с будущим master:

![image](https://github.com/user-attachments/assets/8a211174-9964-4bdd-89aa-b4088ffd3e07)

Устанавливаю kubespray, передаю внутренние ip-адреса будущих нод, запускаю ansible-playbook для развертывания кластера:

![изображение](https://github.com/user-attachments/assets/0e96d86e-d944-48f5-96c4-2463833d59e7)

Cоздаю директорию для хранения файла конфигурации, копирую конфигурационный файл Kubernetes созданную директорию и назначаю права для пользователя на директорию и файл конфигурации.

![image](https://github.com/user-attachments/assets/10c08b78-2363-43e3-a4ce-62e943d4c755)

Проверяю состояние кластера:

![image](https://github.com/user-attachments/assets/0920c67a-6956-4656-885b-0240fd9e1c60)

Поды и ноды кластера доступны и находятся в состоянии готовности.

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.
3. 





![изображение](https://github.com/user-attachments/assets/0b40dc7d-ca9b-4650-95df-8a30a17176fd)

![изображение](https://github.com/user-attachments/assets/ffe112c4-0016-4225-b6be-d5a6e46ae38e)

![image](https://github.com/user-attachments/assets/12337051-7bc8-4fbb-84a8-64f024b33094)

![image](https://github.com/user-attachments/assets/061e21e4-1d5a-47dc-9474-efce88ee9fba)


![image](https://github.com/user-attachments/assets/47edca0f-54e9-4afe-8d9e-72ed0b7d6623)


[Git репозиторий с тестовым приложением и Dockerfile](https://github.com/SemikovaTV/test_app)




---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользоваться пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). Альтернативный вариант - использовать набор helm чартов от [bitnami](https://github.com/bitnami/charts/tree/main/bitnami).

2. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ к тестовому приложению.

### Ответ

Подключаюсь к master-node, создаю namespace monitoring:

![изображение](https://github.com/user-attachments/assets/d89edbae-36bd-4ab8-9d24-20f43a82ea0b)

добавляю и обновляю helm репозиторий prometheus-community:

![изображение](https://github.com/user-attachments/assets/c698b7bc-8d1b-4308-bf83-eb81baced070)

Устанавливаю helm репозиторий и проверяю:

![изображение](https://github.com/user-attachments/assets/23c59266-7d2d-4a7d-9ab5-caba4a0b9283)

![изображение](https://github.com/user-attachments/assets/2dad785a-47a7-4d82-a194-d8c26e52a4a5)

![изображение](https://github.com/user-attachments/assets/b29e3537-2ece-4f7e-9cf6-89c41497506f)


Вижу, что сервисы stble-grafana и stble-kube-prometheus-stac-prometheus имеют формат ClusterIP и не будут мне доступны из интернета, поэтому меняю им значения на NodePort:

stble-grafana:
```
ubuntu@master:~$ kubectl edit svc stble-grafana -n monitoring
service/stble-grafana edited
```

![изображение](https://github.com/user-attachments/assets/9d462716-b7ad-4b3d-80bc-a4e07cae22c7)


stale-kube-prometheus-stac-prometheus:

```
ubuntu@master:~$ kubectl edit svc stble-kube-prometheus-stac-prometheus -n monitoring
service/stble-kube-prometheus-stac-prometheus edited
```

![изображение](https://github.com/user-attachments/assets/7723e639-51fc-41d7-89f8-92f3d032b5a9)


Результат:

![изображение](https://github.com/user-attachments/assets/30e71d3c-61b5-4fe6-96a5-0663b8bfaf8e)


Проверяю:

Grafana:

![изображение](https://github.com/user-attachments/assets/2a83a1c2-9206-42e3-a1a1-a5bd7264a286)

Prometheus:

![изображение](https://github.com/user-attachments/assets/94ac48f6-0f97-477e-b5bf-b213d50e9172)

После настройки системы монтиторинга перехожу к к деплою тестового приложения:

Создаю namespace:

![изображение](https://github.com/user-attachments/assets/f61540e5-6541-4f70-84b2-a00aa831a0d0)

Поскольку я использую Yandex Container Registry - создам secret и передам кластеру данные для авторизации:
```
ubuntu@master:~$ kubectl create secret generic regcred --from-file=.dockerconfigjson=.docker/config.json  --type=kubernetes.io/dockerconfigjson -n testapp 
secret/regcred created
```

Пишу манифест deployment.yaml:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: testapp
  labels:
    app: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: cr.yandex/crp0vhgidss6m2b770o3/myapp:test
        resources:
          requests:
            cpu: "1"
            memory: "200Mi"
          limits:
            cpu: "2"
            memory: "400Mi"
        ports:
        - containerPort: 80
      imagePullSecrets:
      - name: regcred
```
Применяю конфигурацию и проверяю, что поды запущены:

![изображение](https://github.com/user-attachments/assets/d1156dad-5246-4435-86ce-ffaf714b41ff)

![изображение](https://github.com/user-attachments/assets/92c15733-d5b9-4301-924d-90af7577c498)

Подключусь к поду и проверю, что приложение работает:

![изображение](https://github.com/user-attachments/assets/325f76e2-b30f-415c-a7b7-79981174cc53)

Теперь напишу манифест сервиса с типом NodePort для доступа к приложению извне:
```
apiVersion: v1
kind: Service
metadata:
  name: web-service
  namespace: testapp
spec:
  type: NodePort
  selector:
    app: web
  ports:
  - protocol: TCP
    port: 80
    nodePort: 31122
```
Применяю и проверяю:
```
ubuntu@master:~$ kubectl apply -f svc.yaml -n testapp 
service/web-service created
ubuntu@master:~$ kubectl get service -n testapp 
NAME          TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
web-service   NodePort   10.233.22.203   <none>        80:31122/TCP   16s
```
Проверяю на нодах:

![изображение](https://github.com/user-attachments/assets/5ff41fe2-438a-4c60-9560-ac30acee6a54)

![изображение](https://github.com/user-attachments/assets/03ae10ed-1bcb-4cd6-85ee-853727b3b0d7)

Приложение доступно на всех нодах кластера.





---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

### Ответ

Для выполнения данного задания буду использоавть Jenkins.

![image](https://github.com/user-attachments/assets/86d1757e-892b-4025-a089-f16e07e70ce9)

![image](https://github.com/user-attachments/assets/65bf412b-58a2-4515-9bd6-2345fabdb475)

![image](https://github.com/user-attachments/assets/342f43c8-9821-4c41-934b-f3b6427e679d)

![image](https://github.com/user-attachments/assets/f18cba9c-430e-4e25-a542-1e684f83a42d)

![Без имени](https://github.com/user-attachments/assets/72abead6-0d8a-4976-bf72-d3b05b7d56f8)

```
ubuntu@master:~$ kubectl create namespace runner
namespace/runner created
```

```
ubuntu@master:~$ kubectl --namespace=runner create secret generic runner-secret --from-literal=runner-registration-token="gitlab_token" --from-literal=runner-token="gitlab_token"
```
![image](https://github.com/user-attachments/assets/0ea322e3-719f-4f53-8059-7ca28d49d4b1)

Создам файл values.yml (добавь ссылку)

![image](https://github.com/user-attachments/assets/de15c3cb-fe55-48ca-be78-ee739acabfa3)

![image](https://github.com/user-attachments/assets/fc02f968-6116-48c5-8177-ce958444d7a0)

![image](https://github.com/user-attachments/assets/2bcad30f-9bbb-40a4-bf58-2e29ce76b896)







---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)
