-- params : ...
-- function num : 0 , upvalues : _ENV
local DynChipHolder = require("Game.Exploration.Data.DynChipHolder")
local DynBattleRole = class("DynBattleRole", DynChipHolder)
local cs_GameData = (CS.GameData).instance
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local HeroAttrUtility = require("Game.Exploration.Data.HeroAttrUtility")
local DynBattleSkill = require("Game.Exploration.Data.DynBattleSkill")
DynBattleRole.ctor = function(self)
  -- function num : 0_0
  self.fightingPower = 0
  self.modelSpecSign = 0
  self.breakId = 0
  self.__monsterLableId = nil
  self.__monsterLableCfg = nil
end

DynBattleRole.SetCoord = function(self, coord, benchRow)
  -- function num : 0_1 , upvalues : _ENV
  self.coord = coord
  self.x = (BattleUtil.Pos2XYCoord)(coord)
  if benchRow > self.x then
    self.onBench = not benchRow
    self.onBench = false
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

DynBattleRole.SetCoordXY = function(self, x, y, benchRow)
  -- function num : 0_2 , upvalues : _ENV
  self.coord = (BattleUtil.XYCoord2Pos)(x, y)
  self.x = x
  self.y = y
  if benchRow > self.x then
    self.onBench = not benchRow
    self.onBench = false
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

DynBattleRole.SetBattleBench = function(self, onbench)
  -- function num : 0_3
  self._battleOnBench = onbench
end

DynBattleRole.ResetBattleBench = function(self)
  -- function num : 0_4
  self._battleOnBench = nil
end

DynBattleRole.GetName = function(self)
  -- function num : 0_5
end

DynBattleRole.GetCareer = function(self)
  -- function num : 0_6
end

DynBattleRole.GetCamp = function(self)
  -- function num : 0_7
end

DynBattleRole.GetResPicName = function(self)
  -- function num : 0_8
end

DynBattleRole.GetResModelName = function(self, isDefault)
  -- function num : 0_9
end

DynBattleRole.GetExtendResName = function(self)
  -- function num : 0_10
end

DynBattleRole.GetResSrcId = function(self)
  -- function num : 0_11
end

DynBattleRole.GetSkinId = function(self)
  -- function num : 0_12
  return 0
end

DynBattleRole.GetOvrideBindPoints = function(self)
  -- function num : 0_13
  if self.resCfg == nil then
    return nil
  end
  return (self.resCfg).overide_bind_point
end

DynBattleRole.GetCarrerIcon = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local careerId = self:GetCareer()
  local career = (ConfigData.career)[careerId]
  if career == nil then
    return nil
  end
  return career.icon
end

DynBattleRole.GetCampIcon = function(self)
  -- function num : 0_15 , upvalues : _ENV
  local campId = self:GetCamp()
  local camp = (ConfigData.camp)[campId]
  if camp == nil then
    return nil
  end
  return camp.icon
end

DynBattleRole.GetOriginSkillList = function(self)
  -- function num : 0_16
  return self.originSkillList
end

DynBattleRole.OffsetAttrFromChip = function(self, property, value)
  -- function num : 0_17 , upvalues : HeroAttrUtility
  (HeroAttrUtility.OffsetAttrFromDynHero)(self, property, value)
end

DynBattleRole.UpdateHpPer = function(self, hpPer)
  -- function num : 0_18
  self.hpPer = hpPer
end

DynBattleRole.SetExtraAttr = function(self, attrId, value)
  -- function num : 0_19 , upvalues : _ENV
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.extraAttr)[attrId] = value
  if attrId == eHeroAttr.maxHp then
    self.maxHp = self:GetRealAttr(eHeroAttr.maxHp)
  end
end

DynBattleRole.SetBaseAttr = function(self, attrId, value)
  -- function num : 0_20 , upvalues : _ENV
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.baseAttr)[attrId] = value
  if attrId == eHeroAttr.maxHp then
    self.maxHp = self:GetRealAttr(eHeroAttr.maxHp)
  end
end

DynBattleRole.SetRatioAttr = function(self, attrId, value)
  -- function num : 0_21 , upvalues : _ENV
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.ratioAttr)[attrId] = value
  if attrId == eHeroAttr.maxHp then
    self.maxHp = self:GetRealAttr(eHeroAttr.maxHp)
  end
end

DynBattleRole.GetClientOriginAttr = function(self, attrId)
  -- function num : 0_22
  return 0
end

DynBattleRole.GetOriginAttr = function(self, attrId)
  -- function num : 0_23
  return (self.originAttr)[attrId] or 0
end

DynBattleRole.GetBaseAttr = function(self, attrId)
  -- function num : 0_24
  return (self.baseAttr)[attrId] or 0
end

DynBattleRole.GetRatioAttr = function(self, attrId)
  -- function num : 0_25
  return (self.ratioAttr)[attrId] or 0
end

DynBattleRole.GetExtraAttr = function(self, attrId)
  -- function num : 0_26
  return (self.extraAttr)[attrId] or 0
end

DynBattleRole.GetRealAttr = function(self, attrId)
  -- function num : 0_27 , upvalues : _ENV
  return (((self.originAttr)[attrId] or 0) + ((self.baseAttr)[attrId] or 0)) * (eHeroAttrPercent + ((self.ratioAttr)[attrId] or 0)) // eHeroAttrPercent + ((self.extraAttr)[attrId] or 0)
end

DynBattleRole.CopyAttrFromBattleCharacterEntity = function(self, entity)
  -- function num : 0_28
  for i = 0, (entity.originAttrList).Length - 1 do
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R6 in 'UnsetPending'

    (self.originAttr)[i] = (entity.originAttrList)[i]
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.baseAttr)[i] = (entity.baseAttrList)[i]
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.ratioAttr)[i] = (entity.ratioAttrList)[i]
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.extraAttr)[i] = (entity.extraAttrList)[i]
  end
  local hp = entity.hp
  local hpPer = hp * 10000 // entity.maxHp
  if hpPer == 0 and hp > 0 then
    hpPer = 1
  end
  self.hpPer = hpPer
end

DynBattleRole.GetFormulaAttr = function(self, attrId)
  -- function num : 0_29 , upvalues : _ENV, ExplorationEnum
  if attrId == eHeroAttr.hp then
    local maxHp = self:GetRealAttr(eHeroAttr.maxHp)
    local hp = self.hpPer * maxHp // ExplorationEnum.eHeroHpPercent
    if hp == 0 and self.hpPer > 0 then
      hp = 1
    end
    return hp
  else
    do
      if attrId == eHeroAttr.attack_range then
        return self.attackRange
      else
        return self:GetRealAttr(attrId)
      end
    end
  end
end

DynBattleRole.GetSkillFightingPower = function(self, heroPower)
  -- function num : 0_30 , upvalues : _ENV
  local skillList = {}
  local skillDic = {}
  if self.originSkillList ~= nil then
    for k,v in pairs(self.originSkillList) do
      (table.insert)(skillList, v)
      skillDic[v.dataId] = v
    end
  end
  do
    if self.__itemSkillDic ~= nil then
      for k,v in pairs(self.__itemSkillDic) do
        local oldSkill = skillDic[k.dataId]
        if oldSkill == nil or oldSkill.level < k.level then
          if oldSkill then
            (table.removebyvalue)(skillList, oldSkill)
          end
          ;
          (table.insert)(skillList, k)
          skillDic[k.dataId] = k
        end
      end
    end
    do
      local fightingPower = 0
      for k,battleSkill in pairs(skillList) do
        local battleCfg = (ConfigData.battle_skill)[battleSkill.dataId]
        if battleSkill.type ~= eBattleSkillLogicType.Chip and battleSkill.type ~= eBattleSkillLogicType.TempChip then
          local isChipType = battleCfg == nil or battleCfg.skill_comat == ""
          do
            local power = PlayerDataCenter:GetBattleSkillFightPower(battleSkill.dataId, battleSkill.level, heroPower, isChipType)
            fightingPower = fightingPower + power
            -- DECOMPILER ERROR at PC83: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC83: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
      do return fightingPower end
      -- DECOMPILER ERROR: 2 unprocessed JMP targets
    end
  end
end

DynBattleRole.GetFightingPower = function(self, fullHp)
  -- function num : 0_31 , upvalues : _ENV
  if self.originAttr == nil then
    warn("GetFightingPower:originAttr is nil")
    return 0
  end
  local attrDic = self:GetDynBattleRoleAttrDic()
  local heroPower = 0
  if fullHp then
    heroPower = (ConfigData.GetFormulaValue)(eFormulaType.Hero, attrDic)
  else
    if self.belong == eBattleRoleBelong.enemy then
      heroPower = (ConfigData.GetFormulaValue)(eFormulaType.BattleHeroEnemy, attrDic)
    else
      heroPower = (ConfigData.GetFormulaValue)(eFormulaType.BattleHero, attrDic)
    end
  end
  local fightingPower = heroPower + self:GetSkillFightingPower(heroPower)
  fightingPower = (math.floor)(fightingPower)
  fightingPower = fightingPower + (self._extraFixedPower or 0)
  self.fightingPower = fightingPower
  return fightingPower
end

DynBattleRole.GetDynBattleRoleAttrDic = function(self)
  -- function num : 0_32 , upvalues : _ENV
  local attrDic = (table.GetDefaulValueTable)(0)
  for i = 1, (ConfigData.attribute).maxPropertyId - 1 do
    attrDic[i] = self:GetFormulaAttr(i)
  end
  return attrDic
end

DynBattleRole.GetAttackRangeType = function(self)
  -- function num : 0_33
  if self.attackRange > 1 then
    return 2
  else
    return 1
  end
end

DynBattleRole.IsDead = function(self)
  -- function num : 0_34
  do return self.hpPer <= 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DynBattleRole.SetExtraFixedPower = function(self, combat)
  -- function num : 0_35
  self._extraFixedPower = combat
end

DynBattleRole.GetExtraFixedPower = function(self)
  -- function num : 0_36
  return self._extraFixedPower
end

DynBattleRole.GetTowerCastCdFormula = function(self)
  -- function num : 0_37
  return 0
end

DynBattleRole.GetMonsterDieRewardFormula = function(self)
  -- function num : 0_38
  return 0
end

DynBattleRole.GetTowerCastCostFormula = function(self)
  -- function num : 0_39
  return 0
end

DynBattleRole.GetTowerLoadOffFormula = function(self)
  -- function num : 0_40
  return 0
end

DynBattleRole.GetRawAttr = function(self, rawAttributionID)
  -- function num : 0_41
  if self.rawAttr == nil then
    return 0
  end
  return (self.rawAttr)[rawAttributionID] or 0
end

DynBattleRole.GetStandardMoveSpd = function(self)
  -- function num : 0_42
  return (self.resCfg).base_move_spd
end

DynBattleRole.SetMonsterLableId = function(self, monsterLableId)
  -- function num : 0_43 , upvalues : _ENV
  if monsterLableId == nil or monsterLableId <= 0 then
    return 
  end
  self.__monsterLableId = monsterLableId
  self.__monsterLableCfg = (ConfigData.monster_lable)[monsterLableId]
  if self.__monsterLableCfg == nil then
    error("monsterLableCfg not exist lableId:" .. tostring(monsterLableId))
    return 
  end
  self:__GenMonsterLableSkills()
end

DynBattleRole.GetIsHaveMonsterLable = function(self)
  -- function num : 0_44
  do return self.__monsterLableId ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DynBattleRole.GetMonsterLableIsHideAfterStartBattle = function(self)
  -- function num : 0_45
  if self:GetIsHaveMonsterLable() then
    return not (self.__monsterLableCfg).label_onBattle
  else
    return false
  end
end

DynBattleRole.GetMonsterLableEffectIsHideAfterStartBattle = function(self)
  -- function num : 0_46
  return not (self.__monsterLableCfg).fx_onBattle
end

DynBattleRole.GetMonsterLableId = function(self)
  -- function num : 0_47
  return self.__monsterLableId
end

DynBattleRole.GetMonsterLableCfg = function(self)
  -- function num : 0_48
  return self.__monsterLableCfg
end

DynBattleRole.__GenMonsterLableSkills = function(self)
  -- function num : 0_49 , upvalues : _ENV, DynBattleSkill
  self:RemoveItemSkillTypeDic({[eBattleSkillLogicType.Lable] = true})
  local skillList = (self.__monsterLableCfg).skill_group
  for _,athSkillId in pairs(skillList) do
    local skillLevel = 1
    local skillData = (DynBattleSkill.New)(athSkillId, skillLevel, eBattleSkillLogicType.Lable)
    skillData:SetSkillFromMonsterLabel(self.__monsterLableId)
    self:AddItemSkill(skillData)
  end
end

DynBattleRole.GetMonsterLableEffectId = function(self)
  -- function num : 0_50
  local label_fx = (self.__monsterLableCfg).label_fx
  if label_fx == nil or label_fx == 0 then
    return nil
  end
  return label_fx
end

DynBattleRole.GetMonsterLableMatCfgId = function(self)
  -- function num : 0_51
  local label_mat = (self.__monsterLableCfg).label_mat
  if label_mat == nil or label_mat == 0 then
    return nil
  end
  return label_mat
end

return DynBattleRole

