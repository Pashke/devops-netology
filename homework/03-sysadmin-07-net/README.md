# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
> `ip -c -br link` - linux  
> `ipconfig`, `netsh interface show interface` - win
2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
> Протокол lldp.  
> Пакет lldpd  
> Команда `lldpctl`
3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
> VLAN.  
> Пакет `apt install vlan`. Изменение конфигурации `vi /etc/network/interfaces`.  
> Пример конфига из презентации: 
> ```
> auto vlan1400
> iface vlan1400 inet static
>         address 192.168.1.1
>         netmask 255.255.255.0
>         vlan_raw_device eth0
> 
> auto eth0.1400
> iface eth0.1400 inet static
>         address 192.168.1.1
>         netmask 255.255.255.0
>         vlan_raw_device eth0
> ```
4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
> Типы LAG в презентации: статический и динамический.  
> Гугление подсказывает такие типы (но видимо это ответ на опции): mode=0 (balance-rr), mode=1 (active-backup), mode=2 (balance-xor), mode=3 (broadcast),
> mode=4 (802.3ad), mode=5 (balance-tlb) и mode=6 (balance-alb).  
> Пример конфигурации:
> ```
> # The primary network interface
> auto bond0 eth0 eth1
> # настроим параметры бонд-интерфейса
> iface bond0 inet static
> # адрес, маска, шлюз. (можно еще что-нибудь по вкусу)
>         address 10.0.0.11
>         netmask 255.255.255.0
>         gateway 10.0.0.254
>         # определяем подчиненные (объединяемые) интерфейсы
>         bond-slaves eth0 eth1
>         # задаем тип бондинга
>         bond-mode balance-alb
>         # интервал проверки линии в миллисекундах
> bond-miimon 100
>         # Задержка перед установкой соединения в миллисекундах
> bond-downdelay 200
> # Задержка перед обрывом соединения в миллисекундах
>         bond-updelay 200
> ```
5. Сколько IP адресов в сети с маской /29 ? 
> 6

Сколько /29 подсетей можно получить из сети с маской /24. 
> 32

Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
> 10.10.10.0/29  
> 10.10.10.8/29  
> 10.10.10.16/29   
> ...
6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? 
> 100.64.0.0 — 100.127.255.255 (маска подсети: 255.192.0.0 или /10) Carrier-Grade NAT

Маску выберите из расчета максимум 40-50 хостов внутри подсети.
> /26
7. Как проверить ARP таблицу в Linux, Windows? 
> `arp -a` `ip neigh`

Как очистить ARP кеш полностью? 
> `sudo ip neigh flush all`

Как из ARP таблицы удалить только один нужный IP?
> `arp -d <IP>`


 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

 8*. Установите эмулятор EVE-ng.
 
 Инструкция по установке - https://github.com/svmyasnikov/eve-ng

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng. 
> Не осилил настройку. Как в vmvare вставлять скопированный текст, чтоб облегчить работу, найти не смог. Попытался 
> через putty подключиться, не смог отладить подключение, не хочет коннектиться. С virtualBox было проще подключение.
> Будет больше времени, еще раз попробую.
 ---