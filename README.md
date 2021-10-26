# devops-netology
1. `**/.terraform/*`  
Добавить в исключение директории .terraform и все что в них находится, даже если директория находится в каких-то других
директориях
2. `*.tfstate` `*.tfstate.*`  
Игнорирование файлов с расширением .tfstate и содержащих в наименование .tfstate.
3. `crash.log`  
Игнорировать файл c логом
4. `*.tfvars`  
Игнорировать файлы с расширением .tfvars, которые судя по описанию содержат пароли, приватные ключи и др файлы.
5. `override.tf` `override.tf.json` `*_override.tf` `*_override.tf.json`  
Игнорировать файлы override.tf и override.tf.json, также содержащие на конце _override.tf и _override.tf.json
6. `.terraformrc` `terraform.rc`  
Игнорировать файлы с расширением .terraformrc и файл terraform.rc