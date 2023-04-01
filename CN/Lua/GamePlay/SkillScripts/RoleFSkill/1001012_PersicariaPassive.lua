-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1001012 = class("bs_1001012", base)
bs_1001012.config = {effectId_line = 100103, effectId_PassHit = 100104, buffId_live = 300901, nanaka_buffId = 10260301, 
heal_config = {baseheal_formula = 3021}
, selectId = 20, selectRange = 10}
bs_1001012.ctor = function(self)
  -- function num : 0_0
end

bs_1001012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetDeadHurtTrigger("bs_1001012_1", 99, self.OnSetDeadHurt, nil, nil, nil, (self.caster).belongNum, nil, 1)
end

bs_1001012.OnSetDeadHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if self:IsReadyToTake() and (context.target).belongNum == (self.caster).belongNum and (context.target).roleType == 1 and context.target ~= context.sender and (context.target):GetBuffTier((self.config).nanaka_buffId) <= 0 then
    LuaSkillCtrl:CallBuff(self, context.target, (self.config).buffId_live, 1, 1, true)
    LuaSkillCtrl:CallEffect(context.target, (self.config).effectId_line, self)
    LuaSkillCtrl:CallEffect(context.target, (self.config).effectId_PassHit, self)
    LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_2_0 , upvalues : context, _ENV, self
    if context.target == nil or (context.target).hp <= 0 then
      return 
    end
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, context.target)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {(self.arglist)[1]}, false, false)
    skillResult:EndResult()
  end
)
    self:OnSkillTake()
  end
end

bs_1001012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1001012

