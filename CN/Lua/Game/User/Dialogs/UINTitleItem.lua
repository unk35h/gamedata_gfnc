-- params : ...
-- function num : 0 , upvalues : _ENV
local UINTitleItem = class("UINTitleItem", UIBaseNode)
local base = UIBaseNode
UINTitleItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINTitleItem.InitTitleItem = function(self, cfg, index)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(cfg.name)
  self.index = index
  local newTitleItemDic = (PlayerDataCenter.gameSettingData):GetNewTitleItemDic()
  if newTitleItemDic[cfg.id] then
    ((self.ui).img_New):SetActive(true)
  else
    ;
    ((self.ui).img_New):SetActive(false)
  end
end

UINTitleItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINTitleItem

