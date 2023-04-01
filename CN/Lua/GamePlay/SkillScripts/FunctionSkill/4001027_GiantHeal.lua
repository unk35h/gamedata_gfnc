-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001027 = class("bs_4001027", LuaSkillBase)
local base = LuaSkillBase
bs_4001027.config = {buffId = 2056}
bs_4001027.ctor = function(self)
  -- function num : 0_0
end

bs_4001027.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4001027_1", 1, self.OnAfterHurt, nil, nil, nil, eBattleRoleBelong.player)
  self.count = 0
end

bs_4001027.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and (self.arglist)[1] <= target.maxHp then
    self.count = self.count + 1
    if (self.arglist)[2] <= self.count then
      local healNum = (self.arglist)[3]
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
      LuaSkillCtrl:HealResultWithConfig(self, skillResult, 6, {healNum}, true, true)
      self.count = 0
    end
  end
end

bs_4001027.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001027

