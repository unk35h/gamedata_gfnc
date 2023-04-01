-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15098 = class("bs_15098", LuaSkillBase)
local base = LuaSkillBase
bs_15098.config = {}
bs_15098.ctor = function(self)
  -- function num : 0_0
end

bs_15098.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_15098_10", 1, self.OnRoleDie)
end

bs_15098.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum == eBattleRoleBelong.enemy then
    LuaSkillCtrl:CallAddPlayerHmp((ConfigData.game_config).ultMpCost * (self.arglist)[1] // 1000)
  end
end

bs_15098.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15098

