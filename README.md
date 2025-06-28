![структура проєкту](image.png)

main.tf — головний файл для виклику модулів.

backend.tf — конфігурація віддаленого бекенду (S3 + DynamoDB).

outputs.tf — вивід результатів з усіх модулів.

modules/ — каталог з модулями:

- s3-backend/ — модуль для створення S3 бакету та DynamoDB для Terraform бекенду.

- vpc/ — модуль для створення VPC, маршрутів тощо.

- ecr/ — модуль для створення ECR репозиторію з політикою доступу.

Команди для ініціалізації запуску

```hcl
terraform init
terraform plan
terraform apply
terraform destroy
```
