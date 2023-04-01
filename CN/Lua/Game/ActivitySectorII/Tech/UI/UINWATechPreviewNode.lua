-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.CommonUI.LogicPreviewNode.UILogicPreviewNodeBase")
local UINWATechPreviewNode = class("UINWATechPreviewNode", base)
local UINWATechPreviewNodeItem = require("Game.ActivitySectorII.Tech.UI.UINWATechPreviewNodeItem")
local CommonLogicUtil = require("Game.Common.CommonLogicUtil.CommonLogicUtil")
UINWATechPreviewNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, UINWATechPreviewNodeItem
  (base.OnInit)(self)
  ;
  (base.InitWithClass)(self, nil, UINWATechPreviewNodeItem)
end

UINWATechPreviewNode.InitWATechPreview = function(self, techData)
  -- function num : 0_1 , upvalues : _ENV, CommonLogicUtil
  ((self.ui).tex_SkillName):SetIndex(0, techData:GetAWTechName())
  ;
  (((self.ui).obj_Current).gameObject):SetActive(false)
  ;
  (self.headAttrPool):HideAll()
  ;
  (self.rowItemPool):HideAll()
  local curLevel = techData:GetCurLevel()
  local maxLevel = techData:GetMaxLevel()
  local logicArray, para1Array, para2Array, para3Array = techData:GetTechLogic(maxLevel)
  local maxLevelCount = #logicArray
  local attrItem = (self.headAttrPool):GetOne()
  attrItem:InitAttrItem(ConfigData:GetTipContent(900))
  for index,logic in ipairs(logicArray) do
    local para1 = para1Array[index]
    local para2 = para2Array[index]
    local para3 = para3Array[index]
    local _, shortDes, _ = (CommonLogicUtil.GetDesString)(logic, para1, para2, para3, eLogicDesType.ActWinter)
    local attrItem = (self.headAttrPool):GetOne()
    attrItem:InitAttrItem(shortDes)
  end
  for level = 1, maxLevel do
    local isCurLevel = curLevel == level
    local rowItem = (self.rowItemPool):GetOne()
    rowItem:InitWithClass()
    rowItem:InitShopItemPriveInterval(isCurLevel, techData, R20_PC77, maxLevelCount)
    if isCurLevel then
      (((self.ui).obj_Current).gameObject):SetActive(true)
      ;
      ((self.ui).obj_Current):SetParent(rowItem.transform)
      -- DECOMPILER ERROR at PC95: Confused about usage of register: R16 in 'UnsetPending'

      ;
      ((self.ui).obj_Current).anchoredPosition = Vector2.zero
      ;
      ((self.ui).obj_Current):SetAsFirstSibling()
    end
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINWATechPreviewNode._OnClickClose = function(self)
  -- function num : 0_2
  self:Hide()
end

UINWATechPreviewNode.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINWATechPreviewNode

