-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91011 = class("bs_91011", LuaSkillBase)
local base = LuaSkillBase
bs_91011.config = {buffId = 2009}
bs_91011.ctor = function(self)
  -- function num : 0_0
end

bs_91011.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_91011_1", 1, self.OnAfterBattleStart)
end

bs_91011.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local grids = LuaSkillCtrl:FindEmptyGridsWithinRange((self.caster).x, (self.caster).y, 1)
  if grids ~= nil and grids.Count > 0 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, grids.Count, nil, true)
    ;
    (self.caster):UpdateHp()
  end
end

bs_91011.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91011

