-- params : ...
-- function num : 0 , upvalues : _ENV
local UIShowCharacter = class("UIShowCharacter", UIBaseWindow)
local base = UIBaseWindow
UIShowCharacter.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_Return, self, self.ExitButtonClicked)
  self.ctrl = ControllerManager:GetController(ControllerTypeId.ShowCharacter, true)
  ;
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
end

UIShowCharacter.InitSettingGraph = function(self)
  -- function num : 0_1
end

UIShowCharacter.BackAction = function(self)
  -- function num : 0_2
  (self.ctrl):ExitShowCharacter()
end

UIShowCharacter.ExitButtonClicked = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIShowCharacter.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  self.ctrl = nil
  ;
  (base.OnDelete)(self)
end

return UIShowCharacter

