#!/bin/sh
set -e

# Substitute environment variables in nginx.conf.template and start nginx
export OIDC_ISSUER_HOST
export OIDC_REGISTRATION_ENDPOINT
export ALLOWED_REDIRECT_URIS
envsubst < /etc/nginx/nginx.conf.template > /usr/local/openresty/nginx/conf/nginx.conf

cat /usr/local/openresty/nginx/conf/nginx.conf

openresty -g 'daemon off;'
