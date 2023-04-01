-- params : ...
-- function num : 0 , upvalues : _ENV
local DynBattleRole = require("Game.Exploration.Data.DynBattleRole")
local DynBattleSkill = require("Game.Exploration.Data.DynBattleSkill")
local DynHero = class("DynHero", DynBattleRole)
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
DynHero.ctor = function(self, heroData, uid, rolType)
  -- function num : 0_0
  self.onBench = false
  self:InitDynHeroData(heroData, uid, rolType)
end

DynHero.InitDynHeroData = function(self, heroData, uid, rolType)
  -- function num : 0_1 , upvalues : _ENV, ExplorationEnum
  local skinId = (PlayerDataCenter.skinData):DealNotSelfHaveHeroSkinOverraid(heroData.skinId, heroData.dataId)
  heroData:UpdateSkin(skinId)
  self.heroData = heroData
  self.heroCfg = heroData.heroCfg
  self.dataId = (self.heroCfg).id
  if not rolType then
    self.rolType = proto_object_EplBattleRoleType.BattleRoleNormal
    self.cat = heroData.cat
    self.rank = heroData.star
    if not heroData.modelSpecSign then
      self.modelSpecSign = heroData:GetHeroIsNotHaveLegalSkin()
      self.isTowerAbandonMove = self.cat == (BattleUtil.battleRoleCat).waitToCasterHero
      if not uid then
        self.uid = self.dataId
        self.resCfg = (ConfigData.resource_model)[(self.heroCfg).src_id]
        if self.resCfg == nil then
          error("resource model cfg is null,id:" .. tostring((self.heroCfg).src_id))
          return 
        end
        self.totalDamage = 0
        self.belong = eBattleRoleBelong.player
        self.attackRange = (self.heroCfg).range
        self.moveSpeed = (self.heroCfg).move_spd
        self.intensity = (self.heroCfg).intensity
        self.hpPer = ExplorationEnum.eHeroHpPercent
        self.baseAttr = {}
        self.ratioAttr = {}
        self.extraAttr = {}
        self.isContainAction = true
        self.death_frames = (self.resCfg).death_frames
        self.priority = 1
        self:InitTowerHeroData()
        -- DECOMPILER ERROR: 3 unprocessed JMP targets
      end
    end
  end
end

DynHero.InitTowerHeroData = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.cat == (BattleUtil.battleRoleCat).waitToCasterHero then
    local towerCfg = (ConfigData.tower_hero_data)[self.dataId]
    if towerCfg == nil then
      error("找不到指定id的塔防角色:" .. self.dataId)
      return 
    end
    self.towerCostFormula = towerCfg.coin_cost_formula
    self.towerCdFormula = towerCfg.cd_formula
    self.towerOnSaleFormula = towerCfg.sell_formula
  end
end

DynHero.UpdateBaseHeroData = function(self, attrDic, baseSkillDic, athSkillGroup, additionSkillGroup, rawAttr)
  -- function num : 0_3 , upvalues : _ENV, DynBattleSkill
  if self.heroData == nil then
    return 
  end
  self.originAttr = {}
  for i = 2, eHeroAttr.max_property_count + 1 do
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R10 in 'UnsetPending'

    (self.originAttr)[i - 1] = attrDic[i]
  end
  local inTd = (BattleUtil.IsInTDBattle)()
  self.originSkillList = {}
  self.showSkillDic = {}
  for skillId,skillLevel in pairs(baseSkillDic) do
    local heroSkill = ((self.heroData).skillDic)[skillId]
    if heroSkill == nil then
      warn((string.format)("Cant get client heroSkill, skill id = %s, heroId = %s", skillId, (self.heroData).dataId))
    else
      if skillLevel ~= heroSkill.level then
        warn((string.format)("Client heroSkill level is different, skill id = %s, heroId = %s, clientLevel = %s, serverLevel = %s", skillId, (self.heroData).dataId, heroSkill.level, skillLevel))
      end
      if inTd then
        local battleSkill = self:__GetTdBattleAdapterSkill(skillId, skillLevel, heroSkill)
        if battleSkill ~= nil then
          (table.insert)(self.originSkillList, battleSkill)
          -- DECOMPILER ERROR at PC72: Confused about usage of register: R14 in 'UnsetPending'

          ;
          (self.showSkillDic)[skillId] = battleSkill
        else
          do
            do
              local battleSkill = (DynBattleSkill.New)(skillId, skillLevel, eBattleSkillLogicType.Original, heroSkill:IsSkillUnlockAdvance())
              battleSkill:SetIsFullLevel(heroSkill:IsFullLevel())
              ;
              (table.insert)(self.originSkillList, battleSkill)
              -- DECOMPILER ERROR at PC92: Confused about usage of register: R14 in 'UnsetPending'

              ;
              (self.showSkillDic)[skillId] = battleSkill
              -- DECOMPILER ERROR at PC93: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC93: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC93: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC93: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC93: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC93: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC93: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
  for skillId,heroSkill in pairs((self.heroData).skillDic) do
    if (self.showSkillDic)[skillId] == nil then
      local skillLevel = heroSkill.level
      if inTd then
        local battleSkill = self:__GetTdBattleAdapterSkill(skillId, skillLevel, heroSkill)
        -- DECOMPILER ERROR at PC115: Confused about usage of register: R14 in 'UnsetPending'

        if battleSkill ~= nil then
          (self.showSkillDic)[skillId] = battleSkill
        else
          do
            do
              local battleSkill = (DynBattleSkill.New)(skillId, skillLevel, eBattleSkillLogicType.Original, heroSkill:IsSkillUnlockAdvance())
              battleSkill:SetIsFullLevel(heroSkill:IsFullLevel())
              -- DECOMPILER ERROR at PC130: Confused about usage of register: R14 in 'UnsetPending'

              ;
              (self.showSkillDic)[skillId] = battleSkill
              -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
  self:RemoveItemSkillTypeDic(eBattleSkillLogicFreshRemove)
  if athSkillGroup ~= nil then
    for athSkillId,_ in pairs(athSkillGroup) do
      local skillLevel = 1
      local skillData = (DynBattleSkill.New)(athSkillId, skillLevel, eBattleSkillLogicType.AthSuit)
      self:AddItemSkill(skillData)
    end
  end
  do
    if additionSkillGroup ~= nil then
      for athSkillId,_ in pairs(additionSkillGroup) do
        local skillLevel = 1
        local skillData = (DynBattleSkill.New)(athSkillId, skillLevel, eBattleSkillLogicType.ExtraAdd)
        self:AddItemSkill(skillData)
      end
    end
    do
      self.rawAttr = rawAttr
    end
  end
end

DynHero.__GetTdBattleAdapterSkill = function(self, skillId, skillLevel, heroSkill)
  -- function num : 0_4 , upvalues : _ENV, ExplorationEnum, DynBattleSkill
  local tdSkillCfg = (ConfigData.skill_adapter)[(ExplorationEnum.SpecGameTypeAdapter).TD]
  local skillAdapterCfg = nil
  if tdSkillCfg ~= nil then
    skillAdapterCfg = tdSkillCfg[skillId]
  end
  if skillAdapterCfg ~= nil and skillAdapterCfg.lock_type > 0 then
    local realSkillId = skillAdapterCfg.skill_id_new
    local battleSkill = (DynBattleSkill.New)(realSkillId, skillLevel, eBattleSkillLogicType.Original, heroSkill:IsSkillUnlockAdvance())
    battleSkill:SetIsFullLevel(heroSkill:IsFullLevel())
    battleSkill:SetSkillAdapterType(skillAdapterCfg.lock_type)
    return battleSkill
  end
  do
    return nil
  end
end

DynHero.GetClientOriginAttr = function(self, attrId)
  -- function num : 0_5 , upvalues : _ENV
  if self.heroData == nil then
    return 0
  end
  if (ConfigData.attribute)[attrId] == nil or (ConfigData.attribute)[attrId + 100] == nil or (ConfigData.attribute)[attrId + 200] == nil then
    return 0
  end
  return (self.heroData):GetAttr(attrId)
end

DynHero.GetName = function(self)
  -- function num : 0_6 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.heroCfg).name)
end

DynHero.GetCareer = function(self)
  -- function num : 0_7
  return (self.heroCfg).career
end

DynHero.GetCamp = function(self)
  -- function num : 0_8
  return (self.heroCfg).camp
end

DynHero.GetResPicName = function(self)
  -- function num : 0_9
  return (self.heroData):GetResPicName()
end

DynHero.GetResModelName = function(self, isDefault)
  -- function num : 0_10
  return (self.heroData):GetResModelName(isDefault)
end

DynHero.GetExtendResName = function(self)
  -- function num : 0_11
  return (self.heroData):GetExtendResName()
end

DynHero.GetResSrcId = function(self)
  -- function num : 0_12
  return (self.heroCfg).src_id
end

DynHero.GetSkinId = function(self)
  -- function num : 0_13
  return (self.heroData).skinId or 0
end

DynHero.GetLevel = function(self)
  -- function num : 0_14
  return (self.heroData).level
end

DynHero.GetCurExp = function(self)
  -- function num : 0_15
  return (self.heroData).curExp
end

DynHero.GetTotalExp = function(self)
  -- function num : 0_16
  return (self.heroData):GetLevelTotalExp()
end

DynHero.GetStar = function(self)
  -- function num : 0_17
  return (self.heroData).star
end

DynHero.UpdateTotalDamage = function(self, totalDamage)
  -- function num : 0_18
  self.totalDamage = totalDamage
end

DynHero.GetID = function(self)
  -- function num : 0_19
  return self.dataId
end

DynHero.IsBench = function(self)
  -- function num : 0_20
  if self._battleOnBench ~= nil then
    return self._battleOnBench
  end
  return self.onBench
end

DynHero.IsSupport = function(self)
  -- function num : 0_21 , upvalues : _ENV
  do return self.rolType == proto_object_EplBattleRoleType.BattleRoleAssist end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DynHero.IsFriendSupport = function(self)
  -- function num : 0_22 , upvalues : _ENV
  do return self.rolType == proto_object_EplBattleRoleType.BattleRoleFriendAssist end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DynHero.SetDynHeroFmtIdx = function(self, fmtInx)
  -- function num : 0_23
  self.fmtInx = fmtInx
end

DynHero.GetDynHeroFmtIdx = function(self)
  -- function num : 0_24
  return self.fmtInx
end

DynHero.SetDynHeroTalentLevel = function(self, talentLevel)
  -- function num : 0_25
  self._talentLevel = talentLevel
end

DynHero.GetDynHeroTalentLevel = function(self)
  -- function num : 0_26
  return self._talentLevel
end

DynHero.InitDynHeroBenchByFmtIdx = function(self, maxStageNum)
  -- function num : 0_27
  self.onBench = maxStageNum < self.fmtInx
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DynHero.GetTowerCastCostFormula = function(self)
  -- function num : 0_28
  return self.towerCostFormula
end

DynHero.GetTowerCastCdFormula = function(self)
  -- function num : 0_29
  return self.towerCdFormula
end

DynHero.GetTowerLoadOffFormula = function(self)
  -- function num : 0_30
  return self.towerOnSaleFormula
end

return DynHero

