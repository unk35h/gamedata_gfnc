-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93044 = class("bs_93044", LuaSkillBase)
local base = LuaSkillBase
bs_93044.config = {buffId = 2073}
bs_93044.ctor = function(self)
  -- function num : 0_0
end

bs_93044.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetDeadHurtTrigger("bs_93044_1", 900, self.OnSetDeadHurt, self.caster)
end

bs_93044.OnSetDeadHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender ~= self.caster then
    return 
  end
  if (context.skill).skillTag ~= eSkillTag.ultSkill then
    return 
  end
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.arglist)[1], nil, false)
  LuaSkillCtrl:CallAddPlayerHmp((ConfigData.game_config).ultMpCost * (self.arglist)[2] // 1000)
end

bs_93044.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_93044

