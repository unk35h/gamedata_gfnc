-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_301104 = class("bs_301104", LuaSkillBase)
local base = LuaSkillBase
bs_301104.config = {effectId1 = 12031}
bs_301104.ctor = function(self)
  -- function num : 0_0
end

bs_301104.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_301104_1", 1, self.OnAfterBattleStart)
end

bs_301104.OnAfterBattleStart = function(self)
  -- function num : 0_2
end

bs_301104.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  if (self.caster).roleDataId == 40030 then
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId1, self)
  end
end

return bs_301104

