-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10321 = class("bs_10321", LuaSkillBase)
local base = LuaSkillBase
bs_10321.config = {buffWKId = 1248, buffSL = 1249, buffEWSL = 1250}
bs_10321.ctor = function(self)
  -- function num : 0_0
end

bs_10321.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_10321_1", 1, self.OnAfterBattleStart)
  self:AddAfterAddBuffTrigger("bs_10321_7", 1, self.OnAfterAddBuff, nil, self.caster, nil, nil, (self.config).buffWKId)
  self:AddBeforeBuffDispelTrigger("bs_10321_1", 1, self.BeforeBuffDispel, self.caster, nil, (self.config).buffWKId)
  self:AddBuffDieTrigger("bs_10321_2", 1, self.OnBuffDie, self.caster, nil, (self.config).buffWKId)
end

bs_10321.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffSL, 1, nil, true)
end

bs_10321.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_3 , upvalues : _ENV
  if buff.dataId == (self.config).buffWKId then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffEWSL, 1, nil, true)
  end
end

bs_10321.BeforeBuffDispel = function(self, targetRole, context)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffEWSL, 0)
end

bs_10321.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_5 , upvalues : _ENV
  if buff.dataId == (self.config).buffWKId then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffEWSL, 0)
  end
end

bs_10321.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10321

