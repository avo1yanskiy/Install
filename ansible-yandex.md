Для убунты.

## не забудь сделать "chmod +x ansible-yandex.sh"

```bash
#!/bin/bash
echo 'Привет, это установка ansible & yandex cloud!'

sleep 5

sudo apt update

sudo apt -y install vim
sudo apt -y install curl
sudo apt -y install wget
sudo apt -y install zip

sudo add-apt-repository ppa:ansible/ansible-2.10
sudo apt -y install ansible

echo 'Terraform'

sudo apt update && sudo apt install -y gnupg software-properties-common curl

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt update && sudo apt -y install terraform