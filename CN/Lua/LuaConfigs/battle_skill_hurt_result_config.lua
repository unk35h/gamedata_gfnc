-- params : ...
-- function num : 0 , upvalues : _ENV
local battle_skill_hurt_result_config = {
{basehurt_formula = 9993, crit_formula = 9992, hit_formula = 9991, returndamage_formula = 1000}
, 
{basehurt_formula = 3000, id = 2}
, 
{id = 3}
, 
{basehurt_formula = 3000, hurt_type = 0, id = 4}
, 
{hurt_type = 1, id = 5}
, 
{basehurt_formula = 3000, def_formula = 0, id = 6}
, 
{def_formula = 0, id = 7}
, 
{basehurt_formula = 3000, def_formula = 0, hurt_type = 2, id = 8}
, 
{def_formula = 0, hurt_type = 2, id = 9}
, 
{basehurt_formula = 3000, crit_formula = 9992, hit_formula = 9991, hurt_type = 0, id = 10, returndamage_formula = 1000}
, 
{basehurt_formula = 3032, hurt_type = 0, id = 11}
, 
{basehurt_formula = 207901, id = 12}
, 
{crit_formula = 9992, id = 13}
, 
{basehurt_formula = 3033, correct_formula = 0, crithur_ratio = 0, def_formula = 0, hurt_type = 2, id = 14, lifesteal_formula = 0, minhurt_formula = 0, spell_lifesteal_formula = 0}
, 
{hurt_type = 1, id = 15, returndamage_formula = 1000}
, 
{correct_formula = 0, crithur_ratio = 0, def_formula = 0, hurt_type = 2, id = 16, lifesteal_formula = 0, minhurt_formula = 0, spell_lifesteal_formula = 0}
, 
{crit_formula = 9992, hurt_type = 1, id = 17}
, 
{def_formula = 103102, id = 18}
, 
{basehurt_formula = 3035, id = 19}
, 
{basehurt_formula = 3034, id = 20}
, 
{basehurt_formula = 3036, hurt_type = 1, id = 21}
, 
{crit_formula = 9992, hit_formula = 9991, hurt_type = 1, id = 22, returndamage_formula = 1000}
, 
{basehurt_formula = 103401, crit_formula = 9992, hurt_type = 1, id = 23}
, 
{basehurt_formula = 3000, crit_formula = 10003, id = 24}
, 
{basehurt_formula = 3000, crit_formula = 9992, id = 25}
, 
{basehurt_formula = 10127, id = 26, lifesteal_formula = 0, spell_lifesteal_formula = 0}
, 
{basehurt_formula = 9993, crit_formula = 10003, crithur_ratio = 10196, id = 27, lifesteal_formula = 0, spell_lifesteal_formula = 0}
, 
{basehurt_formula = 10127, def_formula = 0, id = 28, lifesteal_formula = 0, spell_lifesteal_formula = 0}
, 
{basehurt_formula = 106704, crit_formula = 9992, def_formula = 0, hit_formula = 9991, hurt_type = 0, id = 29, returndamage_formula = 1000}
, 
{basehurt_formula = 106702, def_formula = 0, hurt_type = 0, id = 30}
}
local __default_values = {basehurt_formula = 3010, correct_formula = 9989, crit_formula = 0, crithur_ratio = 9995, def_formula = 9996, hit_formula = 0, hurt_type = -1, id = 1, lifesteal_formula = 1001, minhurt_formula = 9994, returndamage_formula = 0, spell_lifesteal_formula = 1002}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(battle_skill_hurt_result_config) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base, 
formulaTypes = {"basehurt_formula", "correct_formula", "crit_formula", "crithur_ratio", "def_formula", "hit_formula", "hurt_type", "lifesteal_formula", "minhurt_formula", "returndamage_formula", "spell_lifesteal_formula"}
}
setmetatable(battle_skill_hurt_result_config, {__index = __rawdata})
return battle_skill_hurt_result_config

