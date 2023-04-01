-- params : ...
-- function num : 0 , upvalues : _ENV
local sector_stage_bgm = {
{}
, 
{id = 2, label_boss_combat = "SelectorLabel_BossCombat_Hi", label_lv_select = "SelectorLabel_LevelSelect_Mid", label_normal_combat = "SelectorLabel_NormalCombat_Hi"}
, 
{bgm_id = 3109, id = 3}
, 
{bgm_id = 3201, id = 4, label_boss_combat = "Mus_Story_Sad", label_lv_select = "Mus_Story_Sad", label_normal_combat = "Mus_Story_Sad", selector = "Mus_Story_Sad"}
, 
{bgm_id = 3203, id = 5, label_boss_combat = "Mus_EV3_Story_Justice", label_lv_select = "Mus_EV3_Story_Justice", label_normal_combat = "Mus_EV3_Story_Justice", selector = "Mus_EV3_Story_Justice"}
, 
{bgm_id = 3381, id = 6, label_boss_combat = "", label_lv_select = "", label_normal_combat = "", selector = ""}
}
local __default_values = {bgm_id = 3108, id = 1, label_boss_combat = "SelectorLabel_BossCombat", label_lv_select = "SelectorLabel_LevelSelect", label_normal_combat = "SelectorLabel_NormalCombat", selector = "Selector_Mus_Sector"}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(sector_stage_bgm) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(sector_stage_bgm, {__index = __rawdata})
return sector_stage_bgm

