-- params : ...
-- function num : 0 , upvalues : _ENV
local scene = {
{audio_id = 3330, scene_name = "006_Arena_001"}
, 
{audio_id = 3102, deploy_rows = 2, id = 2, scene_name = "006_Arena_002", size_row = 6}
, 
{audio_id = 3101, deploy_rows = 2, id = 3, scene_name = "006_Arena_003", size_row = 6}
, 
{audio_id = 3103, id = 4, scene_name = "006_Arena_004"}
, 
{audio_id = 3107, deploy_rows = 2, id = 5, size_row = 6}
, 
{audio_id = 3104, id = 6, scene_name = "006_Arena_005"}
, 
{id = 7, scene_name = "006_Arena_006"}
, 
{audio_id = 3104, id = 8, scene_name = "006_Arena_007"}
, 
{audio_id = 3104, deploy_rows = 11, id = 9, scene_name = "006_Arena_TD_000", size_col = 7, size_row = 11}
, 
{audio_id = 3106, deploy_rows = 2, id = 10, scene_name = "006_Arena_008", size_row = 6}
, 
{audio_id = 3201, deploy_rows = 2, id = 11, scene_name = "006_Arena_010", size_row = 6}
, 
{audio_id = 3108, depth_support = true, id = 12, scene_name = "006_Arena_SE2021_003"}
, 
{deploy_rows = 11, depth_support = true, id = 13, scene_name = "006_Arena_SE2021_001", size_col = 7, size_row = 11}
, 
{audio_id = 3109, id = 14, scene_name = "006_Arena_SE2021_002"}
, 
{audio_id = 3201, depth_support = true, id = 15, scene_name = "006_Arena_SE2021_003"}
, 
{audio_id = 3107, id = 16, size_row = 6}
, 
{audio_id = 3201, id = 17, scene_name = "006_Arena_010", size_row = 6}
, 
{audio_id = 3110, id = 18, scene_name = "006_Arena_012"}
, 
{audio_id = 3202, id = 19, scene_name = "006_Arena_010", size_row = 6}
, 
{audio_id = 3107, id = 20, size_row = 6}
, 
{audio_id = 3107, id = 21, size_row = 6}
, 
{audio_id = 3330, id = 22, scene_name = "006_Arena_007"}
, 
{audio_id = 3341, id = 23, scene_name = "006_Arena_003_a"}
, 
{audio_id = 3341, id = 24, scene_name = "006_Arena_014"}
, 
{deploy_rows = 11, depth_support = true, grid_scale_factor = 50, id = 25, scene_name = "006_Arena_SE2021_001", size_col = 14, size_row = 22}
, 
{deploy_rows = 9, depth_support = true, id = 26, scene_name = "006_Arena_016", size_col = 7, size_row = 10}
, 
{audio_id = 3341, depth_support = true, id = 27, scene_name = "006_Arena_015"}
, 
{audio_id = 3341, depth_support = true, id = 28, scene_name = "006_Arena_017"}
}
local __default_values = {audio_id = 3105, deploy_rows = 3, depth_support = false, grid_scale_factor = 100, id = 1, scene_name = "006_Arena_000", size_col = 5, size_row = 7}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(scene) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(scene, {__index = __rawdata})
return scene

