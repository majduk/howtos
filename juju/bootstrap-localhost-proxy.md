# How to use juju LXD cloud behind a proxy

First configure LXD bridge.

Let's assume:
- lxdbr0 IP is `10.233.148.1`
- proxy address is `http://100.107.0.4:1080/`

bootstrap.sh:
```
#!/usr/bin/env bash
set -x
export http_proxy=http://100.107.0.4:1080/
export https_proxy=http://100.107.0.4:1080/
export no_proxy=$(echo 10.233.148.{1..255} | sed 's/ /,/g') 

lxc config set core.proxy_http http://100.107.0.4:1080/
lxc config set core.proxy_https http://100.107.0.4:1080/
lxc config set core.proxy_ignore_hosts 10.233.148.1

juju bootstrap --debug --no-gui --model-default=bootstrap.yaml --bootstrap-series=xenial localhost localhost
```

bootstrap.yaml:
```
apt-http-proxy: "http://100.107.0.4:1080/"
apt-https-proxy: "http://100.107.0.4:1080/"
http-proxy: "http://100.107.0.4:1080/"
https-proxy: "http://100.107.0.4:1080/"
no-proxy: "127.0.0.1,10.233.148.1,localhost"
```

deploy.sh:
```
#!/usr/bin/env bash

export http_proxy=http://100.107.0.4:1080/
export https_proxy=http://100.107.0.4:1080/
export no_proxy=$(echo 100.107.{0..3}.{2..255} | sed 's/ /,/g')

juju deploy --debug $1
```



