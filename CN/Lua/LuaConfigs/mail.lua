-- params : ...
-- function num : 0 , upvalues : _ENV
local mail = {
[102] = {}
, 
[103] = {entry = 103}
, 
[112] = {entry = 112}
, 
[113] = {entry = 113}
, 
[114] = {entry = 114, type = 1}
, 
[115] = {entry = 115, type = 1}
, 
[116] = {entry = 116}
, 
[117] = {entry = 117}
, 
[118] = {entry = 118}
, 
[119] = {entry = 119}
, 
[120] = {entry = 120}
, 
[121] = {entry = 121}
, 
[122] = {entry = 122}
, 
[123] = {entry = 123}
, 
[124] = {entry = 124}
, 
[125] = {entry = 125}
, 
[126] = {entry = 126}
, 
[127] = {entry = 127}
, 
[128] = {entry = 128}
, 
[129] = {entry = 129}
, 
[130] = {entry = 130}
, 
[131] = {entry = 131}
, 
[132] = {entry = 132}
, 
[133] = {entry = 133}
, 
[134] = {entry = 134}
, 
[135] = {entry = 135}
, 
[136] = {entry = 136}
, 
[137] = {entry = 137}
, 
[138] = {entry = 138}
, 
[139] = {entry = 139}
, 
[140] = {entry = 140}
, 
[141] = {entry = 141}
, 
[142] = {entry = 142}
, 
[143] = {entry = 143}
, 
[144] = {entry = 144}
, 
[145] = {entry = 145}
, 
[146] = {entry = 146}
, 
[147] = {entry = 147}
, 
[148] = {entry = 148}
, 
[149] = {entry = 149}
, 
[150] = {entry = 150}
, 
[151] = {entry = 151}
, 
[152] = {entry = 152}
, 
[153] = {entry = 153}
, 
[154] = {entry = 154}
, 
[155] = {entry = 155}
, 
[156] = {entry = 156}
, 
[157] = {entry = 157}
, 
[158] = {entry = 158}
, 
[159] = {entry = 159}
, 
[160] = {entry = 160}
, 
[161] = {entry = 161}
, 
[162] = {entry = 162}
, 
[163] = {entry = 163}
, 
[164] = {entry = 164}
, 
[165] = {entry = 165}
, 
[166] = {entry = 166}
, 
[167] = {entry = 167}
, 
[168] = {entry = 168}
, 
[169] = {entry = 169}
, 
[170] = {entry = 170}
}
local __default_values = {entry = 102, type = 0}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(mail) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(mail, {__index = __rawdata})
return mail

