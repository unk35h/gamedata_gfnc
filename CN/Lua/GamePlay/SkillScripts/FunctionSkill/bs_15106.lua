-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15106 = class("bs_15106", LuaSkillBase)
local base = LuaSkillBase
bs_15106.config = {buffId = 2070}
bs_15106.ctor = function(self)
  -- function num : 0_0
end

bs_15106.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self:AddSetHurtTrigger("bs_15106_1", 1, self.OnSetHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack, false)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15106_2", 1, self.OnAfterBattleStart)
end

bs_15106.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1)
end

bs_15106.OnSetHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  local distance = 0
  if (context.target).belongNum == eBattleRoleBelong.enemy and context.sender == self.caster then
    distance = LuaSkillCtrl:GetGridsDistance((self.caster).x, (self.caster).y, (context.target).x, (context.target).y)
    context.hurt = context.hurt + context.hurt * distance * (self.arglist)[3] // 1000
  end
end

bs_15106.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15106

