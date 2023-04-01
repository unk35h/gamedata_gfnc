-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210902 = class("bs_210902", LuaSkillBase)
local base = LuaSkillBase
bs_210902.config = {}
bs_210902.ctor = function(self)
  -- function num : 0_0
end

bs_210902.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_210902_1", 1, self.OnAfterBattleStart)
end

bs_210902.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local grid = LuaSkillCtrl:GetGridWithRole(self.caster)
  if grid ~= nil then
    LuaSkillCtrl:CallCreateEfcGrid((grid.coord).x, (grid.coord).y, 1126)
  end
end

bs_210902.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_210902

