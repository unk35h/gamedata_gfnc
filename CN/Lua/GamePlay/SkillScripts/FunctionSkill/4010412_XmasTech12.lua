-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010412 = class("bs_4010412", LuaSkillBase)
local base = LuaSkillBase
bs_4010412.config = {}
bs_4010412.ctor = function(self)
  -- function num : 0_0
end

bs_4010412.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4010412_1", 1, self.OnAfterHurt, self.caster, nil, eBattleRoleBelong.player, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_4010412.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and not isTriggerSet and not isMiss then
    local exHurtValue = (self.caster).maxHp * (self.arglist)[1] // 1000
    LuaSkillCtrl:RemoveLife(exHurtValue, self, target, true, nil, true, true, eHurtType.RealDmg)
  end
end

bs_4010412.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010412

