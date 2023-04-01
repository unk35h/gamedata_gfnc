-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25050 = class("bs_25050", LuaSkillBase)
local base = LuaSkillBase
bs_25050.config = {buffId = 110076}
bs_25050.ctor = function(self)
  -- function num : 0_0
end

bs_25050.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddHurtResultStartTrigger("bs_25050_16", 1, self.OnHurtResultStart, nil, nil, eBattleRoleBelong.player, nil, eBattleRoleType.character)
  self:AddHurtResultEndTrigger("bs_25050_17", 1, self.OnHurtResultEnd, nil, nil, eBattleRoleBelong.player, nil, eBattleRoleType.character)
end

bs_25050.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if (skill.maker).belongNum == eBattleRoleBelong.player and (skill.maker).roleType == eBattleRoleType.character then
    local value = (1000 - (skill.maker).hp * 1000 // (skill.maker).maxHp) // (self.arglist)[1]
    LuaSkillCtrl:CallBuff(self, skill.maker, (self.config).buffId, value, nil, true)
  end
end

bs_25050.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_3 , upvalues : _ENV
  if (skill.maker).belongNum == eBattleRoleBelong.player and (skill.maker).roleType == eBattleRoleType.character then
    LuaSkillCtrl:DispelBuff(skill.maker, (self.config).buffId, 0, true)
  end
end

bs_25050.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25050

