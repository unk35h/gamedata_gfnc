-- params : ...
-- function num : 0 , upvalues : _ENV
local UILogicPreviewNodeBase = require("Game.CommonUI.LogicPreviewNode.UILogicPreviewNodeBase")
local UINAttrMiniWidget = class("UINAttrMiniWidget", UILogicPreviewNodeBase)
local base = UILogicPreviewNodeBase
local UINAttrIntroItem = require("Game.Formation.UI.Common.UINHeroAttrIntroItem")
UINAttrMiniWidget.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, base
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (base.InitWithClass)(self, nil, nil)
  ;
  (self.rowItemPool):HideAll()
end

UINAttrMiniWidget.OnShow = function(self)
  -- function num : 0_1 , upvalues : base
  (base.OnShow)(self)
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).verticalNormalizedPosition = 1
end

UINAttrMiniWidget.OnHide = function(self)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.Hide)(self)
  AudioManager:PlayAudioById(1068)
end

UINAttrMiniWidget.OnUpdateAttrData = function(self, name, attrDataList)
  -- function num : 0_3 , upvalues : _ENV
  if attrDataList == nil then
    return 
  end
  self.attrDataList = attrDataList
  ;
  (self.rowItemPool):HideAll()
  for index = 1, #self.attrDataList do
    local rowItem = (self.rowItemPool):GetOne()
    rowItem:InitWithClass()
    local curData = (self.attrDataList)[index]
    local gridPool = rowItem.attrPool
    if gridPool ~= nil then
      gridPool:HideAll()
      local nameItem = gridPool:GetOne()
      nameItem:InitAttrItem(curData.name)
      local basicValueItem = gridPool:GetOne()
      basicValueItem:InitAttrItem((curData.attrValueStrs)[1])
      -- DECOMPILER ERROR at PC37: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((basicValueItem.ui).tex_Attri).alignment = 5
    end
    do
      do
        local iconSprite = CRH:GetSprite(curData.icon)
        -- DECOMPILER ERROR at PC44: Confused about usage of register: R11 in 'UnsetPending'

        ;
        ((rowItem.ui).attrIcon).sprite = iconSprite
        -- DECOMPILER ERROR at PC45: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
end

UINAttrMiniWidget.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINAttrMiniWidget

