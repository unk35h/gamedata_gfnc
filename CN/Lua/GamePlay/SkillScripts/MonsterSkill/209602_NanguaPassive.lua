-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_209602 = class("bs_209602", LuaSkillBase)
local base = LuaSkillBase
bs_209602.config = {effectId1 = 2007205, configId = 3, 
realDamage = {basehurt_formula = 502, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0, correct_formula = 0}
, effectIdAttack = 10953}
bs_209602.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_209602_165464", 99, self.OnRoleDie, nil, self.caster)
  self.time = 0
end

bs_209602.OnRoleDie = function(self, killer, role)
  -- function num : 0_1 , upvalues : _ENV, base
  if killer.belongNum ~= (self.caster).belongNum and killer.hp > 0 and self.time == 0 and role == self.caster then
    LuaSkillCtrl:CallEffectWithArg(killer, (self.config).effectId1, self, false, false, self.OnEffectTrigger, killer)
    self.time = self.time + 1
    ;
    (base.OnCasterDie)(self)
  end
end

bs_209602.OnEffectTrigger = function(self, targetRole, effect, eventId, target)
  -- function num : 0_2 , upvalues : _ENV
  if effect.dataId == (self.config).effectId1 and eventId == eBattleEffectEvent.Trigger and targetRole ~= nil then
    local realHurt = targetRole.maxHp * (self.arglist)[1] // 1000
    if realHurt <= 0 then
      realHurt = 1
    end
    LuaSkillCtrl:CallRealDamage(self, targetRole, nil, (self.config).realDamage, {realHurt}, true)
  end
end

bs_209602.OnCasterDie = function(self)
  -- function num : 0_3
end

bs_209602.LuaDispose = function(self)
  -- function num : 0_4 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_209602

