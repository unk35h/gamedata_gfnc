-- params : ...
-- function num : 0 , upvalues : _ENV
local UIChristmas22StrategyOverview = class("UIChristmas22StrategyOverview", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
local cs_Edge = ((CS.UnityEngine).RectTransform).Edge
local UINWATechLine = require("Game.ActivitySectorII.Tech.UI.UINWATechLine")
local UINCarnival22TechItemLocked = require("Game.ActivityCarnival.UI.CarnivalTech.UINCarnival22TechItemLocked")
local Top_INTERNIVAL = 30
local LEFT_INTERNIVAL = 30
local TECH_WIDTH_NOR = 199
local TECH_WIDTH_SPLIT = 209
local TECH_HEIGHT = 249
local TECH_LENGHT_SPLIT = 2
local LockedLineOffsetY = 20
UIChristmas22StrategyOverview.__SetNodeClass = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._techItemClass = require("Game.ActivityChristmas.UI.Tech.UINChristmas22TechItem")
  self._techLvClass = require("Game.ActivityChristmas.UI.Tech.UINChristmas22TechLv")
  self._techTitleClass = require("Game.ActivityChristmas.UI.Tech.UINChristmas22TechTitle")
  self._specialListClass = require("Game.ActivityChristmas.UI.Tech.UINChristmas22TechSpecialList")
  self._specialSideClass = require("Game.ActivityChristmas.UI.Tech.UINChristmas22TechSpeicalSide")
  self._desType = eLogicDesType.Christmas
  self._lvNodeOffset = 0
  self._itemNoEnoughTip = 8714
  self._resetNoEnoughTip = 8713
end

UIChristmas22StrategyOverview.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, cs_ResLoader, UINWATechLine, UINCarnival22TechItemLocked
  self:__SetNodeClass()
  ;
  (UIUtil.SetTopStatus)(self, self.CloseChristmas22StrategyOverview)
  self.resloader = (cs_ResLoader.Create)()
  ;
  (UIUtil.AddButtonListener)((self.ui).background, self, self.OnClickBg)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_rect, self, self.OnClickBg)
  self.__OnTechLvCallback = BindCallback(self, self.__OnTechLv)
  self.__OnTechResetCallback = BindCallback(self, self.__OnTechReset)
  self.__OnTechDetailCallback = BindCallback(self, self.__OnTechDetail)
  self.__OnClickLvCallbackCallback = BindCallback(self, self.OnClickLvCallback)
  self.__GetLockItemCallback = BindCallback(self, self.__GetLockItem)
  self.__RefreshWindowCallback = BindCallback(self, self.__RefreshWindow)
  self._itemPool = (UIItemPool.New)(self._techItemClass, (self.ui).techItem)
  self._titlePool = (UIItemPool.New)(self._techTitleClass, (self.ui).titleNode)
  self._linePool = (UIItemPool.New)(UINWATechLine, (self.ui).obj_Line)
  self._lockPool = (UIItemPool.New)(UINCarnival22TechItemLocked, (self.ui).obj_ItemLocked)
  ;
  ((self.ui).techItem):SetActive(false)
  ;
  ((self.ui).titleNode):SetActive(false)
  ;
  ((self.ui).obj_Line):SetActive(false)
  self._sideNode = ((self._specialSideClass).New)()
  ;
  (self._sideNode):Init((self.ui).side)
  ;
  (self._sideNode):SetChristmas22LogicDesType(self._desType)
  ;
  (self._sideNode):BindChrismas22TechSpeicalSide(self.__OnTechLvCallback, self.__OnTechResetCallback, self.__OnTechDetailCallback)
  local rectPoint = (self.transform):InverseTransformPoint(((self.ui).rect).position)
  local rectSizeDetail = (((self.ui).rect).rect).size
  local lvNodeSizeDetail = ((((self.ui).techInfoNode).transform).rect).size
  local techItemDetail = ((((self.ui).techItem).transform).rect).size
  self._lvNodePointRang = {}
  -- DECOMPILER ERROR at PC143: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._lvNodePointRang).minX = rectPoint.x - rectSizeDetail.x / 2
  -- DECOMPILER ERROR at PC151: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._lvNodePointRang).maxX = rectPoint.x + rectSizeDetail.x / 2 - lvNodeSizeDetail.x
  -- DECOMPILER ERROR at PC154: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._lvNodePointRang).maxY = rectPoint.y
  -- DECOMPILER ERROR at PC161: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._lvNodePointRang).minY = rectPoint.y - rectSizeDetail.y + lvNodeSizeDetail.y
  -- DECOMPILER ERROR at PC164: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._lvNodePointRang).lvWith = lvNodeSizeDetail.x
  -- DECOMPILER ERROR at PC167: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._lvNodePointRang).itemWith = techItemDetail.x
  ;
  (((self.ui).techInfoNode).gameObject):SetActive(false)
  self.__ItemUpdateCallback = BindCallback(self, self.__ItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__ItemUpdateCallback)
end

UIChristmas22StrategyOverview.InitChristmas22StrategyOverview = function(self, actTechTree, specialBranchId, callback)
  -- function num : 0_2 , upvalues : _ENV
  self._data = actTechTree
  self._specialBranchId = specialBranchId
  self._callback = callback
  local techType = (self._data):GetTreeId()
  local techTypeCfg = (ConfigData.activity_tech_type)[techType]
  do
    if techTypeCfg ~= nil then
      local resTable = {}
      if techTypeCfg.activity_tech_item or 0 > 0 then
        (table.insert)(resTable, techTypeCfg.activity_tech_item)
      end
      for k,v in pairs(techTypeCfg.return_tech_item) do
        (table.insert)(resTable, k)
      end
      ;
      (UIUtil.RefreshTopResId)(resTable)
    end
    self._allTechDataDic = (self._data):GetTechDataDic()
    self._branchList = {}
    for branchId,_ in pairs(self._allTechDataDic) do
      if branchId ~= self._specialBranchId then
        (table.insert)(self._branchList, R13_PC55)
      end
    end
    ;
    (table.sort)(self._branchList)
    ;
    (self._sideNode):InitChristmas22TechSpeicalSide(self._data, self._specialBranchId, self.resloader)
    self:__GenTitle()
    self:__GenTech()
  end
end

UIChristmas22StrategyOverview.__ItemUpdate = function(self, _, _, itemDic)
  -- function num : 0_3 , upvalues : _ENV
  local techTypeCostDic = (self._data):GetTechTypeCostDic()
  if techTypeCostDic == nil then
    return 
  end
  for itemId,_ in pairs(techTypeCostDic) do
    if itemDic[itemId] ~= nil then
      self:__RefreshWindow()
      break
    end
  end
end

UIChristmas22StrategyOverview.__GenTitle = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (self._titlePool):HideAll()
  for _,branchId in ipairs(self._branchList) do
    local item = (self._titlePool):GetOne()
    item:InitChristmas22TechTitle(self._data, branchId)
  end
end

UIChristmas22StrategyOverview.__GenTech = function(self)
  -- function num : 0_5 , upvalues : _ENV, TECH_HEIGHT
  local bottomY = 0
  ;
  (self._itemPool):HideAll()
  self._techItemDic = {}
  for branchId,branchTechDic in pairs(self._allTechDataDic) do
    if branchId ~= self._specialBranchId then
      for techId,techData in pairs(branchTechDic) do
        if not techData:IsActTechAutoUnlock() then
          local item = (self._itemPool):GetOne()
          ;
          (item.transform):SetParent((self.ui).rect)
          -- DECOMPILER ERROR at PC35: Confused about usage of register: R13 in 'UnsetPending'

          ;
          (item.gameObject).name = "tech_" .. tostring(techId)
          item:BindChristmas22TechItemLockFunc(self.__GetLockItemCallback)
          item:InitChristmas22TechItem(techData, self.resloader, self.__OnClickLvCallbackCallback)
          local pos = self:__CalTechPos(techData.colIndex, techData.rowIndex)
          -- DECOMPILER ERROR at PC49: Confused about usage of register: R14 in 'UnsetPending'

          ;
          (item.transform).anchoredPosition = pos
          -- DECOMPILER ERROR at PC51: Confused about usage of register: R14 in 'UnsetPending'

          ;
          (self._techItemDic)[techId] = item
          if pos.y < bottomY then
            bottomY = pos.y
          end
        end
      end
    end
  end
  ;
  (self._linePool):HideAll()
  for techId,techItem in pairs(self._techItemDic) do
    local preId = (techItem:GetChristmas22TechData()):GetPreTechId()
    if preId ~= nil then
      local preItem = (self._techItemDic)[preId]
      if preItem ~= nil then
        local item = (self._linePool):GetOne()
        ;
        (item.transform):SetParent((self.ui).rect)
        item:InitWALineItem(preItem, techItem)
        -- DECOMPILER ERROR at PC99: Confused about usage of register: R10 in 'UnsetPending'

        ;
        (item.gameObject).name = "line_" .. tostring(preId) .. "_" .. tostring(techId)
      end
    end
  end
  local sizeDelta = ((self.ui).rect).sizeDelta
  sizeDelta.y = -bottomY + TECH_HEIGHT
  -- DECOMPILER ERROR at PC111: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).rect).sizeDelta = sizeDelta
end

UIChristmas22StrategyOverview.__CalTechPos = function(self, col, row)
  -- function num : 0_6 , upvalues : _ENV, TECH_LENGHT_SPLIT, TECH_WIDTH_SPLIT, TECH_WIDTH_NOR, LEFT_INTERNIVAL, TECH_HEIGHT, Top_INTERNIVAL
  row = (self._data):GetTechRow(row)
  local splitCount = (math.floor)(col - 1 / TECH_LENGHT_SPLIT)
  local x = splitCount * TECH_WIDTH_SPLIT + (col - 1 - splitCount) * TECH_WIDTH_NOR + LEFT_INTERNIVAL
  local y = -(row - 1) * TECH_HEIGHT - Top_INTERNIVAL
  return (Vector2.New)(x, y)
end

UIChristmas22StrategyOverview.__RefreshWindow = function(self)
  -- function num : 0_7 , upvalues : _ENV
  for k,v in pairs((self._titlePool).listItem) do
    v:RefreshChristmas22TechTitle()
  end
  for k,v in pairs(self._techItemDic) do
    v:RefreshChristmas22TechItem()
  end
  ;
  (self._sideNode):RefreshChristmas22TechSpeicalSide()
  if self._lvNode ~= nil and (self._lvNode).active then
    (self._lvNode):RefreshChristmas22TechLv()
  end
  if self._detailNode ~= nil and (self._detailNode).active then
    (self._detailNode):RefreshChristmas22TechSpecialList()
  end
end

UIChristmas22StrategyOverview.OnClickBg = function(self)
  -- function num : 0_8
  if self._lvNode ~= nil then
    (self._lvNode):Hide()
  end
end

UIChristmas22StrategyOverview.OnClickLvCallback = function(self, techItem, techData)
  -- function num : 0_9 , upvalues : _ENV
  if self._lvNode == nil then
    ((self.ui).techInfoNode):SetActive(true)
    self._lvNode = ((self._techLvClass).New)()
    ;
    (self._lvNode):Init((self.ui).techInfoNode)
    ;
    (self._lvNode):SetChristmas22LogicDesType(self._desType)
  else
    ;
    (self._lvNode):Show()
  end
  ;
  (self._lvNode):InitChristmas22TechLv(techData, self.__OnTechLvCallback)
  local pos = (((self._lvNode).transform).parent):InverseTransformPoint((techItem.transform).position)
  pos.x = pos.x + (self._lvNodePointRang).itemWith + self._lvNodeOffset
  if (self._lvNodePointRang).maxX < pos.x then
    pos.x = pos.x - (self._lvNodePointRang).lvWith - (self._lvNodePointRang).itemWith - self._lvNodeOffset
  end
  pos.x = (math.clamp)(pos.x, (self._lvNodePointRang).minX, (self._lvNodePointRang).maxX)
  pos.y = (math.clamp)(pos.y, (self._lvNodePointRang).minY, (self._lvNodePointRang).maxY)
  -- DECOMPILER ERROR at PC79: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self._lvNode).transform).localPosition = pos
end

UIChristmas22StrategyOverview.__GetLockItem = function(self)
  -- function num : 0_10
  return ((self._lockPool):GetOne()).gameObject
end

UIChristmas22StrategyOverview.__OnTechLv = function(self, techData)
  -- function num : 0_11 , upvalues : _ENV, cs_MessageCommon
  if techData:IsMaxLvel() then
    return 
  end
  local cond, para1, para2 = techData:GetAWTechUnlockParam(techData:GetCurLevel() + 1)
  local isUnlock = (CheckCondition.CheckLua)(cond, para1, para2)
  if not isUnlock then
    (cs_MessageCommon.ShowMessageTips)((CheckCondition.GetUnlockInfoLua)(cond, para1, para2))
    return 
  end
  if (self._data):GetTechBranchLevel() < techData:GetActTechPrfeTotleLevel() then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8716))
    return 
  end
  if not techData:IsLeveUpResEnough() then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(self._itemNoEnoughTip))
  end
  ;
  (self._data):ReqTechUp(techData:GetTechId(), function()
    -- function num : 0_11_0 , upvalues : _ENV, self, techData
    if not IsNull(self.transform) then
      (self._sideNode):AddWaitLookTech(techData)
      self:__RefreshWindow()
    end
  end
)
end

UIChristmas22StrategyOverview.__OnTechReset = function(self)
  -- function num : 0_12 , upvalues : _ENV, cs_MessageCommon
  local techTypeCfg = (ConfigData.activity_tech_type)[(self._data):GetTreeId()]
  for k,v in pairs(techTypeCfg.return_tech_item) do
    if PlayerDataCenter:GetItemCount(k) < v then
      (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(self._resetNoEnoughTip))
      return 
    end
  end
  ;
  (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(8715), function()
    -- function num : 0_12_0 , upvalues : self
    (self._data):ReqTechAllReset(self.__RefreshWindowCallback)
  end
, nil)
end

UIChristmas22StrategyOverview.__OnTechDetail = function(self)
  -- function num : 0_13
  if self._detailNode == nil then
    ((self.ui).windowInfo):SetActive(true)
    self._detailNode = ((self._specialListClass).New)()
    ;
    (self._detailNode):Init((self.ui).windowInfo)
    ;
    (self._detailNode):SetChristmas22LogicDesType(self._desType)
    ;
    (self._detailNode):InitChristmas22TechSpecialList(self._data, self._specialBranchId, self.resloader, self.__OnTechLvCallback)
  else
    ;
    (self._detailNode):Show()
    ;
    (self._detailNode):RefreshChristmas22TechSpecialList()
  end
end

UIChristmas22StrategyOverview.CloseChristmas22StrategyOverview = function(self)
  -- function num : 0_14
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIChristmas22StrategyOverview.OnDelete = function(self)
  -- function num : 0_15 , upvalues : _ENV, base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__ItemUpdateCallback)
  ;
  (base.OnDelete)(self)
end

return UIChristmas22StrategyOverview

