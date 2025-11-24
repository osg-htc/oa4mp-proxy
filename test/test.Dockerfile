FROM openresty/openresty:alpine

COPY nginx-test.conf /usr/local/openresty/nginx/conf/nginx.conf

EXPOSE 8081

CMD ["openresty", "-g", "daemon off;"]
