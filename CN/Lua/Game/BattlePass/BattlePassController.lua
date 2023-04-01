-- params : ...
-- function num : 0 , upvalues : _ENV
local BattlePassController = class("BattlePassController", ControllerBase)
local base = ControllerBase
local BattlePassEnum = require("Game.BattlePass.BattlePassEnum")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local eActivityState = ActivityFrameEnum.eActivityState
BattlePassController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.network = NetworkManager:GetNetwork(NetworkTypeID.BattlePass)
end

BattlePassController.__IsBattlePassFinished = function(self, passId)
  -- function num : 0_1 , upvalues : _ENV
  local passInfo = ((PlayerDataCenter.battlepassData).passInfos)[passId]
  do
    if passInfo == nil or not passInfo:IsBattlePassValid() then
      local showingWindow = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
      showingWindow:ShowTextBoxWithConfirm(ConfigData:GetTipContent(323), function()
    -- function num : 0_1_0 , upvalues : _ENV
    if UIManager:GetWindow(UIWindowTypeID.EventBattlePass) ~= nil then
      (UIUtil.ReturnHome)()
    end
  end
)
      return true
    end
    return false
  end
end

BattlePassController.GetBattlePassBuyLevelup = function(self, passId)
  -- function num : 0_2 , upvalues : _ENV
  local passInfo = ((PlayerDataCenter.battlepassData).passInfos)[passId]
  if passInfo == nil then
    return 0, 0
  end
  local levelup = passInfo:TryGetExpUpgradeLevel((passInfo.passCfg).ultimate_expadd)
  return levelup, passInfo.level
end

BattlePassController.BuyBattlePass = function(self, passId, purchaseType)
  -- function num : 0_3 , upvalues : _ENV, BattlePassEnum
  if self:__IsBattlePassFinished(passId) then
    return 
  end
  local passCfg = (ConfigData.battlepass_type)[passId]
  local payId = (BattlePassEnum.GetPassPayId)(purchaseType, passCfg)
  local levelup = 0
  local oldlevel = 0
  if purchaseType == (BattlePassEnum.BuyQuality).Ultimate or purchaseType == (BattlePassEnum.BuyQuality).SupplyUltimate then
    levelup = self:GetBattlePassBuyLevelup(passId)
  end
  ;
  (self.network):CS_BATTLEPASS_Buy(payId, function()
    -- function num : 0_3_0 , upvalues : _ENV, levelup, oldlevel
    local window = UIManager:GetWindow(UIWindowTypeID.EventBattlePassPurchase)
    if window ~= nil then
      window:OnBtnCloseClick()
    end
    if levelup > 0 then
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonUpgradeTips, function(window)
      -- function num : 0_3_0_0 , upvalues : oldlevel, levelup
      if window == nil then
        return 
      end
      window:InitBattlePassLevelUp(oldlevel, oldlevel + levelup)
    end
)
    end
  end
)
end

BattlePassController.TakeBattlePassReward = function(self, id, level, takeway)
  -- function num : 0_4
  if self:__IsBattlePassFinished(id) then
    return 
  end
  ;
  (self.network):CS_BATTLEPASS_Take(id, level, takeway)
end

BattlePassController.BuyBattlePassExp = function(self, id, num, callback)
  -- function num : 0_5
  if self:__IsBattlePassFinished(id) then
    return 
  end
  ;
  (self.network):CS_BATTLEPASS_Buy_Exp(id, num, callback)
end

BattlePassController.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return BattlePassController

