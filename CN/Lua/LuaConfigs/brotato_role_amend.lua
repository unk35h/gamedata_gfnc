-- params : ...
-- function num : 0 , upvalues : _ENV
local brotato_role_amend = {
[1001] = {}
, 
[1002] = {id = 1002, move_speed_factor = 500}
, 
[1003] = {id = 1003, move_speed_factor = 500}
, 
[1004] = {id = 1004, move_speed_factor = 500}
, 
[1005] = {id = 1005, move_speed_factor = 500}
, 
[1006] = {id = 1006, move_speed_factor = 500}
, 
[1007] = {id = 1007, move_speed_factor = 500}
, 
[1008] = {id = 1008, move_speed_factor = 500}
, 
[1009] = {id = 1009, move_speed_factor = 500}
, 
[1010] = {id = 1010, move_speed_factor = 500}
, 
[1011] = {id = 1011, move_speed_factor = 500}
, 
[1014] = {id = 1014, move_speed_factor = 500}
, 
[1015] = {id = 1015, move_speed_factor = 500}
, 
[1016] = {id = 1016}
, 
[1017] = {id = 1017}
, 
[1018] = {id = 1018}
, 
[1019] = {id = 1019}
, 
[1021] = {id = 1021}
, 
[1022] = {id = 1022}
, 
[1024] = {id = 1024}
, 
[1025] = {id = 1025}
, 
[1026] = {id = 1026}
, 
[1028] = {id = 1028}
, 
[1029] = {id = 1029}
, 
[1030] = {id = 1030}
, 
[1032] = {id = 1032}
, 
[1033] = {id = 1033}
, 
[1035] = {id = 1035}
, 
[1036] = {id = 1036}
, 
[1037] = {id = 1037}
, 
[1040] = {id = 1040}
, 
[1041] = {id = 1041}
, 
[1042] = {id = 1042}
, 
[1043] = {id = 1043}
, 
[1044] = {id = 1044, move_speed_factor = 200}
, 
[1045] = {id = 1045}
, 
[1046] = {id = 1046}
, 
[1047] = {id = 1047}
, 
[1048] = {id = 1048}
, 
[1049] = {id = 1049}
, 
[1050] = {id = 1050}
, 
[1051] = {id = 1051}
, 
[1052] = {id = 1052}
, 
[1053] = {id = 1053}
, 
[1054] = {id = 1054}
, 
[1055] = {id = 1055}
, 
[1056] = {id = 1056}
, 
[1057] = {id = 1057}
, 
[1058] = {id = 1058}
, 
[1059] = {id = 1059}
, 
[1060] = {id = 1060}
, 
[1061] = {id = 1061}
, 
[1062] = {id = 1062}
}
local __default_values = {attack_range_factor = 200, attack_speed_factor = 500, id = 1001, move_speed_factor = 100, skill_range_factor = 200}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(brotato_role_amend) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(brotato_role_amend, {__index = __rawdata})
return brotato_role_amend

