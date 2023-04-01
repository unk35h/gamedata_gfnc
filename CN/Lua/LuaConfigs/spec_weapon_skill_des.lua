-- params : ...
-- function num : 0 , upvalues : _ENV
local spec_weapon_skill_des = {
[100204] = {new_skill_describe = 219093}
, 
[100205] = {id = 100205, new_skill_describe = 262949}
, 
[100206] = {id = 100206, new_skill_describe = 343462}
, 
[100704] = {id = 100704, new_skill_describe = 441561}
, 
[100705] = {id = 100705, new_skill_describe = 40868}
, 
[100706] = {id = 100706, new_skill_describe = 6370}
, 
[101004] = {id = 101004, new_skill_describe = 75308}
, 
[101005] = {id = 101005, new_skill_describe = 48567}
, 
[101006] = {id = 101006, new_skill_describe = 23601}
, 
[101104] = {id = 101104, new_skill_describe = 291717}
, 
[101105] = {id = 101105, new_skill_describe = 308734}
, 
[101106] = {id = 101106, new_skill_describe = 519063}
, 
[101604] = {id = 101604, new_skill_describe = 251214}
, 
[101605] = {id = 101605, new_skill_describe = 462913}
, 
[101606] = {id = 101606, new_skill_describe = 325318}
, 
[101804] = {id = 101804, new_skill_describe = 24630}
, 
[101805] = {id = 101805, new_skill_describe = 24658}
, 
[101806] = {id = 101806, new_skill_describe = 135375}
, 
[101904] = {id = 101904, new_skill_describe = 432589}
, 
[101905] = {id = 101905, new_skill_describe = 214920}
, 
[101906] = {id = 101906, new_skill_describe = 94329}
, 
[102104] = {id = 102104, new_skill_describe = 452129}
, 
[102105] = {id = 102105, new_skill_describe = 355638}
, 
[102106] = {id = 102106, new_skill_describe = 25937}
, 
[102204] = {id = 102204, new_skill_describe = 37414}
, 
[102205] = {id = 102205, new_skill_describe = 20173}
, 
[102206] = {id = 102206, new_skill_describe = 450607}
, 
[102504] = {id = 102504, new_skill_describe = 399929}
, 
[102505] = {id = 102505, new_skill_describe = 207148}
, 
[102506] = {id = 102506, new_skill_describe = 37385}
, 
[103104] = {id = 103104, new_skill_describe = 481664}
, 
[103105] = {id = 103105}
, 
[103106] = {id = 103106, new_skill_describe = 52649}
, 
[103404] = {id = 103404, new_skill_describe = 266762}
, 
[103405] = {id = 103405, new_skill_describe = 230917}
, 
[103406] = {id = 103406, new_skill_describe = 247875}
, 
[103904] = {id = 103904, new_skill_describe = 437838}
, 
[103905] = {id = 103905, new_skill_describe = 304420}
, 
[103906] = {id = 103906, new_skill_describe = 334388}
, 
[104104] = {id = 104104, new_skill_describe = 323925}
, 
[104105] = {id = 104105, new_skill_describe = 369011}
, 
[104106] = {id = 104106, new_skill_describe = 516639}
, 
[104604] = {id = 104604, new_skill_describe = 169487}
, 
[104605] = {id = 104605, new_skill_describe = 321706}
, 
[104606] = {id = 104606, new_skill_describe = 201199}
, 
[105705] = {id = 105705, new_skill_describe = 144418}
, 
[105706] = {id = 105706, new_skill_describe = 341218}
, 
[105707] = {id = 105707, new_skill_describe = 340863}
}
local __default_values = {id = 100204, new_skill_describe = 120710}
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

