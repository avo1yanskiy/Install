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

wget https://releases.hashicorp.com/terraform/1.1.3/terraform_1.1.3_linux_arm64.zip

unzip terraform_1.1.3_linux_arm64.zip

sudo mv terraform /usr/local/bin/

terraform version