-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.CommonUI.LogicPreviewNode.UILogicPreviewNodeBase")
local UINEpRSLevelPreview = class("UINEpRSLevelPreview", base)
local UINEpRSLevelRowItem = require("Game.Exploration.UI.ResidentStore.StoreLevelPreview.UINEpRSLevelRowItem")
UINEpRSLevelPreview.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, UINEpRSLevelRowItem
  (base.OnInit)(self)
  ;
  (base.InitWithClass)(self, nil, UINEpRSLevelRowItem)
end

UINEpRSLevelPreview.InitEpRSLevelPreview = function(self, residentShopCfg, curLevel)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).tex_SkillName):SetIndex(2)
  ;
  (((self.ui).obj_Current).gameObject):SetActive(true)
  ;
  (self.headAttrPool):HideAll()
  ;
  (self.rowItemPool):HideAll()
  local attrItem = (self.headAttrPool):GetOne()
  attrItem:InitAttrItem(ConfigData:GetTipContent(900))
  attrItem = (self.headAttrPool):GetOne()
  attrItem:InitAttrItem(ConfigData:GetTipContent(6010))
  attrItem = (self.headAttrPool):GetOne()
  attrItem:InitAttrItem(ConfigData:GetTipContent(6011))
  attrItem = (self.headAttrPool):GetOne()
  attrItem:InitAttrItem(ConfigData:GetTipContent(6012))
  attrItem = (self.headAttrPool):GetOne()
  attrItem:InitAttrItem(ConfigData:GetTipContent(6013))
  local cellingAdd = 0
  for level = 1, residentShopCfg.maxLevel do
    local shopCfg = residentShopCfg[level]
    local logicList = {}
    ;
    (table.insert)(logicList, tostring(level))
    cellingAdd = cellingAdd + shopCfg.function_limit_bonus
    ;
    (table.insert)(logicList, tostring(cellingAdd))
    for i = 1, (ConfigData.buildinConfig).ChipMaxLevel do
      local ratio = tostring(FormatNum((shopCfg.function_drop_ratio)[i] / 10)) .. "%"
      ;
      (table.insert)(logicList, ratio)
    end
    local isCurLevel = curLevel == level
    local rowItem = (self.rowItemPool):GetOne()
    rowItem:InitWithClass()
    rowItem:InitEpRSLevelRowItem(level, isCurLevel, logicList)
    if isCurLevel then
      ((self.ui).obj_Current):SetParent(rowItem.transform)
      -- DECOMPILER ERROR at PC135: Confused about usage of register: R13 in 'UnsetPending'

      ;
      ((self.ui).obj_Current).anchoredPosition = Vector2.zero
      ;
      ((self.ui).obj_Current):SetAsFirstSibling()
    end
  end
  -- DECOMPILER ERROR at PC148: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).verticalNormalizedPosition = 1 - (curLevel - 1) / (residentShopCfg.maxLevel - 1)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINEpRSLevelPreview._OnClickClose = function(self)
  -- function num : 0_2
  self:Hide()
end

UINEpRSLevelPreview.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINEpRSLevelPreview

