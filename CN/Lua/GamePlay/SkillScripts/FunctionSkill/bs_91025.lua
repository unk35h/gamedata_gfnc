-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91025 = class("bs_91025", LuaSkillBase)
local base = LuaSkillBase
bs_91025.config = {buffId = 2047, buffTier = 1}
bs_91025.ctor = function(self)
  -- function num : 0_0
end

bs_91025.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddHurtResultStartTrigger("bs_91024_15", 1, self.OnHurtResultStart, self.caster, nil, eBattleRoleBelong.player)
  self:AddHurtResultEndTrigger("bs_91024_16", 1, self.OnHurtResultEnd, self.caster, nil, eBattleRoleBelong.player)
end

bs_91025.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if skill.maker == self.caster and (skill.maker).maxHp ~= 0 and (skill.maker).hp * 1000 // (skill.maker).maxHp <= (self.arglist)[1] then
    LuaSkillCtrl:CallBuff(self, skill.maker, (self.config).buffId, (self.config).buffTier, nil)
  end
end

bs_91025.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_3 , upvalues : _ENV
  if skill.maker == self.caster and (self.arglist)[1] < (skill.maker).hp * 1000 // (skill.maker).maxHp then
    LuaSkillCtrl:DispelBuff(skill.maker, (self.config).buffId, 0)
  end
end

bs_91025.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91025

