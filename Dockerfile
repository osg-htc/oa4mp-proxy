# Use OpenResty base image
FROM openresty/openresty:alpine

# Install envsubst (gettext)
RUN apk add --no-cache gettext

# Copy nginx template and entrypoint script
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 8080
