-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_spring_difficulty = {
{difficulty_des = 248204, difficulty_name = 248204}
, 
{
catalog = {103, 104, 610}
, difficulty_id = 2, difficulty_name_en = "NORMAL MODE"}
, 
{
catalog = {105, 106, 611}
, difficulty_des = 360027, difficulty_id = 3, difficulty_name = 360027, difficulty_name_en = "HARD MODE"}
, 
{
catalog = {107, 108, 612}
, difficulty_des = 94840, difficulty_id = 4, difficulty_name = 94840, difficulty_name_en = "EXTREME MODE"}
, 
{
catalog = {201, 202, 609}
, difficulty_des = 248204, difficulty_id = 5, difficulty_name = 248204}
, 
{
catalog = {203, 204, 610}
, difficulty_id = 6, difficulty_name_en = "NORMAL MODE"}
, 
{
catalog = {205, 206, 611}
, difficulty_des = 360027, difficulty_id = 7, difficulty_name = 360027, difficulty_name_en = "HARD MODE"}
, 
{
catalog = {207, 208, 612}
, difficulty_des = 94840, difficulty_id = 8, difficulty_name = 94840, difficulty_name_en = "EXTREME MODE"}
, 
{
catalog = {301, 302, 609}
, difficulty_des = 248204, difficulty_id = 9, difficulty_name = 248204}
, 
{
catalog = {303, 304, 610}
, difficulty_id = 10, difficulty_name_en = "NORMAL MODE"}
, 
{
catalog = {305, 306, 611}
, difficulty_des = 360027, difficulty_id = 11, difficulty_name = 360027, difficulty_name_en = "HARD MODE"}
, 
{
catalog = {307, 308, 612}
, difficulty_des = 94840, difficulty_id = 12, difficulty_name = 94840, difficulty_name_en = "EXTREME MODE"}
, 
{
catalog = {401, 402, 609}
, difficulty_des = 248204, difficulty_id = 13, difficulty_name = 248204}
, 
{
catalog = {403, 404, 610}
, difficulty_id = 14, difficulty_name_en = "NORMAL MODE"}
, 
{
catalog = {405, 406, 611}
, difficulty_des = 360027, difficulty_id = 15, difficulty_name = 360027, difficulty_name_en = "HARD MODE"}
, 
{
catalog = {407, 408, 612}
, difficulty_des = 94840, difficulty_id = 16, difficulty_name = 94840, difficulty_name_en = "EXTREME MODE"}
, 
{
catalog = {501, 502, 609}
, difficulty_des = 248204, difficulty_id = 17, difficulty_name = 248204}
, 
{
catalog = {503, 504, 610}
, difficulty_id = 18, difficulty_name_en = "NORMAL MODE"}
, 
{
catalog = {505, 506, 611}
, difficulty_des = 360027, difficulty_id = 19, difficulty_name = 360027, difficulty_name_en = "HARD MODE"}
, 
{
catalog = {507, 508, 612}
, difficulty_des = 94840, difficulty_id = 20, difficulty_name = 94840, difficulty_name_en = "EXTREME MODE"}
, 
{
catalog = {601, 602, 609}
, difficulty_des = 248204, difficulty_id = 21, difficulty_name = 248204}
, 
{
catalog = {603, 604, 610}
, difficulty_id = 22, difficulty_name_en = "NORMAL MODE"}
, 
{
catalog = {605, 606, 611}
, difficulty_des = 360027, difficulty_id = 23, difficulty_name = 360027, difficulty_name_en = "HARD MODE"}
, 
{
catalog = {607, 608, 612}
, difficulty_des = 94840, difficulty_id = 24, difficulty_name = 94840, difficulty_name_en = "EXTREME MODE"}
}
local __default_values = {
catalog = {101, 102, 609}
, difficulty_des = 215360, difficulty_id = 1, difficulty_name = 215360, difficulty_name_en = "EASY MODE"}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_spring_difficulty) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_spring_difficulty, {__index = __rawdata})
return activity_spring_difficulty

