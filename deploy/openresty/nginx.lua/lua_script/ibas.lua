local _M = {}

local http = require "resty.http"
local cjson = require "cjson"
function _M.get_platform_runk8s(token,code,port,namespace)
  local httpc = http.new()
  -- httpc:set_timeout(100)
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
    ngx.log(ngx.ERR,"request error :",err)
  end
  httpc:close()
  return res
end

function _M.get_platform_delK8s(token,code)
  local httpc = http.new()
  local params = {}
  params['token'] = token
  params['serverCode'] = 'SERVER'
  params['accountCode'] = code
  local res,err = httpc:request_uri("http://192.168.2.10:30090/operationmaintenance/services/rest/data/delK8sForOpen?"..ngx.encode_args(params),{
    method = "GET",
    headers = {
      ["Accept"] = "*",
      ["Accept-Encoding"] = "UTF-8",
    },
    ssl_verify = false
  })
  if not res then
    ngx.log(ngx.ERR,"request error :",err)
    return err
  end
  httpc:close()
  return res.status
end


function _M.get_request_uri(uri)
  local httpc = http.new()
   -- httpc:set_timeout(200)
   -- httpc:set_keepalive(200)
   
   local res,err = httpc:request_uri(uri,{
   method = "GET",
   headers = {
      ["Accept"] = "text/html,application/xhtml+xml,application/xml",
      ["Accept-Encoding"] = "UTF-8",
   },
   ssl_verify = false
  })
  httpc:close()
  if not res then ngx.log(ngx.ERR,"res err:",err) return 0 end
  if res == nil then ngx.log(ngx.ERR,"res is nil") return 0 end
  return res.status
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

  if not res then  return nil  end
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

  if not res then  return nil  end
  local response = res.body

  httpc:close()


  return response
end


return _M

