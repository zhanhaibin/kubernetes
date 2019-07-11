local _M = {}

local http = require "resty.http"
local cjson = require "cjson"
local request_console_url = "http://192.168.2.10:30090"

function _M.get_platform_runk8s(code,port,namespace)
  local httpc = http.new()
  -- httpc:set_timeout(100)
  local params = {}
  params['accountCode'] = code
  params['port'] = port
  params['serverCode'] = 'SERVER'
  params['namespace'] = namespace
  local res,err = httpc:request_uri(request_console_url.."/operationmaintenance/services/rest/data/runK8sForOpen?"..ngx.encode_args(params),{
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
  -- ngx.sleep(100)
  return res
end

function _M.get_platform_delK8s(code)
  local httpc = http.new()
  local params = {}
  params['serverCode'] = 'SERVER'
  params['accountCode'] = code
  params['namespace'] = 'api'
  local res,err = httpc:request_uri(request_console_url.."/operationmaintenance/services/rest/data/delK8sForOpen?"..ngx.encode_args(params),{
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

function _M.get_platform_podserviceurl(enccode,accountport)
  local httpc = http.new()
  local params = {}
  params['customerEncCode'] = enccode
  params['accountPort'] = accountport
  httpc:set_timeout(120)
  local res,err = httpc:request_uri(request_console_url.."/operationmaintenance/services/rest/data/getK8sPodServiceUrl?"..ngx.encode_args(params),{
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
function _M.get_platform_customercode(enccode)
  local httpc = http.new()
  local params = {}
  params['customerEncCode'] = enccode
  
  local res,err = httpc:request_uri(request_console_url.."/customermanagement/services/rest/data/searchCustomerForOpen?"..ngx.encode_args(params),{
   method = "GET",
   headers = {
      ["Accept"] = "application/json",
      ["Accept-Encoding"] = "UTF-8",
   },
   ssl_verify = false
  })
 
  if not res then  return err  end
  local response = res.body
  httpc:close()
  return response
end


return _M

