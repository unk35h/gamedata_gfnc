-- params : ...
-- function num : 0 , upvalues : _ENV
local camp = {
{camp_audio = 4004, camp_info = 254327, camp_video_path = "energy", editor_filter_name = 387183, name = 387183}
, 
{camp_info = 64248, camp_info_audio = 4052, icon = "2_camp", id = 2}
, 
{camp_audio = 4001, camp_info = 466113, camp_info_audio = 4053, camp_video_path = "dna", editor_filter_name = 23549, icon = "3_camp", id = 3, name = 28609}
, 
{camp_audio = 4003, camp_info_audio = 4054, camp_video_path = "cyber", editor_filter_name = 11829, icon = "4_camp", id = 4, name = 11829}
, 
{camp_audio = 4002, camp_info = 425373, camp_info_audio = 4055, camp_video_path = "global", editor_filter_name = 14040, icon = "5_camp", id = 5, name = 444397}
}
local __default_values = {camp_audio = 4000, camp_info = 110254, camp_info_audio = 4051, camp_video_path = "42lab", editor_filter_name = "42LAB", icon = "1_camp", id = 1, name = "42LAB"}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(camp) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base, 
camp2HeroListDic = {
{1004, 1005, 1007, 1010, 1024, 1027, 1032, 1034, 1041, 1043, 1047, 1049, 1056, 1058, 1067}
, 
{1001, 1002, 1003, 1006, 1009, 1011, 1012, 1019, 1020, 1037, 1042, 1045, 1055, 1057}
, 
{1015, 1018, 1023, 1028, 1031, 1033, 1052, 1065}
, 
{1016, 1021, 1025, 1026, 1029, 1044, 1046, 1048, 1050, 1051, 1053, 1054, 1061, 1062, 1063}
, 
{1008, 1013, 1014, 1017, 1022, 1030, 1035, 1036, 1038, 1039, 1040, 1059, 1060, 1064, 1066}
}
, 
camp2HeroNumDic = {15, 14, 8, 15, 15}
}
setmetatable(camp, {__index = __rawdata})
return camp

