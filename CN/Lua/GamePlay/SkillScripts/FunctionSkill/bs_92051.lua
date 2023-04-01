-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92051 = class("bs_92051", LuaSkillBase)
local base = LuaSkillBase
bs_92051.config = {buffId = 2032, buffTier = 1}
bs_92051.ctor = function(self)
  -- function num : 0_0
end

bs_92051.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_92051_1", 1, self.OnSetHurt, self.caster)
  self.time = 0
end

bs_92051.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.sender).belongNum == (self.caster).belongNum and not context.isMiss and not context.isTriggerset and self.time < (self.arglist)[2] then
    self:PlayChipEffect()
    local heal_Num = (context.sender).maxHp * (self.arglist)[1] // 1000
    LuaSkillCtrl:CallBuff(self, context.sender, (self.config).buffId, (self.config).buffTier, nil, true)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, context.sender)
    LuaSkillCtrl:HealResultWithConfig(self, skillResult, 6, {heal_Num}, true, true)
    self.time = self.time + 1
  end
end

bs_92051.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92051

