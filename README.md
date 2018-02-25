# About this Repo

This is the Git repo of the official Docker image for [nginx](https://registry.hub.docker.com/_/nginx/) with [nginx-auth-ldap](https://github.com/kvspb/nginx-auth-ldap).
See the Hub page for the full readme on how to use the Docker image and for information
regarding contributing and issues.

The full readme is generated over in [docker-library/docs](https://github.com/docker-library/docs),
specificially in [docker-library/docs/nginx](https://github.com/docker-library/docs/tree/master/nginx).

# Sample Configuration
First, you create `nginx.conf.template` as below.
```
$ cat <<'EOF' > nginx.conf.template
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    # ldap auth configuration
    auth_ldap_cache_enabled on;
    auth_ldap_cache_expiration_time 600000; # 10 min
    auth_ldap_cache_size 1000;

    ldap_server ldap1 {
        url ${NGINX_AUTH_LDAP_URL};
        binddn ${NGINX_AUTH_LDAP_BINDDN};
        binddn_passwd ${NGINX_AUTH_LDAP_BINDPW};
        require valid_user;
    }

    server {
        listen       80;
        server_name  localhost;

        location / {
            auth_ldap "Closed content";
            auth_ldap_servers ldap1;
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }
    }
}
EOF
```
And, run below command.
```
$ docker run -d -p 127.0.0.1:8080:80 \
    -v $(pwd)/nginx.conf.template:/etc/nginx/nginx.conf.template \
    -e NGINX_AUTH_LDAP_URL=<LDAP URL (ex. ldap://example.com/ou=people,dc=example,dc=com)> \
    -e NGINX_AUTH_LDAP_BINDDN=<BIND DN (ex. cn=auth,dc=example,dc=com)> \
    -e NGINX_AUTH_LDAP_BINDPW=<password of BIND DN> \
    weseek/nginx-auth-ldap:1.13.9-alpine \
    sh -c $'envsubst \'$NGINX_AUTH_LDAP_URL$NGINX_AUTH_LDAP_BINDDN$NGINX_AUTH_LDAP_BINDPW\' \
    < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && nginx -g "daemon off;"'
```
