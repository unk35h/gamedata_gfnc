-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessTeamData = class("WarChessTeamData")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local WarChessDynPlayer = require("Game.WarChess.Data.Battle.WarChessDynPlayer")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
WarChessTeamData.ctor = function(self)
  -- function num : 0_0
  self.__teamUID = nil
  self.__index = 0
  self.__clientIndex = 0
  self.__AP = 0
  self.__LastAP = self.__AP
  self.__curBFId = nil
  self.logicPos = nil
  self.__IsMoving = false
  self.__MoveOverCallback = nil
  self.__dynHeroDataOrderDic = {}
  self.__dynPlayer = nil
  self.__totalHp = 1
  self.__teamLeaderHeroId = nil
  self.__isGhost = false
  self.__isDead = false
  self.__moveableGirdDic = nil
  self.__buffNumericDic = {}
  self.__limitMoveOneGrid = nil
  self.__headIconOverraidId = nil
  self.__initialDeploy = true
  self.__formationRuleCfg = nil
  self._chipAdd = {}
  self._chipDel = {}
  self.__earlySetPos = nil
end

WarChessTeamData.GetNewTeamDataByDTeamData = function(fInfo, dTeamData, deadTeamData)
  -- function num : 0_1 , upvalues : WarChessTeamData, _ENV, WarChessDynPlayer
  local teamData = (WarChessTeamData.New)()
  teamData.__index = fInfo.teamUid & CommonUtil.UInt16Max
  teamData.__clientIndex = dTeamData:GetDTeamIndex()
  teamData.logicPos = dTeamData:GetBornPoint()
  teamData.__teamLeaderHeroId = (dTeamData:GetFirstHeroData()).dataId
  teamData.__teamUID = fInfo.teamUid
  teamData.__AP = fInfo.point
  teamData:UpdateTeamNumericDiff(fInfo.formationNumeric)
  teamData.__teamName = dTeamData:GetDTeamName()
  teamData.__initialDeploy = fInfo.initial
  teamData.__treeId = dTeamData:GetFmtCSTId()
  local formationCfg = teamData:GetTeamFormationRuleCfg()
  local normalNum = formationCfg.stage_num
  local benchNum = formationCfg.bench_num
  for i = 1, normalNum do
    local heroData = dTeamData:GetDTeamHeroData(i)
    if heroData ~= nil then
      local heroId = heroData.dataId
      -- DECOMPILER ERROR at PC49: Confused about usage of register: R13 in 'UnsetPending'

      if heroData ~= nil then
        (teamData.__dynHeroDataOrderDic)[i] = heroId
      end
    end
  end
  for i = normalNum + 1, normalNum + benchNum do
    local heroData = dTeamData:GetDTeamHeroData(i)
    if heroData ~= nil then
      local heroId = heroData.dataId
      -- DECOMPILER ERROR at PC64: Confused about usage of register: R13 in 'UnsetPending'

      if heroData ~= nil then
        (teamData.__dynHeroDataOrderDic)[i] = heroId
      end
    end
  end
  if deadTeamData ~= nil then
    teamData.__dynPlayer = deadTeamData:GetTeamDynPlayer()
  else
    teamData.__dynPlayer = (WarChessDynPlayer.CreateDungeonPlayer)(teamData.__formationRuleCfg)
    ;
    (teamData.__dynPlayer):UpDateWCDynPlayerChipLimit(fInfo.algLimit)
  end
  return teamData
end

WarChessTeamData.GetNewTeamDataByMsg = function(data, fmtData)
  -- function num : 0_2 , upvalues : WarChessTeamData, WarChessHelper, _ENV, WarChessDynPlayer
  local teamData = (WarChessTeamData.New)()
  local fInfo = data.fInfo
  teamData.__index = data.index
  do
    if fInfo.pos ~= nil then
      local x, y = (WarChessHelper.Coordination2Pos)((fInfo.pos).pos)
      teamData.logicPos = (Vector2.New)(x, y)
    end
    teamData.__teamLeaderHeroId = nil
    teamData.__teamUID = fInfo.teamUid
    teamData.__AP = fInfo.point
    teamData:UpdateTeamNumericDiff(fInfo.formationNumeric)
    teamData.__teamName = data.teamName
    teamData.__initialDeploy = fInfo.initial
    teamData.__treeId = fmtData.cstId
    local formationCfg = teamData:GetTeamFormationRuleCfg()
    local normalNum = formationCfg.stage_num
    local benchNum = formationCfg.bench_num
    for i = 1, normalNum + benchNum do
      local heroId = (fInfo.heroForms)[i]
      if heroId ~= nil then
        if teamData.__teamLeaderHeroId == nil then
          teamData.__teamLeaderHeroId = heroId
        end
        -- DECOMPILER ERROR at PC49: Confused about usage of register: R12 in 'UnsetPending'

        ;
        (teamData.__dynHeroDataOrderDic)[i] = heroId
      end
    end
    teamData.__dynPlayer = (WarChessDynPlayer.CreateDungeonPlayer)(teamData.__formationRuleCfg)
    ;
    (teamData.__dynPlayer):UpDateWCDynPlayerChipLimit(fInfo.algLimit)
    teamData.__clientIndex = fInfo.fromFormationIdx
    if fInfo.fromFormationIdx == 0 then
      teamData.__clientIndex = data.index
    end
    return teamData
  end
end

WarChessTeamData.UpdateWCTeamFormDiff = function(self, formDiff)
  -- function num : 0_3 , upvalues : _ENV
  local oldLader = self.__teamLeaderHeroId
  self.__dynHeroDataOrderDic = {}
  self.__teamLeaderHeroId = nil
  local formationCfg = self:GetTeamFormationRuleCfg()
  local normalNum = formationCfg.stage_num
  local benchNum = formationCfg.bench_num
  for heroIndex = 1, normalNum + benchNum do
    local heroId = (formDiff.update)[heroIndex]
    if heroId ~= nil then
      if self.__teamLeaderHeroId == nil then
        self.__teamLeaderHeroId = heroId
      end
      -- DECOMPILER ERROR at PC21: Confused about usage of register: R11 in 'UnsetPending'

      ;
      (self.__dynHeroDataOrderDic)[heroIndex] = heroId
    end
  end
  if self.__teamLeaderHeroId == nil then
    error("warchess team is empty, pls check index:" .. tostring(self:GetWCTeamIndex()))
  end
  if oldLader ~= self.__teamLeaderHeroId then
    return true
  end
end

WarChessTeamData.GetTeamDynPlayer = function(self)
  -- function num : 0_4
  return self.__dynPlayer
end

WarChessTeamData.GetWCTeamIndex = function(self)
  -- function num : 0_5
  return self.__index
end

WarChessTeamData.GetWCTeamClientIndex = function(self)
  -- function num : 0_6
  return self.__clientIndex
end

WarChessTeamData.GetWCTeamLogicPos = function(self)
  -- function num : 0_7
  return self.logicPos
end

WarChessTeamData.SetWCTeamLogicPos = function(self, logicPos)
  -- function num : 0_8
  self.logicPos = logicPos
end

WarChessTeamData.GetWCTeamServerPos = function(self)
  -- function num : 0_9 , upvalues : WarChessHelper
  return (WarChessHelper.Pos2Coordination)(self.logicPos)
end

WarChessTeamData.GetWCTeamId = function(self)
  -- function num : 0_10
  return self.__teamUID
end

WarChessTeamData.GetTeamActionPoint = function(self)
  -- function num : 0_11
  return self.__AP
end

WarChessTeamData.GetTeamCSTreeId = function(self)
  -- function num : 0_12
  return self.__treeId
end

WarChessTeamData.SetTeamActionPoint = function(self, ap)
  -- function num : 0_13 , upvalues : _ENV
  if ap == self.__AP then
    return 
  end
  self.__LastAP = self.__AP
  self.__AP = ap
  MsgCenter:Broadcast(eMsgEventId.WC_TeamAPChange, self)
end

WarChessTeamData.GetWCTeamIsGhost = function(self)
  -- function num : 0_14
  return self.__isGhost
end

WarChessTeamData.SetWCTeamIsGhost = function(self, isGhost)
  -- function num : 0_15
  self.__isGhost = isGhost
end

WarChessTeamData.GetWCTeamIsDead = function(self)
  -- function num : 0_16
  return self.__isDead
end

WarChessTeamData.SetWCTeamIsDead = function(self, isDead)
  -- function num : 0_17
  self.__isDead = isDead
end

WarChessTeamData.UpdateTeamChipDiff = function(self, alg)
  -- function num : 0_18 , upvalues : _ENV
  if (table.count)(alg) == 0 then
    return 
  end
  ;
  (table.clearmap)(self._chipAdd)
  ;
  (table.clearmap)(self._chipDel)
  for chipId,v in pairs(alg) do
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R7 in 'UnsetPending'

    if v == 0 then
      (self._chipDel)[chipId] = true
    else
      -- DECOMPILER ERROR at PC25: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (self._chipAdd)[chipId] = v
    end
  end
  ;
  (self.__dynPlayer):__UpdateAllChip(self._chipAdd, self._chipDel)
end

WarChessTeamData.GetWCTeamChipList = function(self)
  -- function num : 0_19
  local dynPlayer = self:GetTeamDynPlayer()
  return dynPlayer:GetChipList()
end

WarChessTeamData.GetWCTeamOrderDic = function(self)
  -- function num : 0_20
  return self.__dynHeroDataOrderDic
end

WarChessTeamData.SetWCTeamMoveableGirdDic = function(self, moveableGirdDic)
  -- function num : 0_21
  self.__moveableGirdDic = moveableGirdDic
end

WarChessTeamData.GetWCTeamMoveableGirdDic = function(self)
  -- function num : 0_22
  return self.__moveableGirdDic
end

WarChessTeamData.SetWCTeamInteractablePosDic = function(self, couldInterActPosDic)
  -- function num : 0_23
  self.__couldInterActPosDic = couldInterActPosDic
end

WarChessTeamData.GetWCTeamInteractablePosDic = function(self)
  -- function num : 0_24
  return self.__couldInterActPosDic
end

WarChessTeamData.SetWCTeamLevelNubDic = function(self, levelNubDic)
  -- function num : 0_25
  self.__levelNubDic = levelNubDic
end

WarChessTeamData.GetWCTeamLevelNubDic = function(self)
  -- function num : 0_26
  return self.__levelNubDic
end

WarChessTeamData.SetIsMoving = function(self, bool)
  -- function num : 0_27
  self.__IsMoving = bool
end

WarChessTeamData.GetIsMoving = function(self)
  -- function num : 0_28
  return self.__IsMoving
end

WarChessTeamData.SetMoveOverCallback = function(self, callback)
  -- function num : 0_29
  self.__MoveOverCallback = callback
end

WarChessTeamData.GetMoveOverCallback = function(self)
  -- function num : 0_30
  return self.__MoveOverCallback
end

WarChessTeamData.GetFirstHeroId = function(self)
  -- function num : 0_31
  return self.__teamLeaderHeroId
end

WarChessTeamData.GetWCTeamName = function(self)
  -- function num : 0_32
  return self.__teamName
end

WarChessTeamData.GetWCTeamDiffAP = function(self)
  -- function num : 0_33
  local changeNum = self.__AP - self.__LastAP
  self:ClearWCLastAP()
  return changeNum
end

WarChessTeamData.ClearWCLastAP = function(self)
  -- function num : 0_34
  self.__LastAP = self.__AP
end

WarChessTeamData.GenWCTeamHP = function(self)
  -- function num : 0_35 , upvalues : _ENV
  local wcDynPlayer = self:GetTeamDynPlayer()
  local count = 0
  local totalRate = 0
  for heroId,dynHero in pairs(wcDynPlayer.heroDic) do
    if not dynHero:IsBench() then
      count = count + 1
      totalRate = totalRate + dynHero.hpPer
    end
  end
  self.__totalHp = (totalRate) / (count) / 10000
end

WarChessTeamData.GetWCTeamHP = function(self)
  -- function num : 0_36
  return self.__totalHp
end

WarChessTeamData.RefreshWCTeamPower = function(self)
  -- function num : 0_37 , upvalues : _ENV
  (self.__dynPlayer):RefreshCacheFightPower()
  local curPower = (self.__dynPlayer):GetCacheFightPower()
  MsgCenter:Broadcast(eMsgEventId.WC_TeamPowerChange, self, curPower)
end

WarChessTeamData.GetWCTeamPower = function(self)
  -- function num : 0_38
  local curPower = (self.__dynPlayer):GetCacheFightPower()
  return curPower
end

WarChessTeamData.GetWCTeamHeroList = function(self)
  -- function num : 0_39
  return (self.__dynPlayer).heroList
end

WarChessTeamData.UpdateTeamNumericDiff = function(self, numericUpdate)
  -- function num : 0_40 , upvalues : _ENV, WarChessHelper
  if numericUpdate ~= nil then
    for type,value in pairs(numericUpdate) do
      -- DECOMPILER ERROR at PC9: Confused about usage of register: R7 in 'UnsetPending'

      if value == 0 then
        (self.__buffNumericDic)[type] = nil
      else
        -- DECOMPILER ERROR at PC12: Confused about usage of register: R7 in 'UnsetPending'

        ;
        (self.__buffNumericDic)[type] = value
      end
    end
  end
  do
    local curLimitMoveOneGrid = nil
    if (self.__buffNumericDic)[proto_object_WarChessNumeric.WarChessNumericLimitMoveOneGrid] ~= nil then
      curLimitMoveOneGrid = true
    else
      curLimitMoveOneGrid = false
    end
    if self.__limitMoveOneGrid ~= curLimitMoveOneGrid then
      self.__limitMoveOneGrid = curLimitMoveOneGrid
    end
    if (self.__buffNumericDic)[proto_object_WarChessNumeric.WarChessBuffCatAddLimitCombatHeroNumPoint] ~= nil then
      self:UpdateTeamFormationRule((self.__buffNumericDic)[proto_object_WarChessNumeric.WarChessBuffCatAddLimitCombatHeroNumPoint])
    end
    if numericUpdate[proto_object_WarChessNumeric.WarChessBuffCatAddChessMovePoint] ~= nil then
      local wcCtrl = WarChessManager:GetWarChessCtrl()
      local value = numericUpdate[proto_object_WarChessNumeric.WarChessBuffCatAddChessMovePoint]
      if value == 0 then
        self:SetTeamHeadIcon(nil)
      else
        local iconResId = (WarChessHelper.WCJumpChessType2HeadIconId)(value)
        self:SetTeamHeadIcon(iconResId)
      end
    end
  end
end

WarChessTeamData.GetTeamNumeric = function(self, type)
  -- function num : 0_41
  return (self.__buffNumericDic)[type]
end

WarChessTeamData.UpdateTeamFormationRule = function(self, extraCombatHeroNum)
  -- function num : 0_42 , upvalues : _ENV
  if self.__extraCombatHeroNum == extraCombatHeroNum then
    return 
  end
  local wcLevelCfg = WarChessManager:GetWCLevelCfg()
  local originalFormationRuleId = wcLevelCfg.start_formation
  self.__extraCombatHeroNum = extraCombatHeroNum
  local fmtRuleCfg = (ConfigData.formation_rule)[originalFormationRuleId]
  self.__formationRuleCfg = fmtRuleCfg
  local totalNum = fmtRuleCfg.stage_num + fmtRuleCfg.bench_num
  local newStageNum = fmtRuleCfg.stage_num + extraCombatHeroNum
  for k,v in pairs(ConfigData.formation_rule) do
    if v.stage_num == newStageNum and v.stage_num + v.bench_num == totalNum then
      self.__formationRuleCfg = v
      self:UpdateDynHeroByFromationRuleChange()
      return 
    end
  end
end

WarChessTeamData.UpdateDynHeroByFromationRuleChange = function(self)
  -- function num : 0_43
  if self.__dynPlayer ~= nil then
    (self.__dynPlayer):SetPlayerFormationRuleCfg(self.__formationRuleCfg)
    ;
    (self.__dynPlayer):UpdateDynHerosDeployPos()
  end
end

WarChessTeamData.GetIsLimitMoveOneGrid = function(self)
  -- function num : 0_44
  return self.__limitMoveOneGrid
end

WarChessTeamData.GetCouldWalkLength = function(self)
  -- function num : 0_45
  if self.__limitMoveOneGrid then
    return 1
  end
  return nil
end

WarChessTeamData.GetSetInitialDeploy = function(self)
  -- function num : 0_46
  if self.__initialDeploy then
    self.__initialDeploy = false
    return true
  end
  return false
end

WarChessTeamData.SetTeamHeadIcon = function(self, headId)
  -- function num : 0_47
  self.__headIconOverraidId = headId
end

WarChessTeamData.GetTeamHeadIcon = function(self)
  -- function num : 0_48
  return self.__headIconOverraidId
end

WarChessTeamData.GetTeamFormationRuleCfg = function(self)
  -- function num : 0_49
  if self.__formationRuleCfg == nil then
    self:UpdateTeamFormationRule(0)
  end
  return self.__formationRuleCfg
end

WarChessTeamData.SetEarlySettedPos = function(self, pos)
  -- function num : 0_50
  self.__earlySetPos = pos
end

WarChessTeamData.GetEarlySettedPos = function(self)
  -- function num : 0_51
  return self.__earlySetPos
end

return WarChessTeamData

