README.md

## Zabbix


Запуск playbook`а 

```
ansible-playbook site.yml -i inventory/hosts

```

`tags` для запуска отдельных play из плейбука

--tags epel,package ( добавление epel-release, обновление пакетов )

--tags httpd,vim,curl ( запуск уставноки HTTPD сервера )

--tags service ( стартовать сервис httpd )

--tags j2 ( формирование index.html ) 


P/S сделать еще в плейбуке `enable` сервиса.
