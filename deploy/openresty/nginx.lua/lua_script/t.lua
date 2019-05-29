-- local req = require "req"
local cjson = require "cjson"
local http = require "resty.http"
--
--local  args = req.getArgs()
--local token = args['token']
local http_req = http.new()
local request_uri = ngx.var.request_uri
ngx.say("request_uri :",request_uri)
local res_req,err_req = http_req:request_uri(request_uri,{
    method = "GET",
    headers = {
      ["Accept"] = "*",
      ["Accept-Encoding"] = "UTF-8",
    },
    ssl_verify = false
    })
http_req:set_keepalive(120)

-- ngx.status = res_req.status
ngx.log(ngx.INFO,res_req.status)
if res_req.status == 404 or res_req.status == 502 or res_req.status == 503 then
   call_platform_runk8s(token)
end

-- ngx.status = res.status
-- ngx.say(cjson.encode(cjson.decode(res.body)))

