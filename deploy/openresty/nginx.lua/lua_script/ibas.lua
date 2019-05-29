local _M = {}

local http = require "resty.http"
local cjson = require "cjson"
function _M.get_platform_runk8s(token,code,port,namespace)
  local httpc = http.new()
  httpc:set_timeout(100)
  local params = {}
  params['token'] = token
  params['customerCode'] = code
  params['port'] = port
  params['serverCode'] = 'SERVER'
  params['namespace'] = namespace
  local res,err = httpc:request_uri("https://console.avacloud.com.cn/customermanagement/services/rest/data/runK8sForOpen?"..ngx.encode_args(params),{
    method = "GET",
    headers = {
      ["Accept"] = "*",
      ["Accept-Encoding"] = "UTF-8",
    },
    ssl_verify = false
  })
  if not res then
    ngx.say("request error :",err)
  end
  return res
end



function _M.get_platform_token(user,password)
  local httpc = http.new()
  httpc:set_timeout(120)
  local params = {}
  params['user'] = user
  params['password'] = password
  local res,err = httpc:request_uri("https://console.avacloud.com.cn/initialfantasy/services/rest/data/userConnect?"..ngx.encode_args(params),{
   method = "POST",
   headers = {
      ["Accept"] = "application/json",
      ["Accept-Encoding"] = "UTF-8",
   },
   ssl_verify = false
  })

  if not res then  return nil,nil,err  end
  local token = ''
  local response = cjson.decode(res.body)
  for i, w in ipairs(response.ResultObjects) do
    token = w.Token
  end
  httpc:close()


  return token
end

function _M.get_platform_customercode(token,enccode)
  local httpc = http.new()
  local params = {}
  params['token'] = token
  params['customerEncCode'] = enccode
  httpc:set_timeout(120)
  local res,err = httpc:request_uri("https://console.avacloud.com.cn/customermanagement/services/rest/data/searchCustomerForOpen?"..ngx.encode_args(params),{
   method = "GET",
   headers = {
      ["Accept"] = "application/json",
      ["Accept-Encoding"] = "UTF-8",
   },
   ssl_verify = false
  })

  if not res then  return nil,nil,err  end
  local token = ''
  local response = res.body

  httpc:close()


  return response
end


return _M

