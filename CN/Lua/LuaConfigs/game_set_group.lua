-- params : ...
-- function num : 0 , upvalues : _ENV
local game_set_group = {
{}
, 
{group_name = 431367, id = 2, 
order = {3}
}
, 
{group_name = 229021, id = 3, 
order = {4, 5}
}
}
local __default_values = {group_name = 105467, id = 1, 
order = {2, 1}
}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(game_set_group) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(game_set_group, {__index = __rawdata})
return game_set_group

