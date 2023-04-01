-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21034 = class("bs_21034", LuaSkillBase)
local base = LuaSkillBase
bs_21034.config = {checkBuffId = 110015, buffId = 1009}
bs_21034.ctor = function(self)
  -- function num : 0_0
end

bs_21034.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_21034_7", 2, self.OnAfterAddBuff, nil, nil, nil, nil, (self.config).checkBuffId)
  self:AddBeforeBuffDispelTrigger("bs_21034_6", 2, self.BeforeBuffDispel, self.caster, nil, (self.config).checkBuffId)
end

bs_21034.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if buff.dataId == (self.config).checkBuffId then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.arglist)[1], nil)
  end
end

bs_21034.BeforeBuffDispel = function(self, targetRole, context)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, (self.arglist)[1])
end

bs_21034.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21034

