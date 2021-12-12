# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.
> `+`
2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
> Если правильно понимаю, то нет. У файлов будет один inode, на который и настраиваются права. И решил это проверить:
> ![](../../picture/homework_3.5/3.5.2.png)
3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.
> `+`
4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
> ![](../../picture/homework_3.5/3.5.4.png)
5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.
> ![](../../picture/homework_3.5/3.5.5.png)
6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.
> Используемая команда `sudo mdadm --create --verbose /dev/md1 -l 1 -n 2 /dev/sd{b1,c1}`  
> ![](../../picture/homework_3.5/3.5.6.png)
7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
> ![](../../picture/homework_3.5/3.5.7.png)
8. Создайте 2 независимых PV на получившихся md-устройствах.
> ![](../../picture/homework_3.5/3.5.8.png)
9. Создайте общую volume-group на этих двух PV.
> ![](../../picture/homework_3.5/3.5.9.png)
10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
> `lvcreate -L 100M vgtest /dev/md0`  
> ![](../../picture/homework_3.5/3.5.10.png)
11. Создайте `mkfs.ext4` ФС на получившемся LV.
> ![](../../picture/homework_3.5/3.5.11.png)
12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
> ```bash
> root@vagrant:~# mkdir /tmp/new
> root@vagrant:~# mount /dev/vgtest/lvol0 /tmp/new
> ```
> ![](../../picture/homework_3.5/3.5.12.png)
13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
> ![](../../picture/homework_3.5/3.5.13.png)
14. Прикрепите вывод `lsblk`.
> ![](../../picture/homework_3.5/3.5.14.png)
15. Протестируйте целостность файла:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
> ![](../../picture/homework_3.5/3.5.15.png)
16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
> ![](../../picture/homework_3.5/3.5.16.png)
17. Сделайте `--fail` на устройство в вашем RAID1 md.
> `mdadm /dev/md1 --fail /dev/sdb1`
18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
> ![](../../picture/homework_3.5/3.5.18.png)
19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
> ![](../../picture/homework_3.5/3.5.19.png)
20. Погасите тестовый хост, `vagrant destroy`.
> `+`