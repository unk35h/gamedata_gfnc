-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010409 = class("bs_4010409", LuaSkillBase)
local base = LuaSkillBase
bs_4010409.config = {
heal_config = {baseheal_formula = 9990}
}
bs_4010409.ctor = function(self)
  -- function num : 0_0
end

bs_4010409.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4010409_3", 1, self.OnAfterHurt, nil, nil, eBattleRoleBelong.player)
end

bs_4010409.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender.belongNum == eBattleRoleBelong.player and isCrit and not isTriggerSet then
    local value = sender.maxHp * (self.arglist)[1] // 1000
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, sender)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {value}, true, true)
    skillResult:EndResult()
  end
end

bs_4010409.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010409

