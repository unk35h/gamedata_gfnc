-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70032 = class("bs_70032", LuaSkillBase)
local base = LuaSkillBase
bs_70032.config = {}
bs_70032.ctor = function(self)
  -- function num : 0_0
end

bs_70032.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_70032_1", 1, self.OnAfterBattleStart)
end

bs_70032.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallAddRoleProperty(self.caster, 15, 10000000, eHeroAttrType.Extra)
end

bs_70032.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_70032

