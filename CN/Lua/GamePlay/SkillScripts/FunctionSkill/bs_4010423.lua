-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010423 = class("bs_4010423", LuaSkillBase)
local base = LuaSkillBase
bs_4010423.config = {buffId = 2086}
bs_4010423.ctor = function(self)
  -- function num : 0_0
end

bs_4010423.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4010423", 1, self.OnAfterHurt, nil, self.caster)
  self.count = 0
end

bs_4010423.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if self.count == 0 and target == self.caster then
    local hp = (self.caster).hp
    local MaxHP = (self.caster).maxHp
    local percent = hp / MaxHP * 1000
    if percent <= (self.arglist)[1] then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
      self.count = 1
      self:RemoveSkillTrigger(eSkillTriggerType.AfterHurt)
    end
  end
end

bs_4010423.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010423

