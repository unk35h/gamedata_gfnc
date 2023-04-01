-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25111 = class("bs_25111", LuaSkillBase)
local base = LuaSkillBase
bs_25111.config = {buffId = 195}
bs_25111.ctor = function(self)
  -- function num : 0_0
end

bs_25111.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_25111_2", 1, self.OnAfterAddBuff, nil, nil, eBattleRoleBelong.player, eBattleRoleBelong.enemy, nil, nil, eBuffFeatureType.BeatBack)
end

bs_25111.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum == eBattleRoleBelong.enemy then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, 75)
  end
end

bs_25111.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25111

