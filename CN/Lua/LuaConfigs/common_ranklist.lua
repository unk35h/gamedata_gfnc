-- params : ...
-- function num : 0 , upvalues : _ENV
local common_ranklist = {
{option_name = 295101, percent_show = 5000, rank_title = 200695, time_switch = true}
, 
{id = 2, percent_show = 5000, rank_title = 135619}
, 
{id = 3, option_name = 421987, precise_max = 200, rank_title = 71049}
, 
{id = 4, option_name = 434465, precise_max = 200, rank_title = 114273}
, 
{id = 5, option_name = 426997, precise_max = 200}
, 
{hero_num = 2, id = 6, option_name = 467001, option_show_type = 1, percent_show = 5000, rank_title = 204052}
, 
{id = 7, option_name = 260143, option_show_type = 1, rank_title = 85482}
, 
{id = 8, rank_title = 492533, time_switch = true}
, 
{id = 9, rank_title = 305082, time_switch = true}
, 
{id = 10, rank_title = 501026, time_switch = true}
, 
{id = 11, rank_title = 472055, time_switch = true}
, 
{id = 12, rank_title = 277562, time_switch = true}
, 
{id = 13, rank_title = 497068, time_switch = true}
, 
{id = 14, rank_title = 208120, time_switch = true}
, 
{id = 15, rank_title = 234160, time_switch = true}
, 
{id = 16, rank_title = 195214, time_switch = true}
, 
{id = 17, rank_title = 40174, time_switch = true}
, 
{hero_num = 2, id = 18, option_name = 467001, option_show_type = 1, percent_show = 5000, rank_title = 407942}
, 
{hero_num = 0, hero_show_type = 1, id = 19, option_name = 322079, option_show_type = 1, percent_show = 8000, rank_title = 268037}
, 
{hero_num = 0, hero_show_type = 1, id = 20, option_name = 485966, percent_show = 8000, rank_title = 179278}
, 
{hero_num = 0, id = 21, option_name = 228682, rank_title = 255292}
, 
{hero_num = 10, id = 22, option_name = 76012, percent_show = 5000, rank_title = 487663}
, 
{hero_num = 10, id = 23, option_name = 76012, percent_show = 5000, rank_title = 505612}
, 
{id = 24, option_name = 260143, option_show_type = 1, rank_title = 386758}
, 
{id = 25, option_name = 421987, precise_max = 200, rank_title = 15067}
, 
{hero_num = 10, id = 26, option_name = 140121, percent_show = 5000, rank_title = 372224}
, 
{hero_num = 10, id = 27, option_name = 140121, percent_show = 5000, rank_title = 32166}
, 
{id = 28, option_name = 426997, precise_max = 200}
, 
{id = 29, option_name = 260143, option_show_type = 1, rank_title = 85482}
}
local __default_values = {hero_num = 5, hero_show_type = 0, id = 1, option_name = 508726, option_show_type = 0, percent_show = 0, precise_max = 100, rank_title = 48669, rank_title_en = "RANKING", time_switch = false}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(common_ranklist) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(common_ranklist, {__index = __rawdata})
return common_ranklist

