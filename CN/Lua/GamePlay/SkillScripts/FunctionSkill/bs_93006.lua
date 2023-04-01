-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93006 = class("bs_93006", LuaSkillBase)
local base = LuaSkillBase
bs_93006.config = {effectId = 10965}
bs_93006.ctor = function(self)
  -- function num : 0_0
end

bs_93006.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_93006_1", 1, self.OnAfterPlaySkill)
end

bs_93006.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if not skill.isCommonAttack and LuaSkillCtrl:CallRange(1, 1000) < (self.arglist)[1] and self:IsReadyToTake() then
    self:OnSkillTake()
    LuaSkillCtrl:CallReFillMainSkillCdForRole(self.caster)
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self, self.SkillEventFunc)
  end
end

bs_93006.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_93006

