-- params : ...
-- function num : 0 , upvalues : _ENV
local dorm_fight_fx = {
{src_name = "FX/Common/FX_PVP/FXP_pvp_JD_1"}
, 
{id = 2, src_name = "FX/Common/FX_PVP/FXP_pvp_JD_2"}
, 
{bind_point = 0, bind_type = 0, birth_point = 1, birth_type = 2, exist_frame = 30, id = 3}
}
local __default_values = {bind_point = 110, bind_type = 3, birth_point = 110, birth_type = 1, exist_frame = 9000, id = 1, src_name = "FX/Common/FX_PVP/FXP_PVP_Attack"}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(dorm_fight_fx) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(dorm_fight_fx, {__index = __rawdata})
return dorm_fight_fx

