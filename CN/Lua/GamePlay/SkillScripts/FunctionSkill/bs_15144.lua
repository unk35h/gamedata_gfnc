-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15144 = class("bs_15144", LuaSkillBase)
local base = LuaSkillBase
bs_15144.config = {effectId = 12067}
bs_15144.ctor = function(self)
  -- function num : 0_0
end

bs_15144.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterPlaySkillTrigger("bs_15144_3", 1, self.OnAfterPlaySkill, nil, nil, (self.caster).belongNum, nil, eBattleRoleType.character, nil, nil, eSkillTag.commonAttack)
  self.damageNum = 0
end

bs_15144.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.isCommonAttack then
    self:findMax()
    if (skill.moveSelectTarget).targetRole == nil then
      return 
    end
    LuaSkillCtrl:CallEffect((skill.moveSelectTarget).targetRole, (self.config).effectId, self, self.SkillEventFunc)
  end
end

bs_15144.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult1 = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult1, 14, {self.damageNum}, true, true)
    skillResult1:EndResult()
  end
end

bs_15144.findMax = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local role, baseDamage = LuaSkillCtrl:CallFindMaxPowOrSkillIntensityRole()
  if role ~= nil then
    self.damageNum = baseDamage * (self.arglist)[1] // 1000
  end
end

bs_15144.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15144

