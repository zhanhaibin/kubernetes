-- local req = require "req"
local cjson = require "cjson"
local http = require "resty.http"

function call_platform_runk8s(token)
  local httpc = http.new()
--  local params = {}
--  params['token'] = ''
  local res,err = httpc:request_uri("https://console.avacloud.com.cn/operationmaintenance/services/rest/data/runK8sForOpen?token=9e81e4bb0c8acfd05e9b9dfa42706562&serverCode=SERVER&accountCode=c00002-06&namespace=customer",{
    method = "GET",
    headers = {
      ["Accept"] = "*",
      ["Accept-Encoding"] = "UTF-8",
    },
    ssl_verify = false
  })
  httpc:set_keepalive(120)

  if not res then
    ngx.say("request error :",err)
    return
  end
  ngx.status = res.status
  if ngx.status == 404 then
    return cjson.decode(res.status)
  else
    return cjson.decode(res.body)
  end
end

--local args = req.getArgs()
--local token = args['token']
local http_req = http.new()
local res_req,err_req = http_req:request_uri("https://app.avacloud.com.cn/2ir2vuf1/p06/",{
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

