-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonDyncElemDataBase = class("DungeonDyncElemDataBase")
local DungeonDyncEnum = require("Game.Dungeon.Dync.DungeonDyncEnum")
local FormationUtil = require("Game.Formation.FormationUtil")
DungeonDyncElemDataBase.CreateDefaultDungeonDyncElemData = function(class, moduleId)
  -- function num : 0_0
  local data = (class.New)()
  data:_InitData(nil, true, moduleId)
  return data
end

DungeonDyncElemDataBase.ctor = function(self)
  -- function num : 0_1 , upvalues : DungeonDyncEnum
  self._dyncType = (DungeonDyncEnum.DgDyncType).None
end

DungeonDyncElemDataBase._GenDungeonDyncElemProtoMsgDefault = function(self, moduleId)
  -- function num : 0_2 , upvalues : DungeonDyncEnum, FormationUtil
  local dungeonType = (DungeonDyncEnum.DgDyncType2DungeonTypeDic)[self._dyncType]
  local defaultFmtId = (FormationUtil.GetFmtIdByDungeonType)(dungeonType, 1)
  local msg = {moduleId = moduleId, idx = 0, 
selectedChipGroup = {}
, 
charHpPer = {}
, 
monsterHpPer = {}
, formId = defaultFmtId, 
lastChipGroup = {}
, astDync = nil}
  return msg
end

DungeonDyncElemDataBase._InitData = function(self, msg, isDailyDungeonNew, newModuleId)
  -- function num : 0_3
  if isDailyDungeonNew then
    msg = self:_GenDungeonDyncElemProtoMsgDefault(newModuleId)
  end
  self.moduleId = msg.moduleId
  self.idx = msg.idx
  self.selectedChipGroup = msg.selectedChipGroup
  self.charHpPer = msg.charHpPer
  self.lastChipGroup = msg.lastChipGroup
  self._removeAstDync = self.astDync ~= nil and msg.astDync == nil
  self.astDync = msg.astDync
  self.isDailyDungeonNew = isDailyDungeonNew
  self.failed = msg.failed
  self:_ClearDeadHero()
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DungeonDyncElemDataBase._CheckLastChipGroup = function(self)
  -- function num : 0_4
end

DungeonDyncElemDataBase._ClearDeadHero = function(self)
  -- function num : 0_5 , upvalues : DungeonDyncEnum, FormationUtil, _ENV
  if self.isDailyDungeonNew then
    return 
  end
  local dungeonType = (DungeonDyncEnum.DgDyncType2DungeonTypeDic)[self._dyncType]
  local fmtIdOffset = (FormationUtil.GetFmtIdOffsetByDungeonType)(dungeonType)
  for i = 1, (ConfigData.game_config).formationCount do
    local fmtId = i + fmtIdOffset
    local formationData = (PlayerDataCenter.formationDic)[fmtId]
    if formationData ~= nil then
      local deadHeroDic = {}
      for heroId,hp in pairs(self.charHpPer) do
        if hp == 0 then
          deadHeroDic[heroId] = true
        end
      end
      formationData:SetFmtExcludeHeroIdDic(deadHeroDic)
      if self._removeAstDync or self:HasDgDyncLastAstHero() and self:GetDgDyncLastAstHeroHpPer() == 0 then
        formationData:CleanSupportData()
      end
    end
  end
end

DungeonDyncElemDataBase.ClearDungeonDyncElemFmtExclude = function(self)
  -- function num : 0_6 , upvalues : DungeonDyncEnum, FormationUtil, _ENV
  if self.isDailyDungeonNew then
    return 
  end
  local dungeonType = (DungeonDyncEnum.DgDyncType2DungeonTypeDic)[self._dyncType]
  local fmtIdOffset = (FormationUtil.GetFmtIdOffsetByDungeonType)(dungeonType)
  for i = 1, (ConfigData.game_config).formationCount do
    local fmtId = i + fmtIdOffset
    local formationData = (PlayerDataCenter.formationDic)[fmtId]
    if formationData ~= nil then
      formationData:ClearFmtExcludeHeroIdDic()
      formationData:CleanSupportData()
    end
  end
end

DungeonDyncElemDataBase.UpdDungeonDyncElemData = function(self, msg)
  -- function num : 0_7
  self:_InitData(msg)
end

DungeonDyncElemDataBase.GetDungeonDyncHeroHpPer = function(self, heroData)
  -- function num : 0_8
  local hpPer = nil
  -- DECOMPILER ERROR at PC8: Unhandled construct in 'MakeBoolean' P1

  if heroData.isFriendSupport and self.astDync ~= nil then
    hpPer = (self.astDync).hpPer
  end
  hpPer = (self.charHpPer)[heroData.dataId]
  if not hpPer then
    hpPer = 10000
  end
  return hpPer
end

DungeonDyncElemDataBase.HasDgDyncLastAstHero = function(self)
  -- function num : 0_9
  do return self.astDync ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DungeonDyncElemDataBase.GetDgDyncLastAstHeroHpPer = function(self)
  -- function num : 0_10
  if not self:HasDgDyncLastAstHero() then
    return 0
  end
  return (self.astDync).hpPer
end

DungeonDyncElemDataBase.GetDgDyncAscHeroData = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if self.astDync == nil then
    error("self.astDync is nil")
    return nil
  end
  return (self.astDync).brief, (self.astDync).random
end

DungeonDyncElemDataBase.IsDgDyncComplete = function(self)
  -- function num : 0_12
end

DungeonDyncElemDataBase.SetDgDyncElemLastChipGroup = function(self, lastChipGroup)
  -- function num : 0_13
  self.lastChipGroup = lastChipGroup
end

DungeonDyncElemDataBase.GetDgDyncElemName = function(self)
  -- function num : 0_14
end

DungeonDyncElemDataBase.DgDyncIsHaveMultReward = function(self)
  -- function num : 0_15
end

DungeonDyncElemDataBase.IsFailInDgBattle = function(self)
  -- function num : 0_16
  return self.failed
end

return DungeonDyncElemDataBase

