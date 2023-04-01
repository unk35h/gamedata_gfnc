-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_22204 = class("bs_22204", LuaSkillBase)
local base = LuaSkillBase
bs_22204.config = {}
bs_22204.ctor = function(self)
  -- function num : 0_0
end

bs_22204.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.HurtResultStart, "bs_22204_4", 1, self.OnHurtResultStart)
  self:AddSetDeadHurtTrigger("bs_22204_2", 99, self.OnSetDeadHurt, nil, nil, nil, nil, nil, 1)
end

bs_22204.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2
  if (context.target).roleDataId == 1021059 then
    context.active = false
  end
end

bs_22204.OnSetDeadHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  if (context.target).roleDataId == 1058 then
    LuaSkillCtrl:ForceEndBattle(true)
  end
end

bs_22204.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_22204

