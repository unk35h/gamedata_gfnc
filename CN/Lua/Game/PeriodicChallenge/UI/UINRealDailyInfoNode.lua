-- params : ...
-- function num : 0 , upvalues : _ENV
local UINRealDailyInfoNode = class("UINRealDailyInfoNode", UIBaseNode)
local base = UIBaseNode
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
UINRealDailyInfoNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINRealDailyInfoNode.InitRealDailyInfoNode = function(self, realDailySectorId, dungeonId)
  -- function num : 0_1 , upvalues : _ENV
  self.dungeonId = dungeonId
  local sectorCfg = (ConfigData.sector)[realDailySectorId]
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(sectorCfg.name)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Info).text = (LanguageUtil.GetLocaleText)(sectorCfg.description)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Tip).text = ConfigData:GetTipContent(TipContent.WeeklyChallenge_DailyChallengeTip)
  self:RefreshPeriodicInfoItem()
end

UINRealDailyInfoNode.RefreshPeriodicInfoItem = function(self)
  -- function num : 0_2 , upvalues : SectorStageDetailHelper
  local _, dungeonId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
  local isInEp = self.dungeonId == dungeonId
  ;
  ((self.ui).obj_Continue):SetActive(isInEp)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return UINRealDailyInfoNode

