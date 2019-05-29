#! /bin/bash
redis-server /usr/local/openresty/nginx/redis.conf
exec /usr/local/openresty/bin/openresty -g "daemon off;"
