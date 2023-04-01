-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_30057 = class("bs_30057", LuaSkillBase)
local base = LuaSkillBase
bs_30057.config = {buffWKId = 1248, buffId = 1251}
bs_30057.ctor = function(self)
  -- function num : 0_0
end

bs_30057.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_10321_7", 1, self.OnAfterAddBuff, nil, self.caster, nil, nil, (self.config).buffWKId)
  self:AddBeforeBuffDispelTrigger("bs_10321_1", 1, self.BeforeBuffDispel, self.caster, nil, (self.config).buffWKId)
  self:AddBuffDieTrigger("bs_10321_2", 1, self.OnBuffDie, self.caster, nil, (self.config).buffWKId)
end

bs_30057.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if buff.dataId == (self.config).buffWKId then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  end
end

bs_30057.BeforeBuffDispel = function(self, targetRole, context)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
end

bs_30057.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_4 , upvalues : _ENV
  if buff.dataId == (self.config).buffWKId then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_30057.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_30057

