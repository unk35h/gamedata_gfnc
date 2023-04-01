-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10262 = class("bs_10262", LuaSkillBase)
local base = LuaSkillBase
bs_10262.config = {buffId = 1177, buffTier = 1}
bs_10262.ctor = function(self)
  -- function num : 0_0
end

bs_10262.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.HurtResultStart, "bs_10262_14", 1, self.OnHurtResultStart)
end

bs_10262.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.target).hp * 1000 // (context.target).maxHp <= (self.arglist)[1] then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil, true)
  else
    if (self.arglist)[1] < (context.target).hp * 1000 // (context.target).maxHp then
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
    end
  end
end

bs_10262.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10262

