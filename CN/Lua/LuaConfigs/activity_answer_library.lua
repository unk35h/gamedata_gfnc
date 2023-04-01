-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_answer_library = {
{answer_1right = 5978, answer_2 = 123225, answer_3 = 125032, answer_4 = 171829, title = 5445}
, 
{answer_1right = 148523, answer_2 = 29863, answer_3 = 205407, answer_4 = 391395, title = 250939, title_id = 2}
, 
{answer_1right = 220297, answer_2 = 245114, answer_3 = 157947, answer_4 = 295556, title = 424586, title_id = 3}
, 
{answer_1right = 46305, answer_2 = 52411, answer_3 = 170608, answer_4 = 160884, title = 386984, title_id = 4}
, 
{answer_2 = 365283, answer_3 = 189659, answer_4 = 472491, title = 239953, title_id = 5}
, 
{answer_2 = 425940, answer_3 = 279575, answer_4 = 213507, title = 89120, title_id = 6}
, 
{answer_1right = 340881, answer_2 = 467766, answer_3 = 49418, answer_4 = 81491, title = 384877, title_id = 7}
, 
{answer_1right = 109425, answer_2 = 245103, answer_3 = 521869, answer_4 = 32693, title = 172667, title_id = 8}
, 
{answer_1right = "T1642", answer_2 = "T1641", title = 315384, title_id = 9}
, 
{answer_1right = 495165, answer_2 = 383973, answer_3 = 504830, answer_4 = 490149, title = 423270, title_id = 10}
, 
{answer_1right = "NotREAL?", answer_2 = 147155, answer_3 = 56148, answer_4 = 200086, title = 328605, title_id = 11}
, 
{answer_1right = 87399, answer_2 = 297612, answer_3 = 332678, answer_4 = 139228, title_id = 12}
, 
{answer_1right = 223873, answer_2 = 242442, answer_3 = 401823, answer_4 = 313898, title = 470812, title_id = 13}
, 
{answer_1right = 98834, answer_2 = 247873, answer_3 = 304585, answer_4 = 448601, title = 413670, title_id = 14}
, 
{answer_1right = 189659, answer_2 = 516981, answer_3 = 412120, answer_4 = 365283, title = 168873, title_id = 15}
, 
{answer_1right = 368678, answer_2 = 56544, answer_3 = 338221, answer_4 = 285036, title = 339077, title_id = 16}
, 
{answer_1right = 43974, answer_2 = 512348, answer_3 = 524129, answer_4 = 228619, title = 432464, title_id = 17}
, 
{answer_1right = 306185, answer_2 = 178415, answer_3 = 355602, answer_4 = 473509, title = 121274, title_id = 18}
, 
{answer_1right = 235162, answer_2 = 213154, answer_3 = 392640, answer_4 = 152242, title = 221532, title_id = 19}
, 
{answer_1right = 453828, answer_2 = 125863, answer_3 = 13199, answer_4 = 129816, title = 106226, title_id = 20}
, 
{answer_1right = 504810, answer_3 = 208774, answer_4 = 219029, title = 349857, title_id = 21}
, 
{answer_1right = 500473, answer_2 = 196416, answer_3 = 35058, answer_4 = 103404, title = 239609, title_id = 22}
, 
{answer_1right = 412120, answer_2 = 41160, answer_3 = 463012, answer_4 = 492583, title = 270832, title_id = 23}
, 
{answer_1right = 170332, answer_2 = 275038, answer_3 = 37158, answer_4 = 76415, title = 420852, title_id = 24}
, 
{answer_1right = 512425, answer_2 = 408498, answer_3 = 426447, answer_4 = 273739, title = 83775, title_id = 25}
, 
{answer_1right = 430214, answer_2 = 181643, answer_3 = 213597, answer_4 = 484005, title = 76684, title_id = 26}
, 
{answer_1right = 308493, answer_2 = 22547, answer_3 = 241624, answer_4 = 164645, title = 418844, title_id = 27}
, 
{answer_1right = 140034, answer_2 = 274580, answer_3 = 136486, answer_4 = 320507, title = 47693, title_id = 28}
, 
{answer_1right = 365283, answer_2 = 73980, answer_3 = 63247, answer_4 = 512348, title = 127384, title_id = 29}
, 
{answer_1right = 231791, answer_2 = 304585, answer_3 = 210734, answer_4 = 285909, title = 8003, title_id = 30}
}
local __default_values = {answer_1right = 501167, answer_2 = "2A,2B,2C,2D", answer_3 = "T3485", answer_4 = "T800", player_recommend = false, title = 102032, title_id = 1}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_answer_library) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_answer_library, {__index = __rawdata})
return activity_answer_library

