-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15067 = class("bs_15067", LuaSkillBase)
local base = LuaSkillBase
bs_15067.config = {buffId = 1258, configId1 = 26}
bs_15067.ctor = function(self)
  -- function num : 0_0
end

bs_15067.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHealTrigger("bs_15067_1", 1, self.OnSetHeal, self.caster, nil, nil, (self.caster).belongNum, nil, eBattleRoleType.character)
end

bs_15067.OnSetHeal = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster and self:IsReadyToTake() and not context.isTriggerSet and (context.target).roleType == eBattleRoleType.character and (context.target).belongNum == (self.caster).belongNum and (context.target).maxHp - (context.target).hp < context.heal then
    self:OnSkillTake()
    local exHeal = (context.heal - (context.target).maxHp + (context.target).hp) * (self.arglist)[1] // 1000
    if exHeal <= 0 then
      exHeal = context.heal
    end
    local damageValue = exHeal
    if damageValue > 0 then
      local targetlist2 = LuaSkillCtrl:CallTargetSelect(self, 7, 10)
      if targetlist2.Count > 0 then
        local target = (targetlist2[0]).targetRole
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId1, {damageValue}, true)
        skillResult:EndResult()
      end
    end
  end
end

bs_15067.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15067

