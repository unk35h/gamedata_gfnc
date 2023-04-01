-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15145 = class("bs_15145", LuaSkillBase)
local base = LuaSkillBase
bs_15145.config = {formula = 10106, effectId = 12066, buffId = 1059}
bs_15145.ctor = function(self)
  -- function num : 0_0
end

bs_15145.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_15144_3", 1, self.OnAfterHurt, nil, nil, (self.caster).belongNum, nil, eBattleRoleType.character, nil, nil, eSkillTag.commonAttack, false)
  self.damageNum = 0
end

bs_15145.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if not isTriggerSet and skill.isCommonAttack and isCrit then
    self:findMax()
    local skillResult1 = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult1, 14, {self.damageNum}, true, true)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, 75)
  end
end

bs_15145.findMax = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local role, baseDamage = LuaSkillCtrl:CallFindMaxPowOrSkillIntensityRole()
  if role ~= nil then
    self.damageNum = baseDamage * (self.arglist)[1] // 1000
  end
end

bs_15145.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15145

