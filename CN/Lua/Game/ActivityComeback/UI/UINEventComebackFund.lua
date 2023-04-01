-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventComebackFund = class("UINEventComebackFund", UIBaseNode)
local base = UIBaseNode
local UINEventComebackFundItem = require("Game.ActivityComeback.UI.UINEventComebackFundItem")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local BattlePassEnum = require("Game.BattlePass.BattlePassEnum")
UINEventComebackFund.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEventComebackFundItem, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.__OnClickBuy)
  self.__OnReceiveCallback = BindCallback(self, self.__OnReceive)
  self._fundPool = (UIItemPool.New)(UINEventComebackFundItem, (self.ui).taskItem)
  ;
  ((self.ui).taskItem):SetActive(false)
  self._rewardPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
  self.__RefreshItemCallback = BindCallback(self, self.__RefreshItem)
  MsgCenter:AddListener(eMsgEventId.UpdatePickedRewardLevel, self.__RefreshItemCallback)
  MsgCenter:AddListener(eMsgEventId.BattlePassChange, self.__RefreshItemCallback)
  self.__ItemUpdateCallback = BindCallback(self, self.__ItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__ItemUpdateCallback)
end

UINEventComebackFund.InitCombackFund = function(self, fundId)
  -- function num : 0_1 , upvalues : _ENV
  self._data = (PlayerDataCenter.battlepassData):GetBattlePass(fundId)
  if self._data == nil then
    error("回归基金是空")
    return 
  end
  local cfg = (self._data):GetPassCfg()
  local payId = cfg.senior_price
  local targtItemId = cfg.condition_para1
  local maxLevel = (self._data):GetBattlePassMaxLevel()
  local isUnlock = (self._data):GetBattlePassUnlockSenior()
  if not isUnlock then
    ((self.ui).down):SetActive(true)
    local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay)
    local _, price = payCtrl:GetPayPriceShow(payId)
    local unit = payCtrl:GetPayShowUnitStr()
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R11 in 'UnsetPending'

    ;
    ((self.ui).tex_Price).text = tostring(price)
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R11 in 'UnsetPending'

    ;
    ((self.ui).text_Unit).text = unit
    ;
    (self._rewardPool):HideAll()
    for _,itemId in ipairs(cfg.core_reward) do
      local count = (cfg.core_reward_dic)[itemId]
      if count or 0 > 0 then
        local item = (self._rewardPool):GetOne()
        item:InitItemWithCount((ConfigData.item)[itemId], count)
      end
    end
  else
    do
      ;
      ((self.ui).down):SetActive(false)
      ;
      (self._fundPool):HideAll()
      local targetCount = (self._data):GetBattlePassTotalExp()
      local levelCfgList = (ConfigData.battlepass)[fundId]
      local targetLevel = (self._data):GetPassLevel()
      local levelExp = 0
      for level = 1, maxLevel do
        local levelCfg = levelCfgList[level]
        if levelCfg ~= nil then
          local item = (self._fundPool):GetOne()
          item:InitCombackFundItem(levelCfg, targtItemId, levelExp, self.__OnReceiveCallback)
          local isTarget = level <= targetLevel
          item:RefreshConbackFundItemState(isUnlock, isTarget, not (self._data):GetIsThisLeveHaveNewReward(level))
          levelExp = levelCfg.exp + levelExp
        end
      end
      -- DECOMPILER ERROR at PC132: Confused about usage of register: R11 in 'UnsetPending'

      ;
      ((self.ui).img_Icon).sprite = CRH:GetSpriteByItemId(targtItemId)
      -- DECOMPILER ERROR at PC138: Confused about usage of register: R11 in 'UnsetPending'

      ;
      ((self.ui).tex_CurrentCount).text = tostring(targetCount)
      self._targetItemId = targtItemId
      -- DECOMPILER ERROR: 2 unprocessed JMP targets
    end
  end
end

UINEventComebackFund.__RefreshItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isUnlock = (self._data):GetBattlePassUnlockSenior()
  if isUnlock then
    ((self.ui).down):SetActive(false)
  end
  local targetLevel = (self._data):GetPassLevel()
  for _,item in ipairs((self._fundPool).listItem) do
    local level = item:GetConbackFundLevel()
    item:RefreshConbackFundItemState(isUnlock, level <= targetLevel, not (self._data):GetIsThisLeveHaveNewReward(level))
  end
  local cfg = (self._data):GetPassCfg()
  local targtItemId = cfg.condition_para1
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_CurrentCount).text = tostring((self._data):GetBattlePassTotalExp())
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINEventComebackFund.__ItemUpdate = function(self, itemUpdata)
  -- function num : 0_3
  if itemUpdata[self._targetItemId] ~= nil then
    self:__RefreshItem()
  end
end

UINEventComebackFund.__OnReceive = function(self, level)
  -- function num : 0_4 , upvalues : _ENV, BattlePassEnum
  if not (self._data):GetBattlePassUnlockSenior() then
    return 
  end
  if (self._data):GetPassLevel() < level then
    return 
  end
  if not (self._data):GetIsThisLeveHaveNewReward(level) then
    return 
  end
  local battlePassNetwork = NetworkManager:GetNetwork(NetworkTypeID.BattlePass)
  battlePassNetwork:CS_BATTLEPASS_Take(((self._data).passCfg).id, level, (BattlePassEnum.TakeWay).BaseAndSenior)
end

UINEventComebackFund.__OnClickBuy = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if (self._data):GetBattlePassUnlockSenior() then
    return 
  end
  local cfg = (self._data):GetPassCfg()
  local payId = cfg.senior_price
  local network = NetworkManager:GetNetwork(NetworkTypeID.BattlePass)
  network:CS_BATTLEPASS_Buy(payId)
end

UINEventComebackFund.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnDelete)(self)
  MsgCenter:RemoveListener(eMsgEventId.UpdatePickedRewardLevel, self.__RefreshItemCallback)
  MsgCenter:RemoveListener(eMsgEventId.BattlePassChange, self.__RefreshItemCallback)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__ItemUpdateCallback)
end

return UINEventComebackFund

