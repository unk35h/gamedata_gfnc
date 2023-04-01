-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_7011 = class("bs_7011", LuaSkillBase)
local base = LuaSkillBase
bs_7011.config = {}
bs_7011.ctor = function(self)
  -- function num : 0_0
end

bs_7011.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnSelfAfterMove, "bs_7011_OnSelfAfterMove", 1, self.OnSelfAfterMove)
end

bs_7011.OnSelfAfterMove = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self.caster).intensity < 3 then
    local damage = (self.caster).hp * ((self.caster).recordTable)["15063_damagePer"] // 1000
    LuaSkillCtrl:RemoveLife(damage, self, self.caster, true)
  end
end

bs_7011.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_7011

