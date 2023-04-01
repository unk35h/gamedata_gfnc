-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventWeeklyQAQuestionOptionItem = class("UINEventWeeklyQAQuestionOptionItem", UIBaseNode)
local base = UIBaseNode
local EventWeeklyQAQuestionOption = require("Game.EventWeeklyQA.Data.EventWeeklyQAQuestionOption")
UINEventWeeklyQAQuestionOptionItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_option, self, self._OnClickOption)
end

UINEventWeeklyQAQuestionOptionItem.InitWeeklyQAQuestionOptionItem = function(self, optionData, onClickOption)
  -- function num : 0_1 , upvalues : _ENV, EventWeeklyQAQuestionOption
  self.optionData = optionData
  ;
  ((self.ui).tex_des):SetIndex(optionData.showIndex - 1, (LanguageUtil.GetLocaleText)(optionData.des))
  self:SetOptionImgItem((EventWeeklyQAQuestionOption.eOptionState).notAnswer)
  self.__onClickOption = onClickOption
end

UINEventWeeklyQAQuestionOptionItem.SetOptionImgItem = function(self, optionState)
  -- function num : 0_2
  ((self.ui).imgItem_option):SetIndex(optionState)
end

UINEventWeeklyQAQuestionOptionItem._OnClickOption = function(self)
  -- function num : 0_3
  if self.__onClickOption ~= nil then
    (self.__onClickOption)((self.optionData).logicIndex)
  end
end

return UINEventWeeklyQAQuestionOptionItem

