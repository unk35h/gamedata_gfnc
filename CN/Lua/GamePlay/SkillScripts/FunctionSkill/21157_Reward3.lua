-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21157 = class("bs_21157", LuaSkillBase)
local base = LuaSkillBase
bs_21157.config = {}
bs_21157.ctor = function(self)
  -- function num : 0_0
end

bs_21157.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_21157_1", 1, self.OnRoleDie, nil, nil, eBattleRoleBelong.player, eBattleRoleBelong.enemy)
end

bs_21157.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum == eBattleRoleBelong.enemy and killer.belongNum == eBattleRoleBelong.player then
    local value = role.maxHp * (self.arglist)[1] // 1000
    local targetlist = LuaSkillCtrl:FindRolesAroundRole(role)
    if targetlist ~= nil and targetlist.Count > 0 then
      for i = 0, targetlist.Count - 1 do
        local targetRole = targetlist[i]
        if targetRole.belongNum == eBattleRoleBelong.player then
          LuaSkillCtrl:CallHeal(value, self, targetRole, true)
        end
      end
    end
  end
end

bs_21157.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21157

