-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92058 = class("bs_92058", LuaSkillBase)
local base = LuaSkillBase
bs_92058.config = {buffId = 2050, buffId2 = 2051, effectId_Suck = 104307}
bs_92058.ctor = function(self)
  -- function num : 0_0
end

bs_92058.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_92058_3", 1, self.OnAfterHurt, self.caster)
end

bs_92058.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and not isTriggerSet and not isMiss then
    local powNum = target.pow * (self.arglist)[1] // 1000
    local skillNum = target.skill_intensity * (self.arglist)[1] // 1000
    if skill.isCommonAttack then
      LuaSkillCtrl:DispelBuff(sender, (self.config).buffId, 0)
      LuaSkillCtrl:DispelBuff(sender, (self.config).buffId2, 0)
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, powNum, nil, true)
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId2, skillNum, nil, true)
    end
  end
end

bs_92058.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92058

