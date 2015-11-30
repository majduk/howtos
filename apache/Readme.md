Apache Configuration examples



## Adding query string param
```
    #temp - quick fix
    RewriteCond %{REQUEST_URI} /uri/path
    RewriteCond %{QUERY_STRING} some_existing_param
    RewriteCond %{QUERY_STRING} !param
    RewriteRule ^/oauth/authorize /uri/path?param=value [R,QSA]
    #
```
