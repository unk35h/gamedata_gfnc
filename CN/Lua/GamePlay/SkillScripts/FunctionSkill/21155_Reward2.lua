-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21155 = class("bs_21155", LuaSkillBase)
local base = LuaSkillBase
bs_21155.config = {buffId = 110034}
bs_21155.ctor = function(self)
  -- function num : 0_0
end

bs_21155.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21155_1", 1, self.OnAfterBattleStart)
end

bs_21155.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if targetlist.Count > 0 then
    local buffTier = (self.arglist)[1] - targetlist.Count
    for i = 0, targetlist.Count - 1 do
      LuaSkillCtrl:CallBuff(self, (targetlist[i]).targetRole, (self.config).buffId, buffTier, nil)
      ;
      ((targetlist[i]).targetRole):UpdateHp()
    end
  end
end

bs_21155.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21155

