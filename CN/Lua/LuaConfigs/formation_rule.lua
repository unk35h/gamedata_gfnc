-- params : ...
-- function num : 0 , upvalues : _ENV
local formation_rule = {
{bench_num = 5, id = 1, stage_num = 2}
, 
{bench_num = 5, id = 2, stage_num = 3}
, 
{bench_num = 2, bench_start_idx = 7, id = 3, stage_num = 6}
, 
{bench_num = 4, bench_start_idx = 5, id = 4, stage_num = 4}
, 
{bench_start_idx = 6, id = 5}
; 
[0] = {bench_start_idx = 6}
}
local __default_values = {bench_num = 3, bench_start_idx = 4, id = 0, stage_num = 5}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(formation_rule) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(formation_rule, {__index = __rawdata})
return formation_rule

