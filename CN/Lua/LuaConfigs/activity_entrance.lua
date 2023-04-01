-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_entrance = {
{activityId = 9001, 
jump_arg = {9001}
}
, 
{id = 2, image_entrance = "UI_CharDunLoginInPythonEntrance", popup_id = 2, red_dot = 2}
, 
{activityId = 10002, id = 3, image_entrance = "UI_CharDunLoginInKuroEntrance", 
jump_arg = {10002}
, popup_id = 3, red_dot = 2}
, 
{activityId = 11001, id = 4, image_entrance = "Winter21/UI_Win21Entrance", 
jump_arg = {11001}
, popup_id = 4}
, 
{activityId = 10003, id = 5, image_entrance = "UI_CharDunLoginInHazeEntrance", 
jump_arg = {10003}
, popup_id = 5, red_dot = 2}
, 
{activityId = 10009, id = 6, image_entrance = "UI_CharDunLoginInClukayEntrance", 
jump_arg = {10009}
, popup_id = 19, red_dot = 2}
, 
{activityId = 12001, id = 7, image_entrance = "WhiteDay22/UI_WhiteDayLoginInEntrance", 
jump_arg = {12001}
, popup_id = 7}
, 
{activityId = 10005, id = 8, image_entrance = "UI_CharDunLoginInMagnhildaEntrance", 
jump_arg = {10005}
, popup_id = 9, red_dot = 2}
, 
{activityId = 13001, id = 9, image_entrance = "AprilFool22/UI_AprilFoolLoginInEntrance", 
jump_arg = {13001}
, popup_id = 8}
, 
{activityId = 10004, id = 10, image_entrance = "UI_CharDunLoginInNoraEntrance", 
jump_arg = {10004}
, popup_id = 6, red_dot = 2}
, 
{activityId = 22001, id = 11, image_entrance = "Halloween22/UI_ActHalloween22LoginInEntrance", 
jump_arg = {22001}
, popup_id = 22}
, 
{activityId = 10006, id = 12, image_entrance = "UI_CharDunLoginInHelixEntrance", 
jump_arg = {10006}
, popup_id = 11, red_dot = 2}
, 
{activityId = 18001, id = 13, image_entrance = "MiniGame/UI_MiniGameEntrance", 
jump_arg = {18001}
, popup_id = 13}
, 
{activityId = 17001, id = 14, image_entrance = "Carnival22/UI_Carnival22LoginInEntrance", 
jump_arg = {17001}
, popup_id = 12}
, 
{activityId = 10007, id = 15, image_entrance = "UI_CharDunLoginInZangYinEntrance", 
jump_arg = {10007}
, popup_id = 14, red_dot = 2}
, 
{activityId = 19001, id = 16, image_entrance = "UI_EventDaliyChallenge22Entrance", 
jump_arg = {19001}
, popup_id = 15}
, 
{activityId = 10008, id = 17, image_entrance = "UI_CharDunLoginInMillauEntrance", 
jump_arg = {10008}
, popup_id = 16, red_dot = 2}
; 
[19] = {activityId = 20001, id = 19, image_entrance = "ActSummer2022/UI_ActSum22LoginInEntrance", 
jump_arg = {20001}
, popup_id = 18}
, 
[20] = {activityId = 12002, id = 20, image_entrance = "WhiteDay22/UI_WhiteDayLoginInEntrance2", 
jump_arg = {12002}
, popup_id = 17}
, 
[22] = {activityId = 10010, id = 22, image_entrance = "UI_CharDunLoginInClothoEntrance", 
jump_arg = {10010}
, popup_id = 20, red_dot = 2}
, 
[23] = {activityId = 10011, id = 23, image_entrance = "UI_CharDunLoginInDupinEntrance", 
jump_arg = {10011}
, popup_id = 23, red_dot = 2}
, 
[24] = {activityId = 22002, id = 24, image_entrance = "Christmas22/UI_Christmas22LoginInEntrance", 
jump_arg = {22002}
, popup_id = 27}
, 
[25] = {activityId = 24001, id = 25, image_entrance = "Spring23/UI_Spring23LoginInEntrance", 
jump_arg = {24001}
, popup_id = 29}
, 
[26] = {activityId = 10013, id = 26, image_entrance = "UI_CharDunLoginInJiangYuEntrance", 
jump_arg = {10013}
, popup_id = 28, red_dot = 2}
, 
[27] = {activityId = 10012, id = 27, image_entrance = "UI_CharDunLoginInUndlineEntrance", 
jump_arg = {10012}
, popup_id = 26, red_dot = 2}
, 
[28] = {activityId = 11002, id = 28, image_entrance = "Winter21/UI_Win21EntranceReprint", 
jump_arg = {11002}
, popup_id = 24}
, 
[29] = {activityId = 25001, id = 29, image_entrance = "Winter23/UI_Winter23LoginInEntrance", 
jump_arg = {25001}
, popup_id = 33}
, 
[30] = {activityId = 10014, id = 30, image_entrance = "UI_CharDunLoginInYelenaEntrance", 
jump_arg = {10014}
, popup_id = 31, red_dot = 2}
, 
[31] = {activityId = 12003, id = 31, image_entrance = "WhiteDay22/UI_WhiteDayReprintLoginInEntrance", 
jump_arg = {12003}
, popup_id = 32}
, 
[32] = {activityId = 17002, id = 32, image_entrance = "Carnival22/UI_Carnival23ReprintLoginInEntrance", 
jump_arg = {17002}
, popup_id = 34}
, 
[33] = {activityId = 10015, id = 33, image_entrance = "UI_CharDunLoginInErikaEntrance", 
jump_arg = {10015}
, popup_id = 35, red_dot = 2}
}
local __default_values = {activityId = 10001, id = 1, image_entrance = "ActSummer2021/UI_ActSum21Entrance", 
jump_arg = {10001}
, jump_id = 109, popup_id = 1, red_dot = 1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_entrance) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base, 
activityIdDic = {[9001] = 1, [10001] = 2, [10002] = 3, [10003] = 5, [10004] = 10, [10005] = 8, [10006] = 12, [10007] = 15, [10008] = 17, [10009] = 6, [10010] = 22, [10011] = 23, [10012] = 27, [10013] = 26, [10014] = 30, [10015] = 33, [11001] = 4, [11002] = 28, [12001] = 7, [12002] = 20, [12003] = 31, [13001] = 9, [17001] = 14, [17002] = 32, [18001] = 13, [19001] = 16, [20001] = 19, [22001] = 11, [22002] = 24, [24001] = 25, [25001] = 29}
}
setmetatable(activity_entrance, {__index = __rawdata})
return activity_entrance

