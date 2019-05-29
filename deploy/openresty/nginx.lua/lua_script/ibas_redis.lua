local _M = {}

local redis = require "redis"
function _M.set_ibas_redis(key,url)
 if key == nil or key == "" then
         key = "api"
 end
 local red = redis:new()
 local value = red:set(key,url)
 red:close()
 return value
end

function _M.get_ibas_redis(key)
 if key == nil or key == "" then
         key = "api"
 end

 local red = redis:new()
 local value = red:get(key)
 red:close()
 
 return value
end

return _M
