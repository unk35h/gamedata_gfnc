-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001036 = class("bs_4001036", LuaSkillBase)
local base = LuaSkillBase
bs_4001036.config = {buffId = 2020, buffTier = 1}
bs_4001036.ctor = function(self)
  -- function num : 0_0
end

bs_4001036.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.flag = false
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_4001036_1", 1, self.OnAfterBattleStart)
  self:AddSetHurtTrigger("bs_4010209_2", 90, self.OnSetHurt, self.caster)
end

bs_4001036.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[3])
end

bs_4001036.OnSetHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  local buffTier = ((context.skill).maker):GetBuffTier((self.config).buffId)
  if (context.skill).maker == self.caster and context.isTriggerSet ~= true and (context.skill).isCommonAttack and context.extra_arg ~= (ConfigData.buildinConfig).HurtIgnoreKey and buffTier > 0 then
    context.hurt = context.hurt // 2
  end
end

bs_4001036.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001036

