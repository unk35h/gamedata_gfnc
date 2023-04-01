-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21056 = class("bs_21056", LuaSkillBase)
local base = LuaSkillBase
bs_21056.config = {buffId = 110028}
bs_21056.ctor = function(self)
  -- function num : 0_0
end

bs_21056.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddHurtResultEndTrigger("bs_21056_16", 1, self.OnHurtResultEnd, nil, nil, eBattleRoleBelong.enemy)
  self:AddHurtResultStartTrigger("bs_21056_17", 1, self.OnHurtResultStart, nil, nil, eBattleRoleBelong.enemy)
end

bs_21056.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if (skill.maker).belongNum == eBattleRoleBelong.enemy and (skill.maker).hp < (context.target).hp then
    LuaSkillCtrl:CallBuff(self, skill.maker, (self.config).buffId, 1, nil)
  end
end

bs_21056.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_3 , upvalues : _ENV
  if (skill.maker).belongNum == eBattleRoleBelong.enemy then
    LuaSkillCtrl:DispelBuff(skill.maker, (self.config).buffId, 0)
  end
end

bs_21056.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21056

