-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local SkinConditionFunc = {[proto_csmsg_SystemFunctionID.SystemFunctionID_Store] = function(cfg, skinCtrl)
  -- function num : 0_0
  do return skinCtrl:GetGoodsBySkinCfg(cfg) ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_Operate_Active] = function(cfg, skinCtrl)
  -- function num : 0_1
  do return skinCtrl:GetActFrameDataBySkinCfg(cfg) ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_HeroRank] = function(cfg, skinCtrl)
  -- function num : 0_2
  return true
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_Gift] = function(cfg, skinCtrl)
  -- function num : 0_3
  do return skinCtrl:GetGiftBySkinCfg(cfg) ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
}
return SkinConditionFunc

