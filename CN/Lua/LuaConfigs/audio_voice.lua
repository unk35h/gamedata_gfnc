-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {}
local __rt_2 = {6}
local __rt_3 = {0}
local __rt_4 = {29}
local __rt_5 = {301806}
local __rt_6 = {301806003}
local __rt_7 = {301806006}
local __rt_8 = {304607}
local __rt_9 = {306103}
local audio_voice = {
{describe = 379491, is_show = 1, name = "MORNING"}
, 
{describe = 350428, id = 2, is_show = 2, name = "AFTERNOON"}
, 
{describe = 474134, id = 3, is_show = 3, name = "EVENING"}
, 
{describe = 423077, id = 4, is_show = 4, name = "MIDNIGHT"}
, 
{describe = 307943, id = 5, is_show = 5, name = "DIALOGUE1"}
, 
{describe = 113172, id = 6, is_show = 6, name = "DIALOGUE2"}
, 
{describe = "DIALOGUE3", id = 7, name = "DIALOGUE3"}
, 
{describe = 442689, id = 8, is_show = 7, name = "DIALOGUE4"}
, 
{describe = "DIALOGUE5", id = 9, name = "DIALOGUE5"}
, 
{describe = 427119, id = 10, is_show = 8, name = "INTERACT1"}
, 
{describe = 232348, id = 11, is_show = 9, name = "INTERACT2"}
, 
{describe = 37577, id = 12, is_show = 10, name = "INTERACT3"}
, 
{describe = "NEWYEAR", id = 13, name = "NEWYEAR"}
, 
{describe = "VALENTINE", id = 14, name = "VALENTINE"}
, 
{describe = "TANABATA", id = 15, name = "TANABATA"}
, 
{describe = "ALLHALLOWS", id = 16, name = "ALLHALLOWS"}
, 
{describe = "CHRISTMAS", id = 17, name = "CHRISTMAS"}
, 
{describe = "PLAYERBIRTHDAY", id = 18, name = "PLAYERBIRTHDAY"}
; 
[101] = {describe = 208045, id = 101, is_show = 11, name = "GAIN"}
, 
[102] = {describe = 62926, id = 102, is_show = 12, name = "LEVELUP"}
, 
[103] = {describe = 432664, id = 103, is_show = 13, name = "RANKUP"}
, 
[104] = {describe = "RANKMAX", id = 104, name = "RANKMAX"}
, 
[105] = {describe = 343117, id = 105, is_show = 14, name = "FORMATION"}
, 
[106] = {describe = 382310, id = 106, is_show = 15, name = "BATTLE"}
, 
[107] = {describe = 53739, id = 107, is_show = 16, name = "SKILL"}
, 
[108] = {id = 108, is_show = 17, name = "MVP1"}
, 
[109] = {describe = "MVP2", id = 109, is_show = 18, name = "MVP2"}
, 
[110] = {describe = "DUTY", id = 110, name = "DUTY"}
, 
[111] = {describe = 214099, id = 111, is_show = 19, name = "RETREAT"}
, 
[112] = {describe = 54720, id = 112, name = "RELATIONSHIP1", pre_condition = __rt_2, pre_para1 = __rt_3, pre_para2 = __rt_2}
, 
[113] = {describe = 384237, id = 113, name = "RELATIONSHIP2", pre_condition = __rt_2, pre_para1 = __rt_3, 
pre_para2 = {7}
}
, 
[114] = {describe = 189466, id = 114, name = "RELATIONSHIP3", pre_condition = __rt_2, pre_para1 = __rt_3, 
pre_para2 = {8}
}
, 
[115] = {describe = 518983, id = 115, name = "RELATIONSHIP4", pre_condition = __rt_2, pre_para1 = __rt_3, 
pre_para2 = {9}
}
, 
[116] = {describe = 324212, id = 116, name = "RELATIONSHIP5", pre_condition = __rt_2, pre_para1 = __rt_3, 
pre_para2 = {10}
}
, 
[117] = {describe = "OATH", id = 117, name = "OATH"}
, 
[118] = {describe = 120297, id = 118, is_show = 20, name = "TITLE"}
, 
[140] = {describe = 319339, id = 140, name = "ACCEPT"}
, 
[141] = {describe = 450835, id = 141, name = "AGREE"}
, 
[142] = {describe = 308809, id = 142, name = "APPRECIATE"}
, 
[143] = {describe = 443615, id = 143, name = "FEELING"}
, 
[144] = {describe = 448691, id = 144, name = "LOWMOOD"}
, 
[145] = {describe = 461636, id = 145, name = "MOOD1"}
, 
[146] = {describe = 108415, id = 146, name = "MOOD2"}
, 
[201] = {describe = "Live2D", id = 201}
, 
[1059001] = {describe = 92045, exclusive_hero = 1059, id = 1059001, is_show = 21, name = "MORNING_2"}
, 
[1059002] = {describe = 361744, exclusive_hero = 1059, id = 1059002, is_show = 22, name = "AFTERNOON_2"}
, 
[1059003] = {describe = 343982, exclusive_hero = 1059, id = 1059003, is_show = 23, name = "EVENING_2"}
, 
[1059004] = {describe = 148995, exclusive_hero = 1059, id = 1059004, is_show = 24, name = "MIDNIGHT_2"}
, 
[1059005] = {describe = 49273, exclusive_hero = 1059, id = 1059005, is_show = 25, name = "DIALOGUE1_2"}
, 
[1059006] = {describe = 446456, exclusive_hero = 1059, id = 1059006, is_show = 26, name = "DIALOGUE2_2"}
, 
[1059007] = {describe = 295949, exclusive_hero = 1059, id = 1059007, name = "DIALOGUE3_2"}
, 
[1059008] = {describe = 319351, exclusive_hero = 1059, id = 1059008, is_show = 27, name = "DIALOGUE4_2"}
, 
[1059009] = {describe = 41739, exclusive_hero = 1059, id = 1059009, name = "DIALOGUE5_2"}
, 
[1059010] = {describe = 122833, exclusive_hero = 1059, id = 1059010, is_show = 28, name = "INTERACT1_2"}
, 
[1059011] = {describe = 520016, exclusive_hero = 1059, id = 1059011, is_show = 29, name = "INTERACT2_2"}
, 
[1059012] = {describe = 392911, exclusive_hero = 1059, id = 1059012, is_show = 30, name = "INTERACT3_2"}
, 
[1059013] = {describe = 264387, exclusive_hero = 1059, id = 1059013, name = "NEWYEAR_2"}
, 
[1059014] = {describe = 479174, exclusive_hero = 1059, id = 1059014, name = "VALENTINE_2"}
, 
[1059015] = {describe = 399120, exclusive_hero = 1059, id = 1059015, name = "TANABATA_2"}
, 
[1059016] = {describe = 87023, exclusive_hero = 1059, id = 1059016, name = "ALLHALLOWS_2"}
, 
[1059017] = {describe = 113130, exclusive_hero = 1059, id = 1059017, name = "CHRISTMAS_2"}
, 
[1059018] = {describe = 355002, exclusive_hero = 1059, id = 1059018, name = "PLAYERBIRTHDAY_2"}
, 
[1059102] = {describe = 475158, exclusive_hero = 1059, id = 1059102, is_show = 32, name = "LEVELUP_2"}
, 
[1059103] = {describe = 189284, exclusive_hero = 1059, id = 1059103, is_show = 33, name = "RANKUP_2"}
, 
[1059104] = {describe = 69904, exclusive_hero = 1059, id = 1059104, name = "RANKMAX_2"}
, 
[1059105] = {describe = 357051, exclusive_hero = 1059, id = 1059105, is_show = 34, name = "FORMATION_2"}
, 
[1059106] = {describe = 461379, exclusive_hero = 1059, id = 1059106, is_show = 35, name = "BATTLE_2"}
, 
[1059107] = {describe = 243941, exclusive_hero = 1059, id = 1059107, is_show = 36, name = "SKILL_2"}
, 
[1059108] = {describe = 201350, exclusive_hero = 1059, id = 1059108, is_show = 37, name = "MVP1_2"}
, 
[1059109] = {describe = 74245, exclusive_hero = 1059, id = 1059109, is_show = 38, name = "MVP2_2"}
, 
[1059110] = {describe = 462014, exclusive_hero = 1059, id = 1059110, name = "DUTY_2"}
, 
[1059118] = {describe = 125743, exclusive_hero = 1059, id = 1059118, is_show = 40, name = "TITLE_2"}
, 
[1059140] = {describe = 345445, exclusive_hero = 1059, id = 1059140, name = "ACCEPT_2"}
, 
[1059141] = {describe = 200733, exclusive_hero = 1059, id = 1059141, name = "AGREE_2"}
, 
[1059142] = {describe = 154959, exclusive_hero = 1059, id = 1059142, name = "APPRECIATE_2"}
, 
[1059143] = {describe = 343969, exclusive_hero = 1059, id = 1059143, name = "FEELING_2"}
, 
[1059144] = {describe = 91645, exclusive_hero = 1059, id = 1059144, name = "LOWMOOD_2"}
, 
[1059145] = {describe = 295944, exclusive_hero = 1059, id = 1059145, name = "MOOD1_2"}
, 
[1059146] = {describe = 433793, exclusive_hero = 1059, id = 1059146, name = "MOOD2_2"}
, 
[301806001] = {describe = 379491, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806001, is_show = 54, name = "NEWYEAR_MORNING", pre_condition = __rt_4, pre_para1 = __rt_5, pre_para2 = __rt_6}
, 
[301806003] = {describe = 474134, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806003, is_show = 55, name = "NEWYEAR_EVENING", pre_condition = __rt_4, pre_para1 = __rt_5, pre_para2 = __rt_6}
, 
[301806004] = {describe = 423077, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806004, is_show = 56, name = "NEWYEAR_MIDNIGHT", pre_condition = __rt_4, pre_para1 = __rt_5, pre_para2 = __rt_6}
, 
[301806005] = {describe = 307943, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806005, is_show = 57, name = "NEWYEAR_DIALOGUE1", pre_condition = __rt_4, pre_para1 = __rt_5, 
pre_para2 = {301806005}
}
, 
[301806006] = {describe = 113172, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806006, is_show = 58, name = "NEWYEAR_DIALOGUE2", pre_condition = __rt_4, pre_para1 = __rt_5, pre_para2 = __rt_7}
, 
[301806008] = {describe = 442689, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806008, is_show = 59, name = "NEWYEAR_DIALOGUE4", pre_condition = __rt_4, pre_para1 = __rt_5, pre_para2 = __rt_7}
, 
[301806010] = {describe = 427119, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806010, is_show = 60, name = "NEWYEAR_INTERACT1", pre_condition = __rt_4, pre_para1 = __rt_5, 
pre_para2 = {301806010}
}
, 
[301806011] = {describe = 232348, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806011, is_show = 61, name = "NEWYEAR_INTERACT2", pre_condition = __rt_4, pre_para1 = __rt_5, 
pre_para2 = {301806011}
}
, 
[301806012] = {describe = 37577, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806012, is_show = 62, name = "NEWYEAR_INTERACT3", pre_condition = __rt_4, pre_para1 = __rt_5, 
pre_para2 = {301806012}
}
, 
[301806101] = {describe = 208045, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806101, is_show = 63, name = "NEWYEAR_GAIN", pre_condition = __rt_4, pre_para1 = __rt_5, 
pre_para2 = {301806101}
}
, 
[301806105] = {describe = 343117, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806105, is_show = 64, name = "NEWYEAR_FORMATION", pre_condition = __rt_4, pre_para1 = __rt_5, 
pre_para2 = {301806105}
}
, 
[301806106] = {describe = 382310, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806106, is_show = 65, name = "NEWYEAR_BATTLE", pre_condition = __rt_4, pre_para1 = __rt_5, 
pre_para2 = {301806106}
}
, 
[301806107] = {describe = 53739, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806107, is_show = 66, name = "NEWYEAR_SKILL", pre_condition = __rt_4, pre_para1 = __rt_5, 
pre_para2 = {301806107}
}
, 
[301806108] = {exclusive_hero = 1018, exclusive_skin = 301806, id = 301806108, is_show = 67, name = "NEWYEAR_MVP1", pre_condition = __rt_4, pre_para1 = __rt_5, 
pre_para2 = {301806108}
}
, 
[301806111] = {describe = 214099, exclusive_hero = 1018, exclusive_skin = 301806, id = 301806111, is_show = 68, name = "NEWYEAR_RETREAT", pre_condition = __rt_4, pre_para1 = __rt_5, 
pre_para2 = {301806111}
}
, 
[301806201] = {describe = "Live2D", exclusive_hero = 1018, exclusive_skin = 301806, id = 301806201, pre_condition = __rt_4, pre_para1 = __rt_5, 
pre_para2 = {301806201}
}
, 
[304607002] = {describe = 350428, exclusive_hero = 1046, exclusive_skin = 304607, id = 304607002, is_show = 69, name = "WUXIA_AFTERNOON", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607002}
}
, 
[304607003] = {describe = 474134, exclusive_hero = 1046, exclusive_skin = 304607, id = 304607003, is_show = 70, name = "WUXIA_EVENING", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607003}
}
, 
[304607004] = {describe = 423077, exclusive_hero = 1046, exclusive_skin = 304607, id = 304607004, is_show = 71, name = "WUXIA_MIDNIGHT", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607004}
}
, 
[304607006] = {describe = 113172, exclusive_hero = 1046, exclusive_skin = 304607, id = 304607006, is_show = 72, name = "WUXIA_DIALOGUE2", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607006}
}
, 
[304607007] = {describe = "DIALOGUE3", exclusive_hero = 1046, exclusive_skin = 304607, id = 304607007, name = "WUXIA_DIALOGUE3", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607007}
}
, 
[304607008] = {describe = 442689, exclusive_hero = 1046, exclusive_skin = 304607, id = 304607008, is_show = 73, name = "WUXIA_DIALOGUE4", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607008}
}
, 
[304607009] = {describe = "DIALOGUE5", exclusive_hero = 1046, exclusive_skin = 304607, id = 304607009, name = "WUXIA_DIALOGUE5", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607009}
}
, 
[304607010] = {describe = 427119, exclusive_hero = 1046, exclusive_skin = 304607, id = 304607010, is_show = 74, name = "WUXIA_INTERACT1", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607010}
}
, 
[304607012] = {describe = 37577, exclusive_hero = 1046, exclusive_skin = 304607, id = 304607012, is_show = 75, name = "WUXIA_INTERACT3", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607012}
}
, 
[304607101] = {describe = 208045, exclusive_hero = 1046, exclusive_skin = 304607, id = 304607101, is_show = 76, name = "WUXIA_GAIN", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607101}
}
, 
[304607105] = {describe = 343117, exclusive_hero = 1046, exclusive_skin = 304607, id = 304607105, is_show = 77, name = "WUXIA_FORMATION", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607105}
}
, 
[304607106] = {describe = 382310, exclusive_hero = 1046, exclusive_skin = 304607, id = 304607106, is_show = 78, name = "WUXIA_BATTLE", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607106}
}
, 
[304607107] = {describe = 53739, exclusive_hero = 1046, exclusive_skin = 304607, id = 304607107, is_show = 79, name = "WUXIA_SKILL", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607107}
}
, 
[304607108] = {exclusive_hero = 1046, exclusive_skin = 304607, id = 304607108, is_show = 80, name = "WUXIA_MVP1", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607108}
}
, 
[304607111] = {describe = 214099, exclusive_hero = 1046, exclusive_skin = 304607, id = 304607111, is_show = 81, name = "WUXIA_RETREAT", pre_condition = __rt_4, pre_para1 = __rt_8, 
pre_para2 = {304607111}
}
, 
[306103003] = {describe = 474134, exclusive_hero = 1061, exclusive_skin = 306103, id = 306103003, is_show = 41, name = "CHRISTMAS_EVENING", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103003}
}
, 
[306103005] = {describe = 307943, exclusive_hero = 1061, exclusive_skin = 306103, id = 306103005, is_show = 42, name = "CHRISTMAS_DIALOGUE1", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103005}
}
, 
[306103006] = {describe = 113172, exclusive_hero = 1061, exclusive_skin = 306103, id = 306103006, is_show = 43, name = "CHRISTMAS_DIALOGUE2", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103006}
}
, 
[306103009] = {describe = "DIALOGUE5", exclusive_hero = 1061, exclusive_skin = 306103, id = 306103009, name = "CHRISTMAS_DIALOGUE5", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103009}
}
, 
[306103010] = {describe = 427119, exclusive_hero = 1061, exclusive_skin = 306103, id = 306103010, is_show = 44, name = "CHRISTMAS_INTERACT1", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103010}
}
, 
[306103011] = {describe = 232348, exclusive_hero = 1061, exclusive_skin = 306103, id = 306103011, is_show = 45, name = "CHRISTMAS_INTERACT2", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103011}
}
, 
[306103012] = {describe = 37577, exclusive_hero = 1061, exclusive_skin = 306103, id = 306103012, is_show = 46, name = "CHRISTMAS_INTERACT3", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103012}
}
, 
[306103101] = {describe = 208045, exclusive_hero = 1061, exclusive_skin = 306103, id = 306103101, is_show = 47, name = "CHRISTMAS_GAIN", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103101}
}
, 
[306103105] = {describe = 343117, exclusive_hero = 1061, exclusive_skin = 306103, id = 306103105, is_show = 48, name = "CHRISTMAS_FORMATION", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103105}
}
, 
[306103106] = {describe = 382310, exclusive_hero = 1061, exclusive_skin = 306103, id = 306103106, is_show = 49, name = "CHRISTMAS_BATTLE", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103106}
}
, 
[306103107] = {describe = 53739, exclusive_hero = 1061, exclusive_skin = 306103, id = 306103107, is_show = 50, name = "CHRISTMAS_SKILL", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103107}
}
, 
[306103108] = {exclusive_hero = 1061, exclusive_skin = 306103, id = 306103108, is_show = 51, name = "CHRISTMAS_MVP1", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103108}
}
, 
[306103109] = {describe = "MVP2", exclusive_hero = 1061, exclusive_skin = 306103, id = 306103109, is_show = 52, name = "CHRISTMAS_MVP2", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103109}
}
, 
[306103110] = {describe = "DUTY", exclusive_hero = 1061, exclusive_skin = 306103, id = 306103110, name = "CHRISTMAS_DUTY", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103110}
}
, 
[306103111] = {describe = 214099, exclusive_hero = 1061, exclusive_skin = 306103, id = 306103111, is_show = 53, name = "CHRISTMAS_RETREAT", pre_condition = __rt_4, pre_para1 = __rt_9, 
pre_para2 = {306103111}
}
}
local __default_values = {describe = "MVP1", exclusive_hero = 0, exclusive_skin = 0, id = 1, is_show = 0, name = "L2D", pre_condition = __rt_1, pre_para1 = __rt_1, pre_para2 = __rt_1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in (_ENV.pairs)(audio_voice) do
  (_ENV.setmetatable)(v, base)
end
local __rawdata = {__basemetatable = base, 
heroVoiceSkinIdList = {
[1018] = {1018, 301806}
, 
[1046] = {1046, 304607}
, 
[1061] = {1061, 306103}
}
, 
skinVoice = {
[301806] = {301806101, 301806105, 301806106, 301806107, 301806108, 301806001, 301806003, 301806004, 301806005, 301806006, 301806010, 301806008, 301806011, 301806111, 301806012}
, 
[304607] = {304607108, 304607111, 304607107, 304607106, 304607105, 304607012, 304607010, 304607008, 304607006, 304607004, 304607003, 304607002, 304607101}
, 
[306103] = {306103111, 306103109, 306103108, 306103107, 306103106, 306103105, 306103101, 306103003, 306103005, 306103006, 306103010, 306103011, 306103012}
}
}
;
(_ENV.setmetatable)(audio_voice, {__index = __rawdata})
return audio_voice

