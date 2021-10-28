### install Prometheus & node_exporter

## Create Prometheus Users
```
$ sudo useradd --no-create-home --shell /bin/false prome
$ sudo useradd --no-create-home --shell /bin/false node_exporter
```
## Create Prometheus Directories
```
$ sudo mkdir /etc/prometheus
$ sudo mkdir /var/lib/prometheus
```
## Downloading URL 

https://prometheus.io/download/

or 

https://github.com/prometheus/prometheus/releases

## Downloading and Installing Prometheus

```
$ wget https://github.com/prometheus/prometheus/releases/download/v2.0.0/prometheus-{version}.linux-amd64.tar.gz

* Extract the Prometheus archive using the following command:

$ tar xvf prometheus-{version}.linux-amd64.tar.gz
```
## Copy prometheus & promtool
```
$ sudo cp prometheus-{version}.linux-amd64/prometheus /usr/local/bin/
$ sudo cp prometheus-{version}.linux-amd64/promtool /usr/local/bin/
```

## chown
```
$ sudo chown prome:prome /usr/local/bin/prometheus
$ sudo chown prome:prome /usr/local/bin/promtool
```
## Copy /etc/prometheus
```
$ mkdir /etc/prometheus
$ sudo cp -r prometheus-{version}.linux-amd64/consoles /etc/prometheus
$ sudo cp -r prometheus-{version}.linux-amd64/console_libraries /etc/prometheus
```
## Chown 
```
$ sudo chown -R prome:prome /etc/prometheus/consoles
$ sudo chown -R prome:prome /etc/prometheus/console_libraries
$ sudo chown -R prome:prom /var/lib/prometheus
```
## Prometheus Configuration
$ vim nano /etc/prometheus/prometheus.yml

Next, copy and paste the following lines into the terminal:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
```

## Create service prometheus

$ sudo nano /etc/systemd/system/prometheus.service

```bash
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prome
Group=prome
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
```
## Start & status prometheus

$ sudo systemctl daemon-reload

$ sudo systemctl start prometheus
$ sudo systemctl enable prometheus
$ sudo systemctl status prometheus


### Access the Prometheus Web Interface

http://ip-address:9090


## Add Exporters
To make Prometheus more useful to you, try adding exporters. Some of the most commonly used exporters include the following:

* Node_exporter-
* Blackbox_exporter
* rabbitmq_exporter
* Mysqld_exporter
Here, we will add node_exporter to the Prometheus system. Node_exporter generates metrics about resources like CPU, memory, disk usage, etc.
```
$ wget https://github.com/prometheus/node_exporter/releases/download/
v0.15.1/node_exporter-0.15.1.linux-amd64.tar.gz
```
```
$ tar xvf node_exporter-0.15.1.linux-amd64.tar.gz
sudo nano /etc/prometheus/prometheus.yml
```
## Copy node_exporter
```
$ sudo cp node_exporter-{version}.linux-amd64/node_exporter /usr/local/bin
```
## Chown
```
$ sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
```
## Create a service file for the exporter

$ sudo nano /etc/systemd/system/node_exporter.service
```
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User= node_exporter
Group= node_exporter
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
```
## daemon-reload & Start 
```
$ sudo systemctl daemon-reload
$ sudo systemctl start node_exporter
$ sudo systemctl enable node_exporter
```
## Configuring Prometheus for node_exporter

$ sudo nano etc/prometheus/prometheus.yml

```yaml
- job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']
```
```
sudo systemctl restart prometheus
```

Check http://ip-address:9090
