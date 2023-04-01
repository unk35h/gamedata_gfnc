-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDungeonTowerSuccess = class("UIDungeonTowerSuccess", UIBaseWindow)
local base = UIBaseWindow
UIDungeonTowerSuccess.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.Push2BackStack)(self, self.OnBtnCloseClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickClose)
end

UIDungeonTowerSuccess.InitDunTowerNounUnlock = function(self, unlockName)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Condition).text = (string.format)(ConfigData:GetTipContent(970), unlockName)
end

UIDungeonTowerSuccess.SetBtnCloseAction = function(self, action)
  -- function num : 0_2
  self.onBtnCloseAction = action
end

UIDungeonTowerSuccess.OnClickClose = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIDungeonTowerSuccess.OnBtnCloseClick = function(self)
  -- function num : 0_4
  do
    if self.onBtnCloseAction ~= nil then
      local bindFunc = self.onBtnCloseAction
      self.onBtnCloseActio = nil
      bindFunc()
    end
    self:Delete()
  end
end

UIDungeonTowerSuccess.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UIDungeonTowerSuccess

