# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.
> mysql -u root -p db < /data/bd_backup/test_dump.sql

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.
> \s   
> Server version:         8.0.28 MySQL Community Server - GPL

Подключитесь к восстановленной БД и получите список таблиц из этой БД.
> ```
> mysql> SHOW TABLES from db;
> +--------------+
> | Tables_in_db |
> +--------------+
> | orders       |
> +--------------+
> 1 row in set (0.00 sec)
> ```  

**Приведите в ответе** количество записей с `price` > 300.
> ```
> mysql> select count(1) from orders where price > 300;
> +----------+
> | count(1) |
> +----------+
> |        1 |
> +----------+
> 1 row in set (0.00 sec)
> ```

В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"
> ```
> mysql> CREATE USER test@localhost IDENTIFIED WITH mysql_native_password BY 'test-pass'
>     -> PASSWORD EXPIRE INTERVAL 180 DAY
>     -> FAILED_LOGIN_ATTEMPTS 3;
> Query OK, 0 rows affected (0.08 sec)
> 
> mysql> ALTER USER test@localhost WITH MAX_QUERIES_PER_HOUR 100;
> Query OK, 0 rows affected (0.09 sec)
> 
> mysql> ALTER USER test@localhost ATTRIBUTE '{"name": "James", "surname": "Pretty"}';
> Query OK, 0 rows affected (0.12 sec)
> ```

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
> ```
> mysql> grant select on db.* to test@localhost;
> Query OK, 0 rows affected, 1 warning (0.12 sec)
> ```

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.
> ```
> mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user = 'test';
> +------+-----------+----------------------------------------+
> | USER | HOST      | ATTRIBUTE                              |
> +------+-----------+----------------------------------------+
> | test | localhost | {"name": "James", "surname": "Pretty"} |
> +------+-----------+----------------------------------------+
> 1 row in set (0.00 sec)
> ```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.
> ```
> mysql> SHOW CREATE TABLE orders;
> +--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
> | Table  | Create Table                                                                                                                                                                                                                              |
> +--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
> | orders | CREATE TABLE `orders` (
>   `id` int unsigned NOT NULL AUTO_INCREMENT,
>   `title` varchar(80) NOT NULL,
>   `price` int DEFAULT NULL,
>   PRIMARY KEY (`id`)
> ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
> +--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
> 1 row in set (0.01 sec)
> ```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`
> ```
> mysql> SHOW PROFILES;
> +----------+------------+----------------------------------+
> | Query_ID | Duration   | Query                            |
> +----------+------------+----------------------------------+
> |        1 | 0.00014625 | SET profiling = 1                |
> ...
> |        8 | 0.00039050 | SHOW CREATE TABLE orders         |
> |        9 | 0.83084875 | ALTER TABLE orders ENGINE=MyISAM |
> |       10 | 1.22524250 | ALTER TABLE orders ENGINE=InnoDB |
> +----------+------------+----------------------------------+
> 10 rows in set, 1 warning (0.00 sec)
> ```


## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

> ```
> [mysqld]
> pid-file        = /var/run/mysqld/mysqld.pid
> socket          = /var/run/mysqld/mysqld.sock
> datadir         = /var/lib/mysql
> secure-file-priv= NULL
> 
> innodb_flush_log_at_trx_commit = 2
> innodb_file_per_table=1
> innodb_log_buffer_size = 1M
> innodb_buffer_pool_size = 4800M
> innodb_log_file_size = 100M
> ```