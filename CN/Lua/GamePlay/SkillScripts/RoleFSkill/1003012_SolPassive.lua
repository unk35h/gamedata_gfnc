-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1003012 = class("bs_1003012", base)
bs_1003012.config = {effectId_pass = 100306, audioId_pass = 100308}
bs_1003012.ctor = function(self)
  -- function num : 0_0
end

bs_1003012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_1003012_2", 1, self.OnSetHurt, nil, self.caster)
end

bs_1003012.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.target == self.caster and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[2] and (context.skill).dataId ~= 202003 and context.isTriggerSet ~= true and context.extraArg ~= (ConfigData.buildinConfig).HurtIgnoreKey and (context.skill).SkillRange ~= nil and (context.skill).SkillRange > 1 then
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_pass, self)
    context.hurt = context.hurt * (1000 - (self.arglist)[1]) // 1000
  end
end

bs_1003012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1003012

