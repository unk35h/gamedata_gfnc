-- params : ...
-- function num : 0 , upvalues : _ENV
local dorm_house = {
{default_room = 1, dorm_effect = "FX/Scene/DormScenes/ZS_Prefab_line", house_roomtype = 0, icon_index = 0, unlock_level = 1, unlock_logic = 1, unlock_para = ""}
, 
{id = 2, name = 465279, type = 0, unlock_level = 1, unlock_logic = 1, unlock_para = ""}
, 
{default_room = 1, dorm_effect = "", house_roomtype = 0, icon_index = 0, id = 3, name = 70400, type = 2, unlock_para = "1001=100"}
, 
{id = 4, is_hide = true, name = 156443}
, 
{id = 5, is_hide = true, name = 246966, unlock_house_before = 4}
, 
{id = 6, is_hide = true, name = 245860, unlock_house_before = 5}
}
local __default_values = {comfort_limit = 99999, default_room = 2, dorm_effect = "FX/Scene/DormScenes/ZS_Prefab_nothing", house_roomtype = 1, icon_index = 1, id = 1, is_hide = false, name = 13334, type = 1, unlock_house_before = 0, unlock_logic = 2, unlock_para = "908=1"}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(dorm_house) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base, 
dmHouseUnlockItemIdDic = {}
, 
dmHouseUnlockPreHouseIdDic = {}
, 
id_sort_list = {1, 2}
}
setmetatable(dorm_house, {__index = __rawdata})
return dorm_house

