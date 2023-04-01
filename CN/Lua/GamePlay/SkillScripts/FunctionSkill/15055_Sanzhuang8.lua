-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15055 = class("bs_15055", LuaSkillBase)
local base = LuaSkillBase
bs_15055.config = {buffId1 = 1245, buffId2 = 1246}
bs_15055.ctor = function(self)
  -- function num : 0_0
end

bs_15055.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15055_1", 1, self.OnAfterBattleStart)
end

bs_15055.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId2, 2, nil, true)
  local roles = LuaSkillCtrl:FindRolesAroundRole(self.caster)
  if roles ~= nil and roles.Count > 0 then
    for i = 0, roles.Count - 1 do
      local targetRole = roles[i]
      if targetRole.career ~= 4 and targetRole.hp > 0 then
        LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId1, 1, nil, true)
      end
    end
  end
end

bs_15055.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15055

