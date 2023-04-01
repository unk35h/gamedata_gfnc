-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21036 = class("bs_21036", LuaSkillBase)
local base = LuaSkillBase
bs_21036.config = {buffId = 110030}
bs_21036.ctor = function(self)
  -- function num : 0_0
end

bs_21036.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddHurtResultStartTrigger("bs_21036_14", 1, self.OnHurtResultStart, nil, nil, nil, eBattleRoleBelong.player)
  self:AddHurtResultEndTrigger("bs_21036_15", 1, self.OnHurtResultEnd, nil, nil, nil, eBattleRoleBelong.player)
end

bs_21036.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.target).belongNum == eBattleRoleBelong.player then
    local buffTier = (100 - (context.target).hp * 100 // (context.target).maxHp) * 10 // (self.arglist)[1]
    LuaSkillCtrl:CallBuff(self, context.target, (self.config).buffId, buffTier, nil, true)
  end
end

bs_21036.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_3 , upvalues : _ENV
  if targetRole.belongNum == eBattleRoleBelong.player then
    LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffId, 0)
  end
end

bs_21036.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21036

