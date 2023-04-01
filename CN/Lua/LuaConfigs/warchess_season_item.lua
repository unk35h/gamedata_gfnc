-- params : ...
-- function num : 0 , upvalues : _ENV
local warchess_season_item = {
{name = 149793}
, 
{id = 2, 
param = {0, 10, 112, 1215}
}
, 
{id = 3, name = 50360, 
param = {0, 10, 113, 1225}
}
}
local __default_values = {id = 1, name = 110959, 
param = {0, 10, 104, 1208}
}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(warchess_season_item) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(warchess_season_item, {__index = __rawdata})
return warchess_season_item

