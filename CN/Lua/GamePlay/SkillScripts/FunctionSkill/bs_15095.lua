-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15095 = class("bs_15095", LuaSkillBase)
local base = LuaSkillBase
bs_15095.config = {formula = 10106, effectId = 12054}
bs_15095.ctor = function(self)
  -- function num : 0_0
end

bs_15095.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddBeforeAddBuffTrigger("bs_15095_1", 1, self.OnBeforeAddBuff, nil, self.caster, nil, nil, nil, nil, eBuffFeatureType.Stun)
  self:AddAfterAddBuffTrigger("bs_15095_2", 1, self.OnAfterAddBuff, nil, self.caster, nil, nil, nil, nil, eBuffFeatureType.Stun)
  self:AddAfterBuffRemoveTrigger("bs_15095_3", 4, self.AfterBuffRemove, self.caster, nil, nil, nil, eBuffFeatureType.Stun)
  self.currentHp = 0
  self.effect = nil
end

bs_15095.OnBeforeAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if not LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.Stun) then
    self.currentHp = (self.caster).hp
  end
end

bs_15095.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_3 , upvalues : _ENV
  if LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.Stun) and self.effect == nil then
    self.effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
  end
end

bs_15095.AfterBuffRemove = function(self, buffId, target, removeType)
  -- function num : 0_4 , upvalues : _ENV
  if target.belongNum == eBattleRoleBelong.enemy then
    if self.effect ~= nil then
      (self.effect):Die()
      self.effect = nil
    end
    if not LuaSkillCtrl:RoleContainsBuffFeature(target, eBuffFeatureType.Stun) then
      local damage = (math.max)(self.currentHp - (self.caster).hp, 0) * (self.arglist)[1] // 1000
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, 14, {damage}, true, true)
      skillResult:EndResult()
    end
  end
end

bs_15095.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15095

