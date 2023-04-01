-- params : ...
-- function num : 0 , upvalues : _ENV
local UIMessageBox = class("UIMessageBox", UIBaseWindow)
local base = UIBaseWindow
UIMessageBox.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__permanent = true
  ;
  (UIUtil.AddButtonListener)((self.ui).btnClose, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).buttonConfirm, self, self.OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).buttonNo, self, self.OnClickNo)
  ;
  (UIUtil.AddButtonListener)((self.ui).buttonYes, self, self.OnClickYes)
end

UIMessageBox._Reset = function(self)
  -- function num : 0_1
  ((self.ui).textNode):SetActive(false)
  ;
  ((self.ui).yesNoNode):SetActive(false)
  ;
  (((self.ui).btnClose).gameObject):SetActive(false)
  ;
  (((self.ui).buttonConfirm).gameObject):SetActive(false)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).buttonYes).interactable = true
end

UIMessageBox.ShowTextBox = function(self, msg)
  -- function num : 0_2
  self:_Reset()
  local hasMsg = msg ~= nil
  ;
  ((self.ui).textNode):SetActive(hasMsg)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

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

UIMessageBox.ShowTextBoxWithConfirm = function(self, msg, comfirmFunc)
  -- function num : 0_3
  self:_Reset()
  self:ShowTextBox(msg)
  ;
  (((self.ui).buttonConfirm).gameObject):SetActive(true)
  self.confirmFunc = comfirmFunc
end

UIMessageBox.ShowTextBoxWithClose = function(self, msg, closeFunc)
  -- function num : 0_4
  self:_Reset()
  self:ShowTextBox(msg)
  ;
  (((self.ui).btnClose).gameObject):SetActive(true)
  self.closeFunc = closeFunc
end

UIMessageBox.ShowTextBoxWithYesAndNo = function(self, msg, yesFunc, noFunc, withYesWait)
  -- function num : 0_5
  self:_Reset()
  self:ShowTextBox(msg)
  ;
  ((self.ui).yesNoNode):SetActive(true)
  self.yesFunc = yesFunc
  self.noFunc = noFunc
end

UIMessageBox._ClearBtnYesTimer = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self._btnYesTimerId == nil then
    return 
  end
  TimerManager:StopTimer(self._btnYesTimerId)
  self._btnYesTimerId = nil
end

UIMessageBox.OnClickClose = function(self)
  -- function num : 0_7
  self:Hide()
  if self.closeFunc ~= nil then
    local func = self.closeFunc
    self.closeFunc = nil
    func()
  end
end

UIMessageBox.OnClickConfirm = function(self)
  -- function num : 0_8
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

UIMessageBox.OnClickNo = function(self)
  -- function num : 0_9
  self:Hide()
  if self.noFunc ~= nil then
    local func = self.noFunc
    self.noFunc = nil
    self.yesFunc = nil
    func()
  end
end

UIMessageBox.OnClickYes = function(self)
  -- function num : 0_10
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

UIMessageBox.OnHide = function(self)
  -- function num : 0_11 , upvalues : base
  self:_ClearBtnYesTimer()
  ;
  (base.OnHide)(self)
end

UIMessageBox.OnDelete = function(self)
  -- function num : 0_12 , upvalues : base
  (base.OnDelete)(self)
end

return UIMessageBox

