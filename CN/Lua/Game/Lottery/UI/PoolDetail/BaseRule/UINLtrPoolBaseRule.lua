-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLtrPoolBaseRule = class("UINLtrPoolBaseRule", UIBaseNode)
local base = UIBaseNode
local UINLtrPoolBaseConvertItem = require("Game.Lottery.UI.PoolDetail.BaseRule.UINLtrPoolBaseConvertItem")
UINLtrPoolBaseRule.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINLtrPoolBaseRule.InitLtrPoolBaseRule = function(self, ltrGroupData, fromLtrData)
  -- function num : 0_1 , upvalues : _ENV, UINLtrPoolBaseConvertItem
  local poolCfg = fromLtrData.ltrCfg
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des1Title).text = (LanguageUtil.GetLocaleText)(poolCfg.title1)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des1Rule).text = (LanguageUtil.GetLocaleText)(poolCfg.des1)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des3Title).text = (LanguageUtil.GetLocaleText)(poolCfg.title3)
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des3Rule).text = (LanguageUtil.GetLocaleText)(poolCfg.des3)
  if #((self.ui).tex_Des1Title).text == 0 then
    (((self.ui).tex_Des1Title).gameObject):SetActive(false)
  end
  if #((self.ui).tex_Des3Title).text == 0 then
    (((self.ui).tex_Des3Title).gameObject):SetActive(false)
  end
  local convertItem = (UINLtrPoolBaseConvertItem.New)()
  convertItem:Init((self.ui).blendRuleVItem)
  local ltrData = ltrGroupData.ltrPoolData
  convertItem:InitLtrPoolBaseConvertItem(ltrGroupData.ltrPoolData, fromLtrData == ltrData)
  if self.convertItemList ~= nil then
    (self.convertItemList):HideAll()
  end
  if ltrGroupData:HasLtrMoreGroup() then
    if not self.convertItemList then
      self.convertItemList = (UIItemPool.New)(UINLtrPoolBaseConvertItem, (self.ui).blendRuleVItem)
      local ltrDataList = ltrGroupData:GetLtrInGroupDataList()
      local rootIndex = (convertItem.transform):GetSiblingIndex()
      for i = 2, #ltrDataList do
        convertItem = (self.convertItemList):GetOne()
        ;
        (convertItem.transform):SetSiblingIndex(rootIndex + i - 1)
        ltrData = ltrDataList[i]
        convertItem:InitLtrPoolBaseConvertItem(ltrData, ltrData == fromLtrData)
      end
      -- DECOMPILER ERROR: 5 unprocessed JMP targets
    end
  end
end

UINLtrPoolBaseRule.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINLtrPoolBaseRule

