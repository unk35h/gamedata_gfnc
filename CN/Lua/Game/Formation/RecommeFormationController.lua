-- params : ...
-- function num : 0 , upvalues : _ENV
local RecommeFormationController = class("RecommeFormationController", ControllerBase)
local base = ControllerBase
local CS_MessageCommon = CS.MessageCommon
local RecommeFormationData = require("Game.Formation.Data.RecommeFormationData")
local RecommeFormationNewData = require("Game.Formation.Data.RecommeFormationNewData")
RecommeFormationController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.isRecommeSortForCount = false
  self.heroNetwork = NetworkManager:GetNetwork(NetworkTypeID.Hero)
end

RecommeFormationController.IsCanReqRecomme = function(self, stageId, isShowTip)
  -- function num : 0_1 , upvalues : _ENV, CS_MessageCommon
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Recommend) then
    if isShowTip then
      (CS_MessageCommon.ShowMessageTipsWithErrorSound)(FunctionUnlockMgr:GetFuncUnlockDecription(proto_csmsg_SystemFunctionID.SystemFunctionID_Recommend))
    end
    return false
  end
  local unlockCfg = (ConfigData.system_open)[proto_csmsg_SystemFunctionID.SystemFunctionID_Recommend]
  if stageId <= (unlockCfg.pre_para1)[1] then
    if isShowTip then
      (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Recomme_Forbid))
    end
    return false
  end
  return true
end

RecommeFormationController.ReqRecommeFormation = function(self, stageId, isOpenFormationCopy)
  -- function num : 0_2 , upvalues : _ENV
  if not self:IsCanReqRecomme(stageId, true) then
    return 
  end
  self.isOpenFormationCopy = isOpenFormationCopy or false
  self.reqRecordStageId = stageId
  if self.recommeFormationCache ~= nil and (self.recommeFormationCache).stageId == stageId and PlayerDataCenter.timestamp < (self.recommeFormationCache).refreshTime then
    UIManager:ShowWindowAsync(UIWindowTypeID.RecommeFormation, function(window)
    -- function num : 0_2_0 , upvalues : self
    window:InitRecommeFormation(self.isOpenFormationCopy, self.recommeFormationCache, self)
  end
)
  else
    ;
    (self.heroNetwork):CS_RECOMMANDFORMATION_Detail(self.reqRecordStageId)
  end
end

RecommeFormationController.ReceiveRecommeFormation = function(self, msg)
  -- function num : 0_3 , upvalues : RecommeFormationData, CS_MessageCommon, _ENV
  self.recommeFormationCache = (RecommeFormationData.CreateRecommeData)(self.reqRecordStageId)
  ;
  (self.recommeFormationCache):GenRecommeSingleData(msg)
  if #(self.recommeFormationCache).list == 0 then
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Recomme_Empty))
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.RecommeFormation, function(window)
    -- function num : 0_3_0 , upvalues : self
    window:InitRecommeFormation(self.isOpenFormationCopy, self.recommeFormationCache, self)
  end
)
end

RecommeFormationController.ReqDunRecommeFormation = function(self, dungeonId, isOpenFormationCopy)
  -- function num : 0_4
  self.isOpenFormationCopy = isOpenFormationCopy or false
  self.reqRecordStageId = dungeonId
  ;
  (self.heroNetwork):CS_RECOMMANDFORMATION_DungeonDetail(self.reqRecordStageId)
end

RecommeFormationController.ReceiveDunRecommeFormation = function(self, msg)
  -- function num : 0_5 , upvalues : RecommeFormationData, _ENV, CS_MessageCommon
  local recommeFormationCache = (RecommeFormationData.CreateRecommeData)(self.reqRecordStageId)
  recommeFormationCache:SetAsDungeonRecomme()
  local dungeonStageCfg = (ConfigData.battle_dungeon)[self.reqRecordStageId]
  if dungeonStageCfg.module_id == proto_csmsg_SystemFunctionID.SystemFunctionID_DungeonTower then
    local towerLevelCfg = (ConfigData.dungeon_tower)[self.reqRecordStageId]
    local supportChip = #towerLevelCfg.chip_pool > 0 or #dungeonStageCfg.enter_chip_select > 0
    recommeFormationCache:SetRecommeSupportChip(supportChip)
    local ruleId = ((ConfigData.dungeon_tower_type)[towerLevelCfg.tower_type]).formation_rule
    recommeFormationCache:SetFormationRuleId(ruleId)
  end
  recommeFormationCache:GenRecommeSingleData(msg)
  if #recommeFormationCache.list == 0 then
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Recomme_Empty))
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.RecommeFormation, function(window)
    -- function num : 0_5_0 , upvalues : self, recommeFormationCache
    window:InitRecommeFormation(self.isOpenFormationCopy, recommeFormationCache, self)
  end
)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

RecommeFormationController.ExitRecommeFormation = function(self, singleData)
  -- function num : 0_6 , upvalues : _ENV, CS_MessageCommon
  if singleData == nil then
    return 
  end
  local formationCtrl = ControllerManager:GetController(ControllerTypeId.Formation)
  if formationCtrl ~= nil then
    local newHeroDic = singleData:CopyFormation()
    local isChange = formationCtrl:UpdateFormationHero(newHeroDic)
    if isChange then
      if (table.count)(newHeroDic) == singleData:GetHaveCount() then
        (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Recomme_SuccessAll))
      else
        ;
        (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Recomme_SuccessPart))
      end
    else
      ;
      (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Recomme_Sample))
    end
  end
end

RecommeFormationController.ReqRecommeFormationNew = function(self, stageId, isOpenFormationCopy)
  -- function num : 0_7 , upvalues : _ENV
  if not self:IsCanReqRecomme(stageId, true) then
    return 
  end
  self.isOpenFormationCopy = isOpenFormationCopy or false
  self.reqRecordStageId = stageId
  if self.recommeFormationCacheNew ~= nil and (self.recommeFormationCacheNew).stageId == stageId and PlayerDataCenter.timestamp < (self.recommeFormationCacheNew).refreshTime then
    UIManager:ShowWindowAsync(UIWindowTypeID.RecommeFormationNew, function(window)
    -- function num : 0_7_0 , upvalues : self
    window:InitRecommeFormation(self.isOpenFormationCopy, self.recommeFormationCacheNew, self)
  end
)
  else
    ;
    (self.heroNetwork):CS_RECOMMANDFORMATION_Detail(self.reqRecordStageId)
  end
end

RecommeFormationController.ReceiveRecommeFormationNew = function(self, msg)
  -- function num : 0_8 , upvalues : RecommeFormationNewData, CS_MessageCommon, _ENV
  self.recommeFormationCacheNew = (RecommeFormationNewData.CreateRecommeData)(self.reqRecordStageId)
  ;
  (self.recommeFormationCacheNew):GenRecommeSingleData(msg)
  if #(self.recommeFormationCacheNew).list == 0 then
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Recomme_Empty))
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.RecommeFormationNew, function(window)
    -- function num : 0_8_0 , upvalues : self
    window:InitRecommeFormation(self.isOpenFormationCopy, self.recommeFormationCacheNew, self)
  end
)
end

RecommeFormationController.ReqDunRecommeFormationNew = function(self, dungeonId, isOpenFormationCopy)
  -- function num : 0_9
  self.isOpenFormationCopy = isOpenFormationCopy or false
  self.reqRecordStageId = dungeonId
  ;
  (self.heroNetwork):CS_RECOMMANDFORMATION_DungeonDetail(self.reqRecordStageId)
end

RecommeFormationController.ReceiveDunRecommeFormationNew = function(self, msg)
  -- function num : 0_10 , upvalues : RecommeFormationNewData, _ENV, CS_MessageCommon
  local recommeFormationCacheNew = (RecommeFormationNewData.CreateRecommeData)(self.reqRecordStageId)
  recommeFormationCacheNew:SetAsDungeonRecomme()
  local dungeonStageCfg = (ConfigData.battle_dungeon)[self.reqRecordStageId]
  if dungeonStageCfg.module_id == proto_csmsg_SystemFunctionID.SystemFunctionID_DungeonTower then
    local towerLevelCfg = (ConfigData.dungeon_tower)[self.reqRecordStageId]
    local ruleId = ((ConfigData.dungeon_tower_type)[towerLevelCfg.tower_type]).formation_rule
    recommeFormationCacheNew:SetFormationRuleId(ruleId)
  end
  do
    recommeFormationCacheNew:GenRecommeSingleData(msg)
    if #recommeFormationCacheNew.list == 0 then
      (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Recomme_Empty))
      return 
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.RecommeFormationNew, function(window)
    -- function num : 0_10_0 , upvalues : self, recommeFormationCacheNew
    window:InitRecommeFormation(self.isOpenFormationCopy, recommeFormationCacheNew, self)
  end
)
  end
end

return RecommeFormationController

