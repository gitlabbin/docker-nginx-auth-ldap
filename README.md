# About this Repo

This is the Git repo of the Docker image for [official nginx](https://registry.hub.docker.com/_/nginx/) bundled with [nginx-auth-ldap](https://github.com/kvspb/nginx-auth-ldap).
**Currently, only the mainline-alpine image is maintained.**

# LDAP Feature Enabled Sample Configuration
Run the below command, and access to http://localhost:8080, you may need credential to open.
```
$ git clone https://github.com/weseek/nginx-auth-ldap
$ cd nginx-auth-ldap
$ docker run -d -p 127.0.0.1:8080:80 \
    -v $(pwd)/mainline/alpine/conf.d.example:/etc/nginx/conf.d
    -e NGINX_AUTH_LDAP_URL=<LDAP URL (ex. ldap://example.com/ou=people,dc=example,dc=com)> \
    -e NGINX_AUTH_LDAP_BINDDN=<BIND DN (ex. cn=auth,dc=example,dc=com)> \
    -e NGINX_AUTH_LDAP_BINDPW=<password of BIND DN> \
    weseek/nginx-auth-ldap:1.13.9-alpine
```
If you want to use docker-compose, you can use the below example.
```
$ git clone https://github.com/weseek/nginx-auth-ldap
$ cd nginx-auth-ldap
$ cat <'EOF' > docker-compose.yml
version: '2'
services:
  nginx:
    image: weseek/nginx-auth-ldap:1.13.9-alpine
    ports:
      - 127.0.0.1:8080:80
    environment:
      NGINX_AUTH_LDAP_URL: <LDAP URL (ex. ldap://example.com/ou=people,dc=example,dc=com)>
      NGINX_AUTH_LDAP_BINDDN: <BIND DN (ex. cn=auth,dc=example,dc=com)>
      NGINX_AUTH_LDAP_BINDPW: <password of BIND DN>
    volumes:
      - ./mainline/alpine/conf.d.example:/etc/nginx/conf.d
$ docker-compose up
```
