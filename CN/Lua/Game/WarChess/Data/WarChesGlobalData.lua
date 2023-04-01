-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChesGlobalData = class("WarChesGlobalData")
WarChesGlobalData.ctor = function(self)
  -- function num : 0_0
  self._guideCount = {}
  self._enterPlayCount = 0
  self._outsideItemBoxDic = {}
end

WarChesGlobalData.GetWCGuideExeCount = function(self, wcGuideId)
  -- function num : 0_1
  return (self._guideCount)[wcGuideId] or 0
end

WarChesGlobalData.SetWCGuideExeCount = function(self, wcGuideId, count)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._guideCount)[wcGuideId] = count
end

WarChesGlobalData.SetEnterPlayCount = function(self, count)
  -- function num : 0_3
  self._enterPlayCount = count
end

WarChesGlobalData.GetEnterPlayCount = function(self)
  -- function num : 0_4
  return self._enterPlayCount
end

WarChesGlobalData.SetOutsideItemBoxDic = function(self, dic)
  -- function num : 0_5 , upvalues : _ENV
  if dic == nil then
    return 
  end
  ;
  (table.merge)(self._outsideItemBoxDic, dic)
end

WarChesGlobalData.SetOutsideItemBoxReceive = function(self, boxId)
  -- function num : 0_6
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._outsideItemBoxDic)[boxId] = true
end

WarChesGlobalData.IsReceivedOutsideItemBox = function(self, boxId)
  -- function num : 0_7
  return (self._outsideItemBoxDic)[boxId]
end

WarChesGlobalData.GetOutSideBoxReward = function(self, boxId)
  -- function num : 0_8 , upvalues : _ENV
  local warchessId = WarChessManager:GetWCLevelId()
  local outSideCfg = (ConfigData.warchess_level_real_rewards)[warchessId]
  if outSideCfg == nil then
    return 
  end
  local cfg = outSideCfg[boxId]
  if cfg == nil then
    return 
  end
  return cfg.reward_ids, cfg.reward_nums
end

return WarChesGlobalData

