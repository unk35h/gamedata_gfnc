-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_30048 = class("bs_30048", LuaSkillBase)
local base = LuaSkillBase
bs_30048.config = {}
bs_30048.ctor = function(self)
  -- function num : 0_0
end

bs_30048.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_30048_1", 1, self.OnRoleDie, nil, nil, nil, eBattleRoleBelong.player, nil, eBattleRoleType.character)
end

bs_30048.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if killer == nil then
    return 
  end
  local TowerCd = LuaSkillCtrl:GetTowerCastCd(role)
  if (self.arglist)[1] * 2 < TowerCd then
    TowerCd = TowerCd - (self.arglist)[1]
  else
    TowerCd = (self.arglist)[1]
  end
  LuaSkillCtrl:ResetTowerCastCd(role, TowerCd)
end

bs_30048.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_30048

