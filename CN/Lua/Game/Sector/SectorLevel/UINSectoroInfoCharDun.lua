-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSectoroInfoCharDun = class("UINSectoroInfoCharDun", UIBaseNode)
local base = UIBaseNode
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
UINSectoroInfoCharDun.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Difficult, self, self.OnClickChangeSector)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.OnClickIntro)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_PlotReview, self, self.OnClickPlotReview)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Guide, self, self.__OnClickWarChessGuide)
  self._mainStageColor = ((self.ui).img_btn_Difficult).color
  self._challengeColor = (Color.New)(1, 1, 1, 1)
  self.__UpdateBtnStateEvent = BindCallback(self, self.__UpdateBtnState)
  MsgCenter:AddListener(eMsgEventId.HeroGrowActivityRunEnd, self.__UpdateBtnStateEvent)
  self.__UpdateChallengeStateEvent = BindCallback(self, self.__UpdateChallengeState)
  MsgCenter:AddListener(eMsgEventId.HeroGrowActivityUpdate, self.__UpdateChallengeStateEvent)
  MsgCenter:AddListener(eMsgEventId.HeroGrowActivityTimePass, self.__UpdateChallengeStateEvent)
  self.__isInWCGuide = false
  ;
  ((self.ui).tex_GuideDes):SetIndex(0)
end

UINSectoroInfoCharDun.UpdateSectoroInfoCharDun = function(self, sectorCfg, actInfo, selectSectorCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._sectorCfg = sectorCfg
  self._sectorId = (self._sectorCfg).id
  self._heroGrowInfo = actInfo
  self._heroGrowCfg = nil
  if actInfo ~= nil then
    self._heroGrowCfg = (self._heroGrowInfo):GetHeroGrowCfg()
  else
    local actId = ((ConfigData.activity_hero).sectorMapping)[self._sectorId]
    self._heroGrowCfg = actId ~= nil and (ConfigData.activity_hero)[actId] or nil
  end
  do
    self._selectSectorCallback = selectSectorCallback
    self:__UpdateSectoroInfo()
  end
end

UINSectoroInfoCharDun.__UpdateSectoroInfo = function(self)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_CharDunName).text = (LanguageUtil.GetLocaleText)((self._sectorCfg).name)
  if self._heroGrowCfg == nil then
    return 
  end
  if (self._heroGrowCfg).main_stage == self._sectorId then
    self._changeSectorId = (self._heroGrowCfg).rechallenge_stage
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_btn_Difficult).color = self._mainStageColor
    ;
    ((self.ui).tex_Difficult):SetIndex(0, (LanguageUtil.GetLocaleText)(((ConfigData.sector)[self._changeSectorId]).name))
  else
    self._changeSectorId = (self._heroGrowCfg).main_stage
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_btn_Difficult).color = self._challengeColor
    ;
    ((self.ui).tex_Difficult):SetIndex(1, (LanguageUtil.GetLocaleText)(((ConfigData.sector)[self._changeSectorId]).name))
  end
  self:__UpdateBtnState()
  self:__UpdateChallengeState()
end

UINSectoroInfoCharDun.__UpdateBtnState = function(self)
  -- function num : 0_3 , upvalues : SectorStageDetailHelper
  local active = (self._heroGrowInfo ~= nil and (self._heroGrowInfo):IsActivityRunning())
  local guide_sector = (self._heroGrowCfg).guide_sector
  local isWarChess = (SectorStageDetailHelper.GetIsSectorHaveWarChessStage)(self._sectorId)
  local isHaveWCGuide = (guide_sector ~= nil and guide_sector > 0 and isWarChess)
  if active then
    (((self.ui).btn_Info).gameObject):SetActive(not self.__isInWCGuide)
    if active then
      (((self.ui).btn_Difficult).gameObject):SetActive(not self.__isInWCGuide)
      ;
      (((self.ui).btn_PlotReview).gameObject):SetActive(self._sectorId == (self._heroGrowCfg).main_stage)
      if active and not isHaveWCGuide then
        (((self.ui).btn_Guide).gameObject):SetActive(self.__isInWCGuide)
        ;
        ((self.ui).obj_img_Guide):SetActive(self.__isInWCGuide)
        -- DECOMPILER ERROR: 8 unprocessed JMP targets
      end
    end
  end
end

UINSectoroInfoCharDun.__UpdateChallengeState = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self._heroGrowInfo == nil then
    return 
  end
  if self._sectorId ~= (self._heroGrowCfg).rechallenge_stage or not (self._heroGrowInfo):IsHeroGrowLimiTimes() then
    ((self.ui).times):SetActive(false)
    return 
  end
  ;
  ((self.ui).times):SetActive(true)
  ;
  ((self.ui).remainTimes):SetIndex(0, tostring((self._heroGrowInfo):GetHeroGrowChallengeCount()), tostring((self._heroGrowCfg).max_time))
  self._targetTime = (self._heroGrowInfo):GetHeroGrowChallengeRefrehTime()
  if self.timerId == nil then
    self.timerId = TimerManager:StartTimer(1, self.__TimeCountdown, self)
  end
  self:__TimeCountdown()
end

UINSectoroInfoCharDun.__TimeCountdown = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self._targetTime < PlayerDataCenter.timestamp then
    return 
  end
  local coutdown = self._targetTime - PlayerDataCenter.timestamp
  ;
  ((self.ui).tex_RefreshTime):SetIndex(0, TimeUtil:TimestampToTime(coutdown), tostring((self._heroGrowCfg).free_times))
end

UINSectoroInfoCharDun.OnClickIntro = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self._heroGrowCfg == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_6_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    window:InitCommonInfo(ConfigData:GetTipContent((self._heroGrowCfg).add_content), ConfigData:GetTipContent((self._heroGrowCfg).add_title))
  end
)
end

UINSectoroInfoCharDun.OnClickChangeSector = function(self)
  -- function num : 0_7 , upvalues : SectorStageDetailHelper, _ENV
  if self._selectSectorCallback == nil then
    return false
  end
  if not (SectorStageDetailHelper.IsSectorNoCollide)(self._changeSectorId, true) then
    return false
  end
  ;
  (self._selectSectorCallback)(1, self._changeSectorId)
  self._sectorId = self._changeSectorId
  self._sectorCfg = (ConfigData.sector)[self._sectorId]
  self:__UpdateSectoroInfo()
  return true
end

UINSectoroInfoCharDun.OnClickPlotReview = function(self)
  -- function num : 0_8 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.HeroPlotReview, function(window)
    -- function num : 0_8_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    local CommonPoltReviewData = require("Game.CommonUI.PlotReview.CommonPoltReviewData")
    local CPRData = (CommonPoltReviewData.Create4CharAct)(self._heroGrowCfg)
    window:InitCommonPlotReview(CPRData)
  end
)
end

UINSectoroInfoCharDun.__OnClickWarChessGuide = function(self)
  -- function num : 0_9
  if self.__isInWCGuide then
    self._changeSectorId = self.__oldSectorId
    if self:OnClickChangeSector() then
      ((self.ui).tex_GuideDes):SetIndex(0)
      self.__isInWCGuide = false
    end
  else
    self.__oldSectorId = self._sectorId
    self._changeSectorId = (self._heroGrowCfg).guide_sector
    if self:OnClickChangeSector() then
      ((self.ui).tex_GuideDes):SetIndex(1)
      self.__isInWCGuide = true
    end
  end
  self:__UpdateBtnState()
end

UINSectoroInfoCharDun.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.HeroGrowActivityRunEnd, self.__UpdateBtnStateEvent)
  MsgCenter:RemoveListener(eMsgEventId.HeroGrowActivityUpdate, self.__UpdateChallengeStateEvent)
  MsgCenter:RemoveListener(eMsgEventId.HeroGrowActivityTimePass, self.__UpdateChallengeStateEvent)
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINSectoroInfoCharDun

