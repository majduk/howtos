##Apache Configuration examples



# Adding query string param
```
    #temp - quick fix
    RewriteCond %{REQUEST_URI} /uri/path
    RewriteCond %{QUERY_STRING} some_existing_param
    RewriteCond %{QUERY_STRING} !param
    RewriteRule ^/oauth/authorize /uri/path?param=value [R,QSA]
    #
```


# Reading part of a header into ENV
```

        RewriteEngine On
        #read header part to ENV
        RewriteCond %{HTTP:headerName} ^HeaderPrefiks(.*)$
        RewriteRule .* - [E=REMOTE_USER:%1,NE]

        #secure URL with ENV
        RewriteCond %{REQUEST_URI} ^/url
        RewriteCond %{ENV:REMOTE_USER} ^$
        RewriteRule (.*) - [F]

        #add ENV to path
        RewriteCond %{REQUEST_URI} ^/url/reconciliations
        RewriteRule ^/url/url2(.*)$  /path/url2/%{ENV:REMOTE_USER}/$1

        <Directory /path/url2>
                Options FollowSymLinks -MultiViews
                AllowOverride all
        </Directory>

    
```
