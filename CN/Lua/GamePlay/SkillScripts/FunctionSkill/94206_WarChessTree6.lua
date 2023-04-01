-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94206 = class("bs_94206", LuaSkillBase)
local base = LuaSkillBase
bs_94206.config = {buffId = 110062}
bs_94206.ctor = function(self)
  -- function num : 0_0
end

bs_94206.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddHurtResultStartTrigger("bs_94206_17", 1, self.OnHurtResultStart, self.caster, nil, nil, eBattleRoleBelong.enemy)
  self:AddSetHurtTrigger("bs_94206_2", 1, self.OnSetHurt, self.caster)
end

bs_94206.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if skill.maker == self.caster and (context.target).belongNum == eBattleRoleBelong.enemy then
    local value = (context.target).hp * 1000 // (context.target).maxHp
    if value < (self.arglist)[1] then
      LuaSkillCtrl:CallBuff(self, skill.maker, (self.config).buffId, 1, nil)
    end
  end
end

bs_94206.OnSetHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  if context.sender == self.caster then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_94206.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94206

