-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {1044}
local __rt_2 = {1}
local __rt_3 = {}
local activity_tech_branch = {
[2] = {
{branch_name_en = "Stable Strategy", revertCostIds = __rt_1, revertCostNums = __rt_2, tech_type = 2}
, 
{branch_id = 2, branch_name = 483426, branch_name_en = "Offensive Strategy", revertCostIds = __rt_1, revertCostNums = __rt_2, tech_type = 2}
, 
{branch_id = 3, branch_name = 224677, branch_name_en = "Special Strategy", revertCostIds = __rt_1, revertCostNums = __rt_2, tech_type = 2}
}
, 
[3] = {
[4] = {branch_id = 4, branch_name = 448296, branch_name_en = "Specific Strategy"}
, 
[5] = {branch_id = 5, branch_name = 260489, branch_name_en = "Economic Strategy"}
, 
[6] = {branch_id = 6, branch_name = 20650, branch_name_en = "Pioneering Strategy"}
, 
[7] = {branch_id = 7, branch_name_en = "Stable Strategy"}
, 
[8] = {branch_id = 8, branch_name = 483426, branch_name_en = "Offensive Strategy"}
}
, 
[5] = {
[9] = {branch_id = 9, branch_name = 125520, tech_type = 5}
, 
[10] = {branch_id = 10, tech_type = 5}
, 
[11] = {branch_id = 11, branch_name = 483426, tech_type = 5}
, 
[12] = {branch_id = 12, branch_name = 448296, tech_type = 5}
}
, 
[6] = {
[13] = {branch_id = 13, tech_type = 6}
, 
[14] = {branch_id = 14, branch_name = 483426, tech_type = 6}
, 
[15] = {branch_id = 15, branch_name = 448296, tech_type = 6}
}
, 
[7] = {
[16] = {branch_id = 16, tech_type = 7}
, 
[17] = {branch_id = 17, branch_name = 483426, tech_type = 7}
, 
[18] = {branch_id = 18, branch_name = 448296, tech_type = 7}
}
, 
[8] = {
[19] = {branch_id = 19, branch_name_en = "Stable Strategy", revertCostIds = __rt_1, revertCostNums = __rt_2, tech_type = 8}
, 
[20] = {branch_id = 20, branch_name = 483426, branch_name_en = "Offensive Strategy", revertCostIds = __rt_1, revertCostNums = __rt_2, tech_type = 8}
, 
[21] = {branch_id = 21, branch_name = 224677, branch_name_en = "Special Strategy", revertCostIds = __rt_1, revertCostNums = __rt_2, tech_type = 8}
}
}
local __default_values = {branch_id = 1, branch_name = 152556, branch_name_en = "Strategy", revertCostIds = __rt_3, revertCostNums = __rt_3, tech_type = 3}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_tech_branch) do
  for k1,v1 in pairs(v) do
    setmetatable(v1, base)
  end
end
local __rawdata = {__basemetatable = base, 
branchToTypeMapping = {2, 2, 2, 3, 3, 3, 3, 3, 5, 5, 5, 5, 6, 6, 6, 7, 7, 7, 8, 8, 8}
, 
techBranchTypeList = {
[2] = {1, 2, 3}
, 
[3] = {4, 5, 6, 7, 8}
, 
[5] = {9, 10, 11, 12}
, 
[6] = {13, 14, 15}
, 
[7] = {16, 17, 18}
, 
[8] = {19, 20, 21}
}
, 
techTypeToActMapping = {
[2] = {actCat = 17, actId = 1}
, 
[8] = {actCat = 17, actId = 2}
}
}
setmetatable(activity_tech_branch, {__index = __rawdata})
return activity_tech_branch

