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

$ wget https://github.com/prometheus/prometheus/releases/download/v2.0.0/
prometheus-2.0.0.linux-amd64.tar.gz

* Extract the Prometheus archive using the following command:

tar xvf prometheus-2.0.0.linux-amd64.tar.gz

## Copy prometheus & promtool

$ sudo cp prometheus-2.0.0.linux-amd64/prometheus /usr/local/bin/

$ sudo cp prometheus-2.0.0.linux-amd64/promtool /usr/local/bin/

## chown

$ sudo chown prome:prome /usr/local/bin/prometheus

$ sudo chown prome:prome /usr/local/bin/promtool
