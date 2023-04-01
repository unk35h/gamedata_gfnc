-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSectorInfoNormal = class("UINSectorInfoNormal", UIBaseNode)
local base = UIBaseNode
local UINLevelDifficultItem = require("Game.Sector.SectorLevel.UINLevelDifficultItem")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
UINSectorInfoNormal.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINLevelDifficultItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__OnClickDiffCallback = BindCallback(self, self.__OnClickDiff)
  self.__OnSelectDiffCallback = BindCallback(self, self.__OnSelectDiff)
  self.__RefreshTaskRedNodeCallback = BindCallback(self, self.RefreshTaskRedNode)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SectorTask, self, self.OnClickTask)
  self.poolDifficultItem = (UIItemPool.New)(UINLevelDifficultItem, (self.ui).btn_Difficult)
  self.difficultBtn = (UINLevelDifficultItem.New)()
  ;
  (self.difficultBtn):Init((self.ui).btn_Difficult)
  ;
  (self.difficultBtn):BindLevelDiffItemCallback(self.__OnClickDiffCallback)
  RedDotController:AddListener(RedDotDynPath.SectorItemTaskBtnPath, self.__RefreshTaskRedNodeCallback)
end

UINSectorInfoNormal.UpdateSectorInfoNormal = function(self, sectorCfg, defaultDiff, selectDiffFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._sectorCfg = sectorCfg
  self._curDiff = defaultDiff
  self._sectorId = (self._sectorCfg).id
  self._selectDiffFunc = selectDiffFunc
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_SectorName).text = (LanguageUtil.GetLocaleText)((self._sectorCfg).name)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_SectorNameEn).text = (LanguageUtil.GetLocaleText)((self._sectorCfg).name_en)
  self:RefreshDiffBtnState()
  self:RefreshTaskState()
end

UINSectorInfoNormal.RefreshDiffBtnState = function(self)
  -- function num : 0_2 , upvalues : _ENV, ExplorationEnum
  (self.difficultBtn):RefreshLevelDiffItem(self._sectorId, self._curDiff)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_Arrow).color = (self.difficultBtn):GetDifficultyColor()
  ;
  (self.poolDifficultItem):HideAll()
  local isHardUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Hard)
  for i = 1, (ConfigData.sector_stage).difficultyCount do
    if self._curDiff ~= i and (i ~= (ExplorationEnum.eDifficultType).Hard or isHardUnlock) then
      local diffItem = (self.poolDifficultItem):GetOne()
      ;
      (diffItem.transform):SetParent(((self.ui).diffcultListHolder).transform)
      diffItem:InitLevelDiffItem(self._sectorId, i, self.__OnSelectDiffCallback)
    end
  end
  local isInfinityUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Endless)
  do
    if isInfinityUnlock and self._curDiff ~= (ConfigData.sector_stage).difficultyCount + 1 then
      local diffItem = (self.poolDifficultItem):GetOne()
      ;
      (diffItem.transform):SetParent(((self.ui).diffcultListHolder).transform)
      diffItem:InitLevelDiffItem(self._sectorId, (ConfigData.sector_stage).difficultyCount + 1, self.__OnSelectDiffCallback)
    end
    ;
    ((self.ui).diffcultListHolder):SetActive(false)
  end
end

UINSectorInfoNormal.RefreshTaskState = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local isUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_SectorTask)
  ;
  (((self.ui).btn_SectorTask).gameObject):SetActive(isUnlock)
  if not isUnlock then
    return 
  end
  local sectorTaskCtrl = ControllerManager:GetController(ControllerTypeId.SectorTaskCtrl, true)
  local starId, starCount, _ = sectorTaskCtrl:GetSectorAchievementScore(self._sectorId)
  local starTotalCount = sectorTaskCtrl:GetSectorTaskTotalCount(starId, self._sectorId)
  if starCount <= 9 then
    ((self.ui).tex_CompleteNum):SetIndex(0, "0", tostring(starCount))
  else
    ;
    ((self.ui).tex_CompleteNum):SetIndex(0, "", tostring(starCount))
  end
  if starTotalCount <= 9 then
    ((self.ui).tex_TotalNum):SetIndex(0, "0", tostring(starTotalCount))
  else
    ;
    ((self.ui).tex_TotalNum):SetIndex(0, "", tostring(starTotalCount))
  end
end

UINSectorInfoNormal.RefreshTaskRedNode = function(self, node)
  -- function num : 0_4
  if node:GetRedDotCount() <= 0 then
    ((self.ui).redDot_Task):SetActive(node:GetParentNodeId() ~= self.__sectorId)
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UINSectorInfoNormal.OnClickTask = function(self)
  -- function num : 0_5 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.SectorTask, function(window)
    -- function num : 0_5_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitSectorTask(self._sectorId)
  end
)
end

UINSectorInfoNormal.__OnClickDiff = function(self)
  -- function num : 0_6 , upvalues : SectorStageDetailHelper, _ENV
  local playMoudle = (SectorStageDetailHelper.SectorPlayMoudle)(self._sectorId)
  if (SectorStageDetailHelper.TryGetUncompletedStateCfg)(playMoudle) ~= nil then
    (SectorStageDetailHelper.TryToShowCurrentLevelTips)(playMoudle)
    return 
  end
  if #(self.poolDifficultItem).listItem == 0 then
    return 
  end
  local isOpenOperation = not ((self.ui).diffcultListHolder).activeSelf
  ;
  ((self.ui).diffcultListHolder):SetActive(isOpenOperation)
  if not self._arrowVec then
    self._arrowVec = (Vector3.New)(1, 1, 1)
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._arrowVec).y = isOpenOperation and 1 or -1
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).img_Arrow).transform).localScale = self._arrowVec
  end
end

UINSectorInfoNormal.__OnSelectDiff = function(self, diff)
  -- function num : 0_7
  if diff == self._curDiff or self._selectDiffFunc == nil or not (self._selectDiffFunc)(diff) then
    return 
  end
  self._curDiff = diff
  self:RefreshDiffBtnState()
end

UINSectorInfoNormal.HideDiffSelect = function(self)
  -- function num : 0_8
  (self.difficultBtn):Hide()
end

UINSectorInfoNormal.OnDelete = function(self)
  -- function num : 0_9 , upvalues : _ENV, base
  RedDotController:RemoveListener(RedDotDynPath.SectorItemTaskBtnPath, self.__RefreshTaskRedNodeCallback)
  ;
  (base.OnDelete)(self)
end

return UINSectorInfoNormal

