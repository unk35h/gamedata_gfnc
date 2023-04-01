-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15137 = class("bs_15137", LuaSkillBase)
local base = LuaSkillBase
bs_15137.config = {buffId_live = 3009}
bs_15137.ctor = function(self)
  -- function num : 0_0
end

bs_15137.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetDeadHurtTrigger("bs_15137_1", 850, self.OnSetDeadHurt, nil, nil, nil, (self.caster).belongNum, nil, 1)
  self.Times = 0
end

bs_15137.OnSetDeadHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  local NoDeath = LuaSkillCtrl:RoleContainsBuffFeature(context.target, eBuffFeatureType.NoDeath)
  if self:IsReadyToTake() and (context.target).belongNum == (self.caster).belongNum and (context.target).roleType == 1 and context.target ~= context.sender and (context.target):GetBuffTier((self.config).nanaka_buffId) <= 0 and self.Times == 0 and NoDeath == false then
    LuaSkillCtrl:CallBuff(self, context.target, (self.config).buffId_live, 1, (self.arglist)[1], true)
    self:OnSkillTake()
    self.Times = 1
  end
end

bs_15137.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15137

