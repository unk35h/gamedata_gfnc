-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206302 = class("bs_206302", LuaSkillBase)
local base = LuaSkillBase
bs_206302.config = {buffId = 32}
bs_206302.ctor = function(self)
  -- function num : 0_0
end

bs_206302.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_206302_2", 99, self.OnSetHurt, nil, self.caster)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_206302_1", 1, self.OnAfterBattleStart)
  self.flag650 = true
  self.flag400 = true
end

bs_206302.OnSetHurt = function(self, context)
  -- function num : 0_2
  if context.target == self.caster and (self.caster).hp < context.hurt then
    context.hurt = 0
  end
  if context.target == self.caster then
    context.hurt = context.hurt * 1000 // 3500
  end
end

bs_206302.OnAfterBattleStart = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  LuaSkillCtrl:StartTimer(nil, 220, arriveCallBack)
end

bs_206302.OnArriveAction = function(self)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:ForceEndBattle(true)
end

bs_206302.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_206302

