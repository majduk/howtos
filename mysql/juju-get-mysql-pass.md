# How to manage MySQL password  

## Get root Password

Run on juju CLI machine:
```
juju-cli:~$ juju run --unit percona-cluster/0 leader-get root-password
TheSecreTPass
```

## Set root Password
```
juju-cli:~$ juju run --unit percona-cluster/0 leader-set root-password=MoreSecretPassword
```

**Note:**
This changes only the relation stored password. The actual password stored in MySQL is kept the same.
