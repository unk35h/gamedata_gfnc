-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21057 = class("bs_21057", LuaSkillBase)
local base = LuaSkillBase
bs_21057.config = {buffId = 110029}
bs_21057.ctor = function(self)
  -- function num : 0_0
end

bs_21057.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddHurtResultEndTrigger("bs_21057_16", 1, self.OnHurtResultEnd, nil, nil, eBattleRoleBelong.player)
  self:AddHurtResultStartTrigger("bs_21057_16", 1, self.OnHurtResultStart, nil, nil, eBattleRoleBelong.player)
end

bs_21057.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if (skill.maker).belongNum == eBattleRoleBelong.player and (skill.maker).maxHp ~= 0 and (self.arglist)[1] <= (skill.maker).hp * 1000 // (skill.maker).maxHp then
    LuaSkillCtrl:CallBuff(self, skill.maker, (self.config).buffId, 1, nil)
  end
end

bs_21057.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_3 , upvalues : _ENV
  if (skill.maker).belongNum == eBattleRoleBelong.player then
    LuaSkillCtrl:DispelBuff(skill.maker, (self.config).buffId, 0)
  end
end

bs_21057.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21057

