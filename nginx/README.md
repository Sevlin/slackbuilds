*NGINX* [engine x] is a high-performance HTTP server and reverse proxy as well as an IMAP/POP3 proxy server.

- - - -
By default, nginx will use the "nobody" user and group accounts. Also there are extra third-party modules avaliable.  
List of default overridable values:  
* NGINXUSER=nobody
* NGINXGROUP=nogroup
* NGINX_ENABLE_GEOIP=no
* NGINX_ENABLE_MODSEC=no
* NGINX_ENABLE_HEADERSMORE=no
* NGINX_ENABLE_FANCYINDEX=no

You may specify alternate values on the command line if desired; for example:
```bash
NGINXUSER=backup NGINXGROUP=backup \
NGINX_ENABLE_GEOIP=yes \
NGINX_ENABLE_MODSEC=yes \
NGINX_ENABLE_HEADERSMORE=yes \
NGINX_ENABLE_FANCYINDEX=yes ./nginx.SlackBuild
```
Regardless of which user and group you decide to use, you will need to make sure they exist on both the build system and the target system.

- - - -
* nginx documentation: http://nginx.org/en/docs/  
* modsecurity: https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual  
* headers-more: https://github.com/openresty/headers-more-nginx-module  
* fancyindex: https://github.com/aperezdc/ngx-fancyindex
