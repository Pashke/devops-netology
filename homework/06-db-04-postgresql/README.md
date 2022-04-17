# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
> [docker-compose.yml](docker-compose.yml)

Подключитесь к БД PostgreSQL используя `psql`.
> ```
> psql -h postgres_container -p 5432 -U test
> ```

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.
> [ссылочка](https://postgrespro.ru/docs/postgresql/9.6/app-psql) для себя с подробным описанием команд

**Найдите и приведите** управляющие команды для:
- вывода списка БД
> ```postgres-psql
> test-#  \l
>                              List of databases
>    Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
> -----------+-------+----------+------------+------------+-------------------
>  postgres  | test  | UTF8     | en_US.utf8 | en_US.utf8 | 
>  template0 | test  | UTF8     | en_US.utf8 | en_US.utf8 | =c/test          +
>            |       |          |            |            | test=CTc/test
>  template1 | test  | UTF8     | en_US.utf8 | en_US.utf8 | =c/test          +
>            |       |          |            |            | test=CTc/test
>  test      | test  | UTF8     | en_US.utf8 | en_US.utf8 | 
> (4 rows)
> ```
- подключения к БД
> ```postgres-psql
> test-#  \c postgres
> Password: 
> You are now connected to database "postgres" as user "test".
> ```
- вывода списка таблиц
> `\dt` - вывод списка, по умолчанию выводит список таблиц созданных пользователем. Добавлю `S`, чтоб вывел все таблицы
> ```postgres-psql
> postgres-# \dtS
>                   List of relations
>    Schema   |          Name           | Type  | Owner 
> ------------+-------------------------+-------+-------
>  pg_catalog | pg_aggregate            | table | test
>  pg_catalog | pg_am                   | table | test
>  pg_catalog | pg_amop                 | table | test
>  pg_catalog | pg_amproc               | table | test
>  ...
>  pg_catalog | pg_user_mapping         | table | test
> (62 rows)
> ```
- вывода описания содержимого таблиц
> `\d`
> ```postgres-psql
> postgres-# \dS pg_aggregate
>                Table "pg_catalog.pg_aggregate"
>       Column      |   Type   | Collation | Nullable | Default 
> ------------------+----------+-----------+----------+---------
>  aggfnoid         | regproc  |           | not null | 
>  aggkind          | "char"   |           | not null | 
>  aggnumdirectargs | smallint |           | not null | 
> ...
>  aggminitval      | text     | C         |          | 
> Indexes:
>     "pg_aggregate_fnoid_index" UNIQUE, btree (aggfnoid)
> ```
- выхода из psql
> `\q`

## Задача 2

Используя `psql` создайте БД `test_database`.
> ```postgres-psql
> test=# CREATE DATABASE test_database;
> CREATE DATABASE 
> ```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
> Так как создавал в docker compose манифесте своего пользователя, подменил на него в дампе владельца  
> ```
> psql -U test -W test_database < /data/bd_backup/test_dump.sql
> ```

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
> Отсортировал по avg_width в порядке убывания
> ```postgres-psql
> test_database=# select attname, avg_width from pg_stats where tablename = 'orders' order by 2 desc;
>  attname | avg_width 
> ---------+-----------
>  title   |        16
>  id      |         4
>  price   |         4
> (3 rows)
> ```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
> ```postgres-psql
> test_database=# start transaction;
> START TRANSACTION
> test_database=*# CREATE TABLE orders_1 ( CHECK (price > 499) ) INHERITS (orders);
> CREATE TABLE
> test_database=*# CREATE TABLE orders_2 ( CHECK (price <= 499) ) INHERITS (orders);
> CREATE TABLE
> test_database=*# create rule orders_insert_to_1 as on insert to orders where (price > 499) do instead insert into orders_1 values (new.*);
> CREATE RULE
> test_database=*# create rule orders_insert_to_2 as on insert to orders where (price <= 499) do instead insert into orders_2 values (new.*);
> CREATE RULE
> test_database=*# insert into orders select * from orders;
> INSERT 0 0
> test_database=*# select * from orders_1;
>  id |       title        | price 
> ----+--------------------+-------
>   2 | My little database |   500
>   6 | WAL never lies     |   900
>   8 | Dbiezdmin          |   501
> (3 rows)
> 
> test_database=*# delete from only orders;
> DELETE 8
> test_database=*# end transaction;
> COMMIT
> test_database=# select * from only orders;
>  id | title | price 
> ----+-------+-------
> (0 rows)
> 
> test_database=# select * from orders;
>  id |        title         | price 
> ----+----------------------+-------
>   2 | My little database   |   500
>   6 | WAL never lies       |   900
>   8 | Dbiezdmin            |   501
>   1 | War and peace        |   100
>   3 | Adventure psql time  |   300
>   4 | Server gravity falls |   300
>   5 | Log gossips          |   123
>   7 | Me and my bash-pet   |   499
> (8 rows)
> 
> ```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
> Да, можно было заложить создание секционированной таблицы с использованием `PARTITION BY`.

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.
> ```
> pg_dump -U test test_database > /data/bd_backup/test_db.sql
> ```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?
> Можно добавить `UNIQUE` к столбцу `title`, но есть вероятность, что столбец в дампе неуникален и восстановление 
> для данной таблицы не пройдет. В нашем же примере можно спокойно добавлять `UNIQUE`