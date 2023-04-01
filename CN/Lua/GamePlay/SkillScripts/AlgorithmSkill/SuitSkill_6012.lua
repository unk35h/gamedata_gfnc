-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_6012 = class("bs_6012", LuaSkillBase)
local base = LuaSkillBase
bs_6012.config = {buffid = 601201}
bs_6012.ctor = function(self)
  -- function num : 0_0
end

bs_6012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnSelfAfterMove, "bs_6012_2", 1, self.OnAfterMove)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRoleSplash, self.OnAfterMove)
end

bs_6012.OnAfterMove = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffid, 1, 75)
end

bs_6012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_6012

