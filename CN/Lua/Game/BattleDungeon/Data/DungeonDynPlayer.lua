-- params : ...
-- function num : 0 , upvalues : _ENV
local DynPlayer = require("Game.Exploration.Data.DynPlayer")
local DungeonDynPlayer = class("DungeonDynPlayer", DynPlayer)
local DynHero = require("Game.Exploration.Data.DynHero")
local ChipData = require("Game.PlayerData.Item.ChipData")
local DynEpBuffChip = require("Game.Exploration.Data.DynEpBuffChip")
local HeroData = require("Game.PlayerData.Hero.HeroData")
local DynBattleSkill = require("Game.Exploration.Data.DynBattleSkill")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local DynBuff = require("Game.Exploration.Data.DynBuff")
local DeployTeamUtil = require("Game.Exploration.Util.DeployTeamUtil")
DungeonDynPlayer.ctor = function(self)
  -- function num : 0_0
  self.dungeonBuffList = {}
  self.dungeonBuffCfgList = {}
  self.dungeonBuffDataList = {}
end

DungeonDynPlayer.CreateDungeonPlayer = function(lastDeployData, formationRuleCfg)
  -- function num : 0_1 , upvalues : DungeonDynPlayer
  local player = (DungeonDynPlayer.New)()
  player.__lastHeroPos = lastDeployData and lastDeployData.hero_pos or nil
  player:SetPlayerFormationRuleCfg(formationRuleCfg)
  return player
end

DungeonDynPlayer.InitDynPlayer = function(self, roles, dungeonCfg, playerData, treeId)
  -- function num : 0_2 , upvalues : _ENV, DeployTeamUtil
  local heroDatas = {}
  for k,v in pairs(roles) do
    heroDatas[(v.stc).dataId] = v.stc
  end
  self:InitHeroTeam(roles)
  self.playerSkillMp = (playerData.dyc).mp
  self.playerUltSkillMp = (playerData.dyc).hmp
  self:InitPlayerSkill((playerData.stc).skillGroup, treeId)
  ;
  (DeployTeamUtil.DeployHeroTeam)(self.heroList, dungeonCfg.size_row, dungeonCfg.size_col, dungeonCfg.deploy_rows, self.__lastHeroPos)
  self:__UpdateCoordInBattleEditor()
  self:UpdateHeroAttr(heroDatas)
end

DungeonDynPlayer.InitHeroTeam = function(self, roles)
  -- function num : 0_3 , upvalues : _ENV, HeroData, DynHero
  self.heroList = {}
  self.heroDic = {}
  local tmpHeroIndexDic = {}
  local battleRoleCount = self:GetEnterFiledNum()
  for uid,battleRole in pairs(roles) do
    local heroTeamIndex = (battleRole.dyc).formationIdx
    local roleType = battleRole.roleType
    local heroCfg = (ConfigData.hero_data)[(battleRole.stc).dataId]
    local heroData = (HeroData.New)({
basic = {id = (battleRole.stc).dataId, level = (battleRole.stc).level, exp = 0, star = (battleRole.stc).rank, potentialLvl = (battleRole.stc).potential, ts = -1, career = heroCfg.career, company = heroCfg.camp, skinId = (battleRole.stc).skinId, cat = (battleRole.stc).cat, serverModel = (battleRole.dyc).model}
, spWeapon = (battleRole.stc).specWeapon})
    for k,v in pairs((battleRole.stc).skillGroup) do
      if (heroData.skillDic)[k] ~= nil then
        ((heroData.skillDic)[k]):UpdateSkill(v)
      end
    end
    local dynHeroData = (DynHero.New)(heroData, (battleRole.stc).uid, roleType)
    dynHeroData:SetDynHeroFmtIdx(heroTeamIndex)
    dynHeroData:SetDynHeroTalentLevel((battleRole.stc).talent)
    dynHeroData:SetExtraFixedPower((battleRole.stc).talentEfficiency)
    dynHeroData:InitDynHeroBenchByFmtIdx(battleRoleCount)
    dynHeroData:UpdateHpPer((battleRole.dyc).hpPer)
    -- DECOMPILER ERROR at PC96: Confused about usage of register: R14 in 'UnsetPending'

    ;
    (self.heroDic)[heroData.dataId] = dynHeroData
    tmpHeroIndexDic[dynHeroData] = heroTeamIndex
    ;
    (table.insert)(self.heroList, dynHeroData)
  end
  ;
  (table.sort)(self.heroList, function(hero1, hero2)
    -- function num : 0_3_0 , upvalues : tmpHeroIndexDic
    do return tmpHeroIndexDic[hero1] < tmpHeroIndexDic[hero2] end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  self:InitMirrorHeroTeam()
end

DungeonDynPlayer.InitPlayerSkillCustom = function(self, playerSkillDic, CSTId)
  -- function num : 0_4 , upvalues : _ENV, DynBattleSkill
  self.playerOriginSkillList = {}
  self.playerExtraSkillDic = {}
  self.CSTId = CSTId
  if playerSkillDic ~= nil then
    for k,skillId in pairs(playerSkillDic) do
      local data = (DynBattleSkill.New)(skillId, 1, eBattleSkillLogicType.Original)
      ;
      (table.insert)(self.playerOriginSkillList, data)
      -- DECOMPILER ERROR at PC29: Confused about usage of register: R9 in 'UnsetPending'

      if ((ConfigData.commander_skill_unlock).cs_skill_dic)[skillId] == nil then
        (self.playerExtraSkillDic)[skillId] = 1
      end
    end
  end
end

DungeonDynPlayer.__UpdateCoordInBattleEditor = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if BattleEditorManager ~= nil and BattleEditorManager.DeployFormation then
    BattleEditorManager:DeployTeam(self.heroList)
  end
end

DungeonDynPlayer.UpdateDungeonBuff = function(self, buffGroupMsg)
  -- function num : 0_6 , upvalues : _ENV, DynBuff
  if buffGroupMsg == nil then
    return 
  end
  self.dungeonBuffCfgList = {}
  self.dungeonBuffDataList = {}
  self.dungeonBuffList = buffGroupMsg
  for _,dunBuffId in ipairs(buffGroupMsg) do
    local buffCfg = (ConfigData.dungeon_buff)[dunBuffId]
    if buffCfg == nil then
      error("can\'t get dunbuffCfg with id" .. tostring(dunBuffId))
    else
      ;
      (table.insert)(self.dungeonBuffCfgList, buffCfg)
      local dynBuffData = (DynBuff.CreateByDungeonLevel)(dunBuffId, buffCfg)
      ;
      (table.insert)(self.dungeonBuffDataList, dynBuffData)
    end
  end
end

DungeonDynPlayer.GetDungeonBuff = function(self)
  -- function num : 0_7
  return self.dungeonBuffList, self.dungeonBuffCfgList
end

DungeonDynPlayer.GetDungeonBuffDataList = function(self)
  -- function num : 0_8
  return self.dungeonBuffDataList
end

return DungeonDynPlayer

