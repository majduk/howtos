# Apache Configuration examples

## Adding query string param
```
    #temp - quick fix
    RewriteCond %{REQUEST_URI} /uri/path
    RewriteCond %{QUERY_STRING} some_existing_param
    RewriteCond %{QUERY_STRING} !param
    RewriteRule ^/oauth/authorize /uri/path?param=value [R,QSA]
    #
```


## Reading part of a header into server environment
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
## Rails, partly served from static - Apache 2.2, Passenger 3.0

`http://server/any_path` goes to rails
`http://server/static/resources/file` is taken from /static/resources dir, provided that the file exists. Otherwise it is sent to Rails.


```
Listen 8080
<VirtualHost *:8080>
        ServerAdmin webmaster@localhost
        ServerName oapi.play.pl
        DocumentRoot /var/www/app/public

        <Directory /static/resources>
                Options FollowSymLinks -MultiViews
                AllowOverride all
        </Directory>

        <Directory /var/www/app/public>
                Options FollowSymLinks -MultiViews
                AllowOverride all
        </Directory>

        ErrorLog logs/app-8080-error.log
        CustomLog logs/app-8080-access.log combined

        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel info
        PassengerLogLevel 3
        PassengerMaxPoolSize 40
        PassengerMinInstances 6
        PassengerPoolIdleTime 10
        PassengerDefaultUser apache
        PassengerDefaultGroup apache
</VirtualHost>

```
## Rails application with different base URI - Apache 2.2, Passenger 3.0

This requirese also soft link:
```
/var/www/app/public/uri/path -> /var/www/app/public
```

Apache config:
```
Listen 8080
<VirtualHost *:8080>
        ServerAdmin webmaster@localhost
        ServerName server
        SetEnvIf Request_URI "/assets" resource



        RackBaseURI /uri/path
        DocumentRoot /var/www/app/public
        <Directory /var/www/app/public>
                Options FollowSymLinks -MultiViews
                AllowOverride all
        </Directory>

        ErrorLog logs/rails-app-8080-error.log
        CustomLog logs/rails-app-8080-access.log combined_session env=!resource
        CustomLog logs/rails-app-8080-assets.log combined

        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel info
        PassengerLogLevel 3
        PassengerMaxPoolSize 15
        PassengerMinInstances 6
        PassengerPoolIdleTime 10
        PassengerDefaultUser apache
        PassengerDefaultGroup apache
</VirtualHost>

```

## Rails multiple apps - Apache 2.4, Passenger 3.0
```
Listen 8080
<VirtualHost *:8080>
        ServerAdmin webmaster@localhost
        ServerName server
        #DocumentRoot /var/www/rails-app/public
        SetEnvIf Request_URI "/assets" resource

        #<Directory /var/www/rails-app/public>
        #        Options +FollowSymLinks -MultiViews
        #        AllowOverride all
        #        Require all granted
        #</Directory>

        ErrorLog logs/rails-app-8080-error.log
        CustomLog logs/rails-app-8080-access.log combined_session env=!resource
        CustomLog logs/rails-app-8080-assets.log combined

        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel info
        PassengerLogLevel 3
        PassengerMaxPoolSize 15
        PassengerMinInstances 6
        PassengerPoolIdleTime 10
        PassengerDefaultUser apache
        PassengerDefaultGroup apache
        PassengerAppEnv development

        <Location /playground/app1>
            PassengerBaseURI /playground/app1
            PassengerAppRoot /var/www/app1
        </Location>

        <Location /playground/app2>
            PassengerBaseURI /playground/app2
            PassengerAppRoot /var/www/app2
        </Location>

        <Location /app3>
            PassengerBaseURI /app3
            PassengerAppRoot /var/www/app3
        </Location>
```

