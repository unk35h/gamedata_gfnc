-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93027 = class("bs_93027", LuaSkillBase)
local base = LuaSkillBase
bs_93027.config = {buffId = 2043}
bs_93027.ctor = function(self)
  -- function num : 0_0
end

bs_93027.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_93027_10", 1, self.OnRoleDie, nil, nil, nil, eBattleRoleBelong.player)
end

bs_93027.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum == eBattleRoleBelong.player then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
    self:PlayChipEffect()
  end
end

bs_93027.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_93027

