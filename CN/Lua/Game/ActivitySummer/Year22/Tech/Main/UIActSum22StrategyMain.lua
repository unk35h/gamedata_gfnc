-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIActSum22StrategyMain = class("UIActSum22StrategyMain", base)
local UINActSum22StrategyTreeItem = require("Game.ActivitySummer.Year22.Tech.UINActSum22StrategyTreeItem")
local UINActSum22StgMainTitleItem = require("Game.ActivitySummer.Year22.Tech.Main.UINActSum22StgMainTitleItem")
local UINActSum22StgMainBranchItem = require("Game.ActivitySummer.Year22.Tech.Main.UINActSum22StgMainBranchItem")
local UINActSum22TechInfo = require("Game.ActivitySummer.Year22.Tech.UINActSum22TechInfo")
local UINActSum22TechEffectItem = require("Game.ActivitySummer.Year22.Tech.UINActSum22TechEffectItem")
local UINActSum22BuffItem = require("Game.ActivitySummer.Year22.Tech.Main.UINActSum22BuffItem")
local CommonLogicUtil = require("Game.Common.CommonLogicUtil.CommonLogicUtil")
local ActivitySectorIIIEnum = require("Game.ActivitySectorIII.ActivitySectorIIIEnum")
local cs_ResLoader = CS.ResLoader
UIActSum22StrategyMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV, UINActSum22TechInfo, UINActSum22StrategyTreeItem, UINActSum22StgMainTitleItem, UINActSum22StgMainBranchItem, UINActSum22TechEffectItem, UINActSum22BuffItem
  self._resloder = (cs_ResLoader.Create)()
  ;
  (UIUtil.SetTopStatus)(self, self._OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Tree, self, self._OnClickTree)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Select, self, self._OnClickSelect)
  self._techInfoNode = (UINActSum22TechInfo.New)()
  ;
  (self._techInfoNode):Init((self.ui).techInfoNode)
  ;
  (self._techInfoNode):SetActSum22TechInfoHideFnc(function()
    -- function num : 0_0_0 , upvalues : self
    (((self.ui).tran_Select).gameObject):SetActive(false)
  end
)
  ;
  (self._techInfoNode):Hide()
  self._OnClickTechItemFunc = BindCallback(self, self._OnClickTechItem)
  self._techItemPool = (UIItemPool.New)(UINActSum22StrategyTreeItem, (self.ui).techItem, false)
  self._branchTitleItemPool = (UIItemPool.New)(UINActSum22StgMainTitleItem, (self.ui).titleItem, false)
  self._branchItemPool = (UIItemPool.New)(UINActSum22StgMainBranchItem, (self.ui).brachItem, false)
  self._effectNewItemPool = (UIItemPool.New)(UINActSum22TechEffectItem, (self.ui).effect_New, false)
  self._effectLvUpItemPool = (UIItemPool.New)(UINActSum22TechEffectItem, (self.ui).effect_LvUp, false)
  self._buffItemPool = (UIItemPool.New)(UINActSum22BuffItem, (self.ui).infoItem, false)
  self._techEmptyPool = (UIItemPool.New)(UIBaseNode, (self.ui).techEmpty, false)
end

UIActSum22StrategyMain.InitActSum22StrategyMain = function(self, sum22Data)
  -- function num : 0_1 , upvalues : ActivitySectorIIIEnum, _ENV
  self._sum22Data = sum22Data
  local actReddot = (self._sum22Data):GetActivityReddot()
  if actReddot ~= nil then
    self._techReddot = actReddot:GetChild((ActivitySectorIIIEnum.eActRedDotTypeId).tech)
    self._UpdTechRedDotFunc = BindCallback(self, self._UpdTechRedDot)
    self:_UpdTechRedDot(self._techReddot)
    RedDotController:AddListener((self._techReddot).nodePath, self._UpdTechRedDotFunc)
  end
  local techType = sum22Data:GetActSct3TechType()
  self:_InitActBranch(techType)
  local techList = sum22Data:GenSectorIIITechList()
  self._techList = techList
  if #techList > 100 then
    error("SectorIIITechList num is more than 100")
  end
  ;
  (table.sort)(techList, function(a, b)
    -- function num : 0_1_0
    do return a.techId < b.techId end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  local branchDataDic = {}
  self._branchDataDic = branchDataDic
  local branchTechNumDic = (table.GetDefaulValueTable)(0)
  local branchMaxNum = 0
  local totalLv = 0
  self._techItemDic = {}
  self:_ResetParaLogic()
  for id,techData in ipairs(techList) do
    local techItem = (self._techItemPool):GetOne()
    techItem:InitActSum22StrategyItem(techData, self._resloder, self._OnClickTechItemFunc)
    -- DECOMPILER ERROR at PC71: Confused about usage of register: R15 in 'UnsetPending'

    ;
    (self._techItemDic)[techData:GetTechId()] = techItem
    local branchId = techData:GetActTechBranch()
    local branchItem = self:_GetBranchItem(branchId)
    ;
    (techItem.transform):SetParent(branchItem.transform)
    if not branchDataDic[branchId] then
      branchDataDic[branchId] = {}
      -- DECOMPILER ERROR at PC87: Confused about usage of register: R17 in 'UnsetPending'

      ;
      (branchDataDic[branchId])[id] = techData
      branchTechNumDic[branchId] = branchTechNumDic[branchId] + 1
      branchMaxNum = (math.max)(branchMaxNum, branchTechNumDic[branchId])
      do
        local curLv = techData:GetCurLevel()
        if curLv == 0 then
          techItem:Hide()
        else
          self:_MergeLogic(techData)
        end
        totalLv = totalLv + techData:GetCurLevel()
        -- DECOMPILER ERROR at PC110: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC110: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  self._branchMaxEmptyNum = branchMaxNum % 2 + branchMaxNum
  ;
  ((self.ui).tex_Number):SetIndex(0, tostring(totalLv))
  self:_UpdBranchTitle()
  self:_UpdBuffList()
  ;
  ((self.ui).animation):Play()
  self:_UpdSelectButton()
  GuideManager:TryTriggerGuide(eGuideCondition.ActSum22Strategy)
end

UIActSum22StrategyMain._InitActBranch = function(self, techType)
  -- function num : 0_2 , upvalues : _ENV
  local branchList = ((ConfigData.activity_tech_branch).techBranchTypeList)[techType]
  self.branchTitleDic = {}
  self.branchItemDic = {}
  for k,branchId in ipairs(branchList) do
    local branchCfg = ((ConfigData.activity_tech_branch)[techType])[branchId]
    local titleItem = (self._branchTitleItemPool):GetOne()
    titleItem:InitActSum22StgMainTitleItem(branchCfg)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.branchTitleDic)[branchId] = titleItem
    local branchItem = (self._branchItemPool):GetOne()
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.branchItemDic)[branchId] = branchItem
  end
end

UIActSum22StrategyMain._ResetParaLogic = function(self)
  -- function num : 0_3
  self._logicDic = {}
end

UIActSum22StrategyMain._MergeLogic = function(self, techData)
  -- function num : 0_4 , upvalues : _ENV, CommonLogicUtil
  local curLv = techData:GetCurLevel()
  local logicArray, para1Array, para2Array, para3Array = techData:GetTechLogic(curLv)
  for k,logic in ipairs(logicArray) do
    local para1, para2, para3 = para1Array[k], para2Array[k], para3Array[k]
    ;
    (CommonLogicUtil.MergeLogic)(self._logicDic, logic, {para1, para2, para3})
  end
end

UIActSum22StrategyMain._UpdBuffList = function(self)
  -- function num : 0_5 , upvalues : _ENV, CommonLogicUtil
  local tech_des_sort_list = (self._sum22Data):GetSum22TechDesSrotList()
  ;
  (self._buffItemPool):HideAll()
  for k,logic in ipairs(tech_des_sort_list) do
    local paraTab = (self._logicDic)[logic]
    if paraTab ~= nil then
      local para1Array = paraTab[1]
      local para2Array = paraTab[2]
      local para3Array = paraTab[3]
      for k,para1 in ipairs(para1Array) do
        local para2 = para2Array and para2Array[k] or nil
        local para3 = para3Array and para3Array[k] or nil
        local longDes, shortDes, valueDes = (CommonLogicUtil.GetDesString)(logic, para1, para2, para3, eLogicDesType.Warchess)
        local buffItem = (self._buffItemPool):GetOne()
        buffItem:InitActSum22BuffItem(longDes)
      end
    end
  end
end

UIActSum22StrategyMain._UpdBranchTitle = function(self)
  -- function num : 0_6 , upvalues : _ENV
  (self._techEmptyPool):HideAll()
  for branchId,techDataDic in pairs(self._branchDataDic) do
    local titleItem = (self.branchTitleDic)[branchId]
    if titleItem ~= nil then
      local curNum, maxNum = 0, 0
      for techId,techData in pairs(techDataDic) do
        if techData:GetCurLevel() > 0 then
          curNum = curNum + 1
        end
        maxNum = maxNum + 1
      end
      titleItem:SetActSum22StgMainTitleItemNum(curNum, maxNum)
      for i = curNum + 1, self._branchMaxEmptyNum do
        local branchItem = self:_GetBranchItem(branchId)
        local temptyItem = (self._techEmptyPool):GetOne()
        ;
        (temptyItem.transform):SetParent(branchItem.transform)
      end
    end
  end
end

UIActSum22StrategyMain._GetBranchItem = function(self, branchId)
  -- function num : 0_7
  return (self.branchItemDic)[branchId]
end

UIActSum22StrategyMain._OnClickTechItem = function(self, techItem, techData)
  -- function num : 0_8 , upvalues : _ENV
  (((self.ui).tran_Select).gameObject):SetActive(true)
  ;
  ((self.ui).tran_Select):SetParent(techItem.transform)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tran_Select).anchoredPosition = Vector2.zero
  ;
  (self._techInfoNode):Show()
  ;
  (self._techInfoNode):InitActSum22TechInfo(techData, techItem.transform)
end

UIActSum22StrategyMain._OnClickTree = function(self)
  -- function num : 0_9 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ActSum22StrategyTree, function(win)
    -- function num : 0_9_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitActSum22TechTree(self._sum22Data, function()
      -- function num : 0_9_0_0 , upvalues : self
      ((self.ui).animation):Play()
      self:_ResetItemState()
    end
)
  end
)
end

UIActSum22StrategyMain._UpdTechRedDot = function(self, node)
  -- function num : 0_10
  ((self.ui).selectBlueDot):SetActive(node:GetRedDotCount() > 0)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIActSum22StrategyMain._OnClickSelect = function(self)
  -- function num : 0_11 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ActSum22StrategySelect, function(win)
    -- function num : 0_11_0 , upvalues : self, _ENV
    if win == nil then
      return 
    end
    win:InitTechSelect(self._sum22Data, function(newTechIdDic, lvUpTechIdDic)
      -- function num : 0_11_0_0 , upvalues : self, _ENV
      ((self.ui).animation):Play()
      self:_UpdSelectButton()
      self:_ResetItemState()
      self._lastStateTechIdDic = {}
      for techId,_ in pairs(newTechIdDic) do
        self:_UpdTechItemAfterSelect(techId, true)
      end
      for techId,_ in pairs(lvUpTechIdDic) do
        self:_UpdTechItemAfterSelect(techId, false)
      end
    end
)
  end
)
end

UIActSum22StrategyMain._UpdTechItemAfterSelect = function(self, techId, isNew)
  -- function num : 0_12 , upvalues : _ENV
  local techItem = (self._techItemDic)[techId]
  techItem:Show()
  if isNew then
    techItem:SetActSum22TechItemNew(true)
    local effectNew = (self._effectNewItemPool):GetOne()
    ;
    (effectNew.transform):SetParent(techItem.transform)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (effectNew.transform).anchoredPosition = Vector2.zero
  else
    do
      techItem:SetActSum22TechItemLvUp(true)
      do
        local effect = (self._effectLvUpItemPool):GetOne()
        ;
        (effect.transform):SetParent(techItem.transform)
        -- DECOMPILER ERROR at PC34: Confused about usage of register: R5 in 'UnsetPending'

        ;
        (effect.transform).anchoredPosition = Vector2.zero
        techItem:UpdActSum22TechItem()
        -- DECOMPILER ERROR at PC38: Confused about usage of register: R4 in 'UnsetPending'

        ;
        (self._lastStateTechIdDic)[techId] = true
        self:_ResetParaLogic()
        local totalLv = 0
        for id,techData in ipairs(self._techList) do
          local level = techData:GetCurLevel()
          totalLv = totalLv + level
          if level > 0 then
            self:_MergeLogic(techData)
          end
        end
        ;
        ((self.ui).tex_Number):SetIndex(0, tostring(totalLv))
        self:_UpdBranchTitle()
        self:_UpdBuffList()
      end
    end
  end
end

UIActSum22StrategyMain._UpdSelectButton = function(self)
  -- function num : 0_13
  local selectIdList = (self._sum22Data):GetActSum22TechSelectIdList()
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  if #selectIdList == 0 then
    ((self.ui).btn_Select).interactable = false
  end
end

UIActSum22StrategyMain._ResetItemState = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if self._lastStateTechIdDic == nil then
    return 
  end
  ;
  (self._effectNewItemPool):HideAll()
  ;
  (self._effectLvUpItemPool):HideAll()
  for techId,_ in pairs(self._lastStateTechIdDic) do
    local techItem = (self._techItemDic)[techId]
    techItem:SetActSum22TechItemLvUp(false)
    techItem:SetActSum22TechItemNew(false)
  end
  self._lastStateTechIdDic = nil
end

UIActSum22StrategyMain._OnClickClose = function(self)
  -- function num : 0_15
  self:Delete()
end

UIActSum22StrategyMain.OnDelete = function(self)
  -- function num : 0_16 , upvalues : _ENV, base
  if self._techReddot ~= nil ~= nil then
    RedDotController:RemoveListener((self._techReddot).nodePath, self._UpdTechRedDotFunc)
  end
  ;
  (self._techItemPool):DeleteAll()
  if self._resloder ~= nil then
    (self._resloder):Put2Pool()
    self._resloder = nil
  end
  ;
  (self._techInfoNode):OnDelete()
  ;
  (base.OnDelete)(self)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

return UIActSum22StrategyMain

