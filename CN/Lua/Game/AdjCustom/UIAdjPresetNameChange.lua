-- params : ...
-- function num : 0 , upvalues : _ENV
local UIAdjPresetNameChange = class("UIAdjPresetNameChange", UIBaseWindow)
local base = UIBaseWindow
local CS_MessageCommon = CS.MessageCommon
local RenameHelper = require("Game.CommonUI.Rename.RenameHelper")
UIAdjPresetNameChange.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self.OnClickCancle)
  ;
  (UIUtil.AddButtonListener)((self.ui).background, self, self.OnClickCancle)
  self.characterLimit = ((self.ui).inputField).characterLimit
end

UIAdjPresetNameChange.InitAdjPresetNameChange = function(self, defaultContent, confirmFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._defaultContent = defaultContent
  self._confirmFunc = confirmFunc
  ;
  ((self.ui).tex_Tips):SetIndex(0, self._defaultContent)
  ;
  ((self.ui).tex_textTips):SetIndex(0, tostring(self.characterLimit))
end

UIAdjPresetNameChange.OnClickConfirm = function(self)
  -- function num : 0_2 , upvalues : _ENV, CS_MessageCommon, RenameHelper
  if self._confirmFunc == nil then
    return 
  end
  local content = ((self.ui).inputField).text
  if (string.IsNullOrEmpty)(content) then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(53))
    return 
  end
  if content == self._defaultContent then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(176))
    return 
  end
  local inputLength = RenameHelper:GetNameLength(content)
  if self.characterLimit < inputLength then
    content = RenameHelper:ClampNameInLength(content, self.characterLimit)
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).inputField).text = content
    return 
  end
  ;
  (self._confirmFunc)(content)
  self:Delete()
end

UIAdjPresetNameChange.OnClickCancle = function(self)
  -- function num : 0_3
  self:Delete()
end

return UIAdjPresetNameChange

