-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLogicPreviewRowBase = require("Game.CommonUI.LogicPreviewNode.UINLogicPreviewRowBase")
local UINWATechPreviewNodeItem = class("UINWATechPreviewNodeItem", UINLogicPreviewRowBase)
local base = UINLogicPreviewRowBase
local CommonLogicUtil = require("Game.Common.CommonLogicUtil.CommonLogicUtil")
UINWATechPreviewNodeItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

UINWATechPreviewNodeItem.InitShopItemPriveInterval = function(self, isCurLevel, techData, level, maxLevelCount)
  -- function num : 0_1 , upvalues : _ENV, CommonLogicUtil
  (self.attrPool):HideAll()
  local attrItem = (self.attrPool):GetOne()
  attrItem:InitAttrItem(tostring(level), isCurLevel)
  local logicArray, para1Array, para2Array, para3Array = techData:GetTechLogic(level)
  for index,logic in ipairs(logicArray) do
    local para1 = para1Array[index]
    local para2 = para2Array[index]
    local para3 = para3Array[index]
    local _, _, value = (CommonLogicUtil.GetDesString)(logic, para1, para2, para3, eLogicDesType.ActWinter)
    local attrItem = (self.attrPool):GetOne()
    attrItem:InitAttrItem(value, isCurLevel)
  end
  for i = #logicArray + 1, maxLevelCount do
    local attrItem = (self.attrPool):GetOne()
    attrItem:InitAttrItem("", isCurLevel)
  end
end

UINWATechPreviewNodeItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWATechPreviewNodeItem

