-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15134 = class("bs_15134", LuaSkillBase)
local base = LuaSkillBase
bs_15134.config = {buffId = 110080}
bs_15134.ctor = function(self)
  -- function num : 0_0
end

bs_15134.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15134_1", 1, self.OnAfterBattleStart)
end

bs_15134.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 31, 10)
  if targetList.Count > 0 then
    local targetRole = (targetList[0]).targetRole
    if targetRole.roleType == eBattleRoleType.character then
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, 1, nil, true)
    end
  end
end

bs_15134.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15134

