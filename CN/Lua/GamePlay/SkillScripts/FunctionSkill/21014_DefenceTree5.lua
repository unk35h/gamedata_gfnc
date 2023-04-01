-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21014 = class("bs_21014", LuaSkillBase)
local base = LuaSkillBase
bs_21014.config = {buffId = 110023}
bs_21014.ctor = function(self)
  -- function num : 0_0
end

bs_21014.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21014_1", 1, self.OnAfterBattleStart)
end

bs_21014.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self.caster).intensity >= 2 and not LuaSkillCtrl:IsObstacle(self.caster) then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1)
  end
end

bs_21014.OnSetHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  if context.target == self.caster and (context.sender).intensity >= 2 then
    LuaSkillCtrl:CallBuff(self, context.sender, (self.config).buffId, 1, nil, true)
  end
end

bs_21014.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  if target == self.caster then
    LuaSkillCtrl:DispelBuff(sender, (self.config).buffId, 0)
  end
end

bs_21014.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_5 , upvalues : _ENV
  if context.sender == self.caster and (context.target).intensity >= 2 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  end
end

bs_21014.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21014

