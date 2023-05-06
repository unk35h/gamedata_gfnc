-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {}
local activity_general = {
{}
, 
{id = 2}
; 
[10009] = {id = 10009}
, 
[10010] = {id = 10010}
, 
[10011] = {id = 10011}
, 
[10012] = {id = 10012}
, 
[10013] = {id = 10013}
, 
[10014] = {id = 10014}
, 
[10015] = {id = 10015}
, 
[10016] = {id = 10016}
, 
[17001] = {id = 17001}
, 
[17002] = {id = 17002}
, 
[20001] = {id = 20001}
, 
[22002] = {id = 22002}
, 
[23001] = {id = 23001}
, 
[23002] = {id = 23002}
, 
[24001] = {id = 24001, 
once_quest = {9517, 9518, 9519, 9520, 9521, 9522, 9523, 9524, 9525, 9526, 9527, 9528, 9529, 9530, 9531, 9532, 9533, 9534, 9535, 9536, 9537, 9538, 9539, 9540, 9541, 9542, 9543, 9544, 9545, 9546, 9547, 9548, 9549, 9550, 9551, 9552, 9553, 9554, 9555, 9556, 9557, 9558, 9559, 9560, 9561, 9562, 9563, 9564, 9565}
}
, 
[25001] = {id = 25001, 
period_quest = {9600, 9601}
}
, 
[31001] = {id = 31001, 
once_quest = {7119, 7120, 7121, 7122, 7123, 7124, 7125, 7126, 7127, 7128, 7129, 7130, 7131, 7132, 7133, 7134, 7135, 7136, 7137, 7138, 7139, 7140, 7141, 7142, 7143, 7144, 7145, 7146, 7147, 7148, 7149, 7150, 7151, 7152, 7153, 7154, 7155, 7156, 7157, 7158, 7159, 7160}
}
}
local __default_values = {id = 1, once_quest = __rt_1, period_quest = __rt_1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_general) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_general, {__index = __rawdata})
return activity_general

