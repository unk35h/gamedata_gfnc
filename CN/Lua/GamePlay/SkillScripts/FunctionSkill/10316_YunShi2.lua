-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10316 = class("bs_10316", LuaSkillBase)
local base = LuaSkillBase
bs_10316.config = {ysBuff = 1227, ysBuffDuration = 90}
bs_10316.ctor = function(self)
  -- function num : 0_0
end

bs_10316.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("10315_after_hurt", 1, self.OnAfterHurt, nil, self.caster)
end

bs_10316.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2
  if self:IsReadyToTake() and not isTriggerSet then
    self:CheckAndAddBuffToTarget(sender, target)
  end
end

bs_10316.CheckAndAddBuffToTarget = function(self, sender, target)
  -- function num : 0_3 , upvalues : _ENV
  if target ~= nil and target.hp > 0 and sender ~= nil and sender.hp > 0 and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[1] then
    LuaSkillCtrl:CallBuff(self, sender, (self.config).ysBuff, 1, (self.config).ysBuffDuration)
    self:PlayChipEffect()
    self:OnSkillTake()
    self.attackNum = 0
  end
end

bs_10316.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10316

