-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001038 = class("bs_4001038", LuaSkillBase)
local base = LuaSkillBase
bs_4001038.config = {buffId = 2073}
bs_4001038.ctor = function(self)
  -- function num : 0_0
end

bs_4001038.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_4001038_1", 10, self.OnRoleDie, self.caster, nil, nil, eBattleRoleBelong.enemy)
end

bs_4001038.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if killer ~= self.caster or (self.caster):GetBuffTier((self.config).buffId) < 1 then
    return 
  end
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, false)
end

bs_4001038.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001038

