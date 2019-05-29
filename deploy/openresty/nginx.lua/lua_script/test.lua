local cjson = require "cjson"
local http = require "resty.http"

local httpc = http.new()
local res,err = httpc:request_uri("https://console.avacloud.com.cn/initialfantasy/services/rest/data/fetchUser?token=9e81e4bb0c8acfd05e9b9dfa42706562",{
    method = "POST",
    headers = {
      ["Accept"] = "application/json",
      ["Accept-Encoding"] = "UTF-8",
    },
    ssl_verify = false
    })
httpc:set_keepalive(60)

if not res then 
   ngx.say("request error :",err)
   return
end
ngx.status = res.status
if ngx.status == 404 then 
   ngx.say(res.status)
else
   ngx.say(cjson.encode(cjson.decode(res.body)))
end
-- ngx.status = res.status
-- ngx.say(cjson.encode(cjson.decode(res.body)))

