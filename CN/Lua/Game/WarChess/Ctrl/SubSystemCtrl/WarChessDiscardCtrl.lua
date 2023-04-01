-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.SubSystemCtrl.Base.WarChessSubSystemCtrlBase")
local WarChessDiscardCtrl = class("WarChessDiscardCtrl", base)
WarChessDiscardCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0
  self.__algDiscardSystemData = nil
  self.__identify = nil
end

WarChessDiscardCtrl.__GetWCSubSystemCat = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
  return (eWarChessEnum.eSystemCat).discard
end

WarChessDiscardCtrl.OpenWCSubSystem = function(self, systemState, identify)
  -- function num : 0_2 , upvalues : _ENV
  if systemState == nil or systemState.algDiscardSystemData == nil then
    error("not have data")
    return 
  end
  self.__algDiscardSystemData = systemState.algDiscardSystemData
  self.__identify = identify
  local resultTeam = self:GetWCNextDiscardChipTeam()
  self._curDiscardTeam = resultTeam
  self:__EnterWCDiscard()
end

WarChessDiscardCtrl.__EnterWCDiscard = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self._curDiscardTeam == nil then
    self._curDiscardTeam = ((self.wcCtrl).teamCtrl):GetTeamDataByTeamUid((self.__identify).tid)
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessChipDiscard, function(win)
    -- function num : 0_3_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitWCChipDiscard(self, self._curDiscardTeam)
  end
)
end

WarChessDiscardCtrl.GetWCNextDiscardChipTeam = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local resultTeam = nil
  local teamDic = ((self.wcCtrl).teamCtrl):GetWCTeams()
  for index,teamData in pairs(teamDic) do
    local dynPlayer = teamData:GetTeamDynPlayer()
    if dynPlayer:IsChipOverLimitNum() then
      resultTeam = teamData
      break
    end
  end
  do
    return resultTeam
  end
end

WarChessDiscardCtrl.GetWCCapacityUpGradeCost = function(self, teamData)
  -- function num : 0_5 , upvalues : _ENV
  local dynPlayer = teamData:GetTeamDynPlayer()
  local shopId = WarChessManager:GetWCLevelShopId()
  return dynPlayer:GetChipUpgradeLimitPrice(shopId)
end

WarChessDiscardCtrl.GetWCChipDiscardPrice = function(self, chipData)
  -- function num : 0_6 , upvalues : _ENV
  local shopId = WarChessManager:GetWCLevelShopId()
  local shopCfg = (ConfigData.warchess_shop_coin)[shopId]
  local chipLevel = chipData:GetCount()
  local price = (shopCfg.function_price)[chipLevel]
  local disCardPrice = (math.ceil)(price * shopCfg.discard_scale / 1000)
  return disCardPrice, shopCfg.item1
end

WarChessDiscardCtrl.WCDiscardChip = function(self, algId, callback)
  -- function num : 0_7
  if self._curDiscardTeam == nil then
    return 
  end
  local identify = self.__identify
  local tid = (self._curDiscardTeam):GetWCTeamId()
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_AlgDiscardSystem_Select(identify, tid, algId, callback)
end

WarChessDiscardCtrl.ExitWCDiscard = function(self, callback)
  -- function num : 0_8
  if self._curDiscardTeam ~= nil and ((self._curDiscardTeam):GetTeamDynPlayer()):IsChipOverLimitNum() then
    return 
  end
  local nextDiscardTeam = self:GetWCNextDiscardChipTeam()
  if nextDiscardTeam ~= nil then
    self._curDiscardTeam = nextDiscardTeam
    self:__EnterWCDiscard()
    return 
  end
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_AlgDiscardSystem_Quit(self.__identify, function()
    -- function num : 0_8_0 , upvalues : callback
    if callback ~= nil then
      callback()
    end
  end
)
  self.__algDiscardSystemData = nil
  self.__identify = nil
  self._curDiscardTeam = nil
end

WarChessDiscardCtrl.AddWCChipCapacity = function(self, callback)
  -- function num : 0_9 , upvalues : _ENV
  if self._curDiscardTeam == nil then
    return 
  end
  local costId, costNum = self:GetWCCapacityUpGradeCost(self._curDiscardTeam)
  local curNum = ((self.wcCtrl).backPackCtrl):GetWCItemNum(costId)
  if curNum < costNum then
    ((CS.MessageCommon).ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(8512))
    return 
  end
  local tid = (self._curDiscardTeam):GetWCTeamId()
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_AlgDiscardSystem_PurchaseAlgLimit(self.__identify, tid, function()
    -- function num : 0_9_0 , upvalues : _ENV, callback
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(8532))
    if callback ~= nil then
      callback()
    end
  end
)
end

WarChessDiscardCtrl.CloseWCSubSystem = function(self, isSwitchClose)
  -- function num : 0_10 , upvalues : base, _ENV
  (base.CloseWCSubSystem)()
  UIManager:DeleteWindow(UIWindowTypeID.WarChessChipDiscard)
  self.__algDiscardSystemData = nil
  self.__identify = nil
  self._curDiscardTeam = nil
end

WarChessDiscardCtrl.Delete = function(self)
  -- function num : 0_11
end

return WarChessDiscardCtrl

