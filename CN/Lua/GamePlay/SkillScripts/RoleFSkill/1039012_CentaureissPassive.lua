-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1039012 = class("bs_1039012", base)
bs_1039012.config = {buffId_back = 15101, buffId_dizzy = 6601, effectId_high = 103904, audioId1 = 103901, 
hurt_config = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0, returndamage_formula = 0}
, 
Aoe = {effect_shape = 3, aoe_select_code = 5, aoe_range = 1}
}
bs_1039012.ctor = function(self)
  -- function num : 0_0
end

bs_1039012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_1039012_3", 1, self.OnAfterHurt, self.caster)
  self.attackNum = 0
end

bs_1039012.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and self:IsReadyToTake() then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_high, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).Aoe)
    for i = 0, (skillResult.roleList).Count - 1 do
      LuaSkillCtrl:CallBuff(self, (skillResult.roleList)[i], (self.config).buffId_dizzy, 1, (self.arglist)[2])
    end
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {(self.arglist)[1]})
    skillResult:EndResult()
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
    self:OnSkillTake()
  end
end

bs_1039012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1039012

