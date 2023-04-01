-- params : ...
-- function num : 0 , upvalues : _ENV
local UICarnival22StrategyOverview = class("UICarnival22StrategyOverview", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
local ActivityCarnivalEnum = require("Game.ActivityCarnival.ActivityCarnivalEnum")
local UINWATechLine = require("Game.ActivitySectorII.Tech.UI.UINWATechLine")
local UINCarnival22TechBranchDetail = require("Game.ActivityCarnival.UI.CarnivalTech.UINCarnival22TechBranchDetail")
local UINCarnival22TechDetail = require("Game.ActivityCarnival.UI.CarnivalTech.UINCarnival22TechDetail")
local UINCarnival22TechItem = require("Game.ActivityCarnival.UI.CarnivalTech.UINCarnival22TechItem")
local UINCarnival22TechTitle = require("Game.ActivityCarnival.UI.CarnivalTech.UINCarnival22TechTitle")
local UINWATechPreviewNode = require("Game.ActivitySectorII.Tech.UI.UINWATechPreviewNode")
local UINCarnival22LineLocked = require("Game.ActivityCarnival.UI.CarnivalTech.UINCarnival22LineLocked")
local UINCarnival22TechItemLocked = require("Game.ActivityCarnival.UI.CarnivalTech.UINCarnival22TechItemLocked")
local UINCarnival22TechFinalBG = require("Game.ActivityCarnival.UI.CarnivalTech.UINCarnival22TechFinalBG")
local Top_INTERNIVAL = 30
local LEFT_INTERNIVAL = 30
local TECH_WIDTH_NOR = 199
local TECH_WIDTH_SPLIT = 209
local TECH_HEIGHT = 249
local TECH_LENGHT_SPLIT = 2
local LockedLineOffsetY = 20
local BGLineOffsetY = 28
UICarnival22StrategyOverview.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_ResLoader, UINCarnival22TechTitle, UINCarnival22TechItem, UINWATechLine, UINCarnival22LineLocked, UINCarnival22TechItemLocked, UINCarnival22TechDetail, UINCarnival22TechBranchDetail, UINWATechPreviewNode
  (UIUtil.SetTopStatus)(self, self.OnClickBack)
  self.resloader = (cs_ResLoader.Create)()
  self._titlePool = (UIItemPool.New)(UINCarnival22TechTitle, (self.ui).titleNode)
  ;
  ((self.ui).titleNode):SetActive(false)
  self._techItemPool = (UIItemPool.New)(UINCarnival22TechItem, (self.ui).techItem)
  ;
  ((self.ui).techItem):SetActive(false)
  self._linePool = (UIItemPool.New)(UINWATechLine, (self.ui).obj_Line)
  ;
  ((self.ui).obj_Line):SetActive(false)
  self._lineLockedPool = (UIItemPool.New)(UINCarnival22LineLocked, (self.ui).obj_Locked)
  ;
  ((self.ui).obj_Locked):SetActive(false)
  self._techItemLockedPool = (UIItemPool.New)(UINCarnival22TechItemLocked, (self.ui).obj_ItemLocked)
  ;
  ((self.ui).obj_ItemLocked):SetActive(false)
  self._detailNode = (UINCarnival22TechDetail.New)()
  ;
  (self._detailNode):Init((self.ui).side)
  ;
  (self._detailNode):InitCarnivalTechDetail(BindCallback(self, self.__OnShowTechEfcDetail), BindCallback(self, self.__OnLevelUpTech))
  self._branchDetailNode = (UINCarnival22TechBranchDetail.New)()
  ;
  (self._branchDetailNode):Init((self.ui).windowInfo)
  self._techEftNode = (UINWATechPreviewNode.New)()
  ;
  (self._techEftNode):Init((self.ui).logicPreviewNode)
  self.__GetTechItemLockedCallback = BindCallback(self, self.__GetTechItemLocked)
  self.__OnLookBranchDetailCallback = BindCallback(self, self.__OnLookBranchDetail)
  self.__OnSelectdTechCallback = BindCallback(self, self.__OnSelectdTech)
  self.__OnResetBranchCallback = BindCallback(self, self.__OnResetBranch)
  self.__RefreshTechStateCallback = BindCallback(self, self.__RefreshTechState)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__RefreshTechStateCallback)
  MsgCenter:AddListener(eMsgEventId.PreCondition, self.__RefreshTechStateCallback)
  self.__RefreshReddotCallback = BindCallback(self, self.__RefreshReddot)
end

UICarnival22StrategyOverview.InitActivityCarnivalTech = function(self, carnivalData)
  -- function num : 0_1 , upvalues : _ENV, ActivityCarnivalEnum
  self._carnivalData = carnivalData
  self._allTechDataDic = (self._carnivalData):GetCarnivalTech()
  self._branchList = {}
  for branchId,_ in pairs(self._allTechDataDic) do
    (table.insert)(self._branchList, branchId)
  end
  ;
  (table.sort)(self._branchList)
  self:__GenBranchTitle()
  self:__InitLineBg()
  local firstTechId = self:__GenTechItem()
  local selectTechItem = (self._techItemDic)[firstTechId]
  self:__OnSelectdTech(selectTechItem)
  self:__InitLockedLine()
  local showItemDic = {}
  for _,itemId in ipairs((carnivalData:GetCarnivalMainCfg()).tech_item) do
    showItemDic[itemId] = true
  end
  local techType = (self._carnivalData):GetCarnivalTechType()
  for _,branchId in ipairs(self._branchList) do
    local branchCfg = ((ConfigData.activity_tech_branch)[techType])[branchId]
    for _,itemId in ipairs(branchCfg.revertCostIds) do
      showItemDic[itemId] = true
    end
  end
  local showIds = {}
  for itemId,_ in pairs(showItemDic) do
    (table.insert)(showIds, itemId)
  end
  ;
  (UIUtil.RefreshTopResId)(showIds)
  if self._autoReddot == nil then
    local reddot = (self._carnivalData):GetActivityReddot()
    if reddot ~= nil then
      self._autoReddot = reddot:AddChild((ActivityCarnivalEnum.eActivityCarnivalReddot).AutoTech)
      self:__RefreshReddot(self._autoReddot)
      RedDotController:AddListener((self._autoReddot).nodePath, self.__RefreshReddotCallback)
    end
  end
end

UICarnival22StrategyOverview.__GenBranchTitle = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (self._titlePool):HideAll()
  for _,branchId in ipairs(self._branchList) do
    local item = (self._titlePool):GetOne()
    item:InitCarnivalTechTitle(self._carnivalData, branchId, self.__OnLookBranchDetailCallback)
  end
end

UICarnival22StrategyOverview.__GenTechItem = function(self)
  -- function num : 0_3 , upvalues : _ENV, TECH_HEIGHT
  local firstTechId = math.maxinteger
  local bottomY = 0
  ;
  (self._techItemPool):HideAll()
  self._techItemDic = {}
  self._techRowDic = {}
  for branchId,branchTechDic in pairs(self._allTechDataDic) do
    local branchIndex = (table.indexof)(self._branchList, branchId)
    for techId,techData in pairs(branchTechDic) do
      if not techData:IsActTechAutoUnlock() then
        if techId < firstTechId then
          firstTechId = techId
        end
        local item = (self._techItemPool):GetOne()
        ;
        (item.transform):SetParent((self.ui).rect)
        -- DECOMPILER ERROR at PC44: Confused about usage of register: R15 in 'UnsetPending'

        ;
        (item.gameObject).name = "tech_" .. tostring(techId)
        item:InitCarnivalTechItem(techData, self.__GetTechItemLockedCallback, self.resloader, self.__OnSelectdTechCallback, branchIndex)
        local pos = self:__CalTechPos(techData.colIndex, techData.rowIndex)
        -- DECOMPILER ERROR at PC57: Confused about usage of register: R16 in 'UnsetPending'

        ;
        (item.transform).anchoredPosition = pos
        -- DECOMPILER ERROR at PC59: Confused about usage of register: R16 in 'UnsetPending'

        ;
        (self._techItemDic)[techId] = item
        if pos.y < bottomY then
          bottomY = pos.y
        end
        -- DECOMPILER ERROR at PC72: Confused about usage of register: R16 in 'UnsetPending'

        if (self._techRowDic)[techData.rowIndex] == nil then
          (self._techRowDic)[techData.rowIndex] = {}
        end
        ;
        (table.insert)((self._techRowDic)[techData.rowIndex], item)
      end
    end
  end
  ;
  (self._linePool):HideAll()
  for techId,techItem in pairs(self._techItemDic) do
    local preId = (techItem:GetCarnivalTechData()):GetPreTechId()
    if preId ~= nil then
      local preItem = (self._techItemDic)[preId]
      if preItem ~= nil then
        local item = (self._linePool):GetOne()
        ;
        (item.transform):SetParent((self.ui).rect)
        item:InitWALineItem(preItem, techItem)
        -- DECOMPILER ERROR at PC123: Confused about usage of register: R11 in 'UnsetPending'

        ;
        (item.gameObject).name = "line_" .. tostring(preId) .. "_" .. tostring(techId)
      end
    end
  end
  local sizeDelta = ((self.ui).rect).sizeDelta
  sizeDelta.y = -bottomY + TECH_HEIGHT
  -- DECOMPILER ERROR at PC135: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).rect).sizeDelta = sizeDelta
  return firstTechId
end

UICarnival22StrategyOverview.__CalTechPos = function(self, col, row)
  -- function num : 0_4 , upvalues : _ENV, TECH_LENGHT_SPLIT, TECH_WIDTH_SPLIT, TECH_WIDTH_NOR, LEFT_INTERNIVAL, TECH_HEIGHT, Top_INTERNIVAL
  row = (self._carnivalData):GetCarnivalTechRow(row)
  local splitCount = (math.floor)(col - 1 / TECH_LENGHT_SPLIT)
  local x = splitCount * TECH_WIDTH_SPLIT + (col - 1 - splitCount) * TECH_WIDTH_NOR + LEFT_INTERNIVAL
  local y = -(row - 1) * TECH_HEIGHT - Top_INTERNIVAL
  return (Vector2.New)(x, y)
end

UICarnival22StrategyOverview.__InitLockedLine = function(self)
  -- function num : 0_5 , upvalues : _ENV, LockedLineOffsetY
  self._lineLockItemDic = {}
  local rowIndexDic = (self._carnivalData):GetCarnivalRowsDic()
  for row,_ in pairs(rowIndexDic) do
    local rowCfg = (ConfigData.activity_tech_line)[row]
    if not (CheckCondition.CheckLua)(rowCfg.pre_condition, rowCfg.pre_para1, rowCfg.pre_para2) then
      local lockDes = (CheckCondition.GetUnlockInfoLua)(rowCfg.pre_condition, rowCfg.pre_para1, rowCfg.pre_para2)
      local item = (self._lineLockedPool):GetOne()
      item:InitCarnival22LineLocked(lockDes)
      ;
      (item.transform):SetParent((self.ui).rect)
      local pos = self:__CalTechPos(1, row)
      pos.x = 0
      pos.y = pos.y + LockedLineOffsetY
      -- DECOMPILER ERROR at PC47: Confused about usage of register: R11 in 'UnsetPending'

      ;
      (item.transform).anchoredPosition = pos
      -- DECOMPILER ERROR at PC49: Confused about usage of register: R11 in 'UnsetPending'

      ;
      (self._lineLockItemDic)[row] = item
    end
  end
  self:__RefreshTechItemLockedAlpha()
end

UICarnival22StrategyOverview.__InitLineBg = function(self)
  -- function num : 0_6 , upvalues : _ENV, BGLineOffsetY, UINCarnival22TechFinalBG
  local rowIndexDic = (self._carnivalData):GetCarnivalRowsDic()
  for row,_ in pairs(rowIndexDic) do
    local rowCfg = (ConfigData.activity_tech_line)[row]
    if #rowCfg.bg_prefab ~= 0 then
      local prefab = (self.resloader):LoadABAsset(PathConsts:GetStrategyOverviewItem(rowCfg.bg_prefab))
      if not IsNull(prefab) then
        local go = prefab:Instantiate((self.ui).rect)
        local pos = self:__CalTechPos(1, row)
        pos.x = 0
        pos.y = pos.y + BGLineOffsetY
        -- DECOMPILER ERROR at PC40: Confused about usage of register: R11 in 'UnsetPending'

        ;
        (go.transform).anchoredPosition = pos
        local item = (UINCarnival22TechFinalBG.New)()
        item:Init(go)
        item:InitTechFinalBG(rowCfg)
      end
    end
  end
end

UICarnival22StrategyOverview.__RefreshLockedLine = function(self)
  -- function num : 0_7 , upvalues : _ENV
  for row,item in pairs(self._lineLockItemDic) do
    local rowCfg = (ConfigData.activity_tech_line)[row]
    if (CheckCondition.CheckLua)(rowCfg.pre_condition, rowCfg.pre_para1, rowCfg.pre_para2) then
      (self._lineLockedPool):HideOne(item)
      -- DECOMPILER ERROR at PC20: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (self._lineLockItemDic)[row] = nil
    end
  end
end

UICarnival22StrategyOverview.__OnLookBranchDetail = function(self, branchId)
  -- function num : 0_8
  (self._branchDetailNode):Show()
  ;
  (self._branchDetailNode):InitBranchDetail(self._carnivalData, branchId, self.__OnResetBranchCallback)
end

UICarnival22StrategyOverview.__OnSelectdTech = function(self, techItem)
  -- function num : 0_9 , upvalues : _ENV
  (((self.ui).obj_OnSelelct).transform):SetParent(techItem.transform)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).obj_OnSelelct).transform).anchoredPosition = Vector2.zero
  ;
  (self._detailNode):SetCarnivalTechData(techItem:GetCarnivalTechData())
end

UICarnival22StrategyOverview.__OnShowTechEfcDetail = function(self, techData)
  -- function num : 0_10
  (self._techEftNode):Show()
  ;
  (self._techEftNode):InitWATechPreview(techData)
end

UICarnival22StrategyOverview.__OnLevelUpTech = function(self, techData)
  -- function num : 0_11 , upvalues : cs_MessageCommon
  local flag, reason = techData:IsCouldLevelUp()
  -- DECOMPILER ERROR at PC8: Unhandled construct in 'MakeBoolean' P1

  if not flag and reason ~= nil then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(reason)
  end
  do return  end
  ;
  (self._carnivalData):UpgradLevelTech(techData, function()
    -- function num : 0_11_0 , upvalues : self, techData
    self:__OnLevelUpSuccess(techData)
  end
)
end

UICarnival22StrategyOverview.__OnLevelUpSuccess = function(self, techData)
  -- function num : 0_12 , upvalues : _ENV
  local techItem = (self._techItemDic)[techData:GetTechId()]
  if techItem == nil then
    return 
  end
  ;
  (((self.ui).fX_LevelUp).transform):SetParent(techItem.transform)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).fX_LevelUp).transform).anchoredPosition = Vector2.zero
  ;
  ((self.ui).fX_LevelUp):SetActive(false)
  ;
  ((self.ui).fX_LevelUp):SetActive(true)
  self:__RefreshTechState()
end

UICarnival22StrategyOverview.__OnResetBranch = function(self, branchId)
  -- function num : 0_13
  (self._carnivalData):ResetLevelTech(branchId, self.__RefreshTechStateCallback)
end

UICarnival22StrategyOverview.__RefreshTechState = function(self)
  -- function num : 0_14 , upvalues : _ENV
  for _,techItem in pairs(self._techItemDic) do
    techItem:RefreshCarnivalTechItem()
  end
  for _,item in ipairs((self._titlePool).listItem) do
    item:RefreshCarnivalTechTitle()
  end
  ;
  (self._detailNode):RefreshCarnivalTechDetail()
  self:__RefreshLockedLine()
  if (self._branchDetailNode).active then
    (self._branchDetailNode):RefreshBranchDetail()
  end
  self:__RefreshTechItemLockedAlpha()
end

UICarnival22StrategyOverview.__GetTechItemLocked = function(self)
  -- function num : 0_15
  return (self._techItemLockedPool):GetOne()
end

UICarnival22StrategyOverview.__RefreshTechItemLockedAlpha = function(self)
  -- function num : 0_16 , upvalues : _ENV
  for k,techItem in pairs(self._techItemDic) do
    local techData = techItem:GetCarnivalTechData()
    local row = techData.rowIndex
    if (self._lineLockItemDic)[row] ~= nil then
      techItem:SetCarnivalTechLockedAlpha((self.ui).alpha_itemLineLocked / 255)
    else
      techItem:SetCarnivalTechLockedAlpha((self.ui).alpha_itemLineUnlock / 255)
    end
  end
end

UICarnival22StrategyOverview.__RefreshReddot = function(self, reddot)
  -- function num : 0_17 , upvalues : _ENV
  for i,branchNode in ipairs((self._titlePool).listItem) do
    local branchId = branchNode:GetCarnivalBranchId()
    local reddotChild = reddot:GetChild(branchId)
    branchNode:SetCarnivalBranchReddot(reddotChild ~= nil and reddotChild:GetRedDotCount() > 0)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UICarnival22StrategyOverview.OnClickBack = function(self)
  -- function num : 0_18
  self:Delete()
end

UICarnival22StrategyOverview.OnDelete = function(self)
  -- function num : 0_19 , upvalues : base, _ENV
  (base.OnDelete)(self)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__RefreshTechStateCallback)
  MsgCenter:RemoveListener(eMsgEventId.PreCondition, self.__RefreshTechStateCallback)
  if self._autoReddot ~= nil then
    RedDotController:RemoveListener((self._autoReddot).nodePath, self.__RefreshReddotCallback)
  end
end

return UICarnival22StrategyOverview

