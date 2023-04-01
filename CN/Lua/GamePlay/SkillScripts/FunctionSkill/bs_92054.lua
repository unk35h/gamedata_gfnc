-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92054 = class("bs_92054", LuaSkillBase)
local base = LuaSkillBase
bs_92054.config = {}
bs_92054.ctor = function(self)
  -- function num : 0_0
end

bs_92054.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHealTrigger("bs_92054_2", 2, self.OnAfterHeal, nil, self.caster)
  self.totalHp = ((self.arglist)[1] / 1000 + 1) * (self.caster).maxHp
end

bs_92054.OnAfterHeal = function(self, sender, target, skill, heal, isStealHeal, isCrit, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if not isTriggerSet then
    if target.maxHp + heal < self.totalHp then
      self:PlayChipEffect()
      LuaSkillCtrl:CallAddRoleProperty(target, eHeroAttr.maxHp, heal, eHeroAttrType.Extra)
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HealResultWithConfig(self, skillResult, 6, {heal}, true, true)
    else
      do
        self:PlayChipEffect()
        LuaSkillCtrl:CallAddRoleProperty(target, eHeroAttr.maxHp, self.totalHp - target.maxHp, eHeroAttrType.Extra)
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
        LuaSkillCtrl:HealResultWithConfig(self, skillResult, 6, {self.totalHp - target.maxHp}, true, true)
      end
    end
  end
end

bs_92054.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92054

