-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15091 = class("bs_15091", LuaSkillBase)
local base = LuaSkillBase
bs_15091.config = {buffId = 110086}
bs_15091.ctor = function(self)
  -- function num : 0_0
end

bs_15091.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterBuffRemoveTrigger("bs_15091_2", 4, self.AfterBuffRemove, nil, eBattleRoleBelong.enemy, nil, nil, eBuffFeatureType.Stun)
end

bs_15091.AfterBuffRemove = function(self, buffId, target, removeType)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum == eBattleRoleBelong.enemy and not LuaSkillCtrl:RoleContainsBuffFeature(target, eBuffFeatureType.Stun) then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId, 0, true)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, (self.arglist)[2], true)
  end
end

bs_15091.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15091

