-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21151 = class("bs_21151", LuaSkillBase)
local base = LuaSkillBase
bs_21151.config = {buffId = 3004}
bs_21151.ctor = function(self)
  -- function num : 0_0
end

bs_21151.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_21151_3", 1, self.OnAfterHurt, nil, self.caster)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21151_1", 1, self.OnAfterBattleStart)
  self.Num = 0
end

bs_21151.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.Num == 0 and (self.caster).hp * 1000 // (self.caster).maxHp < (self.arglist)[1] then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[2])
    self.Num = 1
  end
end

bs_21151.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if target == self.caster and self.Num == 0 and not isMiss and (self.caster).hp * 1000 // (self.caster).maxHp < (self.arglist)[1] then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[2])
    self.Num = 1
  end
end

bs_21151.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21151

