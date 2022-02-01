
Создайте пользователя на мастере, а затем перейдите в его домашнюю директорию для выполнения остальных шагов:

```
useradd jean && cd /home/jean
```
Создайте закрытый ключ:

```
openssl genrsa -out jean.key 2048
```
Создайте запрос на подпись сертификата (certificate signing request, CSR). CN — имя пользователя, O — группа. Можно устанавливать разрешения по группам. Это упростит работу, если, например, у вас много пользователей с одинаковыми полномочиями:

```
# Без группы
openssl req -new -key jean.key \
-out jean.csr \
-subj "/CN=jean"

# С группой под названием $group
openssl req -new -key jean.key \
-out jean.csr \
-subj "/CN=jean/O=$group"

# Если пользователь входит в несколько групп
openssl req -new -key jean.key \
-out jean.csr \
-subj "/CN=jean/O=$group1/O=$group2/O=$group3"
```

Подпишите CSR в Kubernetes CA. Мы должны использовать сертификат CA и ключ, которые обычно находятся в /etc/kubernetes/pki. Сертификат будет действителен в течение 500 дней:

```
openssl x509 -req -in jean.csr \
-CA /etc/kubernetes/pki/ca.crt \
-CAkey /etc/kubernetes/pki/ca.key \
-CAcreateserial \
-out jean.crt -days 500
```

Создайте каталог .certs. В нем мы будем хранить открытый и закрытый ключи пользователя:

```
mkdir .certs && mv jean.crt jean.key .certs
```

Создайте пользователя внутри Kubernetes:

```
kubectl config set-credentials jean \
--client-certificate=/home/jean/.certs/jean.crt \
--client-key=/home/jean/.certs/jean.key
```

Задайте контекст для пользователя:

```
kubectl config set-context jean-context \
--cluster=kubernetes --user=jean
```

Отредактируйте файл конфигурации пользователя. В нем содержится информация, необходимая для аутентификации в кластере. Можно воспользоваться файлом конфигурации кластера, который обычно лежит в /etc/kubernetes: переменные certificate-authority-data и server должны быть такими же, как в упомянутом файле:

```yaml
apiVersion: v1
clusters:
- cluster:
 certificate-authority-data: {Сюда вставьте данные}
 server: {Сюда вставьте данные}
name: kubernetes
contexts:
- context:
 cluster: kubernetes
 user: jean
name: jean-context
current-context: jean-context
kind: Config
preferences: {}
users:
- name: jean
user:
 client-certificate: /home/jean/.certs/jean.cert
 client-key: /home/jean/.certs/jean.key
```

Теперь нужно скопировать приведенный выше конфиг в каталог .kube:

```
mkdir .kube && vi .kube/config
```

Осталось сделать пользователя владельцем всех созданных файлов и каталогов:

```
chown -R jean: /home/jean/
```

Пользователь jean успешно создан. То же самое проделаем и для пользователя sarah. Шагов довольно много, и на создание большого количества пользователей может уйти длительное время. Поэтому я написал Bash-скрипты, автоматизирующие процесс: их можно найти в репозитории на GitHub.

Прим. перев.: Как мы писали в своей недавней статье, упростить эту процедуру можно и более «родным» для Kubernetes путём — через новые возможности в консольной утилите kubeadm. Впрочем, помните, что на момент публикации этого перевода они доступы в виде альфа-версии. Пример команды для создания пользователя — kubeadm alpha kubeconfig user.

Теперь у нас есть пользователи, и можно переходить к созданию двух пространств имен:

kubectl create namespace my-project-dev
kubectl create namespace my-project-prod

Поскольку мы пока не определили авторизацию пользователей, у них не должно быть доступа к ресурсам кластера:

User: Jean

kubectl get nodes
Error from server (Forbidden): nodes is forbidden: User "jean" cannot list resource "nodes" in API group "" at the cluster scope

kubectl get pods -n default
Error from server (Forbidden): pods is forbidden: User "jean" cannot list resource "pods" in API group "" in the namespace "default"

kubectl get pods -n my-project-prod
Error from server (Forbidden): pods is forbidden: User "jean" cannot list resource "pods" in API group "" in the namespace "my-project-prod"

kubectl get pods -n my-project-dev
Error from server (Forbidden): pods is forbidden: User "jean" cannot list resource "pods" in API group "" in the namespace "my-project-dev"

User: Sarah

kubectl get nodes
Error from server (Forbidden): nodes is forbidden: User "sarah" cannot list resource "nodes" in API group "" at the cluster scope

kubectl get pods -n default
Error from server (Forbidden): pods is forbidden: User "sarah" cannot list resource "pods" in API group "" in the namespace "default"

kubectl get pods -n my-project-prod
Error from server (Forbidden): pods is forbidden: User "sarah" cannot list resource "pods" in API group "" in the namespace "my-project-prod"

kubectl get pods -n my-project-dev
Error from server (Forbidden): pods is forbidden: User "sarah" cannot list resource "pods" in API group "" in the namespace "my-project-dev"

Создание Role и ClusterRole

Мы будем использовать ClusterRole, доступный по умолчанию. Впрочем, также покажем, как создавать свои Role и ClusterRole. По сути Role и ClusterRole — это всего лишь набор действий (называемых как verbs, т.е. дословно — «глаголов»), разрешенных для определенных ресурсов и пространств имен. Вот пример YAML-файла:

apiVersion: rbac.authorization.k8s.io/v1beta1
kind: Role
metadata:
  name: list-deployments
  namespace: my-project-dev
rules:
  - apiGroups: [ apps ]
    resources: [ deployments ]
    verbs: [ get, list ]
---------------------------------
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: list-deployments
rules:
  - apiGroups: [ apps ]
    resources: [ deployments ]
    verbs: [ get, list ]

Чтобы их создать, выполните команду:

kubectl create -f /path/to/your/yaml/file

Привязка Role или ClusterRole к пользователям

Теперь привяжем ClusterRole по умолчанию (edit и view) к нашим пользователям следующим образом:

jean:
edit — в пространстве имен my-project-dev;
view — в пространстве имен my-project-prod;
sarah:
edit — в пространстве имен my-project-prod.

RoleBinding'и нужно задавать по пространствам имен, а не по пользователям. Другими словами, для авторизации jean мы создадим два RoleBinding'а. Пример YAML-файла, определяющего RoleBinding'и для jean:

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: jean
  namespace: my-project-dev
subjects:
- kind: User
  name: jean
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: edit
  apiGroup: rbac.authorization.k8s.io
---------------------------------
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: jean
  namespace: my-project-prod
subjects:
- kind: User
  name: jean
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: view
  apiGroup: rbac.authorization.k8s.io

Мы разрешаем jean просматривать (view) my-project-prod и редактировать (edit) my-project-dev. То же самое необходимо сделать с авторизациями для sarah. Для их активации выполните команду:

kubectl apply -f /path/to/your/yaml/file

В данном случае была использована kubectl apply вместо kubectl create. Разница между ними в том, что create создает объект и больше ничего не делает, а apply — не только создает объект (в случае, если его не существует), но и обновляет при необходимости.

Давайте проверим, получили ли наши пользователи нужные разрешения.

Пользователь: sarah (edit в my-project-prod)
my-project-prod
может выводить список pod'ов (1);
может создавать deployment'ы (2).
my-project-dev
не может выводить список pod'ов (4);
не может создавать deployment'ы (5).

(1) kubectl get pods -n my-project-prod 
No resources found. 

(2) kubectl run nginx --image=nginx --replicas=1 -n my-project-prod 
deployment.apps/nginx created 

(3) kubectl get pods -n my-project-prod 
NAME                    READY  STATUS   RESTARTS  AGE 
nginx-7db9fccd9b-t14qw  1/1    Running  0         4s 

(4) kubectl get pods -n my-project-dev
Error from server (Forbidden): pods is forbidden: User "sarah" cannot list resource "pods" in API group "" in the namespace "my-project-dev"

(5) kubectl run nginx --image=nginx --replicas=1 -n my-project-dev 
Error from server (Forbidden): deployments.apps is forbidden: User "sarah" cannot create resource "deployments" in API group "apps" in the namespace "my-project-dev"

Пользователь: jean (view в my-project-prod и edit в my-project-dev)
my-project-prod
может выводить список pod'ов (1);
может выводить список deployment'ов (2);
не может удалять deployment'ы (3).
my-project-dev:
может выводить список pod'ов (4);
может создавать deployment'ы (5);
может выводить список deployment'ов (6);
может удалять deployment'ы (7).

```
(1) kubectl get pods -n my-project-prod 
NAME                    READY  STATUS   RESTARTS  AGE 
nginx-7db9fccd9b-t14qw  1/1    Running  0         101s 

(2) kubectl get deploy -n my-project-prod 
NAME   READY  UP-TO-DATE  AVAILABLE  AGE 
nginx  1/1    1           1          110s 

(3) kubectl delete deploy/nginx -n my-project-prod 
Error from server (Forbidden): deployments.extensions "nginx" is forbidden: User "jean" cannot delete resource "deployments" in API group "extensions" in the namespace "my-project-prod" 

(4) kubectl get pods -n my-project-dev
No resources found. 

(5) kubectl run nginx --image=nginx --replicas=1 -n my-project-dev 
deployment.apps/nginx created 

(6) kubectl get deploy -n my-project-dev 
NAME   READY  UP-TO-DATE  AVAILABLE  AGE 
nginx  0/1    1           0          13s 

(7) kubectl delete deploy/nginx -n my-project-dev 
deployment.extensions "nginx" deleted 

(8) kubectl get deploy -n my-project-dev 
No resources found.
```
Управление пользователями и их авторизацией

Итак, мы успешно задали различные роли и авторизации пользователей. Возникает вопрос: как теперь управлять всем этим? Как узнать, правильно ли заданы права доступа для конкретного пользователя? Как узнать, кто обладает полномочиями на выполнение определенного действия? Как получить общую картину разрешений пользователей?

Нам необходимы ответы на все эти вопросы, чтобы обеспечить безопасность кластера. Команда kubectl auth can-i позволяет выяснить, может ли пользователь выполнить определенное действие:

# kubectl auth can-i $action $resource --as $subject

(1) kubectl auth can-i list pods 
(2) kubectl auth can-i list pods --as jean

Первая команда (1) позволяет пользователю узнать, может ли он выполнить некое действие. Вторая (2) — позволяет администратору выдать себя за пользователя, чтобы узнать, может ли тот выполнить определенное действие. Подобное «перевоплощение» разрешено только для пользователей с привилегиями администратора кластера.

Это практически все, что можно сделать с помощью встроенного инструментария. Именно поэтому представлю и некоторые Open Source-проекты, позволяющие расширить возможности, предлагаемые командой kubectl auth can-i. Прежде чем представить их, установим зависимости: Go и Krew.


https://habr.com/ru/company/flant/blog/470503/