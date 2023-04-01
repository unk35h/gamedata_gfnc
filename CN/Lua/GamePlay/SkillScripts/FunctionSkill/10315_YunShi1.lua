-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10315 = class("bs_10315", LuaSkillBase)
local base = LuaSkillBase
bs_10315.config = {ysBuff = 1227, ysBuffDuration = 90}
bs_10315.ctor = function(self)
  -- function num : 0_0
end

bs_10315.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("10314_after_hurt", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
  self.attackNum = 0
end

bs_10315.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2
  if self:IsReadyToTake() and not isTriggerSet then
    self.attackNum = self.attackNum + 1
    self:CheckAndAddBuffToTarget(sender, target)
  end
end

bs_10315.CheckAndAddBuffToTarget = function(self, sender, target)
  -- function num : 0_3 , upvalues : _ENV
  if target ~= nil and target.hp > 0 and sender ~= nil and sender.hp > 0 and (self.arglist)[1] <= self.attackNum then
    LuaSkillCtrl:CallBuff(self, target, (self.config).ysBuff, 1, (self.config).ysBuffDuration)
    self:PlayChipEffect()
    self:OnSkillTake()
    self.attackNum = 0
  end
end

bs_10315.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10315

