-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15073 = class("bs_15073", LuaSkillBase)
local base = LuaSkillBase
bs_15073.config = {buffId = 1258, configId1 = 26}
bs_15073.ctor = function(self)
  -- function num : 0_0
end

bs_15073.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_15073_3", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_15073.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if skill.isCommonAttack and not isTriggerSet then
    local damageNum = (self.caster).maxHp - (self.caster).hp
    if damageNum > 0 then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId1, {damageNum}, true)
      skillResult:EndResult()
    end
  end
end

bs_15073.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15073

