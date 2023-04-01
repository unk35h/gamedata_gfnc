-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94203 = class("bs_94203", LuaSkillBase)
local base = LuaSkillBase
bs_94203.config = {buffId = 110059}
bs_94203.ctor = function(self)
  -- function num : 0_0
end

bs_94203.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_94203_1", 1, self.OnAfterBattleStart)
end

bs_94203.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self.caster).intensity >= 2 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  end
end

bs_94203.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_3
end

bs_94203.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94203

