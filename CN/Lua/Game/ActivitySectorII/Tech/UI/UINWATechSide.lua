-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWATechSide = class("UINWATechSide", UIBaseNode)
local base = UIBaseNode
local UINWATechSideUpItem = require("Game.ActivitySectorII.Tech.UI.UINWATechSideUpItem")
local UINWATechConsumeItem = require("Game.ActivitySectorII.Tech.UI.UINWATechConsumeItem")
local UINWATechConditionItem = require("Game.ActivitySectorII.Tech.UI.UINWATechConditionItem")
local UINWATechPreviewNode = require("Game.ActivitySectorII.Tech.UI.UINWATechPreviewNode")
local CommonLogicUtil = require("Game.Common.CommonLogicUtil.CommonLogicUtil")
local cs_MessageCommon = CS.MessageCommon
UINWATechSide.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWATechSideUpItem, UINWATechConsumeItem, UINWATechConditionItem, UINWATechPreviewNode
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.upItemPool = (UIItemPool.New)(UINWATechSideUpItem, (self.ui).uPItem)
  ;
  ((self.ui).uPItem):SetActive(false)
  self.consumeItemPool = (UIItemPool.New)(UINWATechConsumeItem, (self.ui).obj_consumeItem)
  ;
  ((self.ui).obj_consumeItem):SetActive(false)
  self.conditionItemPool = (UIItemPool.New)(UINWATechConditionItem, (self.ui).obj_conditionItem)
  ;
  ((self.ui).obj_conditionItem):SetActive(false)
  self.previewNode = (UINWATechPreviewNode.New)()
  ;
  (self.previewNode):Init((self.ui).logicPreviewNode)
  ;
  (self.previewNode):Hide()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Upgrade, self, self._OnClickUpgrade)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Preview, self, self._OnClickPreview)
end

UINWATechSide.InitTechSideNode = function(self, uiWATech)
  -- function num : 0_1
  self.uiWATech = uiWATech
end

UINWATechSide.RefreshWATechSide = function(self, techData)
  -- function num : 0_2
  self.techData = techData
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = techData:GetAWTechName()
  self:RefreshLevel()
  self:RefreshUnlockOrUpgrade()
end

UINWATechSide.RefreshLevel = function(self)
  -- function num : 0_3 , upvalues : _ENV, CommonLogicUtil
  local curLevel = (self.techData):GetCurLevel()
  local maxLevel = (self.techData):GetMaxLevel()
  ;
  ((self.ui).tex_Level):SetIndex(0, tostring(curLevel), tostring(maxLevel))
  ;
  (self.upItemPool):HideAll()
  local isUnlock = (self.techData):GetIsTechUnlocked()
  local isMaxLevel = curLevel == maxLevel
  local logicArray, para1Array, para2Array, para3Array = (self.techData):GetTechLogic(isUnlock and curLevel or 1)
  local logicArray_nl, para1Array_nl, para2Array_nl, para3Array_nl = nil, nil, nil, nil
  if isUnlock and not isMaxLevel then
    logicArray_nl = (self.techData):GetTechLogic(curLevel + 1)
  end
  local intro = ""
  for index,logic in ipairs(logicArray) do
    local para1 = para1Array[index]
    local para2 = para2Array[index]
    local para3 = para3Array[index]
    local longDes, shortDes, valueDes = (CommonLogicUtil.GetDesString)(logic, para1, para2, para3, eLogicDesType.ActWinter)
    local nextLevelValue = nil
    if logicArray_nl ~= nil and logicArray_nl[index] ~= nil and logicArray_nl[index] == logic then
      local para1 = para1Array_nl[index]
      local para2 = para2Array_nl[index]
      local para3 = para3Array_nl[index]
      _ = (CommonLogicUtil.GetDesString)(logic, para1, para2, para3, eLogicDesType.ActWinter)
    end
    local upItem = (self.upItemPool):GetOne()
    upItem:RefreshWATechSideUpItem(isUnlock, isMaxLevel, shortDes, valueDes, nextLevelValue)
    if (string.IsNullOrEmpty)(intro) then
      intro = longDes
    else
      intro = intro .. "\n" .. longDes
    end
  end
  if logicArray_nl ~= nil and #logicArray < #logicArray_nl then
    for index = #logicArray + 1, #logicArray_nl do
      local logic = logicArray_nl[index]
      local para1 = para1Array_nl[index]
      local para2 = para2Array_nl[index]
      local para3 = para3Array_nl[index]
      -- DECOMPILER ERROR at PC129: Overwrote pending register: R25 in 'AssignReg'

      local longDes, shortDes, valueDes = (CommonLogicUtil.GetDesString)(logic, para1, nextLevelValue, para3, eLogicDesType.ActWinter)
      local upItem = (self.upItemPool):GetOne()
      upItem:RefreshWATechSideUpItem(false, isMaxLevel, shortDes, valueDes)
      if (string.IsNullOrEmpty)(intro) then
        intro = longDes
      else
        intro = intro .. "\n" .. longDes
      end
    end
  end
  -- DECOMPILER ERROR at PC158: Confused about usage of register: R14 in 'UnsetPending'

  ;
  ((self.ui).tex_Intro).text = intro
  -- DECOMPILER ERROR: 10 unprocessed JMP targets
end

UINWATechSide.RefreshUnlockOrUpgrade = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local isMaxLevel = (self.techData):IsMaxLvel()
  ;
  ((self.ui).obj_isMax):SetActive(isMaxLevel)
  ;
  ((self.ui).obj_consume):SetActive(not isMaxLevel)
  if isMaxLevel then
    return 
  end
  ;
  (self.consumeItemPool):HideAll()
  ;
  (self.conditionItemPool):HideAll()
  local isUnlock = (self.techData):GetIsTechUnlocked()
  if isUnlock then
    ((self.ui).text_consumTypoe):SetIndex(0)
    ;
    ((self.ui).text_Upgrade):SetIndex(0)
  else
    ;
    ((self.ui).text_consumTypoe):SetIndex(1)
    ;
    ((self.ui).text_Upgrade):SetIndex(1)
  end
  local targetLevel = (self.techData):GetCurLevel() + 1
  for itemid,needNum in pairs((self.techData):GetLevelCost(targetLevel)) do
    local consumeItem = (self.consumeItemPool):GetOne()
    consumeItem:InitStOConsumeItem(itemid, needNum)
  end
  local preTechData = (self.techData):GetPreTechData()
  if preTechData ~= nil then
    local consumeItem = (self.conditionItemPool):GetOne()
    local isComplete = (self.techData):GetUnlockPreTechCondition() <= preTechData:GetCurLevel()
    consumeItem:InitStOConditonItem((string.format)(ConfigData:GetTipContent(7105), (self.techData):GetUnlockPreTechCondition(), preTechData:GetAWTechName()), isComplete)
  end
  local preConditionList = (self.techData):GetAWTechUnlockInfo(targetLevel)
  for index,value in ipairs(preConditionList) do
    local isComplete = value.unlock
    local lockReason = value.lockReason
    local consumeItem = (self.conditionItemPool):GetOne()
    consumeItem:InitStOConditonItem(lockReason, isComplete)
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINWATechSide._OnClickUpgrade = function(self)
  -- function num : 0_5 , upvalues : _ENV, cs_MessageCommon
  local isCouldLevelUp, reasonDes = (self.techData):IsCouldLevelUp()
  if isCouldLevelUp then
    local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
    sectorIICtrl:UpgradeSectorIIActTech(self.techData, function(techData)
    -- function num : 0_5_0 , upvalues : _ENV, self
    MsgCenter:Broadcast(eMsgEventId.ActivityTechChange, techData)
    ;
    (self.uiWATech):OnTechItemLevelUp(techData)
    if (self.techData):GetTechId() == techData:GetTechId() then
      self:RefreshWATechSide(techData)
    end
  end
)
  else
    do
      if reasonDes ~= nil then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(reasonDes)
      end
    end
  end
end

UINWATechSide._OnClickPreview = function(self)
  -- function num : 0_6
  (self.previewNode):InitWATechPreview(self.techData)
  ;
  (self.previewNode):Show()
end

UINWATechSide.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UINWATechSide

