# Example site-to-site VPN setup with [Strongswan](https://www.strongswan.org/)

## Environment
- Site A:
```
Public IP: 93.174.24.202
Private subnet: 10.146.247.194/24
```
- Site B:
```
Public IP: 162.213.35.107
Private subnet: 10.55.32.7/24
```

Below sets up tunnel: 
- A->B (attempt initiated automatically) 
- B->A (attempt only when traffic is detected) 

## Setup

1. Install strongswan
```
apt install strongswan
```

2. Configure node in env A
- /etc/ipsec.conf
```
# basic configuration 
config setup
        charondebug="all"
        uniqueids=yes
        strictcrlpolicy=no

conn base-conn
    ###
    authby=secret
    ###
    dpdaction=restart
    keyexchange=ikev2
    auto=start #start tunnel automatically
    ike=aes128gcm16-prfsha256-ecp256,aes256gcm16-prfsha384-ecp384!
    esp=aes128gcm16-ecp256,aes256gcm16-ecp384!
    keyingtries=%forever
    fragmentation=yes #default
    pfs=yes           #default
    aggressive=no     #default
    reauth=yes        #default
    rekey=yes         #default
    ikelifetime=3h    #default
    margintime=9m     #default
    rekeyfuzz=100%    #default
    
conn a-to-b
  also=base-conn
  left=%defaultroute
  leftid=93.174.24.202
  leftsubnet=10.146.247.194/24
  right=162.213.35.107
  rightsubnet=10.55.32.7/20
```
- /etc/ipsec.secrets 
```
# This file holds shared secrets or RSA private keys for authentication.

# RSA private key for this host, authenticating it to any other host
# which knows the public part.
93.174.24.202 162.213.35.107 : PSK "password"
```

3. Configure node in env B
- /etc/ipsec.conf - this is another, a bit simplier example but with the sane metting
```
conn b-to-a
  authby=secret ##important
  left=%defaultroute
  leftid=162.213.35.107
  leftsubnet=10.55.32.7/24
  right=93.174.24.202
  rightsubnet=10.146.247.194/24
  ike=aes128gcm16-prfsha256-ecp256,aes256gcm16-prfsha384-ecp384!
  esp=aes128gcm16-ecp256,aes256gcm16-ecp384!
  keyingtries=%forever
  fragmentation=yes #default
  pfs=yes           #default
  aggressive=no     #default
  reauth=yes        #default
  rekey=yes         #default
  ikelifetime=3h    #default
  margintime=9m     #default
  rekeyfuzz=100%    #default
  dpdaction=restart
  keyexchange=ikev2
  auto=route #start tunnel only when traffic is detected
```
- /etc/ipsec.secrets 
```
162.213.35.107 93.174.24.202 : PSK "password"

```

## Testing

You can use `ipsec statusall`
```
Status of IKE charon daemon (strongSwan 5.3.5, Linux 4.4.0-159-generic, x86_64):
  uptime: 10 seconds, since Aug 27 15:31:26 2019
  malloc: sbrk 1486848, mmap 0, used 343296, free 1143552
  worker threads: 11 of 16 idle, 5/0/0/0 working, job queue: 0/0/0/0, scheduled: 5
  loaded plugins: charon test-vectors aes rc2 sha1 sha2 md4 md5 random nonce x509 revocation constraints pubkey pkcs1 pkcs7 pkcs8 pkcs12 pgp dnskey sshkey pem openssl fips-prf gmp agent xcbc hmac gcm attr kernel-netlink resolve socket-default connmark stroke updown
Listening IP addresses:
  10.55.32.7
Connections:
      b-to-a:  %any...93.174.24.202  IKEv2, dpddelay=30s
      b-to-a:   local:  [162.213.35.107] uses pre-shared key authentication
      b-to-a:   remote: [93.174.24.202] uses pre-shared key authentication
      b-to-a:   child:  10.55.32.0/24 === 10.146.247.0/24 TUNNEL, dpdaction=restart
Routed Connections:
      b-to-a{1}:  ROUTED, TUNNEL, reqid 1
      b-to-a{1}:   10.55.32.0/24 === 10.146.247.0/24
Security Associations (1 up, 0 connecting):
      b-to-a[1]: ESTABLISHED 3 seconds ago, 10.55.32.7[162.213.35.107]...93.174.24.202[93.174.24.202]
      b-to-a[1]: IKEv2 SPIs: c4e7fc61631c2b47_i 5018b398f77c4489_r*, pre-shared key reauthentication in 2 hours
      b-to-a[1]: IKE proposal: AES_GCM_16_128/PRF_HMAC_SHA2_256/ECP_256
      b-to-a{2}:  INSTALLED, TUNNEL, reqid 1, ESP in UDP SPIs: cd89663c_i cc4de2bc_o
      b-to-a{2}:  AES_GCM_16_128, 0 bytes_i, 0 bytes_o, rekeying in 48 minutes
      b-to-a{2}:   10.55.32.0/24 === 10.146.247.0/24
```
