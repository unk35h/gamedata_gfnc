-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1022012 = class("bs_1022012", base)
bs_1022012.config = {buffId_critical = 22401, buffId_storage = 22501}
bs_1022012.ctor = function(self)
  -- function num : 0_0
end

bs_1022012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1022012_1", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_1022012_3", 1, self.OnAfterHurt, self.caster)
end

bs_1022012.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_critical, 1)
end

bs_1022012.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack then
    if not isCrit then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_storage, 1, nil, true)
    end
    if isCrit and (self.caster):GetBuffTier((self.config).buffId_storage) > 0 then
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_storage, 0, true)
    end
  end
end

bs_1022012.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1022012

