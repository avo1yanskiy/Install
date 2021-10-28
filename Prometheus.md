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
```
$ vim nano /etc/prometheus/prometheus.yml

Next, copy and paste the following lines into the terminal:

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

```
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
