-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010406 = class("bs_4010406", LuaSkillBase)
local base = LuaSkillBase
bs_4010406.config = {buffId = 110068}
bs_4010406.ctor = function(self)
  -- function num : 0_0
end

bs_4010406.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddHurtResultStartTrigger("bs_4010406_17", 1, self.OnHurtResultStart, self.caster, nil, nil, eBattleRoleBelong.enemy)
  self:AddSetHurtTrigger("bs_4010406_2", 1, self.OnSetHurt, self.caster)
end

bs_4010406.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if skill.maker == self.caster and (context.target).belongNum == eBattleRoleBelong.enemy then
    local value = (context.target).hp * 1000 // (context.target).maxHp
    if value < (self.arglist)[1] then
      LuaSkillCtrl:CallBuff(self, skill.maker, (self.config).buffId, 1, nil)
    end
  end
end

bs_4010406.OnSetHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  if context.sender == self.caster then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_4010406.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010406

