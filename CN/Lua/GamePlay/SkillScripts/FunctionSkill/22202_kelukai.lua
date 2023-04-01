-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_22202 = class("bs_22202", LuaSkillBase)
local base = LuaSkillBase
bs_22202.config = {buffId = 110066, buffId_live = 3009}
bs_22202.ctor = function(self)
  -- function num : 0_0
end

bs_22202.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_22202_1", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.HurtResultStart, "bs_22202_4", 1, self.OnHurtResultStart)
  self:AddSetDeadHurtTrigger("bs_22202_2", 99, self.OnSetDeadHurt, nil, nil, nil, nil, nil, 1)
  self.AVG = 0
end

bs_22202.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  LuaSkillCtrl:StartAvgWithPauseGame("cpt_clukay_05_03a", nil, nil)
end

bs_22202.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_3 , upvalues : _ENV
  if (context.target).roleDataId == 1058 and self.AVG == 0 and (context.target).hp * 1000 // (context.target).maxHp < 300 then
    LuaSkillCtrl:StartAvgWithPauseGame("cpt_clukay_05_03b", nil, nil)
    self.AVG = 1
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 1, true)
    LuaSkillCtrl:CallBuff(self, context.target, (self.config).buffId, 1, nil, true)
  end
  if context.target == self.caster and self.AVG == 0 then
    context.active = false
  end
end

bs_22202.OnSetDeadHurt = function(self, context)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, context.target, (self.config).buffId_live, 1, 1, true)
  LuaSkillCtrl:StartAvgWithPauseGame("cpt_clukay_05_03c", nil, function()
    -- function num : 0_4_0 , upvalues : _ENV
    LuaSkillCtrl:ForceEndBattle(true)
  end
)
end

bs_22202.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_22202

