-- params : ...
-- function num : 0 , upvalues : _ENV
local title = {
[600001] = {describe = 1, describe_name = 523201}
, 
[600002] = {describe = 2, describe_name = 143906, id = 600002, name = 465096}
, 
[600003] = {describe = 2, describe_name = 143906, id = 600003, name = 517128}
, 
[600004] = {id = 600004, name = 408085}
, 
[600005] = {id = 600005, name = 84418}
, 
[600006] = {id = 600006, name = 309394}
, 
[600007] = {id = 600007, name = 83204}
, 
[600008] = {id = 600008, name = 94957}
, 
[600009] = {describe = 4, describe_name = 410236, id = 600009, name = 54816}
, 
[600010] = {id = 600010, name = 467558}
, 
[600011] = {id = 600011, name = 73993}
, 
[600012] = {id = 600012, name = 370598}
, 
[610001] = {describe = 1, describe_name = 523201, id = 610001, name = 53962, position = 2}
, 
[610002] = {describe = 2, describe_name = 143906, id = 610002, name = 369539, position = 2}
, 
[610003] = {describe = 2, describe_name = 143906, id = 610003, name = 27037, position = 2}
, 
[610004] = {id = 610004, name = 43284, position = 2}
, 
[610005] = {id = 610005, name = 455785, position = 2}
, 
[610006] = {id = 610006, name = 295215, position = 2}
, 
[610007] = {id = 610007, name = 233041, position = 2}
, 
[610008] = {id = 610008, name = 177595, position = 2}
, 
[610009] = {describe = 4, describe_name = 410236, id = 610009, name = 335779, position = 2}
, 
[610010] = {id = 610010, name = 283721, position = 2}
, 
[610011] = {id = 610011, name = 330622, position = 2}
, 
[610012] = {id = 610012, name = 95758, position = 2}
}
local __default_values = {describe = 3, describe_name = 447774, id = 600001, is_hide = false, name = 100928, position = 1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(title) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base, 
blockDic = {}
}
setmetatable(title, {__index = __rawdata})
return title

