-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92086 = class("bs_92086", LuaSkillBase)
local base = LuaSkillBase
bs_92086.config = {buffId1 = 1078, buffId2 = 2096, buffTier = 1, buffId_blood = 195, buffId_fire = 1227}
bs_92086.ctor = function(self)
  -- function num : 0_0
end

bs_92086.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_92086_1", 1, self.OnAfterBattleStart)
  self:AddHurtResultStartTrigger("bs_92086_2", 1, self.OnHurtResultStart, self.caster)
  self:AddHurtResultEndTrigger("bs_92086_15", 1, self.OnHurtResultEnd, self.caster)
end

bs_92086.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId1, (self.config).buffTier, nil, true)
end

bs_92086.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_3 , upvalues : _ENV
  if skill.maker == self.caster and skill.skillTag ~= eSkillTag.commonAttack then
    local restTier1 = (context.target):GetBuffTier((self.config).buffId_blood)
    local restTier2 = (context.target):GetBuffTier((self.config).buffId_fire)
    if restTier1 > 0 or restTier2 > 0 then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId2, restTier1 + restTier2, nil, true)
    end
  end
end

bs_92086.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_4 , upvalues : _ENV
  if skill.maker == self.caster and skill.skillTag ~= eSkillTag.commonAttack then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId2, 0, true)
  end
end

bs_92086.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92086

