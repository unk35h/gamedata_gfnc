-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92090 = class("bs_92090", LuaSkillBase)
local base = LuaSkillBase
bs_92090.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10076, crit_formula = 0}
, effectIdAttack = 10254, buffId1 = 1203, buffId2 = 2079, buffId3 = 1121}
bs_92090.ctor = function(self)
  -- function num : 0_0
end

bs_92090.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_92090_3", 1, self.OnAfterHurt, nil, nil, nil, (self.caster).belongNum)
end

bs_92090.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum == (self.caster).belongNum and isMiss and self.caster == target then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId2, 1, (self.arglist)[1], false)
    if target.attackRange == 1 then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId3, 1, (self.arglist)[1], false)
    else
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId1, 1, (self.arglist)[1], false)
    end
  end
end

bs_92090.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92090

