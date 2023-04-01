-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15154 = class("bs_15154", LuaSkillBase)
local base = LuaSkillBase
bs_15154.config = {buffId = 2067}
bs_15154.ctor = function(self)
  -- function num : 0_0
end

bs_15154.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self:AddOnRoleDieTrigger("bs_15154_1", 10, self.OnRoleDie, nil, nil, nil, nil, nil, eBattleRoleBelong.netural)
end

bs_15154.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum ~= eBattleRoleBelong.netural then
    return 
  end
  local role, damage = LuaSkillCtrl:CallFindMaxPowOrSkillIntensityRole()
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 1, 1)
  for i = 0, targetList.Count - 1 do
    LuaSkillCtrl:RemoveLife(damage, self, (targetList[i]).targetRole, true, true, false, eHurtType.RealDmg)
    LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, 1, ((self.config).arglist)[1])
  end
end

bs_15154.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15154

