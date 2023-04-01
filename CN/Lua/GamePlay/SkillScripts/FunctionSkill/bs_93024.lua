-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93024 = class("bs_93024", LuaSkillBase)
local base = LuaSkillBase
bs_93024.config = {Delay = 150, buffIdUp = 2064, buffIdDown = 2063}
bs_93024.ctor = function(self)
  -- function num : 0_0
end

bs_93024.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_93024_1", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.HurtResultEnd, "bs_93024_3", 3, self.OnHurtResultEnd)
end

bs_93024.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self:PlayChipEffect()
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdUp, (self.arglist)[1], nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdDown, (self.arglist)[2], nil, true)
end

bs_93024.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_3 , upvalues : _ENV
  local buffTier = targetRole:GetBuffTier((self.config).buffIdUp)
  local buffTier1 = targetRole:GetBuffTier((self.config).buffIdDown)
  if hurtValue > 0 and targetRole == self.caster and buffTier > 0 and buffTier1 > 0 then
    LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffIdUp, 0, true)
    LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffIdDown, 0, true)
    local callBack = BindCallback(self, self.CallBack)
    self.damTimer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[3], callBack, self, 0)
  end
end

bs_93024.CallBack = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.damTimer ~= nil and (self.damTimer):IsOver() then
    self.damTimer = nil
  end
  self:PlayChipEffect()
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdUp, (self.arglist)[1], nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdDown, (self.arglist)[2], nil, true)
end

bs_93024.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
  if self.damTimer then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
end

return bs_93024

