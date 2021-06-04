### Hexlet tests and linter status:
[![Actions Status](https://github.com/mxpatlas/devops-for-programmers-project-lvl2/workflows/hexlet-check/badge.svg)](https://github.com/mxpatlas/devops-for-programmers-project-lvl2/actions)


# Реализация проекта 2: деплой redmine при помощи ansible

## Целевая конфигурация

* Два сервера в Digital Ocean (бекенды redmine)
* Один сервер с базой данных Postgres (сервер поднят через Digital Ocean), мы испольузем готовые
  данные для доступа в базу
* Один балансировщик (средствами Digital Ocean) с пробросом портов 80 и 443 в бекенды redmine

redmine запускается в виде docker-контейнера на каждом бекенде

## Требования

* Для деплоя используется ansible 2.9


## Подготовка к деплою

1. Скачать или обновить из git репозиторий https://github.com/mxpatlas/devops-for-programmers-project-lvl2
2. Часть переменных зашифрована. Для деплоя нужно знать пароль для ansible-vault, в этом проекте 
   предполагается простой шаринг пароля между всеми разработчиками и админами которые его используют
   Плейбук ожидает что пароль лежит в `$HOME/.secret/vault.do_mxpatlas`
   При первом запуске необходимо этот файл создать, записать туда пароль, и выставить права доступа
   на чтение только для владельца:
	 ```bash
	 mkdir ~/.secret
	 chmod 0700 ~/.secret
	 touch ~/.secret/vault.do_mxpatlas
	 chmod 0600 ~/.secret/vault.do_mxpatlas
	 ```
   Имя файла с паролем можно использовать свое, для этого надо при запуске make переопределить 
   переменную `VAULT_PASS_FILE`
3. Необходимо настроить авторизацию для всех серверов перечисленных в ./inventory. Если 
используется нестандартное имя ключа, его необходимо прописать для нужных хостов 
через ~/.ssh/config


## Деплой

Деплой на все сервера перечисленные в inventory
```
make deploy
```

Деплой на конкретный узел
```
make ANSIBLE_LIMIT="node1" deploy
```

Дополнительные флаги для ansible-playbook можно передать через `ANSIBLE_PLAYBOOK_FLAGS`
```
make ANSIBLE_PLAYBOOK_FLAGS="--tags redmine" ANSIBLE_LIMIT="node1" deploy
```
Пример переопределения имени файла с паролем для vault
```
make VAULT_PASS_FILE="./my_password" deploy
```

## При необходимости обновить код коллекции из Ansible Galaxy

1. Прописываем изменения в `requirements.txt`
2. Запускаем `make vendor-galaxy`


