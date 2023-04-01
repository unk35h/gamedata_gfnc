-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93025 = class("bs_93025", LuaSkillBase)
local base = LuaSkillBase
bs_93025.config = {}
bs_93025.ctor = function(self)
  -- function num : 0_0
end

bs_93025.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_93025_1", 1, self.OnAfterHurt, nil, self.caster)
  self.dodge_Num = 0
end

bs_93025.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isMiss then
    self.dodge_Num = self.dodge_Num + 1
    if self.dodge_Num == (self.arglist)[1] then
      self.dodge_Num = 0
      local value = (math.max)(0, 50000 - LuaSkillCtrl:GetUltHMp())
      self:PlayChipEffect()
      LuaSkillCtrl:CallAddPlayerHmp(value)
    end
  end
end

bs_93025.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_93025

