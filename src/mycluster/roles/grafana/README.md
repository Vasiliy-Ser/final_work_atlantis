# Role: grafana-mysql

Эта роль:
- создаёт Secret с MySQL-учётными данными для Grafana,
- разворачивает MySQL (Deployment + Service),
- настраивает Grafana на использование внешней базы данных MySQL.

## Переменные

| Переменная | Описание | Значение по умолчанию |
|-------------|-----------|-----------------------|
| grafana_mysql_namespace | Namespace для ресурсов | `monitoring` |
| grafana_mysql_secret_name | Имя секрета | `grafana-mysql-secret` |
| grafana_mysql_database | Имя базы данных | `grafana` |
| grafana_mysql_user | Пользователь MySQL | `grafana` |
| grafana_mysql_password | Пароль MySQL | `grafana123` |
| grafana_mysql_image | Образ MySQL | `mysql:8.0` |
| grafana_mysql_replicas | Количество реплик | `1` |
| grafana_mysql_service_name | Имя сервиса | `grafana-mysql` |
| grafana_mysql_port | Порт MySQL | `3306` |

## Пример использования

```
- hosts: k8s_master
  roles:
    - role: grafana-mysql
      vars:
        grafana_mysql_password: "SuperSecret123"
```

## Автоматический рестарт Grafana

После патча Deployment’a Grafana роль выполняет:
```
kubectl rollout restart deployment grafana -n <namespace>
```