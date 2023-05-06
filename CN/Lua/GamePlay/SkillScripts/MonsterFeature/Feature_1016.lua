-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1016 = class("bs_1016", LuaSkillBase)
local base = LuaSkillBase
bs_1016.config = {
heal_config = {baseheal_formula = 3022}
}
bs_1016.ctor = function(self)
  -- function num : 0_0
end

bs_1016.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetDeadHurtTrigger("bs_1016", 99, self.OnSetDeadHurt, nil, self.caster)
end

bs_1016.OnSetDeadHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.target == self.caster and (context.target):GetBuffTier((self.config).nanaka_buffId) <= 0 then
    local target = nil
    local targets = LuaSkillCtrl:CallTargetSelect(self, 2, 10)
    for i = targets.Count - 1, 0, -1 do
      local role = (targets[i]).targetRole
      if LuaSkillCtrl:IsObstacle(role) then
        targets:RemoveAt(i)
      end
    end
    if targets.Count > 0 then
      for i = 0, targets.Count - 1 do
        local role = (targets[i]).targetRole
        if role ~= nil and role.hp > 0 then
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
          LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {(self.arglist)[1]}, true)
          skillResult:EndResult()
        end
      end
    end
  end
end

bs_1016.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1016

