-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010410 = class("bs_4010410", LuaSkillBase)
local base = LuaSkillBase
bs_4010410.config = {effectId_line = 100103, effectId_PassHit = 100104, effectId = 10813, buffId_live = 3009, nanaka_buffId = 102603, buffId = 110071}
bs_4010410.ctor = function(self)
  -- function num : 0_0
end

bs_4010410.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetDeadHurtTrigger("bs_4010410_1", 949, self.OnSetDeadHurt, nil, nil, nil, (self.caster).belongNum, nil, 1)
  self.Times = 0
end

bs_4010410.OnSetDeadHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  local NoDeath = LuaSkillCtrl:RoleContainsBuffFeature(context.target, eBuffFeatureType.NoDeath)
  if self:IsReadyToTake() and (context.target).belongNum == (self.caster).belongNum and (context.target).roleType == 1 and context.target ~= context.sender and (context.target):GetBuffTier((self.config).nanaka_buffId) <= 0 and self.Times == 0 and NoDeath == false then
    LuaSkillCtrl:CallBuff(self, context.target, (self.config).buffId_live, 1, (self.arglist)[1], true)
    LuaSkillCtrl:CallBuff(self, context.target, (self.config).buffId, 1, nil, true)
    LuaSkillCtrl:CallEffect(context.target, (self.config).effectId, self)
    self:OnSkillTake()
    self.Times = 1
  end
end

bs_4010410.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010410

