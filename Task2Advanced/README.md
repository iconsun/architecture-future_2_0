### Task2Advanced Интеграция Terraform с CI CD и удаленным состоянием

В этой директории находится минимальная конфигурация Terraform с удаленным хранением состояния в S3 совместимом хранилище и примером CI CD пайплайна.

### Структура

Task2Advanced  
main.tf — Terraform конфигурация с примером ресурса null_resource  
backend.tf — настройка backend s3 для хранения terraform.tfstate в удаленном хранилище  
README.md — описание решения

### Настройка backend s3

В файле backend.tf описан backend типа s3.  
Для учебного задания используются тестовые значения

endpoint http://minio 9000  
bucket tf state  
key task2advanced terraform.tfstate  
region us east 1  
access key minioadmin  
secret key minioadmin  

При необходимости значения endpoint bucket и учетные данные можно заменить на настройки Yandex Object Storage или другого S3 совместимого хранилища.

### Локальный запуск Terraform

Перейти в директорию Task2Advanced  

Выполнить инициализацию

```bash
terraform init -reconfigure
terraform plan
terraform apply

