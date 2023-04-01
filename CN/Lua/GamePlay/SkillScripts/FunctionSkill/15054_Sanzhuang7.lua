-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15054 = class("bs_15054", LuaSkillBase)
local base = LuaSkillBase
bs_15054.config = {}
bs_15054.ctor = function(self)
  -- function num : 0_0
end

bs_15054.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15054_1", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_15054_2", 1, self.OnAfterHurt, self.caster)
  self.isXidun = true
end

bs_15054.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], arriveCallBack)
end

bs_15054.OnArriveAction = function(self)
  -- function num : 0_3
  self.isXidun = false
end

bs_15054.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  if sender == self.caster and self.isXidun and not isTriggerSet then
    local sheidValue = hurt * (self.arglist)[2] // 1000
    LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.normal, sheidValue)
  end
end

bs_15054.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15054

