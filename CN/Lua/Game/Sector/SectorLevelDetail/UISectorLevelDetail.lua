-- params : ...
-- function num : 0 , upvalues : _ENV
local UISectorLevelDetail = class("UISectorLevelDetail", UIBaseWindow)
local base = UIBaseWindow
local UINLevelDetail = require("Game.Sector.SectorLevelDetail.UINLevelDtail")
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
local cs_MessageCommon = CS.MessageCommon
UISectorLevelDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINLevelDetail
  (UIUtil.AddButtonListener)((self.ui).btn_Close, nil, UIUtil.OnClickBack)
  self.resloader = ((CS.ResLoader).Create)()
  self.levelDetailNode = (UINLevelDetail.New)()
  ;
  (self.levelDetailNode):Init((self.ui).detailNode)
  ;
  (self.levelDetailNode):InitLevelDtail(self.resloader)
  self.isPushBack2Stack = false
  ;
  (((self.ui).tex_Tips).gameObject):SetActive(false)
end

UISectorLevelDetail.InitSectorLevelDetail = function(self, sectorId, sectorStageId, isLocked)
  -- function num : 0_1 , upvalues : _ENV, SectorLevelDetailEnum
  local stageCfg = (ConfigData.sector_stage)[sectorStageId]
  if stageCfg == nil then
    error("Can\'t find sector stageCfg, stageId = " .. tostring(sectorStageId))
    return 
  end
  local sectorCfg = (ConfigData.sector)[stageCfg.sector]
  if sectorCfg.sector_type == (SectorLevelDetailEnum.eSectorType).WarChess then
    self:__InitWarchessDetailNode(sectorId, stageCfg, isLocked)
  else
    if stageCfg.is_warchess then
      self:__InitWarchessDetailNode(sectorId, stageCfg, isLocked)
    else
      self:__InitNormalDetailNode(sectorId, stageCfg, isLocked)
    end
  end
end

UISectorLevelDetail.InitSectorLevelAvgDetail = function(self, sectorId, avgCfg, playAvgCompleteFunc, isLocked)
  -- function num : 0_2 , upvalues : _ENV, SectorLevelDetailEnum
  self:CleanLastDetail()
  if self.isPushBack2Stack then
    (UIUtil.PopFromBackStack)()
  end
  ;
  (UIUtil.SetTopStatus)(self, self.OnClickSectorLevelDetailBackBtn, {ConstGlobalItem.SKey})
  self.isPushBack2Stack = true
  self:GetBackgroundTexture(sectorId, avgCfg.id, (SectorLevelDetailEnum.eDetailType).Avg)
  ;
  (self.levelDetailNode):InitAvgDetail(avgCfg, playAvgCompleteFunc, sectorId, isLocked)
  ;
  (((self.ui).tex_Tips).gameObject):SetActive(false)
end

UISectorLevelDetail.InitInfinityLevelDetailNode = function(self, sectorId, levelData)
  -- function num : 0_3 , upvalues : _ENV
  self:CleanLastDetail()
  if self.isPushBack2Stack then
    (UIUtil.PopFromBackStack)()
  end
  ;
  (UIUtil.SetTopStatus)(self, self.OnClickSectorLevelDetailBackBtn, {ConstGlobalItem.SKey})
  self.isPushBack2Stack = true
  self:GetBackgroundTexture(sectorId)
  ;
  (self.levelDetailNode):InitInfinityLevelDetailNode(levelData, sectorId)
  ;
  (((self.ui).tex_Tips).gameObject):SetActive(true)
  local isComplete = (PlayerDataCenter.infinityData):IsInfinityDungeonCompleted((levelData.cfg).id)
  local tips = ""
  if isComplete then
    tips = ConfigData:GetTipContent(TipContent.EndLessRepetitionTips)
  else
    tips = ConfigData:GetTipContent(TipContent.EndLessUnfinishedTips)
  end
  -- DECOMPILER ERROR at PC56: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Tips).text = tips
end

UISectorLevelDetail.InitPeriodicChallengeDetailNode = function(self, challengeId, eChallengeType)
  -- function num : 0_4 , upvalues : _ENV, SectorLevelDetailEnum
  self:CleanLastDetail()
  if self.isPushBack2Stack then
    (UIUtil.PopFromBackStack)()
  end
  ;
  (UIUtil.SetTopStatus)(self, self.OnClickSectorLevelDetailBackBtn, {ConstGlobalItem.SKey})
  self.isPushBack2Stack = true
  self:GetBackgroundTexture(nil, challengeId, (SectorLevelDetailEnum.eDetailType).PeriodicChallenge)
  ;
  (self.levelDetailNode):InitPeriodicChallengeDetailNode(challengeId, eChallengeType)
end

UISectorLevelDetail.InitWeeklyChallengeDetailNode = function(self, challengeId, isLocked)
  -- function num : 0_5 , upvalues : _ENV, SectorLevelDetailEnum
  self:CleanLastDetail()
  if self.isPushBack2Stack then
    (UIUtil.PopFromBackStack)()
  end
  ;
  (UIUtil.SetTopStatus)(self, self.OnClickSectorLevelDetailBackBtn, {ConstGlobalItem.SKey})
  self.isPushBack2Stack = true
  self:GetBackgroundTexture(nil, challengeId, (SectorLevelDetailEnum.eDetailType).WeeklyChallenge)
  ;
  (self.levelDetailNode):InitWeeklyChallengeDetailNode(challengeId, isLocked)
end

UISectorLevelDetail.__InitWarchessDetailNode = function(self, sectorId, stageCfg, isLocked)
  -- function num : 0_6 , upvalues : _ENV
  self:CleanLastDetail()
  if self.isPushBack2Stack then
    (UIUtil.PopFromBackStack)()
  end
  self.isPushBack2Stack = true
  self:GetBackgroundTexture(sectorId)
  ;
  (self.levelDetailNode):InitWarchessDetailNode(sectorId, stageCfg, isLocked)
  ;
  (UIUtil.SetTopStatus)(self, self.OnClickSectorLevelDetailBackBtn, {stageCfg.cost_strength_id})
end

UISectorLevelDetail.__InitNormalDetailNode = function(self, sectorId, stageCfg, isLocked)
  -- function num : 0_7 , upvalues : _ENV, SectorLevelDetailEnum
  self:CleanLastDetail()
  if self.isPushBack2Stack then
    (UIUtil.PopFromBackStack)()
  end
  ;
  (UIUtil.SetTopStatus)(self, self.OnClickSectorLevelDetailBackBtn, {ConstGlobalItem.SKey})
  self.isPushBack2Stack = true
  self.stageId = sectorStageId
  self.stageCfg = stageCfg
  self:GetBackgroundTexture(sectorId, (self.stageCfg).id, (SectorLevelDetailEnum.eDetailType).Stage)
  ;
  (self.levelDetailNode):InitLevelDetailNode(self.stageCfg, sectorId, isLocked)
  ;
  (((self.ui).tex_Tips).gameObject):SetActive(false)
end

UISectorLevelDetail.CleanLastDetail = function(self)
  -- function num : 0_8
  (self.levelDetailNode):SetShowAdditionBuffList(nil)
end

UISectorLevelDetail.GetLevelDetailWidthAndDuration = function(self)
  -- function num : 0_9
  return (self.levelDetailNode):GetNLevelDetailWidthAndDuration()
end

UISectorLevelDetail.SetLevelDetaiHideStartEvent = function(self, hideStartEvent)
  -- function num : 0_10
  self.hideStartEvent = hideStartEvent
end

UISectorLevelDetail.SetLevelDetaiHideEndEvent = function(self, hideEndEvent)
  -- function num : 0_11
  self.hideEndEvent = hideEndEvent
end

UISectorLevelDetail.OnClickSectorLevelDetailBackBtn = function(self, toHome)
  -- function num : 0_12
  if (self.levelDetailNode):IsRunningEnterFmtCo() then
    return 
  end
  self.isPushBack2Stack = false
  if self.levelDetailNode ~= nil then
    (self.levelDetailNode):PlayMoveTween(false)
  end
  if self.hideStartEvent ~= nil then
    (self.hideStartEvent)(toHome)
  end
end

UISectorLevelDetail.RefreshDtailNormalNode = function(self)
  -- function num : 0_13
  if self.levelDetailNode ~= nil then
    (self.levelDetailNode):RefreshDtailNormalNode()
  end
end

UISectorLevelDetail.SetCloseWhenClickEmpty = function(self, flag)
  -- function num : 0_14
  (((self.ui).btn_Close).gameObject):SetActive(flag)
end

UISectorLevelDetail.OnShow = function(self)
  -- function num : 0_15 , upvalues : base
  (base.OnShow)(self)
  ;
  (self.levelDetailNode):OnShow()
end

UISectorLevelDetail.OnHide = function(self)
  -- function num : 0_16
  (self.levelDetailNode):OnHide()
  if self.hideEndEvent ~= nil then
    (self.hideEndEvent)()
  end
end

UISectorLevelDetail.GetBackgroundTexture = function(self, sectorId, challengeId, detailType)
  -- function num : 0_17 , upvalues : _ENV
  if self._tempSectorId == sectorId and self._tempStageId == challengeId and self._tempDetailType == self._tempDetailType then
    return 
  end
  self._tempSectorId = sectorId
  self._tempStageId = challengeId
  self._tempDetailType = detailType
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_LevelPic).texture = ExplorationManager:GetSectorHeadTexture(sectorId, challengeId, detailType, self.resloader)
end

UISectorLevelDetail.SetAdditionBuffList = function(self, buffList)
  -- function num : 0_18
  (self.levelDetailNode):SetShowAdditionBuffList(buffList)
end

UISectorLevelDetail.SetActivityEndButCouldReview = function(self, isActivityRunning)
  -- function num : 0_19
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  (self.levelDetailNode).__couldNotStatrBattle = not isActivityRunning
  ;
  (self.levelDetailNode):SetLevelDetailActIsFinishUI(not isActivityRunning)
end

UISectorLevelDetail.SetDetailCustomEnterFmtCallback = function(self, callback)
  -- function num : 0_20
  (self.levelDetailNode):SetDetailNodeCustomEnterFmtCallback(callback)
end

UISectorLevelDetail.SetDetailExBattleStartCallback = function(self, callback)
  -- function num : 0_21
  (self.levelDetailNode):SetDetailNodeExBattleStartCallback(callback)
end

UISectorLevelDetail.SetDetailSelectCanEnterCallback = function(self, callback)
  -- function num : 0_22
  (self.levelDetailNode):SetDetailNodeSelectCanEnterCallback(callback)
end

UISectorLevelDetail.OnDelete = function(self)
  -- function num : 0_23 , upvalues : base
  (self.levelDetailNode):Delete()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UISectorLevelDetail

