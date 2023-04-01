-- params : ...
-- function num : 0 , upvalues : _ENV
local CommonTDMonsterAttackPassive = class("CommonTDMonsterAttackPassive", LuaSkillBase)
local base = LuaSkillBase
CommonTDMonsterAttackPassive.config = {effect_id = 10100, grid_effect_id = 2012303, grid_arrowEfc_id = 2012304, buffId_god = 3009, hurtPerAtk = 1}
CommonTDMonsterAttackPassive.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : _ENV, base
  self:AddTrigger(eSkillTriggerType.BeforePlaySkill, "CommonTDMonsterAttackPassive_checkPlaySkill", 1, self.OnBeforePlaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "CommonTDMonsterAttackPassive_AfterBattleStart", 1, self.OnAfterBattleStart)
  ;
  (base.InitSkill)(self, isMidwaySkill)
end

CommonTDMonsterAttackPassive.OnAfterBattleStart = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self.lastCoord = {}
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.lastCoord).x = (self.caster).x
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.lastCoord).y = (self.caster).y
  self.moveTimer = LuaSkillCtrl:StartTimer(nil, 3, self.CheckCoordAndShowEffect, self, -1, 3)
end

CommonTDMonsterAttackPassive.CheckCoordAndShowEffect = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.lastCoord == nil then
    return 
  end
  if (self.lastCoord).x == (self.caster).x and (self.lastCoord).y == (self.caster).y then
    return 
  end
  if self.gridEffect ~= nil then
    (self.gridEffect):Die()
    self.gridEffect = nil
  end
  local gridTarget = LuaSkillCtrl:GetTargetWithGrid((self.caster).x, (self.caster).y)
  LuaSkillCtrl:CallEffectWithArg(gridTarget, (self.config).grid_arrowEfc_id, self, false, false, self.SkillEventFunc)
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.lastCoord).x = (self.caster).x
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.lastCoord).y = (self.caster).y
end

CommonTDMonsterAttackPassive.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    self.gridEffect = LuaSkillCtrl:CallEffect(target, (self.config).grid_effect_id, self)
  end
end

CommonTDMonsterAttackPassive.OnBeforePlaySkill = function(self, role, context)
  -- function num : 0_4
  if role ~= self.caster then
    return 
  end
  local campRole = (self.caster):GetRoleMoveFollowTarget()
  if ((context.skill).moveSelectTarget).targetRole == campRole and self:IsReadyToTake() then
    context.active = false
    self:AttackTowerCamp()
    if self.cskill ~= nil then
      self:OnSkillTake()
    end
  end
end

CommonTDMonsterAttackPassive.AttackTowerCamp = function(self)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_god, 0, true)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_id, self)
  local campRole = (self.caster):GetRoleMoveFollowTarget()
  local isboss = ((self.caster).recordTable).isTowerBoss
  if campRole.roleDataId == 60010 then
    return 
  end
  if campRole ~= nil and campRole.hp > 0 then
    if isboss then
      LuaSkillCtrl:ForceEndBattle(false)
      return 
    end
    local playerEntity = ((LuaSkillCtrl.battleCtrl).PlayerController).SkillCasterEntity
    local atkOffset = 1
    if playerEntity ~= nil and playerEntity.hp_regen >= 1 then
      atkOffset = playerEntity.hp_regen
    end
    local hurt = (self.config).hurtPerAtk * atkOffset
    LuaSkillCtrl:RemoveLife(hurt, self, campRole, true, nil, true)
  end
  do
    if not isboss then
      LuaSkillCtrl:RemoveLife((self.caster).hp + 1, self, self.caster, true, nil)
    end
  end
end

CommonTDMonsterAttackPassive.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  if self.moveTimer ~= nil then
    (self.moveTimer):Stop()
    self.moveTimer = nil
  end
  if self.gridEffect ~= nil then
    (self.gridEffect):Die()
    self.gridEffect = nil
  end
  self.lastCoord = nil
  self.attackNum = 0
  self.hurtPerAtk = 0
  self.remainHurt = 0
  ;
  (base.OnCasterDie)(self)
end

CommonTDMonsterAttackPassive.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : base
  self.attackNum = 0
  self.hurtPerAtk = 0
  self.remainHurt = 0
  if self.moveTimer ~= nil then
    (self.moveTimer):Stop()
    self.moveTimer = nil
  end
  if self.gridEffect ~= nil then
    (self.gridEffect):Die()
    self.gridEffect = nil
  end
  self.lastCoord = nil
  ;
  (base.LuaDispose)(self)
end

return CommonTDMonsterAttackPassive

