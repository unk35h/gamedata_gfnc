-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_208703 = class("bs_208703", LuaSkillBase)
local base = LuaSkillBase
bs_208703.config = {
hurt_config = {basehurt_formula = 10157}
, effectId_hit = 208703}
bs_208703.ctor = function(self)
  -- function num : 0_0
end

bs_208703.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_208703_13", 1, self.OnAfterHurt, nil, nil, (self.caster).belongNum, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_208703.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target.hp > 0 and target.attackRange == 1 and sender.belongNum == (self.caster).belongNum and sender ~= self.caster and skill.isCommonAttack and not isTriggerSet then
    LuaSkillCtrl:CallBuff(self, target, (self.config).beatBackBuff, 1, 3)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config)
    skillResult:EndResult()
  end
end

bs_208703.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_208703

