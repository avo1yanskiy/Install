Kubernetes UBUNTU

### master control panel

```
# обновление && установка kubelet kubeadm kubectl containerd
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl containerd
    sudo apt-mark hold kubelet kubeadm kubectl
```

```
# При проверке возникнет ошибка. Исправим ее
echo 1 > /proc/sys/net/ipv4/ip_forward
modprobe br_netfilter
```
```

# инициализация кластера
kubeadm init \
  --apiserver-advertise-address=192.168.1.26  \
  --pod-network-cidr 10.244.0.0/16 \
  --apiserver-cert-extra-sans=178.154.248.8 #(IP внешний)
```
```
# добавляем для управления

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
```
## Токен для worker node
kubeadm join 192.168.1.26:6443 --token srurgd.k93pnuwxjowoo8x7 \
	--discovery-token-ca-cert-hash sha256:c8ff547ac56e861d3153fed471050716f7cd612941f478e034ee88628fe0a616
```

### worker node

```
# обновление && установка kubelet kubeadm kubectl containerd
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl containerd
    sudo apt-mark hold kubelet kubeadm kubectl
```

```
# При проверке возникнет ошибка.
echo 1 > /proc/sys/net/ipv4/ip_forward
modprobe br_netfilter
```


### Установка сети kubernetes

flannel:

kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml