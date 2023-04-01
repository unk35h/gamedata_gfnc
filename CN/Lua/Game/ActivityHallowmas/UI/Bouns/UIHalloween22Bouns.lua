-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHalloween22Bouns = class("UIHalloween22Bouns", UIBaseWindow)
local base = UIBaseWindow
local ConditionListener = require("Game.Common.CheckCondition.ConditonListener.ConditionListener")
local CheckerTypeId, _ = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
UIHalloween22Bouns.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, ConditionListener
  self:BindHalloweenBtn()
  self:SethalloweenItemClass()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scroll).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scroll).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self.__OnPickedSingleCallback = BindCallback(self, self.__OnPickedSingle)
  self.__OnPickedSingleCycleCallback = BindCallback(self, self.__OnPickedSingleCycle)
  self._goItem = {}
  self.__RefreshCallback = BindCallback(self, self.__Refresh)
  MsgCenter:AddListener(eMsgEventId.ActivityHallowmas, self.__RefreshCallback)
  self._conditionListener = (ConditionListener.New)()
  self.__RefreshBuyBtnCallback = BindCallback(self, self.__RefreshBuyBtn)
end

UIHalloween22Bouns.BindHalloweenBtn = function(self)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnCloseBouns, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickCloseBouns)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.OnClickBuy)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ReceiveAll, self, self.OnClickPickedAll)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Icon, self, self.OnClickIconTip)
end

UIHalloween22Bouns.SethalloweenItemClass = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self._itemClass = require("Game.ActivityHallowmas.UI.Bouns.UINHalloweenBounsItemWithGet")
  self._cycleClass = require("Game.ActivityHallowmas.UI.Bouns.UINHalloweenBounsCycleItem")
  self._emetyElement = require("Game.ActivityHallowmas.UI.Bouns.UINHalloweenBounsItemEmptyElement")
end

UIHalloween22Bouns.InitHalloween22Bouns = function(self, hallowmasData, closeEvent)
  -- function num : 0_3 , upvalues : CheckerTypeId
  self._data = hallowmasData
  self._closeEvent = closeEvent
  self:__InitFixed()
  self:__Refresh()
  local startTime = ((self._data):GetHallowmasMainCfg()).score_buy_time
  local endTime = (self._data):GetActivityDestroyTime()
  ;
  (self._conditionListener):AddConditionChangeListener(1, self.__RefreshBuyBtnCallback, {CheckerTypeId.TimeRange}, {startTime}, {endTime})
end

UIHalloween22Bouns.__InitFixed = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local itemId = (self._data):GetHallowmasScoreItemId()
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_TokenName).text = ConfigData:GetItemName(itemId)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Token).sprite = CRH:GetSpriteByItemId(itemId)
  local itemCfg = (ConfigData.item)[itemId]
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(itemCfg.describe)
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).scroll).totalCount = (self._data):GetHallowmasLvLimit() + 1
  local targetIndex = (self._data):GetHallowmasLv()
  for i = 1, targetIndex do
    if (self._data):IsHallowmasLevelCanPick(i) then
      targetIndex = i
      break
    end
  end
  do
    ;
    ((self.ui).scroll):RefillCells(targetIndex - 1, 200)
    ;
    ((self.ui).scroll):SrollToCell(targetIndex - 1, 9999)
  end
end

UIHalloween22Bouns.__Refresh = function(self)
  -- function num : 0_5 , upvalues : _ENV
  ((self.ui).tex_TokenNum):SetIndex(0, tostring((self._data):GetHallowmasAllExp()))
  ;
  ((self.ui).tex_Lvl):SetIndex(0, tostring((self._data):GetHallowmasLv()))
  local tempExp = (self._data):GetHallowmasCurExp() % (self._data):GetHallowmasCurExpLimit()
  local remainExp = (self._data):GetHallowmasCurExpLimit() - tempExp
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Exp).text = tostring(remainExp)
  for k,v in pairs(self._goItem) do
    v:RefreshBounsElement()
  end
  self:__RefreshAllGet()
  self:__RefreshBuyBtn()
end

UIHalloween22Bouns.__RefreshAllGet = function(self)
  -- function num : 0_6
  (((self.ui).img_Mask).gameObject):SetActive(not (self._data):IsHallowmasExpAllReceive())
end

UIHalloween22Bouns.__OnInstantiateItem = function(self, go)
  -- function num : 0_7
  local item = ((self._emetyElement).New)()
  item:Init(go)
  item:BindHalloweenBounsItemClass(self._itemClass, self._cycleClass)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._goItem)[go] = item
end

UIHalloween22Bouns.__OnChangeItem = function(self, go, index)
  -- function num : 0_8
  local item = (self._goItem)[go]
  local level = index + 1
  if (self._data):GetHallowmasLvLimit() < level then
    item:InitBounsCycleItem(self._data, self.__OnPickedSingleCycleCallback)
  else
    item:InitBounsItem(self._data, level, self.__OnPickedSingleCallback)
  end
end

UIHalloween22Bouns.__RefreshBuyBtn = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local startTime = ((self._data):GetHallowmasMainCfg()).score_buy_time
  local endTime = (self._data):GetActivityDestroyTime()
  local curTime = PlayerDataCenter.timestamp
  local curLevel = (self._data):GetHallowmasLv()
  local maxLevel = (self._data):GetHallowmasLvLimit()
  ;
  (((self.ui).btn_Buy).gameObject):SetActive(startTime <= curTime and curTime < endTime and curLevel < maxLevel)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIHalloween22Bouns.__OnPickedSingle = function(self, level, item)
  -- function num : 0_10
  (self._data):ReqHallowmasExpReceive(level)
end

UIHalloween22Bouns.__OnPickedSingleCycle = function(self)
  -- function num : 0_11
  (self._data):ReqHallowmasExpCycle()
end

UIHalloween22Bouns.OnClickBuy = function(self)
  -- function num : 0_12 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.EventBattlePassBuyLevel_Halloween, function(win)
    -- function num : 0_12_0 , upvalues : self, _ENV
    if win == nil then
      return 
    end
    win:InitBPHallowBuy(self._data, function(levelCount)
      -- function num : 0_12_0_0 , upvalues : self, _ENV
      local curLevel = (self._data):GetHallowmasLv()
      ;
      (self._data):ReqHallowmasBuyScore(levelCount, function()
        -- function num : 0_12_0_0_0 , upvalues : curLevel, levelCount, self, _ENV
        local expCount = 0
        for i = curLevel, curLevel + levelCount - 1 do
          local cfg = ((self._data):GetHallowmasExpCfg())[i]
          expCount = expCount + cfg.need_exp
        end
        ;
        (UIUtil.ShowCommonReward)({[(self._data):GetHallowmasScoreItemId()] = expCount})
      end
)
    end
)
  end
)
end

UIHalloween22Bouns.OnClickPickedAll = function(self)
  -- function num : 0_13
  if not (self._data):IsHallowmasExpAllReceive() then
    return 
  end
  ;
  (self._data):ReqHallowmasAllExp()
end

UIHalloween22Bouns.OnClickIconTip = function(self)
  -- function num : 0_14 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Carnival22InfoWindow, function(win)
    -- function num : 0_14_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitCarnivalInfoWindow(((self._data):GetHallowmasMainCfg()).score_limit_tip)
  end
)
end

UIHalloween22Bouns.OnClickCloseBouns = function(self)
  -- function num : 0_15 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIHalloween22Bouns.OnCloseBouns = function(self, tohome)
  -- function num : 0_16
  self:Delete()
  if self._closeEvent ~= nil then
    (self._closeEvent)(tohome)
    self._closeEvent = nil
  end
end

UIHalloween22Bouns.OnDelete = function(self)
  -- function num : 0_17 , upvalues : _ENV, base
  (self._conditionListener):Delete()
  MsgCenter:RemoveListener(eMsgEventId.ActivityHallowmas, self.__RefreshCallback)
  ;
  (base.OnDelete)(self)
end

return UIHalloween22Bouns

