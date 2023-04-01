-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15099 = class("bs_15099", LuaSkillBase)
local base = LuaSkillBase
bs_15099.config = {}
bs_15099.ctor = function(self)
  -- function num : 0_0
end

bs_15099.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterPlaySkill, "bs_15099_13", 1, self.OnAfterPlaySkill)
end

bs_15099.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.isUltSkill then
    LuaSkillCtrl:CallAddPlayerHmp((ConfigData.game_config).ultMpCost * (self.arglist)[1] // 1000)
  end
end

bs_15099.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15099

