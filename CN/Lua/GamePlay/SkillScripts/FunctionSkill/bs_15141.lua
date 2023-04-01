-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15141 = class("bs_15141", LuaSkillBase)
local base = LuaSkillBase
bs_15141.config = {effect = 12064}
bs_15141.ctor = function(self)
  -- function num : 0_0
end

bs_15141.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15141_1", 1, self.OnAfterBattleStart)
  self:AddSetHurtTrigger("bs_15141_3", 1, self.OnSetHurt, nil, self.caster)
  self.time = 0
  self.effect = nil
end

bs_15141.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.damTimer ~= nil then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
  self.damTimer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], self.CallBack, self, -1, (self.arglist)[1])
end

bs_15141.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.time == 1 then
    self.time = 0
  end
  if self.effect ~= nil then
    return 
  else
    self.effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effect, self)
  end
end

bs_15141.OnSetHurt = function(self, context)
  -- function num : 0_4
  if (context.target).roleDataId == 116 and self.time == 0 and not context.isMiss then
    self:PlayChipEffect()
    context.hurt = 0
    self.time = 1
    if self.effect ~= nil then
      (self.effect):Die()
      self.effect = nil
    end
  end
end

bs_15141.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
  if self.damTimer then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
end

bs_15141.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
  if self.effect ~= nil then
    (self.effect):Die()
    self.effect = nil
  end
end

return bs_15141

