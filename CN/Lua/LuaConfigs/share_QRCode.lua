-- params : ...
-- function num : 0 , upvalues : _ENV
local share_QRCode = {
{id = 1}
, 
{code_picture = "UI_ShareQRCode", id = 2}
, 
{id = 3}
, 
{id = 4}
, 
{code_picture = "UI_ShareQRCode", id = 5}
, 
{code_picture = "UI_ShareQRCode", id = 6}
, 
{id = 7}
; 
[0] = {code_picture = "UI_ShareQRCode"}
}
local __default_values = {code_picture = "", id = 0}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(share_QRCode) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(share_QRCode, {__index = __rawdata})
return share_QRCode

