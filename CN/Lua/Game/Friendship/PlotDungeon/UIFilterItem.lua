-- params : ...
-- function num : 0 , upvalues : _ENV
local UIFilterItem = class("UIFilterItem", UIBaseNode)
local base = UIBaseNode
UIFilterItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_CampItem, self, self.__onclick)
end

UIFilterItem.InitFWithData = function(self, careerId, isDouble, allText)
  -- function num : 0_1 , upvalues : _ENV
  self.careerId = careerId
  self.isDouble = isDouble
  if careerId == 0 then
    self.itemName = allText
  else
    local careerCfg = (ConfigData.career)[careerId]
    self.itemName = (LanguageUtil.GetLocaleText)(careerCfg.name)
  end
  do
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_CampName).text = self.itemName
  end
end

UIFilterItem.__onclick = function(self)
  -- function num : 0_2
  if self.clickEvent ~= nil then
    (self.clickEvent)(self.careerId, self.itemName)
  end
end

UIFilterItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UIFilterItem

