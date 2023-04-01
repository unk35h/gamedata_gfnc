-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.Base.WarChessCtrlBase")
local WarChessStrategyCtrl = class("WarChessStrategyCtrl", base)
WarChessStrategyCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self.__wcStrageCfg = nil
  self.__wcStrageExpItemId = nil
  self.__wcStrageExp = nil
  self.__wcStrageLevel = 0
  self.__curLevelFullExp = 0
  self.__curLevelExp = 0
  self.__refreshWCStrategyLevelAndExp = BindCallback(self, self.RefreshWCStrategyLevelAndExp)
  MsgCenter:AddListener(eMsgEventId.WC_ItemNumChange, self.__refreshWCStrategyLevelAndExp)
end

WarChessStrategyCtrl.InitWCStrategyCtrl = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local isInSeason = WarChessSeasonManager:GetIsInWCSeason()
  if isInSeason then
    local wcsCtrl = WarChessSeasonManager:GetWCSCtrl()
    local envCfg = wcsCtrl:GetWCEnvCfg()
    if envCfg == nil then
      error("wcs:envCfg is nil, can\'t init strategy ctrl")
    end
    local strategy_id = envCfg.strategy_id
    if strategy_id == 0 then
      return 
    end
    self.__wcStrageCfg = (ConfigData.warchess_strategy)[strategy_id]
    self.__wcStrageExpItemId = (self.__wcStrageCfg).expItemId
    local num = ((self.wcCtrl).backPackCtrl):GetWCItemNum(self.__wcStrageExpItemId)
    self:RefreshWCStrategyLevelAndExp(self.__wcStrageExpItemId, num, num)
  end
end

WarChessStrategyCtrl.RefreshWCStrategyLevelAndExp = function(self, itemId, num, addNum)
  -- function num : 0_2 , upvalues : _ENV
  if itemId ~= self.__wcStrageExpItemId then
    return 
  end
  if num == self.__wcStrageExp then
    return 
  end
  self.__wcStrageExp = num
  local curlevel = 0
  local fullExp = 0
  local levelFullExp = 0
  local lastLevelFullExp = 0
  for level,cfg in ipairs(self.__wcStrageCfg) do
    levelFullExp = cfg.expSum - fullExp
    fullExp = cfg.expSum
    if cfg.expSum <= self.__wcStrageExp then
      curlevel = level
    else
      break
    end
    lastLevelFullExp = fullExp
  end
  do
    self.__wcStrageLevel = curlevel
    self.__curLevelFullExp = levelFullExp
    self.__curLevelExp = self.__wcStrageExp - lastLevelFullExp
    MsgCenter:Broadcast(eMsgEventId.WC_StrategyExpChange)
  end
end

WarChessStrategyCtrl.GetWCIsHaveStrategy = function(self)
  -- function num : 0_3
  do return self.__wcStrageCfg ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

WarChessStrategyCtrl.GetWCStrategyExpNum = function(self)
  -- function num : 0_4
  return self.__wcStrageExp
end

WarChessStrategyCtrl.GetWCStrategyLevel = function(self)
  -- function num : 0_5
  return self.__wcStrageLevel
end

WarChessStrategyCtrl.GetWCStrategyExp = function(self)
  -- function num : 0_6
  return self.__curLevelExp, self.__curLevelFullExp
end

WarChessStrategyCtrl.Delete = function(self)
  -- function num : 0_7 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.WC_ItemNumChange, self.__refreshWCStrategyLevelAndExp)
end

return WarChessStrategyCtrl

