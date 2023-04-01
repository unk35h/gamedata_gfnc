-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91023 = class("bs_91023", LuaSkillBase)
local base = LuaSkillBase
bs_91023.config = {buffId = 2045, buffTier = 1}
bs_91023.ctor = function(self)
  -- function num : 0_0
end

bs_91023.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_91023_1", 1, self.OnAfterBattleStart)
end

bs_91023.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:FindRolesAroundRole(self.caster)
  if targetList ~= nil and targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = targetList[i]
      if role.belongNum == (self.caster).belongNum then
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil, true)
      end
    end
  end
end

bs_91023.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91023

