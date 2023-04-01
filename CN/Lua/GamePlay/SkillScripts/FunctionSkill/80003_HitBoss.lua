-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80003 = class("bs_80003", LuaSkillBase)
local base = LuaSkillBase
bs_80003.config = {buffId = 1240, buffId2 = 278}
bs_80003.ctor = function(self)
  -- function num : 0_0
end

bs_80003.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_80003_3", 1, self.OnAfterHurt, self.caster)
  self:AddSelfTrigger(eSkillTriggerType.HurtResultStart, "bs_80002_1", 1, self.OnHurtResultStart)
end

bs_80003.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster then
    local buffTier = (context.target):GetBuffTier((self.config).buffId2)
    if buffTier > 0 or LuaSkillCtrl:RoleContainsCtrlBuff(context.target) then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
    end
  end
end

bs_80003.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and not isMiss and sender == self.caster and not LuaSkillCtrl:RoleContainsCtrlBuff(target) then
    local buffTier = (self.caster):GetBuffTier((self.config).buffId)
    if buffTier <= 0 then
      return 
    end
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0, true)
  end
end

bs_80003.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80003

