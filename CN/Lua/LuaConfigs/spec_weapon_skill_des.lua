-- params : ...
-- function num : 0 , upvalues : _ENV
local spec_weapon_skill_des = {
[100204] = {new_skill_describe = 306592}
, 
[100205] = {id = 100205, new_skill_describe = 95561}
, 
[100206] = {id = 100206, new_skill_describe = 76201}
, 
[100704] = {id = 100704, new_skill_describe = 173291}
, 
[100705] = {id = 100705, new_skill_describe = 428822}
, 
[100706] = {id = 100706, new_skill_describe = 437812}
, 
[100804] = {id = 100804}
, 
[100805] = {id = 100805, new_skill_describe = 489313}
, 
[100806] = {id = 100806, new_skill_describe = 425372}
, 
[101004] = {id = 101004, new_skill_describe = 129607}
, 
[101005] = {id = 101005, new_skill_describe = 115097}
, 
[101006] = {id = 101006, new_skill_describe = 333066}
, 
[101104] = {id = 101104, new_skill_describe = 223138}
, 
[101105] = {id = 101105, new_skill_describe = 300977}
, 
[101106] = {id = 101106, new_skill_describe = 199606}
, 
[101604] = {id = 101604, new_skill_describe = 166918}
, 
[101605] = {id = 101605, new_skill_describe = 329951}
, 
[101606] = {id = 101606, new_skill_describe = 349486}
, 
[101804] = {id = 101804, new_skill_describe = 501136}
, 
[101805] = {id = 101805, new_skill_describe = 419107}
, 
[101806] = {id = 101806, new_skill_describe = 31037}
, 
[101904] = {id = 101904, new_skill_describe = 501703}
, 
[101905] = {id = 101905, new_skill_describe = 403635}
, 
[101906] = {id = 101906, new_skill_describe = 117795}
, 
[102104] = {id = 102104, new_skill_describe = 524239}
, 
[102105] = {id = 102105, new_skill_describe = 272526}
, 
[102106] = {id = 102106, new_skill_describe = 445225}
, 
[102204] = {id = 102204, new_skill_describe = 388601}
, 
[102205] = {id = 102205, new_skill_describe = 54984}
, 
[102206] = {id = 102206, new_skill_describe = 48304}
, 
[102504] = {id = 102504, new_skill_describe = 113744}
, 
[102505] = {id = 102505, new_skill_describe = 116179}
, 
[102506] = {id = 102506, new_skill_describe = 23902}
, 
[103104] = {id = 103104, new_skill_describe = 225986}
, 
[103105] = {id = 103105, new_skill_describe = 484145}
, 
[103106] = {id = 103106, new_skill_describe = 445631}
, 
[103404] = {id = 103404, new_skill_describe = 402223}
, 
[103405] = {id = 103405, new_skill_describe = 494093}
, 
[103406] = {id = 103406, new_skill_describe = 176090}
, 
[103904] = {id = 103904, new_skill_describe = 457494}
, 
[103905] = {id = 103905, new_skill_describe = 142124}
, 
[103906] = {id = 103906, new_skill_describe = 354044}
, 
[104104] = {id = 104104, new_skill_describe = 440552}
, 
[104105] = {id = 104105, new_skill_describe = 429180}
, 
[104106] = {id = 104106, new_skill_describe = 501325}
, 
[104604] = {id = 104604, new_skill_describe = 21089}
, 
[104605] = {id = 104605, new_skill_describe = 214160}
, 
[104606] = {id = 104606, new_skill_describe = 216065}
, 
[105705] = {id = 105705, new_skill_describe = 229820}
, 
[105706] = {id = 105706, new_skill_describe = 393518}
, 
[105707] = {id = 105707, new_skill_describe = 401165}
}
local __default_values = {id = 100204, new_skill_describe = 113351}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(spec_weapon_skill_des) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(spec_weapon_skill_des, {__index = __rawdata})
return spec_weapon_skill_des

