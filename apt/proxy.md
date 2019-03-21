# APT behind proxy

## Problem

apt-get performs DNS lookup [using system resolver] for every repository entry (including http, onion, and even numeric IPs) [regardless of whether or not a proxy is configured for that particular host].

This may be expected behavior because `Acquire::http::Proxy` can be configured per host. Also, http may be proxied while other apt-transports are not. In these cases, it would be desirable to have local DNS resolution. It seems the only way to block DNS requests for our use case would be to establish complex rules.

So, by default, even when the proxy is set up in the config file, APT uses DNS SRV query [[1](https://docs.maas.io/2.5/en/api#dnsresourcerecord)] to resolve correct address for the actual proxy service, like in th TCP dump below:

```
08:00:01.567260 IP 100.107.0.2.60292 > 100.107.0.31.53: 28966+ SRV? _http._tcp.100.107.0.4. (40)
08:00:11.571207 IP 100.107.0.31.53 > 100.107.0.2.60292: 28966 ServFail 0/0/0 (40)
```

## Solution 1
This solution assumes that you do not have the access for the DNS configuration.

In such a case you should add following APT configuration: 
```
Acquire::http::Proxy "http://<proxy ip>:<proxy port>/";
Acquire::EnableSrvRecords "false";
```

## Solution 2
This solution assumes that you are in charge of DNS configuration.

In such a case, you can add correct SRV record to your DNS. Depending on a type of your DNS, this can be accomplished in a various ways. 

### Bind

You can add following entries to your domain:
```
_http._tcp.proxy IN SRV 10 10 <proxy_port> proxy
proxy 30 IN A <proxy_ip>
```

### MAAS managed DNS

The description below coveres MAAS based DNS [[2](https://docs.maas.io/2.5/en/api#dnsresourcerecord)].

### Testing

You can use DIG, to test your setup.

In case below, TCP service for proxy is located at 10.17.0.4:1080
```
root@lab:~# dig @10.17.0.33  srv _http._tcp.proxy.my-domain

; <<>> DiG 9.10.3-P4-Ubuntu <<>> @10.17.0.33 srv _http._tcp.proxy.my-domain
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 39847
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;_http._tcp.proxy.maas.		IN	SRV

;; ANSWER SECTION:
_http._tcp.proxy.maas.	30	IN	SRV	10 10 1080 proxy.my-domain.

;; AUTHORITY SECTION:
my-domain.			30	IN	NS	my-domain.

;; ADDITIONAL SECTION:
proxy.my-domain.		30	IN	A	10.17.0.4
my-domain.			30	IN	A	10.17.0.31

;; Query time: 0 msec
;; SERVER: 10.17.0.33#53(10.17.0.33)
;; WHEN: Thu Mar 21 12:51:24 UTC 2019
;; MSG SIZE  rcvd: 126
```

## References
1. http://www.kriegisch.at/~adi/docs/srv_records/
2. https://docs.maas.io/2.5/en/api#dnsresourcerecord
