### Task1Advanced Модульная инфраструктура для нескольких сред

Этот каталог содержит переиспользуемый модуль Terraform для создания виртуальной машины в Yandex Cloud и три окружения dev stage prod которые используют один и тот же модуль с разными конфигурациями.

Модуль создаёт виртуальную машину на основе образа Ubuntu подключает загрузочный диск настраивает сетевой интерфейс в указанный подсети и добавляет доступ по SSH через публичный ключ.

### Структура проекта

Task1Advanced  
  modules  
    vm  
      main.tf        описание ресурсов виртуальной машины диск сеть  
      variables.tf   входные параметры модуля  
      outputs.tf     выходные значения модуля  
  envs  
    dev  
      main.tf        использование модуля vm в окружении dev  
      variables.tf   описание переменных окружения dev  
      dev.tfvars     значения переменных для dev  
      outputs.tf     выходные значения окружения dev  
    stage  
      main.tf        использование модуля vm в окружении stage  
      variables.tf   описание переменных окружения stage  
      stage.tfvars   значения переменных для stage  
      outputs.tf     выходные значения окружения stage  
    prod  
      main.tf        использование модуля vm в окружении prod  
      variables.tf   описание переменных окружения prod  
      prod.tfvars    значения переменных для prod  
      outputs.tf     выходные значения окружения prod  



### Модуль vm входные параметры

Файлы модуля находятся в каталогe

Task1Advanced modules vm

Входные переменные модуля

1. vm_name  
   Имя виртуальной машины. Используется как имя ресурса в Yandex Cloud.

2. cores  
   Количество ядер vCPU для виртуальной машины. Числовое значение.

3. memory  
   Объем оперативной памяти в гигабайтах. Числовое значение.

4. disk_size  
   Размер загрузочного диска в гигабайтах. Числовое значение.

5. subnet_id  
   Идентификатор подсети VPC в которой будет создан сетевой интерфейс виртуальной машины.

6. ssh_public_key  
   Публичный SSH ключ целиком одной строкой. Используется для настройки доступа по SSH через метаданные ssh keys.

Все эти переменные объявлены в файле modules vm variables tf и используются в файле modules vm main tf. Благодаря этому модуль можно переиспользовать для разных окружений с разными параметрами.

### Модуль vm создаваемые ресурсы

Модуль создаёт

1. data yandex_compute_image ubuntu  
   Поиск актуального образа Ubuntu по семейству ubuntu 2204 lts.

2. resource yandex_compute_instance vm  
   Виртуальная машина Yandex Compute с параметрами  
   количество ядер из переменной cores  
   объем памяти из переменной memory  
   загрузочный диск с размером disk_size и типом network hdd  
   сетевой интерфейс в подсети subnet_id с включенным NAT  
   метаданные ssh keys с пользователем ubuntu и ключом ssh_public_key  

### Модуль vm выходные значения

Файл modules vm outputs tf возвращает полезные выходы

1. vm_id  
   Идентификатор созданной виртуальной машины.

2. vm_name  
   Имя виртуальной машины.

3. vm_ip_address  
   Внешний IP адрес виртуальной машины полученный из сетевого интерфейса с NAT.

4. boot_disk_id  
   Идентификатор загрузочного диска виртуальной машины.

Эти значения затем прокидываются наружу окружениями dev stage prod через собственные outputs tf.

### Окружения dev stage prod

Каждое окружение находится в своём каталоге

Task1Advanced envs dev  
Task1Advanced envs stage  
Task1Advanced envs prod  

Внутри каждого окружения находится одинаковый набор файлов

1. main tf  
   Описывает провайдера Yandex Cloud и подключает модуль vm.

   Провайдер использует переменные yc_token cloud_id folder_id zone например

   provider "yandex"  
     token     равен var yc_token  
     cloud_id  равен var cloud_id  
     folder_id равен var folder_id  
     zone      равен var zone  

   Модуль vm подключается так

   module "vm"  
     source        равно "../../modules/vm"  
     vm_name        равно var vm_name  
     cores          равно var cores  
     memory         равно var memory  
     disk_size      равно var disk_size  
     subnet_id      равно var subnet_id  
     ssh_public_key равно var ssh_public_key  

2. variables tf  
   Описывает входные переменные корневого модуля окружения. В окружении объявлены переменные

   1. yc_token строка токен для доступа к Yandex Cloud  
   2. cloud_id строка идентификатор облака  
   3. folder_id строка идентификатор каталога  
   4. zone строка зона по умолчанию например ru central1 a  
   5. vm_name имя виртуальной машины  
   6. cores количество ядер  
   7. memory объем памяти  
   8. disk_size размер диска  
   9. subnet_id идентификатор подсети  
   10. ssh_public_key публичный SSH ключ  

3. outputs tf  
   Прокидывает выходы модуля наружу чтобы их можно было получить командой terraform output

   Примеры output блоков

   output "vm_id" значение module vm vm_id  
   output "vm_name" значение module vm vm_name  
   output "vm_ip_address" значение module vm vm_ip_address  
   output "boot_disk_id" значение module vm boot_disk_id  

4. файл переменных окружения tfvars  
   dev dev tfvars  
   stage stage tfvars  
   prod prod tfvars  

   В файле tfvars задаются конкретные значения переменных для окружения включая токен идентификаторы облака и каталога параметры виртуальной машины и subnet id. В учебных целях токен может быть указан прямо в файле tfvars с пометкой что в реальных проектах так делать не рекомендуется.

### Отличия окружений через tfvars

Модуль vm во всех окружениях один и тот же. Различия между dev stage prod задаются только содержимым файлов tfvars.

Пример возможных значений

Окружение dev  
  vm_name   sprint11 dev vm  
  cores     2  
  memory    2  
  disk_size 20  

Окружение stage  
  vm_name   sprint11 stage vm  
  cores     4  
  memory    4  
  disk_size 40  

Окружение prod  
  vm_name   sprint11 prod vm  
  cores     4  
  memory    8  
  disk_size 80  

Идентификатор подсети subnet_id и SSH ключ ssh_public_key в учебной задаче могут быть одинаковыми для всех трёх окружений.

### Настройка провайдера Yandex Cloud

Провайдер yandex в окружениях использует значения из переменных yc_token cloud_id folder_id zone которые задаются в соответствующем tfvars. Эти значения можно скопировать из команды

yc config list  

Допускается для учебного задания передавать token cloud id folder id через tfvars. В реальных проектах рекомендуется использовать переменные окружения и не хранить токен в системе контроля версий.

### Как запускать Terraform для разных окружений

Перед первым запуском инициализировать Terraform для каждого окружения

terraform -chdir=envs/dev init  
terraform -chdir=envs/stage init  
terraform -chdir=envs/prod init  

Применение конфигурации для окружений

Окружение dev  

terraform -chdir=envs/dev plan  -var-file="dev.tfvars"  
terraform -chdir=envs/dev apply -var-file="dev.tfvars"  

Окружение stage  

terraform -chdir=envs/stage plan  -var-file="stage.tfvars"  
terraform -chdir=envs/stage apply -var-file="stage.tfvars"  

Окружение prod  

terraform -chdir=envs/prod plan  -var-file="prod.tfvars"  
terraform -chdir=envs/prod apply -var-file="prod.tfvars"  

### Как посмотреть выходные значения

После успешного применения конфигурации можно вывести выходные значения для каждого окружения

terraform -chdir=envs/dev output  
terraform -chdir=envs/stage output  
terraform -chdir=envs/prod output  

Команда показывает идентификатор виртуальной машины ее имя внешний IP и идентификатор диска для выбранного окружения.

### Как удалить созданные ресурсы

Чтобы не тратить ресурсы после проверки задания можно удалить виртуальные машины для всех окружений

terraform -chdir=envs/dev destroy   -var-file="dev.tfvars"  
terraform -chdir=envs/stage destroy -var-file="stage.tfvars"  
terraform -chdir=envs/prod destroy  -var-file="prod.tfvars"  

После этого все созданные ресурсы будут удалены а модуль и конфигурация останутся в репозитории для повторного использования.
