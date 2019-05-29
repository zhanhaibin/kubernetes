-- local req = require "req"
local cjson = require "cjson"
local http = require "resty.http"
function call_platform_runk8s(token,code,port)
  local httpc = http.new()
  httpc:set_timeout(100)
  local params = {}
  params['token'] = token
  params['customerCode'] = code
  params['port'] = port
  params['serverCode'] = 'SERVER'
  params['namespace'] = 'customer' 
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

function call_platform_delK8s(token,code,port)
  local httpc = http.new()
  local params = {}
  params['token'] = token
  params['customerCode'] = code
  params['port'] = port
  params['serverCode'] = 'SERVER'
  params['namespace'] = 'customer'
  local res,err = httpc:request_uri("https://console.avacloud.com.cn/customermanagement/services/rest/data/delK8sForOpen?"..ngx.encode_args(params),{
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
  httpc:close()  
  return res
end

function lua_string_split(szFullString, szSeparator)  
local nFindStartIndex = 1  
local nSplitIndex = 1  
local nSplitArray = {}  
if szFullString == nil then return '' end
while true do  
   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
   if not nFindLastIndex then  
    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
    break  
   end  
   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
   nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
   nSplitIndex = nSplitIndex + 1  
end  
return nSplitArray  
end

function get_request_uri(uri)
   local httpu = http.new()
   httpu:set_timeout(200)
   httpu:set_keepalive(200)
   
   local res2,err2 = httpu:request_uri(uri,{
   method = "GET",
   headers = {
      ["Accept"] = "text/html,application/xhtml+xml,application/xml",
      ["Accept-Encoding"] = "UTF-8",
   },
   ssl_verify = false
  })
  --if not res2 then ngx.say("res2 err:"..err2) end
  --if res2 == nil then ngx.say("res2 is nil") return nil end
  httpu:close()
  return res2
end

function sleep(n)
  os.execute("sleep " .. n)
end

function get_platform_token(uri,user,password)
  local httpc = http.new()
  httpc:set_timeout(120)
  local uri = uri
  local params = {}
  params['user'] = user
  params['password'] = password
  local res,err = httpc:request_uri(uri..ngx.encode_args(params),{
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

function get_platform_customercode(token)
   local httpc = http.new()
   local params = {}
   params['token'] = token
   local res,err = httpc:request_uri("https://console.avacloud.com.cn/customermanagement/services/rest/data/runK8sForOpen?"..ngx.encode_args(params),{
    method = "POST",
    headers = {
      ["Accept"] = "application/json",
      ["Accept-Encoding"] = "UTF-8",
    },
    ssl_verify = false
  })
  if not res then
    ngx.say("request error :",err)
  end
  return res
end


local http_uri = ngx.var.request_uri
local http_array = lua_string_split(http_uri,"/")
local size = table.getn(http_array)
local account = http_array[2]
local accountcode = http_array[3]


--local res_token = get_platform_token("https://console.avacloud.com.cn/initialfantasy/services/rest/data/userConnect?","admin","1qaz@WSX")
--if res_token ~= nil and res_token ~= '' then
--  call_platform_runk8s(res_token,account,port)
--else
--  ngx.say("token is nil")
--end

--local res_api = get_request_uri(uri)
--zzzzzz  if res_api == nil then ngx.say("res_api is nil"..uri) get_request_uri(uri)  end
--if res_api.status == 500  then
--  ngx.say("res_api.status:"..res_api.status)
  --get_request_uri(uri)
--else 
--  ngx.say("res_api.body"..res_api.body)
--  return res_api.body
--end

