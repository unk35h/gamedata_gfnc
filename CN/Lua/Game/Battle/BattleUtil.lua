-- params : ...
-- function num : 0 , upvalues : _ENV
local BattleUtil = {}
local cs_ColorUtility = (CS.UnityEngine).ColorUtility
local cs_BattleStatistics = (CS.BattleStatistics).Instance
local cs_BattleManager = CS.BattleManager
BattleUtil.mvpParaType = {damage = 1, injury = 2, selfHeal = 3, otherHeal = 4}
BattleUtil.mvpType = {heal = 0, damagem = 1, injury = 2, default = 3}
BattleUtil.battleRoleCat = {normalHero = 0, monster = 1, neutral = 2, pDungeonRole = 3, waitToCasterMonster = 4, waitToCasterHero = 5}
BattleUtil.Pos2XYCoord = function(pos)
  -- function num : 0_0 , upvalues : _ENV
  local x = pos >> 16
  local y = pos & CommonUtil.UInt16Max
  return x, y
end

BattleUtil.XYCoord2Pos = function(x, y)
  -- function num : 0_1
  local pos = x << 16 | y
  return pos
end

BattleUtil.PosOnBench = function(pos)
  -- function num : 0_2 , upvalues : _ENV
  local x = pos >> 16
  do return x == (ConfigData.buildinConfig).BenchX end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

BattleUtil.BattleHexDistance = function(ax, ay, bx, by)
  -- function num : 0_3 , upvalues : _ENV
  local dx = bx - ax
  local dy = by - ay
  local adx = (math.abs)(dx)
  local ady = (math.abs)(dy)
  local lukey = dx > 0 and ay & 1 ~= 0
  if not lukey or not (ady + 1) // 2 then
    local xOffset = ady // 2
  end
  if adx > xOffset or not ady then
    local step = ady + adx - xOffset
  end
  do return step end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

BattleUtil.GetChipAttrUpgradeInfo = function(attrIds, initValues, increaseValues, count, newcount)
  -- function num : 0_4 , upvalues : BattleUtil, _ENV
  if #attrIds == 1 then
    return (BattleUtil._GetChipAttrUpgrade)(attrIds[1], initValues[1], increaseValues[1], count, newcount)
  end
  local result = ""
  for i = 1, #attrIds do
    if i > 1 then
      result = result .. ConfigData:GetTipContent(206)
    end
    result = result .. (BattleUtil._GetChipAttrUpgrade)(attrIds[i], initValues[i], increaseValues[i], count, newcount)
  end
  return result
end

BattleUtil._GetChipAttrUpgrade = function(attrId, initValue, increaseValue, count, newcount)
  -- function num : 0_5 , upvalues : _ENV, cs_ColorUtility
  local attibuteCfg = (ConfigData.attribute)[attrId]
  if attibuteCfg == nil then
    error("Can\'t find attibuteCfg, id = " .. tostring(attrId))
    return ""
  end
  if not count then
    count = 1
  end
  local atrName = (LanguageUtil.GetLocaleText)(attibuteCfg.name)
  local isRatio = attibuteCfg.num_type == 2
  local value = initValue + (increaseValue or 0) * (count - 1)
  if not isRatio or not tostring(FormatNum(value / 10)) .. "%" then
    local valueStr = (tostring(value))
  end
  local sign = nil
  if value < 0 then
    sign = ""
  else
    sign = "+"
  end
  do
    if newcount == nil then
      local content = atrName .. sign .. valueStr
      return content
    end
    local newValue = initValue + (increaseValue or 0) * (newcount - 1)
    local newSign = nil
    if newValue < 0 then
      newSign = ""
    else
      newSign = "+"
    end
    if not isRatio or not tostring(FormatNum(newValue / 10)) .. "%" then
      local newValueStr = tostring(newValue)
    end
    local content = (string.format)("%s<color=#%s>%s</color>%s<color=#%s>%s</color>", atrName, (cs_ColorUtility.ToHtmlStringRGB)(ConfigData:GetChipQualityColor(count)), sign .. valueStr, (ConfigData.buildinConfig).ChipLevelUpSign, (cs_ColorUtility.ToHtmlStringRGB)(ConfigData:GetChipQualityColor(newcount)), newSign .. newValueStr)
    do return content end
    -- DECOMPILER ERROR: 12 unprocessed JMP targets
  end
end

BattleUtil.GetChipAttrInfo = function(attrIds, initValues, increaseValues, count, newcount)
  -- function num : 0_6 , upvalues : BattleUtil, _ENV
  if #attrIds == 1 then
    return (BattleUtil._GetChipAttr)(attrIds[1], initValues[1], increaseValues[1], count, newcount)
  end
  local result = ""
  for i = 1, #attrIds do
    if i > 1 then
      result = result .. ConfigData:GetTipContent(206)
    end
    result = result .. (BattleUtil._GetChipAttr)(attrIds[i], initValues[i], increaseValues[i], count, newcount)
  end
  return result
end

BattleUtil._GetChipAttr = function(attrId, initValue, increaseValue, count, maxcount)
  -- function num : 0_7 , upvalues : _ENV
  local attibuteCfg = (ConfigData.attribute)[attrId]
  if attibuteCfg == nil then
    error("Can\'t find attibuteCfg, id = " .. tostring(attrId))
    return ""
  end
  if not count then
    count = 1
  end
  local atrName = (LanguageUtil.GetLocaleText)(attibuteCfg.name)
  local isRatio = attibuteCfg.num_type == 2
  if not increaseValue then
    local value = initValue + (maxcount ~= nil and maxcount > count or 0) * (count - 1)
    if not isRatio or not tostring(FormatNum(value / 10)) .. "%" then
      local valueStr = (tostring(value))
    end
    local sign = nil
    if value < 0 then
      sign = ""
    else
      sign = "+"
    end
    do
      local content = atrName .. sign .. valueStr
      do return content end
      local content = atrName .. "<color=#" .. (ConfigData.buildinConfig).ChipLevelDarkColor .. ">(<color=#" .. (ConfigData.buildinConfig).ChipLevelLightColor .. ">"
      for level = count, maxcount do
        local value = initValue + (increaseValue or 0) * (level - 1)
        if not isRatio or not tostring(FormatNum(value / 10)) .. "%" then
          local valueStr = (tostring(value))
        end
        local sign = nil
        if value < 0 then
          sign = ""
        else
          sign = "+"
        end
        if level == count then
          content = content .. sign .. valueStr .. "</color>"
        else
          content = content .. "/" .. sign .. valueStr
        end
      end
      content = content .. ")</color>"
      do return content end
      -- DECOMPILER ERROR: 15 unprocessed JMP targets
    end
  end
end

BattleUtil.GenMvp = function(playerRoleList)
  -- function num : 0_8 , upvalues : _ENV, BattleUtil
  local heroGradeList = {}
  local typeTotalValue = {}
  local bestDamageID, bestInjuryID, bestHealID = nil, nil, nil
  local bestDamageNum = 0
  local bestInjuryNum = 0
  local bestHealNum = 0
  for i = 0, playerRoleList.Count - 1 do
    local role = playerRoleList[i]
    if not (role.character).onBench then
      local heroCfg = (ConfigData.hero_data)[role.roleDataId]
      if heroCfg == nil then
        error("Can\'t find heroCfg by id, id = " .. tostring(role.roleDataId))
      else
        local MVPNum = 0
        local ok, damageDetail = (((CS.BattleStatistics).Instance).playerDamage):TryGetValue(role)
        if ok then
          MVPNum = MVPNum + damageDetail.damage * (heroCfg.mvp_para)[(BattleUtil.mvpParaType).damage]
          if bestDamageNum < damageDetail.damage then
            bestDamageNum = damageDetail.damage
            bestDamageID = role.roleDataId
          end
        end
        local ok, takeDamageDetail = (((CS.BattleStatistics).Instance).playerTakeDamage):TryGetValue(role)
        if ok then
          MVPNum = MVPNum + takeDamageDetail.damage * (heroCfg.mvp_para)[(BattleUtil.mvpParaType).injury]
          if bestInjuryNum < takeDamageDetail.damage then
            bestInjuryNum = takeDamageDetail.damage
            bestInjuryID = role.roleDataId
          end
        end
        local ok, healDetail = (((CS.BattleStatistics).Instance).playerHeal):TryGetValue(role)
        if ok then
          MVPNum = MVPNum + healDetail.selfHeal * (heroCfg.mvp_para)[(BattleUtil.mvpParaType).selfHeal]
          MVPNum = MVPNum + healDetail.otherHeal * (heroCfg.mvp_para)[(BattleUtil.mvpParaType).otherHeal]
          if bestHealNum < healDetail.heal then
            bestHealNum = healDetail.heal
            bestHealID = role.roleDataId
          end
        end
        local gradeTab = {role = role, MVPNum = MVPNum}
        ;
        (table.insert)(heroGradeList, gradeTab)
      end
    end
  end
  if #heroGradeList <= 0 then
    return nil
  end
  ;
  (table.sort)(heroGradeList, function(role1, role2)
    -- function num : 0_8_0
    if role2.MVPNum >= role1.MVPNum then
      do return role1.MVPNum == role2.MVPNum end
      do return (role1.role).roleDataId < (role2.role).roleDataId end
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
)
  local mvp = heroGradeList[1]
  local MvpFitNum = 0
  if (mvp.role).roleDataId == bestDamageID then
    mvp.MvpType = (BattleUtil.mvpType).damagem
    MvpFitNum = MvpFitNum + 1
  end
  if (mvp.role).roleDataId == bestInjuryID then
    mvp.MvpType = (BattleUtil.mvpType).injury
    MvpFitNum = MvpFitNum + 1
  end
  if (mvp.role).roleDataId == bestHealID then
    mvp.MvpType = (BattleUtil.mvpType).heal
    MvpFitNum = MvpFitNum + 1
  end
  if MvpFitNum == 0 or MvpFitNum > 1 then
    mvp.MvpType = (BattleUtil.mvpType).default
  end
  return mvp
end

BattleUtil.CalculateBloodGrid = function(maxBlood, minBlood)
  -- function num : 0_9 , upvalues : _ENV
  local bloodGridDivisor = (ConfigData.game_config).bloodGridDivisor
  local booldBossRatio = (ConfigData.game_config).booldBossRatio
  if not maxBlood then
    maxBlood = 0
  end
  if not minBlood then
    minBlood = 0
  end
  if bloodGridDivisor <= 0 or not bloodGridDivisor then
    bloodGridDivisor = 1
  end
  local unitBlood = (maxBlood + minBlood) / bloodGridDivisor
  if booldBossRatio <= 0 or not booldBossRatio then
    booldBossRatio = 1
  end
  local bossUnitBlood = unitBlood * booldBossRatio
  return (math.floor)(unitBlood), (math.floor)(bossUnitBlood), (ConfigData.game_config).bloodGridMax
end

BattleUtil.CalculateBloodDensity = function(bloodPre)
  -- function num : 0_10 , upvalues : _ENV
  local ratio = bloodPre * 100
  local res = 0
  local beforBloodRatio = nil
  for i,bloodRatio in ipairs((ConfigData.game_config).bloodDensitySortList) do
    if bloodRatio[2] <= ratio then
      res = bloodRatio[1]
    else
      local beforBloodShow = beforBloodRatio ~= nil and beforBloodRatio[1] or 0
      local beforBloodReal = beforBloodRatio ~= nil and beforBloodRatio[2] or 0
      local diffUnit = (bloodRatio[1] - beforBloodShow) / (bloodRatio[2] - beforBloodShow)
      res = res + diffUnit * (ratio - beforBloodReal)
      break
    end
    do
      do
        beforBloodRatio = bloodRatio
        -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  return (res) / 100
end

BattleUtil.TryGetCurBattleDungeonType = function()
  -- function num : 0_11 , upvalues : _ENV
  local dungeonCtrl = BattleDungeonManager:GetDungeonCtrl()
  if dungeonCtrl ~= nil then
    return (dungeonCtrl.dungeonCfg).dungeon_type
  end
  do
    if ExplorationManager.epCtrl ~= nil then
      local curRoomData = (ExplorationManager.epCtrl):GetCurrentRoomData()
      return curRoomData.dungeonType
    end
    return -1
  end
end

BattleUtil.IsInTDBattle = function()
  -- function num : 0_12 , upvalues : _ENV
  if BattleEditorManager ~= nil then
    return BattleEditorManager.isInTdMode
  end
  if not BattleDungeonManager:IsInTDDungeon() then
    return ExplorationManager:IsInTDExp()
  end
end

BattleUtil.IsInBrotatBattle = function()
  -- function num : 0_13 , upvalues : _ENV
  if BattleEditorManager ~= nil then
    return BattleEditorManager.isInBrotatoMode
  end
  if not BattleDungeonManager:IsInBrotatoDungeon() then
    return ExplorationManager:IsInBrotatoExp()
  end
end

BattleUtil.IsInGuardBattle = function()
  -- function num : 0_14 , upvalues : _ENV
  if BattleEditorManager ~= nil then
    return BattleEditorManager.isInGuardMode
  end
  if not BattleDungeonManager:IsInGuardDungeon() and not ExplorationManager:IsInGuardExp() then
    return WarChessManager:IsWCInGuardBattle()
  end
end

BattleUtil.IsSpecialTDMode = function()
  -- function num : 0_15 , upvalues : _ENV
  if not ExplorationManager:IsInExploration() then
    return false
  end
  local isTDBattle = false
  do
    if ExplorationManager.floorId ~= nil then
      local expCfg = (ConfigData.exploration)[ExplorationManager.floorId]
      if expCfg ~= nil and ExplorationManager:CheckTDModeByMapLogic(expCfg.map_logic) then
        isTDBattle = true
      end
    end
    if not isTDBattle then
      return false
    end
    for _,v in pairs((ConfigData.buildinConfig).SpecialDungeon) do
      if v == ExplorationManager.dungeonId then
        return true
      end
    end
    return false
  end
end

BattleUtil.IsInDailyDungeon = function()
  -- function num : 0_16 , upvalues : BattleUtil, _ENV
  local dungeonType = (BattleUtil.TryGetCurBattleDungeonType)()
  do return dungeonType == proto_csmsg_DungeonType.DungeonType_Daily end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

BattleUtil.IsInWinterChallengeDungeon = function()
  -- function num : 0_17 , upvalues : BattleUtil, _ENV
  local dungeonType = (BattleUtil.TryGetCurBattleDungeonType)()
  do return dungeonType == proto_csmsg_DungeonType.DungeonType_WinterHard end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

BattleUtil.IsBattleEnableFormation = function()
  -- function num : 0_18 , upvalues : BattleUtil
  if not (BattleUtil.IsInDailyDungeon)() then
    return (BattleUtil.IsInWinterChallengeDungeon)()
  end
end

BattleUtil.IsSupportInterruptPlay = function()
  -- function num : 0_19 , upvalues : _ENV
  local isUnlockInterruptEp = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_InterruptEp)
  if not isUnlockInterruptEp then
    return false
  end
  if ExplorationManager:IsInExploration() then
    if ExplorationManager:GetEpModuleId() == proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration then
      local dungeonId = ExplorationManager:GetEpDungeonId()
      local cfg = (ConfigData.sector_stage)[dungeonId]
      if cfg ~= nil then
        return not cfg.destroy
      end
    end
    do
      do return true end
      if WarChessManager:GetIsInWarChess() then
        if WarChessManager:IsWCInBattle() then
          return false
        end
        local cfg = WarChessManager:GetWCSectorStageCfg()
        if cfg ~= nil then
          return not cfg.destroy
        end
        return true
      end
      do
        return false
      end
    end
  end
end

BattleUtil.LogicFrameCount = 15
BattleUtil.CheatFrame = 4294967295
BattleUtil.FrameToTime = function(frame)
  -- function num : 0_20 , upvalues : BattleUtil
  if not frame then
    frame = 0
  end
  return frame // BattleUtil.LogicFrameCount
end

BattleUtil.SecondToFrame = function(second)
  -- function num : 0_21 , upvalues : BattleUtil
  if second == nil then
    return 0
  end
  return second * BattleUtil.LogicFrameCount
end

BattleUtil.FrameToTimeString = function(frame, needMs)
  -- function num : 0_22 , upvalues : BattleUtil, _ENV
  if not frame then
    frame = 0
  end
  if BattleUtil.CheatFrame <= frame then
    return ConfigData:GetTipContent(1020)
  end
  local t = frame // BattleUtil.LogicFrameCount
  local s = (math.floor)(t % 60)
  local m = (math.floor)(t / 60 % 60)
  local h = ((math.floor)(t / 3600))
  local content = nil
  if needMs then
    local ms = (math.floor)((frame / BattleUtil.LogicFrameCount - t) * 1000)
    if h > 0 then
      content = (string.format)("%02d:%02d:%02d.%03d", h, m, s, ms)
    else
      content = (string.format)("%02d:%02d.%03d", m, s, ms)
    end
  else
    do
      if h > 0 then
        content = (string.format)("%02d:%02d:%02d", h, m, s)
      else
        content = (string.format)("%02d:%02d", m, s)
      end
      return content
    end
  end
end

BattleUtil.TryGetCurBattleBloodGridCfg = function()
  -- function num : 0_23 , upvalues : _ENV
  local dungeonCtrl = BattleDungeonManager:GetDungeonCtrl()
  if dungeonCtrl ~= nil then
    return true, dungeonCtrl.unitBlood, dungeonCtrl.bossUnitBlood, dungeonCtrl.bloodGridMax
  end
  do
    if ExplorationManager.epCtrl ~= nil then
      local epCtrl = ExplorationManager.epCtrl
      return true, epCtrl.unitBlood, epCtrl.bossUnitBlood, epCtrl.bloodGridMax
    end
    return false
  end
end

BattleUtil.GetCurDynPlayer = function(withouWarning)
  -- function num : 0_24 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if wcCtrl ~= nil then
    return (wcCtrl.battleCtrl).curDynPlayer
  end
  local dungeonCtrl = BattleDungeonManager:GetDungeonCtrl()
  if dungeonCtrl ~= nil then
    return dungeonCtrl.dynPlayer
  end
  if ExplorationManager.epCtrl ~= nil then
    return (ExplorationManager.epCtrl).dynPlayer
  end
  if not withouWarning then
    warn("Cant get cur DynPlayerl")
  end
end

BattleUtil.GetCurSceneCtrl = function()
  -- function num : 0_25 , upvalues : _ENV
  local dungeonCtrl = BattleDungeonManager:GetDungeonCtrl()
  if dungeonCtrl ~= nil then
    return dungeonCtrl.sceneCtrl
  end
  if ExplorationManager.epCtrl ~= nil then
    return (ExplorationManager.epCtrl).sceneCtrl
  end
  warn("Cant get scene ctrl")
end

BattleUtil.GetCurSceneBattleFieldSize = function()
  -- function num : 0_26 , upvalues : _ENV
  local dungeonCtrl = BattleDungeonManager:GetDungeonCtrl()
  do
    if dungeonCtrl ~= nil then
      local dungeonCfg = dungeonCtrl.dungeonCfg
      return dungeonCfg.size_row, dungeonCfg.size_col, dungeonCfg.deploy_rows, dungeonCfg.grid_scale_factor
    end
    if ExplorationManager.epCtrl ~= nil then
      return ExplorationManager:GetEpSceneBattleFieldSize()
    end
    warn("Cant get cur scene battle field size")
  end
end

BattleUtil.IsAllowCstChangeShowMoudle = function(battleType)
  -- function num : 0_27 , upvalues : _ENV
  if BattleEditorManager ~= nil then
    return false
  end
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_commander_skill) then
    return false
  end
  if BattleDungeonManager:InBattleDungeon() then
    if BattleDungeonManager:IsInTDDungeon() then
      return false
    end
    local allow = not ((BattleDungeonManager.dungeonCtrl).dungeonCfg).close_cmdskill
    return allow
  end
  do
    if battleType == nil and ExplorationManager:IsInExploration() then
      if ExplorationManager:IsInTDExp() then
        return false
      end
      battleType = ExplorationManager:GetEpModuleTypeCfgId()
    end
    if battleType == nil then
      return false
    end
    local explorationTypeCfg = (ConfigData.exploration_type)[battleType]
    if explorationTypeCfg == nil then
      return false
    end
    return explorationTypeCfg.refresh_command_skill_tree
  end
end

BattleUtil.TryGetFixedCstSkills = function()
  -- function num : 0_28 , upvalues : _ENV
  do
    if ExplorationManager:IsInExploration() then
      local stageId = ExplorationManager:GetEpDungeonId()
      return ConfigData:GetFixedCstSkillsExp(stageId)
    end
    local dungeonCtrl = BattleDungeonManager:GetDungeonCtrl()
    do
      if dungeonCtrl ~= nil then
        local dungeonId = dungeonCtrl.dungeonId
        return ConfigData:GetFixedCstSkillsDun(dungeonId)
      end
      return false
    end
  end
end

BattleUtil.GetConsumeChipLimit = function()
  -- function num : 0_29 , upvalues : _ENV
  do
    if ExplorationManager:IsInExploration() then
      local value = (ExplorationManager:GetSectorStageCfg()).active_alg_limit
      if value > 0 then
        return value
      end
    end
    return (ConfigData.game_config).activeAlgNumMax
  end
end

BattleUtil.ShowBattleResultSkada = function(csbattleController, closeFunc)
  -- function num : 0_30 , upvalues : _ENV, cs_BattleStatistics
  UIManager:ShowWindowAsync(UIWindowTypeID.ResultSkada, function(window)
    -- function num : 0_30_0 , upvalues : cs_BattleStatistics, csbattleController, closeFunc
    if window == nil then
      return 
    end
    window:InitBattleSkada(cs_BattleStatistics, (csbattleController.PlayerTeamController).battleOriginRoleList, (csbattleController.EnemyTeamController).battleOriginRoleList)
    window:SetSkadaCloseCallback(closeFunc)
  end
)
end

BattleUtil.BattleAbleSelectChipSuit = function()
  -- function num : 0_31 , upvalues : _ENV
  if BattleDungeonManager:InBattleDungeon() and BattleDungeonManager.dunInterfaceData ~= nil then
    return (BattleDungeonManager.dunInterfaceData):GetAbleSelectChipSuit()
  end
  return false
end

BattleUtil.TryGetDungeonLvTowerLvInfo = function()
  -- function num : 0_32 , upvalues : _ENV
  if BattleDungeonManager:InBattleDungeon() and BattleDungeonManager.dunInterfaceData ~= nil then
    return (BattleDungeonManager.dunInterfaceData):TryGetDungeonTowerLvInfo()
  end
  return nil, 0
end

BattleUtil.TryRunAfterClickBattleCallback = function(callback)
  -- function num : 0_33 , upvalues : _ENV
  do
    if BattleDungeonManager:InBattleDungeon() and BattleDungeonManager.dunInterfaceData ~= nil then
      local afterClickBattleFunc = (BattleDungeonManager.dunInterfaceData):GetAfterClickBattleFunc()
      if afterClickBattleFunc ~= nil then
        afterClickBattleFunc(callback)
        return 
      end
    end
    if callback ~= nil then
      callback()
    end
  end
end

BattleUtil.IsBattleInPause = function()
  -- function num : 0_34 , upvalues : cs_BattleManager
  local battleCtrl = (cs_BattleManager.Instance).CurBattleController
  return battleCtrl ~= nil and battleCtrl:BattleIsPause() or false
end

return BattleUtil

