-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_30051 = class("bs_30051", LuaSkillBase)
local base = LuaSkillBase
bs_30051.config = {checkBuffId = 1228, fuyuBuffId = 1088, buffDuration = 90}
bs_30051.ctor = function(self)
  -- function num : 0_0
end

bs_30051.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddBuffDieTrigger("bs_30051_1", 1, self.OnBuffDie, nil, nil, (self.config).checkBuffId)
end

bs_30051.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).fuyuBuffId, (self.arglist)[1], (self.config).buffDuration)
  end
end

bs_30051.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_30051

