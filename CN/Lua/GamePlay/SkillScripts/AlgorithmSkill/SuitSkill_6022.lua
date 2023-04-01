-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_6022 = class("bs_6022", LuaSkillBase)
local base = LuaSkillBase
bs_6022.config = {buffId_1 = 602201, buffId_2 = 602202}
bs_6022.ctor = function(self)
  -- function num : 0_0
end

bs_6022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_6022_4", 1, self.OnAfterBattleStart)
  self:AddAfterPlaySkillTrigger("bs_6022_1", 1, self.OnAfterPlaySkill, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.normalSkill)
end

bs_6022.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_1, 1, nil, true)
end

bs_6022.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_2, 1, (self.arglist)[2], true)
end

bs_6022.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_6022

