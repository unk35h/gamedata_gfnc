-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92049 = class("bs_92049", LuaSkillBase)
local base = LuaSkillBase
bs_92049.config = {effectId = 10632}
bs_92049.ctor = function(self)
  -- function num : 0_0
end

bs_92049.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHealTrigger("bs_92049_1", 1, self.OnSetHeal, self.caster)
end

bs_92049.OnSetHeal = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster and self:IsReadyToTake() and not context.isTriggerSet and (context.target).roleType == eBattleRoleType.character and (context.target).belongNum == (self.caster).belongNum and (context.target).maxHp - (context.target).hp < context.heal then
    self:OnSkillTake()
    local exHeal = (context.heal - (context.target).maxHp + (context.target).hp) * (self.arglist)[1] // 1000
    if exHeal <= 0 then
      exHeal = context.heal
    end
    local sheildValue = exHeal
    local targetList = LuaSkillCtrl:FindAllRolesWithinRange(context.target, 1, true)
    if targetList.Count < 1 then
      return 
    end
    for i = 0, targetList.Count - 1 do
      local role = targetList[i]
      if role.belongNum == (self.caster).belongNum then
        LuaSkillCtrl:CallEffect((targetList[0]).targetRole, (self.config).effectId, self, self.SkillEventFunc)
        LuaSkillCtrl:AddRoleShield(role, eShieldType.Normal, sheildValue)
      end
    end
  end
end

bs_92049.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92049

