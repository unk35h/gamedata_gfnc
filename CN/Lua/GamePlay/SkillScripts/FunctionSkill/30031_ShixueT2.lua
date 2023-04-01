-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_30031 = class("bs_30031", LuaSkillBase)
local base = LuaSkillBase
bs_30031.config = {buffId_shixue = 257, buff_baoji = 1195}
bs_30031.ctor = function(self)
  -- function num : 0_0
end

bs_30031.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_30031_7", 1, self.OnAfterAddBuff, nil, self.caster, nil, nil, (self.config).buffId_shixue)
  self:AddBeforeBuffDispelTrigger("bs_30031_1", 1, self.BeforeBuffDispel, self.caster, nil, (self.config).buffId_shixue)
  self:AddBuffDieTrigger("bs_30035_2", 1, self.OnBuffDie, self.caster, nil, (self.config).buffId_shixue)
end

bs_30031.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if buff.dataId == (self.config).buffId_shixue then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff_baoji, buff.tier, nil, true)
  end
end

bs_30031.BeforeBuffDispel = function(self, targetRole, context)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buff_baoji, context.tier)
end

bs_30031.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_4 , upvalues : _ENV
  if buff.dataId == (self.config).buffId_shixue then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buff_baoji, buff.tier)
  end
end

bs_30031.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_30031

