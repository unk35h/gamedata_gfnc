-- params : ...
-- function num : 0 , upvalues : _ENV
local UINStgClgInfoTaskItem = class("UINStgClgInfoTaskItem", UIBaseNode)
local base = UIBaseNode
local UINCommonSwitchToggle = require("Game.CommonUI.CommonSwitchToggle.UINCommonSwitchToggle")
UINStgClgInfoTaskItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCommonSwitchToggle
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  if not IsNull((self.ui).tog_Switch) then
    self._switchChallengeTog = (UINCommonSwitchToggle.New)()
    ;
    (self._switchChallengeTog):Init((self.ui).tog_Switch)
  end
end

UINStgClgInfoTaskItem.InitStgClgInfoTaskItem = function(self, taskCfg, isComplete, isFixed, isOpen, changeOpenFunc)
  -- function num : 0_1 , upvalues : _ENV
  self.changeOpenFunc = changeOpenFunc
  self.taskCfg = taskCfg
  if isFixed then
    isOpen = true
  else
    if not self._changeChallengeFunc then
      self._changeChallengeFunc = BindCallback(self, self._OnClickTaskOpenTog)
      ;
      (self._switchChallengeTog):InitCommonSwitchToggle(isOpen, self._changeChallengeFunc)
      self:_UpdBgOpenColor(isOpen)
      -- DECOMPILER ERROR at PC28: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self.ui).tex_Desc).text = (LanguageUtil.GetLocaleText)(taskCfg.task_intro)
      ;
      ((self.ui).obj_Icon):SetActive(isComplete)
      ;
      ((self.ui).obj_Complete):SetActive(isComplete)
      ;
      ((self.ui).reward):SetActive(not isComplete)
    end
  end
end

UINStgClgInfoTaskItem._UpdBgOpenColor = function(self, isOpen)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Buttom).color = ((self.ui).bg_ColorList)[isOpen and 1 or 2]
end

UINStgClgInfoTaskItem._OnClickTaskOpenTog = function(self, isOn)
  -- function num : 0_3
  self:_UpdBgOpenColor(isOn)
  if self.changeOpenFunc ~= nil then
    (self.changeOpenFunc)((self.taskCfg).id, isOn)
  end
end

UINStgClgInfoTaskItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  if self._switchChallengeTog ~= nil then
    (self._switchChallengeTog):Delete()
  end
  ;
  (base.OnDelete)(self)
end

return UINStgClgInfoTaskItem

