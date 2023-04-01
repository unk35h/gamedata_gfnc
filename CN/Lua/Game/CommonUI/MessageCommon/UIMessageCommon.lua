-- params : ...
-- function num : 0 , upvalues : _ENV
local UIMessageCommon = class("UIMessageCommon", UIBaseWindow)
local base = UIBaseWindow
local UINMsgCommonItem = require("Game.CommonUI.MessageCommon.UINMsgCommonItem")
UIMessageCommon.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINMsgCommonItem
  self.__permanent = true
  ;
  (UIUtil.AddButtonListener)((self.ui).btnClose, self, self._OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).buttonConfirm, self, self._OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).buttonNo, self, self._OnClickNo)
  ;
  (UIUtil.AddButtonListener)((self.ui).buttonYes, self, self._OnClickYes)
  ;
  (((self.ui).extrItem).gameObject):SetActive(false)
  self.extraItemPool = (UIItemPool.New)(UINMsgCommonItem, (self.ui).extrItem)
  ;
  ((self.ui).tex_BtnYes):SetIndex(0)
end

UIMessageCommon._Reset = function(self)
  -- function num : 0_1
  ((self.ui).textNode):SetActive(false)
  ;
  ((self.ui).itemNode):SetActive(false)
  ;
  ((self.ui).yesNoNode):SetActive(false)
  ;
  (((self.ui).btnClose).gameObject):SetActive(false)
  ;
  (((self.ui).buttonConfirm).gameObject):SetActive(false)
  ;
  ((self.ui).textRemind):SetActive(false)
  ;
  ((self.ui).obj_Arrow):SetActive(false)
  ;
  (self.extraItemPool):HideAll()
  ;
  ((self.ui).itemARoot):SetActive(false)
  ;
  ((self.ui).itemBRoot):SetActive(false)
  -- DECOMPILER ERROR at PC52: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).buttonYes).interactable = true
end

UIMessageCommon._ShowItemCostInternal = function(self, itemId, costNum, itemNum)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).itemNode):SetActive(true)
  local itemCfg = (ConfigData.item)[itemId]
  if itemCfg == nil then
    error("Cant get itemCfg, id = " .. tostring(itemId))
    return 
  end
  ;
  ((self.ui).itemARoot):SetActive(true)
  local itemA = (self.extraItemPool):GetOne()
  ;
  (itemA.transform):SetParent(((self.ui).itemARoot).transform)
  ;
  (itemA.transform):SetAsLastSibling()
  itemA:InitMsgCommonItem(itemCfg, costNum, itemNum)
end

UIMessageCommon._ShowItemGetInternal = function(self, itemId, num)
  -- function num : 0_3 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  if itemCfg == nil then
    error("Cant get itemCfg, id = " .. tostring(itemId))
    return 
  end
  ;
  ((self.ui).itemBRoot):SetActive(true)
  local itemB = (self.extraItemPool):GetOne()
  ;
  (itemB.transform):SetParent(((self.ui).itemBRoot).transform)
  ;
  (itemB.transform):SetAsLastSibling()
  itemB:InitMsgCommonItem(itemCfg, nil, num)
end

UIMessageCommon._ShowItemCostAnyInternal = function(self, msg, itemListId, costListNum)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).itemNode):SetActive(true)
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemContent).text = msg
  if itemListId == nil or #itemListId == 0 then
    return 
  end
  ;
  ((self.ui).itemARoot):SetActive(true)
  for index,itemId in pairs(itemListId) do
    local itemCfg = (ConfigData.item)[itemId]
    if itemCfg == nil then
      error("Cant get itemCfg, id = " .. tostring(itemId))
      return 
    end
    local itemA = (self.extraItemPool):GetOne()
    ;
    (itemA.transform):SetParent(((self.ui).itemARoot).transform)
    ;
    (itemA.transform):SetAsLastSibling()
    itemA:InitMsgCommonItem(itemCfg, costListNum[index] or 0)
  end
end

UIMessageCommon.ShowItemCostConfirm = function(self, msg, itemId, costNum, confirmFunc, onlyShowCostNum)
  -- function num : 0_5
  self:_Reset()
  if onlyShowCostNum then
    self:_ShowItemCostInternal(itemId, nil, costNum)
  else
    self:_ShowItemCostInternal(itemId, costNum)
  end
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemContent).text = msg
  ;
  (((self.ui).buttonConfirm).gameObject):SetActive(true)
  self.confirmFunc = confirmFunc
end

UIMessageCommon.ShowItemCost = function(self, msg, itemId, costNum, yesFunc, noFunc, onlyShowCostNum)
  -- function num : 0_6
  self:_Reset()
  if onlyShowCostNum then
    self:_ShowItemCostInternal(itemId, nil, costNum)
  else
    self:_ShowItemCostInternal(itemId, costNum)
  end
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemContent).text = msg
  ;
  ((self.ui).yesNoNode):SetActive(true)
  self.yesFunc = yesFunc
  self.noFunc = noFunc
end

UIMessageCommon.ShowItemCostAny = function(self, msg, itemListId, costListNum, yesFunc, noFunc)
  -- function num : 0_7
  self:_Reset()
  self:_ShowItemCostAnyInternal(msg, itemListId, costListNum)
  ;
  ((self.ui).yesNoNode):SetActive(true)
  self.yesFunc = yesFunc
  self.noFunc = noFunc
end

UIMessageCommon.ShowItemCost2 = function(self, msg, itemId, costNum, itemId2, costNum2, yesFunc, noFunc)
  -- function num : 0_8
  self:_Reset()
  self:_ShowItemCostAnyInternal(msg, {itemId, itemId2}, {costNum, costNum2})
  ;
  ((self.ui).yesNoNode):SetActive(true)
  self.yesFunc = yesFunc
  self.noFunc = noFunc
end

UIMessageCommon.ShowItemConvert = function(self, msg, srcIdList, srcNumList, tarIdList, tarNumList, yesFunc, noFunc)
  -- function num : 0_9 , upvalues : _ENV
  self:_Reset()
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemContent).text = msg
  for k,itemId in ipairs(srcIdList) do
    local costNum = srcNumList[k]
    self:_ShowItemCostInternal(itemId, nil, costNum)
  end
  ;
  ((self.ui).obj_Arrow):SetActive(true)
  for k,itemId in ipairs(tarIdList) do
    local num = tarNumList[k]
    self:_ShowItemGetInternal(itemId, num)
  end
  ;
  ((self.ui).yesNoNode):SetActive(true)
  self.yesFunc = yesFunc
  self.noFunc = noFunc
end

UIMessageCommon.ShowItemCostAnyConfirm = function(self, msg, itemListId, costListNum, confirmFunc)
  -- function num : 0_10
  self:_Reset()
  self:_ShowItemCostAnyInternal(msg, itemListId, costListNum)
  ;
  (((self.ui).buttonConfirm).gameObject):SetActive(true)
  self.confirmFunc = confirmFunc
end

UIMessageCommon.ShowItemCost2Confirm = function(self, msg, itemId1, costNum1, itemId2, costNum2, confirmFunc)
  -- function num : 0_11
  self:_Reset()
  self:_ShowItemCostAnyInternal(msg, {itemId1, itemId2}, {costNum1, costNum2})
  ;
  (((self.ui).buttonConfirm).gameObject):SetActive(true)
  self.confirmFunc = confirmFunc
end

UIMessageCommon.ShowTextBox = function(self, msg)
  -- function num : 0_12
  self:_Reset()
  local hasMsg = msg ~= nil
  ;
  ((self.ui).itemNode):SetActive(not hasMsg)
  ;
  ((self.ui).textNode):SetActive(hasMsg)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Content).text = msg
  ;
  ((self.ui).yesNoNode):SetActive(false)
  ;
  (((self.ui).buttonConfirm).gameObject):SetActive(false)
  ;
  (((self.ui).btnClose).gameObject):SetActive(false)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIMessageCommon.ShowTextBoxWithConfirm = function(self, msg, comfirmFunc)
  -- function num : 0_13
  self:_Reset()
  self:ShowTextBox(msg)
  ;
  (((self.ui).buttonConfirm).gameObject):SetActive(true)
  self.confirmFunc = comfirmFunc
end

UIMessageCommon.ShowTextBoxWithClose = function(self, msg, closeFunc)
  -- function num : 0_14
  self:_Reset()
  self:ShowTextBox(msg)
  ;
  (((self.ui).btnClose).gameObject):SetActive(true)
  self.closeFunc = closeFunc
end

UIMessageCommon.ShowTextBoxWithYesAndNo = function(self, msg, yesFunc, noFunc, withYesWait)
  -- function num : 0_15 , upvalues : _ENV
  self:_Reset()
  self:ShowTextBox(msg)
  ;
  ((self.ui).yesNoNode):SetActive(true)
  self.yesFunc = yesFunc
  self.noFunc = noFunc
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R5 in 'UnsetPending'

  if withYesWait then
    ((self.ui).buttonYes).interactable = false
    local time = 3
    do
      ((self.ui).tex_BtnYes):SetIndex(1, tostring(time))
      self:_ClearBtnYesTimer()
      self._btnYesTimerId = TimerManager:StartTimer(1, function()
    -- function num : 0_15_0 , upvalues : time, self, _ENV
    time = time - 1
    if time > 0 then
      ((self.ui).tex_BtnYes):SetIndex(1, tostring(time))
    else
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R0 in 'UnsetPending'

      ;
      ((self.ui).buttonYes).interactable = true
      ;
      ((self.ui).tex_BtnYes):SetIndex(0)
      self:_ClearBtnYesTimer()
    end
  end
)
    end
  else
    do
      ;
      ((self.ui).tex_BtnYes):SetIndex(0)
    end
  end
end

UIMessageCommon._ClearBtnYesTimer = function(self)
  -- function num : 0_16 , upvalues : _ENV
  if self._btnYesTimerId == nil then
    return 
  end
  TimerManager:StopTimer(self._btnYesTimerId)
  self._btnYesTimerId = nil
end

UIMessageCommon.ShowDontRemindTog = function(self, callback, isOn)
  -- function num : 0_17
  self.dontRemindFunc = callback
  ;
  ((self.ui).textRemind):SetActive(true)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tog_RemindSwitch).isOn = isOn or false
end

UIMessageCommon.OnClickClose = function(self)
  -- function num : 0_18
  self:_OnClickClose()
end

UIMessageCommon._OnClickClose = function(self)
  -- function num : 0_19
  self:Hide()
  if self.closeFunc ~= nil then
    local func = self.closeFunc
    self.closeFunc = nil
    func()
  end
end

UIMessageCommon._OnClickConfirm = function(self)
  -- function num : 0_20
  self:Hide()
  do
    if self.confirmFunc ~= nil then
      local func = self.confirmFunc
      self.confirmFunc = nil
      func()
    end
    if self.dontRemindFunc ~= nil then
      local func = self.dontRemindFunc
      self.dontRemindFunc = nil
      func(((self.ui).tog_RemindSwitch).isOn)
    end
  end
end

UIMessageCommon.OnClickNo = function(self)
  -- function num : 0_21
  self:_OnClickNo()
end

UIMessageCommon._OnClickNo = function(self)
  -- function num : 0_22
  self:Hide()
  if self.noFunc ~= nil then
    local func = self.noFunc
    self.noFunc = nil
    self.yesFunc = nil
    func()
  end
end

UIMessageCommon._OnClickYes = function(self)
  -- function num : 0_23
  self:Hide()
  do
    if self.yesFunc ~= nil then
      local func = self.yesFunc
      self.yesFunc = nil
      self.noFunc = nil
      func()
    end
    if self.dontRemindFunc ~= nil then
      local func = self.dontRemindFunc
      self.dontRemindFunc = nil
      func(((self.ui).tog_RemindSwitch).isOn)
    end
  end
end

UIMessageCommon._GetItemA = function(self)
  -- function num : 0_24 , upvalues : UINMsgCommonItem
  if self.itemA == nil then
    self.itemA = (UINMsgCommonItem.New)()
    ;
    (self.itemA):Init((self.ui).extrItemA)
  end
  ;
  ((self.itemA).gameObject):SetActive(true)
  return self.itemA
end

UIMessageCommon._GetItemB = function(self)
  -- function num : 0_25 , upvalues : UINMsgCommonItem
  if self.itemB == nil then
    self.itemB = (UINMsgCommonItem.New)()
    ;
    (self.itemB):Init((self.ui).extrItemB)
  end
  ;
  ((self.itemB).gameObject):SetActive(true)
  return self.itemB
end

UIMessageCommon.OnHide = function(self)
  -- function num : 0_26 , upvalues : base
  self:_ClearBtnYesTimer()
  ;
  (base.OnHide)(self)
end

UIMessageCommon.OnDelete = function(self)
  -- function num : 0_27 , upvalues : base
  (base.OnDelete)(self)
end

return UIMessageCommon

