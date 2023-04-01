-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmas22TechSpeicalSide = class("UINChristmas22TechSpeicalSide", UIBaseNode)
local base = UIBaseNode
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local UINChristmasBuffItem = require("Game.ActivityChristmas.UI.Tech.UINChristmasBuffItem")
local CommonLogicUtil = require("Game.Common.CommonLogicUtil.CommonLogicUtil")
UINChristmas22TechSpeicalSide.ePageEnum = {strategyInfoNode = 1, buffList = 2}
UINChristmas22TechSpeicalSide.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINChristmasBuffItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Refresh, self, self.OnClickReset)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Check, self, self.OnClickDetail)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Clear, self, self.OnClickLv)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_lock, self, self.OnClickLv)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BuffView, self, self.OnClickBuff)
  self._buffItemPool = (UIItemPool.New)(UINChristmasBuffItem, (self.ui).infoItem)
  ;
  ((self.ui).infoItem):SetActive(false)
end

UINChristmas22TechSpeicalSide.InitChristmas22TechSpeicalSide = function(self, actTechTree, specialBranchId, resloader)
  -- function num : 0_1
  self._data = actTechTree
  self._branchId = specialBranchId
  self._resloader = resloader
  self:__SetUIPageState((self.ePageEnum).strategyInfoNode)
  self:RefreshChristmas22TechSpeicalSide()
end

UINChristmas22TechSpeicalSide.__SetUIPageState = function(self, pageEnumId)
  -- function num : 0_2 , upvalues : _ENV
  if self._curShowPage == (self.ePageEnum).buffList then
    for i,v in ipairs((self._buffItemPool).listItem) do
      v:SetBuffItemNew(false)
    end
  end
  do
    self._curShowPage = pageEnumId
    ;
    ((self.ui).buffList):SetActive(pageEnumId == (self.ePageEnum).buffList)
    ;
    ((self.ui).strategyInfoNode):SetActive(pageEnumId == (self.ePageEnum).strategyInfoNode)
    ;
    ((self.ui).arrowUp):SetActive(pageEnumId == (self.ePageEnum).strategyInfoNode)
    ;
    ((self.ui).arrowDown):SetActive(pageEnumId == (self.ePageEnum).buffList)
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
end

UINChristmas22TechSpeicalSide.SetChristmas22LogicDesType = function(self, desType)
  -- function num : 0_3
  self._desType = desType
end

UINChristmas22TechSpeicalSide.BindChrismas22TechSpeicalSide = function(self, lvCallback, resetCallback, detailCallback)
  -- function num : 0_4
  self._lvCallback = lvCallback
  self._resetCallback = resetCallback
  self._detailCallback = detailCallback
end

UINChristmas22TechSpeicalSide.RefreshChristmas22TechSpeicalSide = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self._needRefreshInfoNode = true
  self._needRefreshBuffNode = true
  local level = (self._data):GetTechBranchLevel(0)
  ;
  ((self.ui).tex_StrategyLvl):SetIndex(0, tostring(level))
  ;
  (((self.ui).btn_Refresh).gameObject):SetActive(level > 0)
  if self._curShowPage == (self.ePageEnum).buffList then
    self:RefreshTechSpeicalSideBuffList()
  else
    self:RefreshTechSpeicalSideInfoNode()
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINChristmas22TechSpeicalSide.AddWaitLookTech = function(self, techData)
  -- function num : 0_6
  if self._waitShowBuffTech == nil then
    self._waitShowBuffTech = {}
  end
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._waitShowBuffTech)[techData.techId] = true
end

UINChristmas22TechSpeicalSide.RefreshTechSpeicalSideInfoNode = function(self)
  -- function num : 0_7 , upvalues : _ENV
  self._needRefreshInfoNode = false
  local nextTechData = nil
  self._curTechData = nil
  local techDic = (self._data):GetTechDataDic()
  local branchTechDic = techDic[self._branchId]
  if branchTechDic == nil then
    if isGameDev then
      error(" branch tech is nil ")
    end
    return 
  end
  local lastTech = nil
  for k,techData in pairs(branchTechDic) do
    if techData:GetRearTechData() == nil then
      lastTech = techData
    end
    if not techData:GetIsUnlock() then
      local preTechData = techData:GetPreTechData()
      if preTechData ~= nil then
        if preTechData:GetIsUnlock() then
          nextTechData = techData
          break
        end
        if preTechData:GetPreTechData() == nil then
          nextTechData = techData
          break
        end
      end
    end
  end
  do
    if nextTechData ~= nil then
      self._curTechData = nextTechData:GetPreTechData()
    else
      if lastTech:GetCurLevel() == 0 then
        self._curTechData = lastTech
      end
    end
    if self._curTechData ~= nil and (self._curTechData):IsMaxLvel() then
      self._curTechData = nextTechData
    end
    if self._curTechData == nil then
      ((self.ui).tex_Exp):SetIndex(0)
      ;
      ((self.ui).upgrade):SetActive(false)
      ;
      ((self.ui).max):SetActive(true)
      return 
    end
    ;
    ((self.ui).upgrade):SetActive(true)
    ;
    ((self.ui).max):SetActive(false)
    ;
    ((self.ui).tex_Exp):SetIndex(1, tostring((self._curTechData):GetActTechPrfeTotleLevel()))
    ;
    (self._resloader):LoadABAssetAsync(PathConsts:GetAtlasAssetPath("SectorBuilding"), function(spriteAtlas)
    -- function num : 0_7_0 , upvalues : _ENV, self
    if spriteAtlas == nil or IsNull(self.transform) then
      return 
    end
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_StrategyIcon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, (self._curTechData):GetWATechIcon())
  end
)
    -- DECOMPILER ERROR at PC121: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_BuffName).text = (self._curTechData):GetAWTechName()
    -- DECOMPILER ERROR at PC129: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Des).text = (self._curTechData):GetTechDescription(nil, self._desType)
    local isUnlock = (self._curTechData):GetIsUnlock()
    ;
    ((self.ui).lock):SetActive(not isUnlock)
    if isUnlock then
      (((self.ui).btn_Clear).gameObject):SetActive(not (self._curTechData):IsMaxLvel())
      ;
      ((self.ui).redDot):SetActive((self._curTechData):IsCouldLevelUp())
    end
  end
end

UINChristmas22TechSpeicalSide.RefreshTechSpeicalSideBuffList = function(self)
  -- function num : 0_8 , upvalues : _ENV, CommonLogicUtil
  self._needRefreshBuffNode = false
  ;
  (self._buffItemPool):HideAll()
  local techDic = (self._data):GetTechDataDic()
  local branchTechDic = techDic[self._branchId]
  if branchTechDic == nil then
    if isGameDev then
      error(" branch tech is nil ")
    end
    return 
  end
  local logicDic = {}
  local updateLogicDic = {}
  for _,branchTechDic in pairs(techDic) do
    for k,techData in pairs(branchTechDic) do
      local level = techData:GetCurLevel()
      local isUpDate = self._waitShowBuffTech ~= nil and (self._waitShowBuffTech)[techData.techId] ~= nil
      if level > 0 then
        local logicArray, para1Array, para2Array, para3Array = techData:GetTechLogic(level)
        for k,logic in ipairs(logicArray) do
          local para1, para2, para3 = para1Array[k], para2Array[k], para3Array[k]
          ;
          (CommonLogicUtil.MergeLogic)(logicDic, logic, {para1, para2, para3})
          if isUpDate then
            if not updateLogicDic[logic] then
              local curAddTable = {}
            end
            updateLogicDic[logic] = curAddTable
            local mergeInfo, MergeType = (CommonLogicUtil.GetMergeInfoTable)(logic)
            if para3 ~= nil and (mergeInfo == nil or mergeInfo[3] == MergeType.equal) then
              if not curAddTable[para1] then
                curAddTable[para1] = {}
                -- DECOMPILER ERROR at PC90: Confused about usage of register: R32 in 'UnsetPending'

                if not (curAddTable[para1])[para2] then
                  (curAddTable[para1])[para2] = {}
                  -- DECOMPILER ERROR at PC93: Confused about usage of register: R32 in 'UnsetPending'

                  ;
                  ((curAddTable[para1])[para2])[para3] = true
                  if para2 ~= nil and (mergeInfo == nil or mergeInfo[2] == MergeType.equal) then
                    if not curAddTable[para1] then
                      do
                        curAddTable[para1] = {}
                        -- DECOMPILER ERROR at PC109: Confused about usage of register: R32 in 'UnsetPending'

                        ;
                        (curAddTable[para1])[para2] = true
                        if para1 ~= nil and (mergeInfo == nil or mergeInfo[1] == MergeType.equal) then
                          curAddTable[para1] = true
                        end
                        -- DECOMPILER ERROR at PC120: LeaveBlock: unexpected jumping out IF_THEN_STMT

                        -- DECOMPILER ERROR at PC120: LeaveBlock: unexpected jumping out IF_STMT

                        -- DECOMPILER ERROR at PC120: LeaveBlock: unexpected jumping out IF_THEN_STMT

                        -- DECOMPILER ERROR at PC120: LeaveBlock: unexpected jumping out IF_STMT

                        -- DECOMPILER ERROR at PC120: LeaveBlock: unexpected jumping out IF_THEN_STMT

                        -- DECOMPILER ERROR at PC120: LeaveBlock: unexpected jumping out IF_STMT

                        -- DECOMPILER ERROR at PC120: LeaveBlock: unexpected jumping out IF_THEN_STMT

                        -- DECOMPILER ERROR at PC120: LeaveBlock: unexpected jumping out IF_STMT

                        -- DECOMPILER ERROR at PC120: LeaveBlock: unexpected jumping out IF_THEN_STMT

                        -- DECOMPILER ERROR at PC120: LeaveBlock: unexpected jumping out IF_STMT

                        -- DECOMPILER ERROR at PC120: LeaveBlock: unexpected jumping out IF_THEN_STMT

                        -- DECOMPILER ERROR at PC120: LeaveBlock: unexpected jumping out IF_STMT

                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  for logic,paraTab in pairs(logicDic) do
    local para1Array = paraTab[1]
    local para2Array = paraTab[2]
    local para3Array = paraTab[3]
    for k,para1 in ipairs(para1Array) do
      local para2 = para2Array and para2Array[k] or nil
      local para3 = para3Array and para3Array[k] or nil
      local longDes, shortDes, valueDes = (CommonLogicUtil.GetDesString)(logic, para1, para2, para3, self._desType)
      local buffItem = (self._buffItemPool):GetOne()
      buffItem:InitActSum22BuffItem(longDes)
      local curCheckTable = updateLogicDic[logic]
      local changed = curCheckTable ~= nil
      local mergeInfo, MergeType = (CommonLogicUtil.GetMergeInfoTable)(logic)
      if changed and para1 ~= nil and (mergeInfo == nil or mergeInfo[1] == MergeType.equal) then
        curCheckTable = curCheckTable[para1]
        changed = curCheckTable ~= nil
      end
      if changed and para2 ~= nil and (mergeInfo == nil or mergeInfo[2] == MergeType.equal) then
        curCheckTable = curCheckTable[para2]
        changed = curCheckTable ~= nil
      end
      if changed and para3 ~= nil and (mergeInfo == nil or mergeInfo[3] == MergeType.equal) then
        curCheckTable = curCheckTable[para3]
        changed = curCheckTable ~= nil
      end
      buffItem:SetBuffItemNew(changed)
    end
  end
  if self._waitShowBuffTech ~= nil then
    (table.clearmap)(self._waitShowBuffTech)
  end
  -- DECOMPILER ERROR: 30 unprocessed JMP targets
end

UINChristmas22TechSpeicalSide.OnClickReset = function(self)
  -- function num : 0_9
  if self._resetCallback then
    (self._resetCallback)()
  end
end

UINChristmas22TechSpeicalSide.OnClickLv = function(self)
  -- function num : 0_10
  if self._lvCallback then
    (self._lvCallback)(self._curTechData)
  end
end

UINChristmas22TechSpeicalSide.OnClickBuff = function(self)
  -- function num : 0_11
  if self._curShowPage == (self.ePageEnum).buffList then
    self:__SetUIPageState((self.ePageEnum).strategyInfoNode)
    if self._needRefreshInfoNode then
      self:RefreshTechSpeicalSideInfoNode()
    end
  else
    self:__SetUIPageState((self.ePageEnum).buffList)
    if self._needRefreshBuffNode then
      self:RefreshTechSpeicalSideBuffList()
    end
  end
end

UINChristmas22TechSpeicalSide.OnClickDetail = function(self)
  -- function num : 0_12
  if self._detailCallback then
    (self._detailCallback)()
  end
end

return UINChristmas22TechSpeicalSide

