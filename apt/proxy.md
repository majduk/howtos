# APT behind proxy

## Problem

apt-get performs DNS lookup [using system resolver] for every repository entry (including http, onion, and even numeric IPs) [regardless of whether or not a proxy is configured for that particular host].

This may be expected behavior because `Acquire::http::Proxy` can be configured per host. Also, http may be proxied while other apt-transports are not. In these cases, it would be desirable to have local DNS resolution. It seems the only way to block DNS requests for our use case would be to establish complex rules.

So, by default, even when the proxy is set up in the config file, APT uses DNS SRV query to resolve correct address for the actual proxy service, like in th TCP dump below:

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


