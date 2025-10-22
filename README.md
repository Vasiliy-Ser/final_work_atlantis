# Дипломный практикум в Yandex.Cloud - Падеев Василий  
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
2. Подготовьте [backend](https://developer.hashicorp.com/terraform/language/backend) для Terraform:    
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)  
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)  
3. Создайте конфигурацию Terrafrom, используя созданный бакет ранее как бекенд для хранения стейт файла. Конфигурации Terraform для создания сервисного аккаунта и бакета и основной инфраструктуры следует сохранить в разных папках.  
4. Создайте VPC с подсетями в разных зонах доступности.  
5. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.  
6. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://developer.hashicorp.com/terraform/language/backend) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий, стейт основной конфигурации сохраняется в бакете или Terraform Cloud  
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.  

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

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:  
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.  
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:  
1. Воспользоваться пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). Альтернативный вариант - использовать набор helm чартов от [bitnami](https://github.com/bitnami/charts/tree/main/bitnami).

### Деплой инфраструктуры в terraform pipeline

1. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:  
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.  
2. Http доступ на 80 порту к web интерфейсу grafana.  
3. Дашборды в grafana отображающие состояние Kubernetes кластера.  
4. Http доступ на 80 порту к тестовому приложению.  
5. Atlantis или terraform cloud или ci/cd-terraform  
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

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нул.  
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.  
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.   
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.  
5. Репозиторий с конфигурацией Kubernetes кластера.  
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.  
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)  

---

## Решение:

Подготовим облачную инфраструктуру в YC. В [в дирректории](https://github.com/Vasiliy-Ser/final_work_atlantis/tree/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/preliminary) опишем создание сервисных аккаунтов с необходимыми ролями, багета с шифрованием KMS, версионированием, и ключа доступа.  
![answer1](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/1.png)  
![answer2](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/2.png)  
![answer3](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/3.png)  
![answer4](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/4.png)  

Используя terraform, в [в дирректории](https://github.com/Vasiliy-Ser/final_work_atlantis/tree/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/implementation) опишем создание сети с помощью [модуля](https://github.com/Vasiliy-Ser/final_work_atlantis/tree/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/modules/vpc) и ВМ используя  используя разные способы. С помощью [модуля](https://github.com/Vasiliy-Ser/final_work_atlantis/tree/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/modules/instance_vm) мы можем создавать ВМ с разными параметрами, будем использовать для мастера (только с приватным адресом) и Bastion (с публичным и приватным адресами). С помощью [модуля](https://github.com/Vasiliy-Ser/final_work_atlantis/tree/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/modules/instance_count) создаются однотипные ВМ Workers и их количество будет равно  длине списка зон указанных в [variables](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/implementation/variables.tf). В итоге кроме вывода в терминал будет создан [hosts](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/kubespray/hosts.yaml) который я в дальнейшем буду использовать для создания кластера с помощью ansible. Также данные о созданной инфраструктуре будут записываться в багет Object Storage. Все ВМ будут находится в одной VPC с ограниченными открытими портами. Подготовим Container Registry для загрузки нашего приложения.  
![answer5](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/5.png)  
![answer6](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/6.png)  
![answer7](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/7.png)  
![answer8](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/8.png)  
![answer9](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/9.png)  

С помощью ansible используя kuberspray и созданный ранее hosts.yaml развернем кластер. Предварительно развернем виртуальное окружение в которое установим все необходимые зависимости и проверим доступность ВМ с помощью ping. Перед установкой в kuberspray можно включить уже встроенные модули MetalLB и/или Ingrass Controller для проброса доступа из кластера. Пробовал, но как их настроить понял позже. После установки kuberspray запускаю созданный мною [playbook](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/src/mycluster/kp_ic_yc.yml) который устанавливает к кластер:  
- kube-prometeus  
- ingress Controller  
- YC  
- настройка Grafana (секреты, MYSQL, дополнения к Deployment (адрес Bastion будет подтягиваться из hosts))   
SQLite, который идет по умолчанию не стал использовать потому, что Grafana полностью не запускалась.  
Запушем созданный образ приложения в Container Registry. На мастере создадим секрет и развернем приложение скаченное из Registry используя [deployment](https://github.com/Vasiliy-Ser/final_work_atlantis/tree/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/k8s).   
С помощью [NetworkPolicy](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/src/networkpolicy.yml) изменю некоторые правила безопасности кластера (устанавливаю вручную):  
- чтобы доступ не блокировался внутри namespace monitoring и ingress-nginx (ingress controller)  
- разрешить доступ из всех подов в monitoring namespace на определенные порты  
- разрешить доступ из всех подов в default на порт 80 где работает наше приложение.  
Чтобы получить доступ с Bastion необходимо применить ingress который я описавл в [playbook](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/src/mycluster/ingress.yml). При обращении к ingress controller я использовал адрес worker на котором он запущен.      
![answer10](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/10.png)  
![answer11](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/11.png)  
![answer12](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/12.png)  
![answer13](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/13.png)  
![answer14](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/14.png)  
![answer15](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/15.png)  
![answer16](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/16.png)  
![answer17](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/17.png)  
![answer18](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/18.png)  

Для доступа к сервисам через публичный адрес Bastion установим nginx и создадим [config](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/src/kube-proxy.conf) удалив конфигурацию которая идет по умолчанию, делаю это вручную.   
![answer20](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/20.png)  
![answer21](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/21.png)  
![answer22](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/22.png)  
![answer23](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/23.png)  

Настроил доступ по 80 порту.  
http://84.252.128.120/atlantis/  
http://84.252.128.120/grafana/   
admin/qwertyuiop  
http://84.252.128.120/app/  

 Примечание. Если доступ с внешнего адреса к приложениям нелоступен, необходимо проверить конфигурацию nginx Bastion и Deployment на мастере, если пришлось что либо изменять, после необходимо перезагружать соответствующие сервисы.  
![answer26](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/26.png)  
![answer24](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/24.png)  

 Для отслеживания изменений инфраструктуры  использую atlantis. В кластере запустим [Deployment + Service](). В Github создадим необходимые секреты, в [pipeline](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/.github/workflows/terraform.yml) опишем следующую логику:  
 - Actions запускается при коммите в дирректории [implementation](https://github.com/Vasiliy-Ser/final_work_atlantis/tree/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/implementation) или самом  [pipeline](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/.github/workflows/terraform.yml)  
 - Проводится инициализация, выводятся проблемные модули если такое есть (у меня возникла рассинхронизация из-за ролей сервисного аккаунта, который не используется, поэтому я эти модули просто удалил). Если проблемные модули встречаются Actions уходит в ошибку, чтобы terraform автоматически ничего не удалил. При успешной проверке выполняются команды plan и apply.  
![answer27](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/27.png)  
![answer28](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/28.png)  
![answer29](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/29.png)  

Для приложения применим похожую логику [pipeline](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/.github/workflows/app.yml). GitHub Actions запускается при коммите в репозиторий [дирректорииили](https://github.com/Vasiliy-Ser/final_work_atlantis/tree/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/docker) или [дирректорииили](https://github.com/Vasiliy-Ser/final_work_atlantis/tree/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/k8s), создании тега. Собирается Docker-образ с тегом latest, подключается kubeconfig (через бастион), деплой в kubernetes (только при теге) и проверка состояния.  
![answer30](https://github.com/Vasiliy-Ser/final_work_atlantis/blob/4ec3a7f7d79d40d7e301e8975a0b5c258bf7d04b/png/30.png)  