-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_103401 = class("bs_103401", LuaSkillBase)
local base = LuaSkillBase
bs_103401.config = {effectId = 10459, buffId_179 = 103401, weaponLv = 0, effectId_ex = 103402, effectId_trail = 103403, effectId_skill = 103406, hurt_configId = 23, buffId_Crit_ex = 103403}
bs_103401.ctor = function(self)
  -- function num : 0_0
end

bs_103401.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self.effectHalo = nil
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_103401_1", 1, self.OnAfterBattleStart)
  if (self.config).weaponLv > 0 then
    self:AddAfterHurtTrigger("bs_103401_2", 9, self.OnAfterHurt, nil, nil, nil, (self.caster).belongNum)
    if (self.config).weaponLv > 2 then
      self:AddOnRoleDieTrigger("bs_103401_3", 10, self.OnRoleDie, nil, nil, (self.caster).belongNum)
    end
  end
end

bs_103401.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local effectId = (self.config).effectId
  if (self.config).weaponLv > 0 then
    effectId = (self.config).effectId_ex
  end
  if self.effectHalo == nil then
    self.effectHalo = LuaSkillCtrl:CallEffect(self.caster, effectId, self)
  end
  local collisionEnter = BindCallback(self, self.OnCollisionEnter)
  local collisionExit = BindCallback(self, self.OnCollisionExit)
  local radius = 100
  if (self.config).weaponLv > 0 then
    radius = 200
  end
  self.times = 0
  self.halo_em = LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, self.caster, radius, 0, eColliderInfluenceType.Player, collisionEnter, nil, collisionExit, nil, false, false, nil, self.caster)
end

bs_103401.OnCollisionEnter = function(self, collider, index, entity)
  -- function num : 0_3 , upvalues : _ENV
  if entity:GetBuffTier((self.config).buffId_179) < 1 then
    LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_179, 1, nil, true)
  end
end

bs_103401.OnCollisionExit = function(self, collider, entity)
  -- function num : 0_4 , upvalues : _ENV
  if entity:GetBuffTier((self.config).buffId_179) >= 1 then
    LuaSkillCtrl:DispelBuff(entity, (self.config).buffId_179, 0, true)
  end
end

bs_103401.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_5 , upvalues : _ENV
  if isTriggerSet ~= true and target.belongNum == (self.caster).belongNum and hurt > 0 and sender ~= nil and sender.hp > 0 and target:GetBuffTier((self.config).buffId_179) > 0 then
    LuaSkillCtrl:CallEffect(sender, (self.config).effectId_trail, self, self.SkillEventFunc, target)
  end
end

bs_103401.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_6 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local selfNum = ((self.caster).recordTable).self_int
    local senderNum = ((self.caster).recordTable).sender_int
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurt_configId, {selfNum, senderNum}, true)
    skillResult:EndResult()
  end
end

bs_103401.OnRoleDie = function(self, killer, role)
  -- function num : 0_7 , upvalues : _ENV
  do
    if killer ~= nil and killer.belongNum == (self.caster).belongNum and killer.hp > 0 and killer:GetBuffTier((self.config).buffId_179) > 0 then
      local skillTime = ((self.caster).recordTable).skillTime
      LuaSkillCtrl:CallResetCDNumForRole(killer, skillTime)
      LuaSkillCtrl:CallEffect(killer, (self.config).effectId_skill, self)
    end
    if killer ~= nil and killer.belongNum == (self.caster).belongNum and killer.hp > 0 and killer:GetBuffTier((self.config).buffId_Crit_ex) > 0 then
      local skillTime = ((self.caster).recordTable).skillTime
      LuaSkillCtrl:CallResetCDNumForRole(killer, skillTime)
      LuaSkillCtrl:CallEffect(killer, (self.config).effectId_skill, self)
    end
  end
end

bs_103401.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
  if self.effectHalo ~= nil then
    (self.effectHalo):Die()
    self.effectHalo = nil
  end
  if self.halo_em ~= nil then
    (self.halo_em):EndAndDisposeEmission()
    self.halo_em = nil
  end
end

bs_103401.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  (base.LuaDispose)(self)
  self.effectHalo = nil
  self.halo_em = nil
end

return bs_103401

