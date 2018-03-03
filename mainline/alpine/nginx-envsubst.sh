#!/bin/sh

for template in $(find /etc/nginx -name '*.conf.template'); do
  envsubst "$(printf '${%s} ' $(env | cut -d= -f1))" < $template > ${template%.template}
done
