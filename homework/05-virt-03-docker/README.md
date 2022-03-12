
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Сценарий выполнения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.
> https://hub.docker.com/repository/docker/pashke88/devops-netology
> ```shell
> docker run -p 8080:80 pashke88/devops-netology
> ```
## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? 
Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и 
две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

> Мне кажется, что здесь подходит docker контейнеры. Все сервисы будут работать отдельно, не влияя друг на друга, например 
> при нестабильной работе одной из частей. Легко можно разворачивать и обновлять. Поддерживает идемпотентность.

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

```shell
# создаем первый контейнер
$ docker run -dit -P --name centos-test -v ~/data:/data centos

# второй контейнер
$ docker run -dit -P --name debian-test -v ~/data:/data debian

#подключаемся к первому и создаем текстовый файл
$ docker exec -it centos-test /bin/bash
[root@e39a0595f061 /]# echo "blablabla" > /data/centos.txt
[root@e39a0595f061 /]# exit

#в хостовой машине 
$ echo "test" > ~/data/host.txt

#подключаемся ко второму и смотрим файлы
$ docker exec -it debian-test /bin/bash
root@6f0c0632e824:/# cd /data/
root@6f0c0632e824:/data# ls -la
total 16
drwxrwxr-x 2 1000 1000 4096 Mar 12 15:32 .
drwxr-xr-x 1 root root 4096 Mar 12 15:27 ..
-rw-r--r-- 1 root root   10 Mar 12 15:31 centos.txt
-rw-rw-r-- 1 1000 1000    5 Mar 12 15:32 host.txt
root@6f0c0632e824:/data# cat *
blablabla
test
```
## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

> https://hub.docker.com/repository/docker/pashke88/05-virt-03-docker-4
> ```shell
> $ docker run pashke88/05-virt-03-docker-4
> ansible-playbook 2.9.24
>   config file = None
>   configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
>   ansible python module location = /usr/lib/python3.9/site-packages/ansible
>   executable location = /usr/bin/ansible-playbook
>   python version = 3.9.5 (default, Nov 24 2021, 21:19:13) [GCC 10.3.1 20210424]
> ```