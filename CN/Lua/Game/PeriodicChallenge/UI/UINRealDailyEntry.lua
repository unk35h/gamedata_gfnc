-- params : ...
-- function num : 0 , upvalues : _ENV
local UINRealDailyEntry = class("UINRealDailyEntry", UIBaseNode)
local base = UIBaseNode
local UINPeriodicInfoItem = require("Game.PeriodicChallenge.UI.UINPeriodicInfoItem")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local cs_MessageCommon = CS.MessageCommon
UINRealDailyEntry.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_node, self, self.OnClickDetail)
  self.targetScore = (ConfigData.game_config).weeklyChallengeDailyUnlockScore
end

UINRealDailyEntry.InitRealDailyEntry = function(self, realDailySectorId, parentNode)
  -- function num : 0_1
  self.sectorId = realDailySectorId
  self.parentNode = parentNode
  self.isSelected = false
end

UINRealDailyEntry.SetDungeonId = function(self, dungeonId)
  -- function num : 0_2
  self.dungeonId = dungeonId
end

UINRealDailyEntry.OnClickDetail = function(self)
  -- function num : 0_3 , upvalues : SectorStageDetailHelper
  local has, dungeonId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
  if has and self.dungeonId ~= dungeonId then
    (SectorStageDetailHelper.TryToShowCurrentLevelTips)((SectorStageDetailHelper.PlayMoudleType).Ep)
    return 
  end
  if (self.parentNode).selectedItem == self then
    return 
  end
  self:OnClickItemCallback(true)
end

UINRealDailyEntry.SetSelectState = function(self, flag)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).img_Select):SetActive(flag)
  self.isSelected = flag
  if flag then
    ((self.ui).wave):DOPlayForward()
    AudioManager:PlayAudioById(1107)
  else
    ;
    ((self.ui).wave):DOPlayBackwards()
    AudioManager:PlayAudioById(1108)
  end
end

UINRealDailyEntry.OnClickItemCallback = function(self, flag)
  -- function num : 0_5 , upvalues : _ENV, cs_MessageCommon
  do
    if not self:GetCanShowStageInfo() or self.dungeonId == nil then
      local tip = (string.format)(ConfigData:GetTipContent(TipContent.WeeklyChallenge_DailyChallengeScoreRequire), self.targetScore)
      ;
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(tip)
      return 
    end
    if flag then
      if (self.parentNode).selectedItem ~= nil then
        ((self.parentNode).selectedItem):SetSelectState(false)
      end
      -- DECOMPILER ERROR at PC32: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (self.parentNode).selectedItem = self
      self:OnSelectSectorLevel()
    else
      -- DECOMPILER ERROR at PC37: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (self.parentNode).selectedItem = nil
    end
  end
end

UINRealDailyEntry.__CloseLevelDetailWindow = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if (self.parentNode).selectedItem ~= nil then
    (UIUtil.OnClickBackByUiTab)(self)
  end
end

UINRealDailyEntry.OnSelectSectorLevel = function(self)
  -- function num : 0_7 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.SectorLevelDetail, function(window)
    -- function num : 0_7_0 , upvalues : self
    window:SetLevelDetaiHideStartEvent(function()
      -- function num : 0_7_0_0 , upvalues : self
      (self.parentNode):PlayMoveLeftTween(false)
      self:SetSelectState(false)
      self:OnClickItemCallback(false)
    end
)
    local width, duration = window:GetLevelDetailWidthAndDuration()
    ;
    (self.parentNode):PlayMoveLeftTween(false, width, duration)
    self:SetSelectState(true, width, duration)
    window:InitSectorLevelDetail(self.sectorId, self.dungeonId)
  end
)
end

UINRealDailyEntry.GetCanShowStageInfo = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local weelyNodeBestScore = (PlayerDataCenter.allWeeklyChallengeData):GetWeelyNodeMaxScore()
  local specNodeBestScore = (PlayerDataCenter.allWeeklyChallengeData):GetSpecNodeMaxScore()
  do return self.targetScore <= weelyNodeBestScore or self.targetScore <= specNodeBestScore end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return UINRealDailyEntry

