-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94104 = class("bs_94104", LuaSkillBase)
local base = LuaSkillBase
bs_94104.config = {buffId = 26}
bs_94104.ctor = function(self)
  -- function num : 0_0
end

bs_94104.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_94104_3", 1, self.OnAfterHurt, nil, self.caster, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_94104.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender.belongNum == eBattleRoleBelong.enemy and target == self.caster and skill.isCommonAttack and not isTriggerSet and LuaSkillCtrl:CallRange(1, 1000) < (self.arglist)[1] then
    LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId, 1, (self.arglist)[2])
  end
end

bs_94104.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94104

