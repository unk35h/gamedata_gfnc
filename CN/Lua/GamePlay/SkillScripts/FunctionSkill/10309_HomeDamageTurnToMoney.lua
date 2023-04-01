-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10309 = class("bs_10309", LuaSkillBase)
local base = LuaSkillBase
bs_10309.config = {}
bs_10309.ctor = function(self)
  -- function num : 0_0
end

bs_10309.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_10309_1", 1, self.OnAfterHurt, nil, nil, eBattleRoleBelong.enemy, eBattleRoleBelong.player, eBattleRoleType.character, 5)
end

bs_10309.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if not isMiss then
    LuaSkillCtrl:AddPlayerTowerMp((self.arglist)[1])
  end
end

bs_10309.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10309

