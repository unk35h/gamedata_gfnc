-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21022 = class("bs_21022", LuaSkillBase)
local base = LuaSkillBase
bs_21022.config = {}
bs_21022.ctor = function(self)
  -- function num : 0_0
end

bs_21022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_21022_1", 1, self.OnAfterHurt, nil, nil, eBattleRoleBelong.player, nil, nil, nil, nil, eSkillTag.commonAttack)
  self.count = 0
end

bs_21022.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and not isTriggerSet and not isMiss then
    self.count = self.count + 1
    if (self.arglist)[1] + 1 <= self.count then
      self.count = 0
      local exHurtValue = (self.caster).maxHp * (self.arglist)[2] // 1000
      LuaSkillCtrl:RemoveLife(exHurtValue, self, target, true, nil, true, true, eHurtType.RealDmg)
    end
  end
end

bs_21022.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21022

