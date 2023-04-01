-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20227 = class("bs_20227", LuaSkillBase)
local base = LuaSkillBase
bs_20227.config = {}
bs_20227.ctor = function(self)
  -- function num : 0_0
end

bs_20227.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_20227_3", 1, self.OnAfterHurt, self.caster)
end

bs_20227.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if skill.isCommonAttack and not isTriggerSet then
    local sheildNum = LuaSkillCtrl:GetRoleAllShield(self.caster) * (self.arglist)[1] // 1000
    if sheildNum > 0 then
      LuaSkillCtrl:RemoveLife(sheildNum, self, target, true, nil, true, false, eHurtType.RealDmg)
    end
  end
end

bs_20227.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20227

