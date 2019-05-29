#! /bin/bash
redis-server /redis.conf
exec /usr/local/openresty/bin/openresty -g "daemon off;"
