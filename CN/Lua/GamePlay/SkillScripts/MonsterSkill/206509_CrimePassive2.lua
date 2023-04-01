-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206501 = class("bs_206501", LuaSkillBase)
local base = LuaSkillBase
bs_206501.config = {buffId_crime = 206501, buffId_crime2 = 206502, buffId_bati = 206800, buffId_sueyoiSpecialAttack = 1045002}
bs_206501.ctor = function(self)
  -- function num : 0_0
end

bs_206501.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_206501_2", 90, self.OnSetHurt, nil, nil, nil, (self.caster).belongNum)
end

bs_206501.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.sender).resSrcId ~= 1045 or not (context.skill).isCommonAttack then
    return 
  end
  if (context.sender):GetBuffTier((self.config).buffId_sueyoiSpecialAttack) > 0 or context.extra_arg == (ConfigData.buildinConfig).HurtIgnoreKey or context.isTriggerSet then
    return 
  end
  if context.target ~= self.caster and ((context.target).recordTable).punish == true and not LuaSkillCtrl:RoleContainsBuffFeature(self.caster, 16) then
    local ReducedHurt = context.hurt * 500 // 1000
    if ReducedHurt > 0 then
      context.hurt = context.hurt - ReducedHurt
      LuaSkillCtrl:RemoveLife(ReducedHurt, self, self.caster, true, nil, true, true, eHurtType.RealDmg)
    end
  end
end

return bs_206501

