-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91015 = class("bs_91015", LuaSkillBase)
local base = LuaSkillBase
bs_91015.config = {buffId = 2025}
bs_91015.ctor = function(self)
  -- function num : 0_0
end

bs_91015.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_91015_1", 1, self.OnAfterBattleStart)
end

bs_91015.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if targetlist.Count ~= 0 then
    for i = 0, targetlist.Count - 1 do
      local value = ((targetlist[i]).targetRole).dodge
      if value < (self.arglist)[1] then
        LuaSkillCtrl:CallBuff(self, (targetlist[i]).targetRole, (self.config).buffId, value, nil, true)
      else
        LuaSkillCtrl:CallBuff(self, (targetlist[i]).targetRole, (self.config).buffId, (self.arglist)[1], nil, true)
      end
    end
  end
  do
    self:PlayChipEffect()
  end
end

bs_91015.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91015

