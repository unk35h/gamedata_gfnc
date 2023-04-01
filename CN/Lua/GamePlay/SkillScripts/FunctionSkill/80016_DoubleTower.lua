-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80016 = class("bs_80016", LuaSkillBase)
local base = LuaSkillBase
bs_80016.config = {}
bs_80016.ctor = function(self)
  -- function num : 0_0
end

bs_80016.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_80016_2", 1, self.OnAfterAddBuff, nil, nil, nil, eBattleRoleBelong.enemy, nil, eBuffType.Debeneficial)
end

bs_80016.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum == eBattleRoleBelong.enemy and target.intensity > 0 and buff.buffType == 2 then
    local shieldValue = (self.caster).skill_intensity * (self.arglist)[1] // 1000
    LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, shieldValue, nil, true)
  end
end

bs_80016.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80016

