-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80019 = class("bs_80019", LuaSkillBase)
local base = LuaSkillBase
bs_80019.config = {
heal_config = {baseheal_formula = 501}
}
bs_80019.ctor = function(self)
  -- function num : 0_0
end

bs_80019.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_80019_2", 1, self.OnAfterHurt, self.caster)
end

bs_80019.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and not isMiss and hurt > 0 and not isTriggerSet then
    local value = hurt * (self.arglist)[1] // 1000
    local targetList = LuaSkillCtrl:CallTargetSelect(self, 47, 10)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local targetRole = (targetList[i]).targetRole
        if targetRole.intensity > 1 then
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
          LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {value}, true)
          skillResult:EndResult()
          break
        end
      end
    end
  end
end

bs_80019.OnAfterBattleStart = function(self)
  -- function num : 0_3
end

bs_80019.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80019

