# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

> [docker-compose.yml](docker-compose.yml)

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
> "создание в docker-compose манифест"
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
> ```postgres-psql
> CREATE TABLE orders
> (
>     id serial,
>     "name" char(200),
>     price integer,
>     PRIMARY KEY (id)
> );
> CREATE TABLE clients
> (
>     id serial,
>     surname char(200),
>     country_of_residence char(200),
>     price integer REFERENCES orders (id),
>     PRIMARY KEY (id)
> );
> create index country on clients(country_of_residence);
> ```
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
> ```postgres-psql
> grant all privileges on database test_db to "test-admin-user";
> ```
- создайте пользователя test-simple-user  
> ```postgres-psql
> CREATE USER "test-simple-user" WITH PASSWORD '12345';
> ```
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
> ```postgres-psql
> GRANT SELECT, insert, update, delete on ALL TABLES IN SCHEMA public to "test-simple-user";
> ```

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
> ```postgres-psql
> SELECT datname FROM pg_database;
> ```
> |datname|
> |-----|
> |postgres|
> |template1|
> |template0|
> |test_db|

- описание таблиц (describe)
> ```shell
> test_db=# \d+ clients
>                                                            Table "public.clients"
>         Column        |      Type      | Collation | Nullable |               Default               | Storage  | Stats target | Description 
> ----------------------+----------------+-----------+----------+-------------------------------------+----------+--------------+-------------
>  id                   | integer        |           | not null | nextval('clients_id_seq'::regclass) | plain    |              | 
>  surname              | character(200) |           |          |                                     | extended |              | 
>  country_of_residence | character(200) |           |          |                                     | extended |              | 
>  price                | integer        |           |          |                                     | plain    |              | 
> Indexes:
>     "clients_pkey" PRIMARY KEY, btree (id)
>     "country" btree (country_of_residence)
> Foreign-key constraints:
>     "clients_price_fkey" FOREIGN KEY (price) REFERENCES orders(id)
> Access method: heap
> 
> test_db=# \d+ orders
>                                                     Table "public.orders"
>  Column |      Type      | Collation | Nullable |              Default               | Storage  | Stats target | Description 
> --------+----------------+-----------+----------+------------------------------------+----------+--------------+-------------
>  id     | integer        |           | not null | nextval('orders_id_seq'::regclass) | plain    |              | 
>  name   | character(200) |           |          |                                    | extended |              | 
>  price  | integer        |           |          |                                    | plain    |              | 
> Indexes:
>     "orders_pkey" PRIMARY KEY, btree (id)
> Access method: heap
> ```
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
> ```postgres-psql
> SELECT grantee, table_catalog, table_name, privilege_type
> FROM information_schema.table_privileges
> where table_name in ('orders', 'clients')
> order by 1, 3, 4;
> ```
- список пользователей с правами над таблицами test_db
> | grantee          | table_catalog | table_name | privilege_type |
> |------------------|---------------|------------|----------------|
> | test-admin-user  | test_db       | clients    | DELETE         |
> | test-admin-user  | test_db       | clients    | INSERT         |
> | test-admin-user  | test_db       | clients    | REFERENCES     |
> | test-admin-user  | test_db       | clients    | SELECT         |
> | test-admin-user  | test_db       | clients    | TRIGGER        |
> | test-admin-user  | test_db       | clients    | TRUNCATE       |
> | test-admin-user  | test_db       | clients    | UPDATE         |
> | test-admin-user  | test_db       | orders     | DELETE         |
> | test-admin-user  | test_db       | orders     | INSERT         |
> | test-admin-user  | test_db       | orders     | REFERENCES     |
> | test-admin-user  | test_db       | orders     | SELECT         |
> | test-admin-user  | test_db       | orders     | TRIGGER        |
> | test-admin-user  | test_db       | orders     | TRUNCATE       |
> | test-admin-user  | test_db       | orders     | UPDATE         |
> | test-simple-user | test_db       | clients    | DELETE         |
> | test-simple-user | test_db       | clients    | INSERT         |
> | test-simple-user | test_db       | clients    | SELECT         |
> | test-simple-user | test_db       | clients    | UPDATE         |
> | test-simple-user | test_db       | orders     | DELETE         |
> | test-simple-user | test_db       | orders     | INSERT         |
> | test-simple-user | test_db       | orders     | SELECT         |
> | test-simple-user | test_db       | orders     | UPDATE         |

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.
> ```postgres-psql
> insert into orders (name, price)
> select 'Шоколад', 10
> union select 'Принтер', 3000 
> union select 'Книга', 500
> union select 'Монитор', 7000
> union select 'Гитара', 4000;
> 
> insert into clients (surname, country_of_residence)
> select 'Иванов Иван Иванович', 'USA'
> union select 'Петров Петр Петрович', 'Canada'
> union select 'Иоганн Себастьян Бах', 'Japan'
> union select 'Ронни Джеймс Дио', 'Russia'
> union select 'Ritchie Blackmore', 'Russia';
> 
> commit;
> 
> select 'orders' "table", count(1) from orders
> union
> select 'clients' "table", count(1) from clients;
> ```
> | table   | count |
> |---------|-------|
> | clients | 5     |
> | orders  | 5     |

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

> ```postgres-psql
> update clients 
> set price = (select id 
>             from orders 
>             where name = 'Книга')
> where surname = 'Иванов Иван Иванович';
> 
> update clients 
> set price = (select id 
>             from orders 
>             where name = 'Монитор')
> where surname = 'Петров Петр Петрович';
> 
> update clients 
> set price = (select id 
>             from orders 
>             where name = 'Гитара')
> where surname = 'Иоганн Себастьян Бах';
> 
> select surname, o.name, o.price
> from clients c
> join orders o on c.price = o.id;
> ```
> | surname              | name    | price |
> |----------------------|---------|-------|
> | Иоганн Себастьян Бах | Гитара  | 4000  |
> | Иванов Иван Иванович | Книга   | 500   |
> | Петров Петр Петрович | Монитор | 7000  |

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

> ```
> QUERY PLAN  
> Hash Join  (cost=1.11..12.40 rows=5 width=1612)  
>   Hash Cond: (o.id = c.price)
>   ->  Seq Scan on orders o  (cost=0.00..10.90 rows=90 width=812)
>   ->  Hash  (cost=1.05..1.05 rows=5 width=808)
>         ->  Seq Scan on clients c  (cost=0.00..1.05 rows=5 width=808)
> ```
> cost - затратность операции  
> rows - количество возвращаемых строк  
> width - средний размер одной строки в байтах  
> Seq Scan — последовательное, блок за блоком, чтение данных таблицы  
> сначала данные берутся из таблицы clients, выгружаются в память, далее берутся данные из таблицы orders и происходит
> объединение по (o.id = c.price)

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

> создание бэкапа
> ```shell
> pg_dump -U test-admin-user -W test_db > /data/bd_backup/test_db.dump
> ```
> восстановление из бэкапа
> ```shell
> psql -U test-admin-user -W test_db < /data/bd_backup/test_db.dump 
> ```