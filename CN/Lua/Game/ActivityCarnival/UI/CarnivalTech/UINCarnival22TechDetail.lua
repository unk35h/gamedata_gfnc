-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22TechDetail = class("UINCarnival22TechDetail", UIBaseNode)
local base = UIBaseNode
local CommonLogicUtil = require("Game.Common.CommonLogicUtil.CommonLogicUtil")
local UINStOConsumeItem = require("Game.StrategyOverview.UI.Side.UINStOConsumeItem")
local UINWATechSideUpItem = require("Game.ActivitySectorII.Tech.UI.UINWATechSideUpItem")
local UINWATechConditionItem = require("Game.ActivitySectorII.Tech.UI.UINWATechConditionItem")
UINCarnival22TechDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWATechSideUpItem, UINStOConsumeItem, UINWATechConditionItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Preview, self, self.OnClickDetail)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Upgrade, self, self.OnClickLevelUp)
  self._upItemPool = (UIItemPool.New)(UINWATechSideUpItem, (self.ui).uPItem)
  ;
  ((self.ui).uPItem):SetActive(false)
  self._costItemPool = (UIItemPool.New)(UINStOConsumeItem, (self.ui).consumeItem)
  ;
  ((self.ui).consumeItem):SetActive(false)
  self.conditionItemPool = (UIItemPool.New)(UINWATechConditionItem, (self.ui).conditionItem)
  ;
  ((self.ui).conditionItem):SetActive(false)
end

UINCarnival22TechDetail.InitCarnivalTechDetail = function(self, clickDetailFunc, clickLevelFunc)
  -- function num : 0_1
  self._clickDetailFunc = clickDetailFunc
  self._clickLevelFunc = clickLevelFunc
end

UINCarnival22TechDetail.SetCarnivalTechData = function(self, actTechData)
  -- function num : 0_2
  self._actTechData = actTechData
  self:RefreshCarnivalTechDetail()
end

UINCarnival22TechDetail.RefreshCarnivalTechDetail = function(self)
  -- function num : 0_3 , upvalues : _ENV, CommonLogicUtil
  local curLevel = (self._actTechData):GetCurLevel()
  local maxLevel = (self._actTechData):GetMaxLevel()
  local isMax = maxLevel <= curLevel
  ;
  ((self.ui).tex_Level):SetIndex(0, tostring(curLevel), tostring(maxLevel))
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (self._actTechData):GetAWTechName()
  ;
  (self._upItemPool):HideAll()
  local isUnlock = (self._actTechData):GetIsTechUnlocked()
  local isMaxLevel = curLevel == maxLevel
  local logicArray, para1Array, para2Array, para3Array = (self._actTechData):GetTechLogic(isUnlock and curLevel or 1)
  local logicArray_nl, para1Array_nl, para2Array_nl, para3Array_nl = nil, nil, nil, nil
  if isUnlock and not isMaxLevel then
    logicArray_nl = (self._actTechData):GetTechLogic(curLevel + 1)
  end
  local intro = ""
  for index,logic in ipairs(logicArray) do
    local para1 = para1Array[index]
    local para2 = para2Array[index]
    local para3 = para3Array[index]
    local longDes, shortDes, valueDes = (CommonLogicUtil.GetDesString)(logic, para1, para2, para3)
    local nextLevelValue = nil
    if logicArray_nl ~= nil and logicArray_nl[index] ~= nil and logicArray_nl[index] == logic then
      local para1 = para1Array_nl[index]
      local para2 = para2Array_nl[index]
      local para3 = para3Array_nl[index]
      _ = (CommonLogicUtil.GetDesString)(logic, para1, para2, para3)
    end
    local upItem = (self._upItemPool):GetOne()
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
      -- DECOMPILER ERROR at PC135: Overwrote pending register: R26 in 'AssignReg'

      local longDes, shortDes, valueDes = (CommonLogicUtil.GetDesString)(logic, para1, nextLevelValue, para3)
      local upItem = (self._upItemPool):GetOne()
      upItem:RefreshWATechSideUpItem(false, isMaxLevel, shortDes, valueDes)
      if (string.IsNullOrEmpty)(intro) then
        intro = longDes
      else
        intro = intro .. "\n" .. longDes
      end
    end
  end
  -- DECOMPILER ERROR at PC162: Confused about usage of register: R15 in 'UnsetPending'

  ;
  ((self.ui).tex_Intro).text = intro
  ;
  ((self.ui).consume):SetActive(not isMax)
  ;
  ((self.ui).isMax):SetActive(isMax)
  if isMax then
    return 
  end
  ;
  (self._costItemPool):HideAll()
  ;
  (self.conditionItemPool):HideAll()
  local costDic = (self._actTechData):GetLevelCost(curLevel + 1)
  local costIdList = {}
  for costId,_ in pairs(costDic) do
    (table.insert)(costIdList, costId)
  end
  ;
  (table.sort)(costIdList)
  for _,costId in ipairs(costIdList) do
    local item = (self._costItemPool):GetOne()
    item:InitStOConsumeItem(costId, costDic[costId])
  end
  local canLevelUp = (self._actTechData):IsCouldLevelUp()
  ;
  (((self.ui).btn_Upgrade).gameObject):SetActive(canLevelUp)
  ;
  (((self.ui).btn_NotUpgrade).gameObject):SetActive(not canLevelUp)
  ;
  ((self.ui).tex_notUplevel):SetIndex(canLevelUp or ((self._actTechData):GetIsUnlock() and 1) or 0)
  if not (self._actTechData):GetIsUnlock() then
    local preTechData = (self._actTechData):GetPreTechData()
    if preTechData ~= nil then
      local consumeItem = (self.conditionItemPool):GetOne()
      local isComplete = (self._actTechData):GetUnlockPreTechCondition() <= preTechData:GetCurLevel()
      consumeItem:InitStOConditonItem((string.format)(ConfigData:GetTipContent(7105), (self._actTechData):GetUnlockPreTechCondition(), preTechData:GetAWTechName()), isComplete)
    end
    local preConditionList = (self._actTechData):GetAWTechUnlockInfo(curLevel + 1)
    for index,value in ipairs(preConditionList) do
      local isComplete = value.unlock
      local lockReason = value.lockReason
      local consumeItem = (self.conditionItemPool):GetOne()
      consumeItem:InitStOConditonItem(lockReason, isComplete)
    end
  end
  -- DECOMPILER ERROR: 21 unprocessed JMP targets
end

UINCarnival22TechDetail.OnClickDetail = function(self)
  -- function num : 0_4
  if self._clickDetailFunc ~= nil then
    (self._clickDetailFunc)(self._actTechData)
  end
end

UINCarnival22TechDetail.OnClickLevelUp = function(self)
  -- function num : 0_5
  if self._clickLevelFunc ~= nil then
    (self._clickLevelFunc)(self._actTechData)
  end
end

return UINCarnival22TechDetail

