-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91010 = class("bs_91010", LuaSkillBase)
local base = LuaSkillBase
bs_91010.config = {buffId = 2008, buffTier = 1}
bs_91010.ctor = function(self)
  -- function num : 0_0
end

bs_91010.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_91010_1", 1, self.OnAfterBattleStart)
end

bs_91010.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:FindRolesAroundRole(self.caster)
  if targetList ~= nil and targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = targetList[i]
      if role.belongNum == (self.caster).belongNum and role.roleType == eBattleRoleType.character then
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil, true)
        ;
        (self.caster):UpdateHp()
      end
    end
  end
end

bs_91010.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91010

