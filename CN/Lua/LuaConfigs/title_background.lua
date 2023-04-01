-- params : ...
-- function num : 0 , upvalues : _ENV
local title_background = {
[620001] = {describe = 1, describe_name = 523201, name = 325556}
, 
[620002] = {describe_text = 21949, font_colour = "#232e4f", icon = "ICON_Item_620002", id = 620002, name = 395496}
, 
[620003] = {describe = 3, describe_name = 410236, describe_text = 438336, icon = "ICON_Item_620003", id = 620003}
, 
[620004] = {describe_text = 426013, icon = "ICON_Item_620004", id = 620004, name = 222626}
}
local __default_values = {describe = 2, describe_name = 447774, describe_text = "", font_colour = "#ffffff", icon = "ICON_Item_620001", id = 620001, is_hide = false, name = 148160}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(title_background) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(title_background, {__index = __rawdata})
return title_background

