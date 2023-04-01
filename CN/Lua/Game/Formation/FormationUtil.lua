-- params : ...
-- function num : 0 , upvalues : _ENV
local FormationUtil = {}
local FmtEnum = require("Game.Formation.FmtEnum")
local FixedFmtHeroData = require("Game.PlayerData.Hero.FixedFmtHeroData")
local DungeonTypeFmtIdOffset = {[proto_csmsg_DungeonType.DungeonType_Daily] = 100, [proto_csmsg_DungeonType.DungeonType_WinterHard] = 200}
local FmtFromModuleFmtIdOffset = {[(FmtEnum.eFmtFromModule).DailyDungeon] = 100, [(FmtEnum.eFmtFromModule).DailyDungeonLevel] = 100, [(FmtEnum.eFmtFromModule).SctIIDunChallenge] = 200, [(FmtEnum.eFmtFromModule).DungeonTwinTower] = 300, [(FmtEnum.eFmtFromModule).CarnivalEp] = 400, [(FmtEnum.eFmtFromModule).WarChess] = 500, [(FmtEnum.eFmtFromModule).SpringEp] = 600}
local FmtSpecialStageOffset = {Guard = 700}
FormationUtil.fixedFmtIdList = {1000, 1001}
FormationUtil.GetFmtIdByDungeonType = function(dungeonType, fmtId)
  -- function num : 0_0 , upvalues : FormationUtil
  local offset = (FormationUtil.GetFmtIdOffsetByDungeonType)(dungeonType)
  local id = fmtId + offset
  return id
end

FormationUtil.GetFmtIdOffsetByDungeonType = function(dungeonType)
  -- function num : 0_1 , upvalues : DungeonTypeFmtIdOffset
  local offset = DungeonTypeFmtIdOffset[dungeonType] or 0
  return offset
end

FormationUtil.GetFmtIdOffsetByFmtFromModule = function(fmtFromModule, stageId)
  -- function num : 0_2 , upvalues : FmtFromModuleFmtIdOffset, FormationUtil
  local offset = FmtFromModuleFmtIdOffset[fmtFromModule] or 0
  if stageId and offset == 0 then
    offset = (FormationUtil.GetFmtIdOffsetBySpecialStage)(stageId)
  end
  return offset
end

FormationUtil.GetFmtIdOffsetBySpecialStage = function(stageId)
  -- function num : 0_3 , upvalues : _ENV, FmtSpecialStageOffset
  local stageCfg = (ConfigData.sector_stage)[stageId]
  if stageCfg then
    local explorationId = (stageCfg.exploration_list)[1]
    local explorationCfg = (ConfigData.exploration)[explorationId]
    return not explorationCfg or (ExplorationManager:CheckGuardModeByMapLogic(explorationCfg.map_logic) and FmtSpecialStageOffset.Guard) or 0
  end
  do
    return 0
  end
end

local _GetModuleIdByFmtFromModuleFunc = {[(FmtEnum.eFmtFromModule).DailyDungeon] = proto_csmsg_DungeonType.DungeonType_Daily, [(FmtEnum.eFmtFromModule).DailyDungeonLevel] = proto_csmsg_DungeonType.DungeonType_Daily, [(FmtEnum.eFmtFromModule).SctIIDunChallenge] = proto_csmsg_DungeonType.DungeonType_WinterHard}
FormationUtil.GetModuleIdByFmtFromModule = function(fmtFromModule)
  -- function num : 0_4 , upvalues : _GetModuleIdByFmtFromModuleFunc, _ENV
  local id = _GetModuleIdByFmtFromModuleFunc[fmtFromModule]
  if id == nil then
    error("Unsupported fmtFromModule, fmtFromModule:" .. tostring(fmtFromModule))
    return 
  end
  return id
end

local _GetDyncDgDataByFmtFromModuleFunc = {[(FmtEnum.eFmtFromModule).DailyDungeon] = function()
  -- function num : 0_5 , upvalues : _ENV
  return (PlayerDataCenter.dungeonDyncData):GetDailyDungeonDyncData()
end
, [(FmtEnum.eFmtFromModule).DailyDungeonLevel] = function()
  -- function num : 0_6 , upvalues : _ENV
  return (PlayerDataCenter.dungeonDyncData):GetDailyDungeonDyncData()
end
, [(FmtEnum.eFmtFromModule).SctIIDunChallenge] = function()
  -- function num : 0_7 , upvalues : _ENV
  return (PlayerDataCenter.dungeonDyncData):GetWinterChallengeDgDyncData()
end
}
FormationUtil.GetDyncDgDataByFmtFromModule = function(fmtFromModule)
  -- function num : 0_8 , upvalues : _GetDyncDgDataByFmtFromModuleFunc, _ENV
  local func = _GetDyncDgDataByFmtFromModuleFunc[fmtFromModule]
  if func == nil then
    error("Unsupported fmtFromModule, fmtFromModule:" .. tostring(fmtFromModule))
    return 
  end
  return func()
end

FormationUtil.GetDgDyncDefaultFmtId = function(dungeonType)
  -- function num : 0_9 , upvalues : FormationUtil
  return (FormationUtil.GetFmtIdByDungeonType)(dungeonType, 1)
end

FormationUtil.GetFmtIdByFixedTeamId = function(fixedTeamId)
  -- function num : 0_10 , upvalues : _ENV, FormationUtil
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local fixedTeamId2FmtIdDic, fixedTeamIdListSaved = saveUserData:GetFmtFixedSaved()
  if (table.contain)(fixedTeamIdListSaved, fixedTeamId) then
    local fmtId = fixedTeamId2FmtIdDic[fixedTeamId]
    local formationData = (PlayerDataCenter.formationDic)[fmtId]
    if formationData == nil then
      formationData = PlayerDataCenter:CreateFormation(fmtId)
      ;
      (NetworkManager:GetNetwork(NetworkTypeID.Hero)):SendFormationFresh(fmtId, formationData.data)
    else
      local assistTeamCfg = (ConfigData.assist_team)[fixedTeamId]
      local idxError = false
      local maxNum = assistTeamCfg.extra_add + #assistTeamCfg.param1
      for idx,heroId in pairs(formationData.data) do
        if idx <= #assistTeamCfg.param1 or maxNum < idx then
          idxError = true
          break
        end
      end
      do
        do
          do
            if assistTeamCfg.extra_add < (table.count)(formationData.data) or idxError then
              formationData:CleanFormation()
              ;
              (NetworkManager:GetNetwork(NetworkTypeID.Hero)):SendFormationFresh(fmtId, formationData.data)
            end
            do return fmtId end
            local fmtId = nil
            if #FormationUtil.fixedFmtIdList <= #fixedTeamIdListSaved then
              local removeFixedTeamId = (table.remove)(fixedTeamIdListSaved, 1)
              fmtId = fixedTeamId2FmtIdDic[removeFixedTeamId]
              fixedTeamId2FmtIdDic[removeFixedTeamId] = nil
            else
              do
                do
                  local newFmtIdIdx = #fixedTeamIdListSaved + 1
                  fmtId = (FormationUtil.fixedFmtIdList)[newFmtIdIdx]
                  ;
                  (table.insert)(fixedTeamIdListSaved, fixedTeamId)
                  fixedTeamId2FmtIdDic[fixedTeamId] = fmtId
                  local formationData = (PlayerDataCenter.formationDic)[fmtId]
                  if formationData == nil then
                    formationData = PlayerDataCenter:CreateFormation(fmtId)
                  else
                    formationData:CleanFormation()
                  end
                  ;
                  (NetworkManager:GetNetwork(NetworkTypeID.Hero)):SendFormationFresh(fmtId, formationData.data)
                  saveUserData:SetFmtFixedSaved(fixedTeamId2FmtIdDic, fixedTeamIdListSaved)
                  return fmtId
                end
              end
            end
          end
        end
      end
    end
  end
end

FormationUtil.SetFiexdFmt = function(fmtId, fixedHeroTeamId, fmtName)
  -- function num : 0_11 , upvalues : _ENV, FixedFmtHeroData
  local assistTeamCfg = (ConfigData.assist_team)[fixedHeroTeamId]
  if (ConfigData.game_config).max_formation_hero < #assistTeamCfg.param1 + assistTeamCfg.extra_add then
    error("assist_team.extra_add error, id = " .. tostring(fixedHeroTeamId))
  end
  local fixedHeroDataList = {}
  local fixedHeroIdList = {}
  for k,heroId in ipairs(assistTeamCfg.param1) do
    local assistLv = (assistTeamCfg.assist_lvs)[k]
    local assistLvCfg = (ConfigData.assist_level)[assistLv]
    local heroData = (FixedFmtHeroData.FixedFmtHeroData)(heroId, assistLvCfg)
    ;
    (table.insert)(fixedHeroDataList, heroData)
    ;
    (table.insert)(fixedHeroIdList, heroId)
  end
  local formationData = (PlayerDataCenter.formationDic)[fmtId]
  formationData:SetFmtFixedHeroList(fixedHeroDataList, fixedHeroIdList)
  if not (string.IsNullOrEmpty)(fmtName) then
    formationData.name = fmtName
  end
  return assistTeamCfg
end

FormationUtil.ClearFiexdFmt = function(fmtId)
  -- function num : 0_12 , upvalues : _ENV
  local formationData = (PlayerDataCenter.formationDic)[fmtId]
  if formationData ~= nil then
    formationData:ClearFmtFixedHero()
  end
end

FormationUtil.CheckCmdSkillChange = function(oldCstData, newCstData)
  -- function num : 0_13 , upvalues : _ENV
  if oldCstData == nil then
    return true
  end
  if oldCstData.treeId ~= newCstData.treeId then
    return true
  end
  for slot,skillId in ipairs(oldCstData:GetUsingCmdSkillList()) do
    if (newCstData.slotSkillList)[slot] ~= skillId then
      return true
    end
  end
  return false
end

FormationUtil.CheckFmtBenchUnlock = function(fmtIndex, getUnlockDesc)
  -- function num : 0_14 , upvalues : _ENV
  local unlock, lockStr = nil, nil
  local benchId = fmtIndex - (ConfigData.game_config).max_stage_hero
  if benchId <= 0 then
    unlock = true
  else
    unlock = (FunctionUnlockMgr.BenchUnlock)(benchId, getUnlockDesc)
  end
  return unlock, lockStr
end

FormationUtil.WarChessTeamsCheck = function(fmtDatas, officialSupportCfgId)
  -- function num : 0_15 , upvalues : _ENV, FormationUtil
  local usedHeroDic = {}
  local needRefreshFmtDataDic = {}
  local isNeedRefresh = false
  for _,fmtData in ipairs(fmtDatas) do
    local heroDic = fmtData:GetFormationHeroDic()
    for heroIndex,heroId in pairs(heroDic) do
      if usedHeroDic[heroId] then
        print("<color=yellow>has repeat hero</color>")
        fmtData:SetHero2Formation(heroIndex, nil)
        isNeedRefresh = true
        needRefreshFmtDataDic[fmtData] = true
      end
      usedHeroDic[heroId] = true
    end
    local isNeedClean = (FormationUtil.TryCleanIllegalOfficialSupportData)(officialSupportCfgId, fmtData)
    if not isNeedRefresh then
      isNeedRefresh = isNeedClean
    end
  end
  for fmtData,_ in pairs(needRefreshFmtDataDic) do
    (NetworkManager:GetNetwork(NetworkTypeID.Hero)):SendFormationFresh(fmtData.id, fmtData.data)
  end
  return isNeedRefresh
end

FormationUtil.TryCleanIllegalOfficialSupportData = function(officialSupportCfgId, fmtData)
  -- function num : 0_16 , upvalues : _ENV
  local isNeedClean = false
  if officialSupportCfgId == nil or officialSupportCfgId == 0 then
    isNeedClean = true
  else
    local oshDic = fmtData:GetIsHaveOfficialSupportDic()
    if oshDic ~= nil then
      for _,officialSuppotData in pairs(oshDic) do
        if officialSuppotData.cfgId ~= officialSupportCfgId then
          isNeedClean = true
          break
        end
      end
    end
  end
  do
    if isNeedClean then
      fmtData:CleanOfficialSupportData()
    end
    return isNeedClean
  end
end

return FormationUtil

