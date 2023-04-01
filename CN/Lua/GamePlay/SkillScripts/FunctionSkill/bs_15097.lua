-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15097 = class("bs_15097", LuaSkillBase)
local base = LuaSkillBase
bs_15097.config = {effectId = 12056, fenEnBuff = 101901}
bs_15097.ctor = function(self)
  -- function num : 0_0
end

bs_15097.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddBeforeAddBuffTrigger("bs_15097_3", 2, self.OnBeforeAddBuff, self.caster, nil, nil, eBattleRoleBelong.enemy, 101901)
  self:AddAfterAddBuffTrigger("bs_15097_2", 1, self.OnAfterAddBuff, self.caster, nil, nil, eBattleRoleBelong.enemy, nil, nil, eBuffFeatureType.BeatBack)
end

bs_15097.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum == eBattleRoleBelong.enemy and self:IsReadyToTake() then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self, self.SkillEventFunc)
  end
  self:OnSkillTake()
end

bs_15097.OnBeforeAddBuff = function(self, target, context)
  -- function num : 0_3 , upvalues : _ENV
  if target.belongNum == eBattleRoleBelong.enemy and self:IsReadyToTake() then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self, self.SkillEventFunc)
  end
  self:OnSkillTake()
end

bs_15097.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, 3, {(self.arglist)[1]}, true, true)
    skillResult:EndResult()
  end
end

bs_15097.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15097

