-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1013 = class("bs_1013", LuaSkillBase)
local base = LuaSkillBase
bs_1013.config = {buffId_def = 506}
bs_1013.ctor = function(self)
  -- function num : 0_0
end

bs_1013.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1013_1", 1, self.OnAfterBattleStart)
  self.count = (self.arglist)[1]
  self.maxCount = (self.arglist)[1]
  self:AddAfterHurtTrigger("bs_1013_2", 1, self.OnAfterHurt, nil, self.caster, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
  self:AddTrigger(eSkillTriggerType.BeforeBattleEnd, "bs_1013_3", 1, self.BeforeEndBattle)
end

bs_1013.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if not isMiss and hurt > 0 and skill.isCommonAttack then
    self.count = self.count - 1
    self:ShowAttackCounting(self.count)
    if self.count == 0 then
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_def, 1, true)
    end
  end
end

bs_1013.OnAfterBattleStart = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_def, 1, nil, true)
  self:ShowAttackCounting(self.count)
end

bs_1013.ShowAttackCounting = function(self, Count)
  -- function num : 0_4 , upvalues : _ENV
  if LuaSkillCtrl.IsInVerify then
    return 
  end
  if Count == 0 then
    LuaSkillCtrl:HideCounting(self.caster)
    return 
  end
  LuaSkillCtrl:ShowCounting(self.caster, Count, self.maxCount)
end

bs_1013.BeforeEndBattle = function(self)
  -- function num : 0_5
  self:ShowAttackCounting(0)
end

bs_1013.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
  self:ShowAttackCounting(0)
end

return bs_1013

