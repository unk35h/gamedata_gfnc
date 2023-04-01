-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94209 = class("bs_94209", LuaSkillBase)
local base = LuaSkillBase
bs_94209.config = {buffId = 110065}
bs_94209.ctor = function(self)
  -- function num : 0_0
end

bs_94209.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_94209_11", 1, self.OnRoleDie)
end

bs_94209.OnRoleDie = function(self, killer, role, killSkill)
  -- function num : 0_2 , upvalues : _ENV
  if killer.belongNum == eBattleRoleBelong.player and role.belongNum == eBattleRoleBelong.enemy then
    local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
    if targetlist.Count > 0 then
      for i = 0, targetlist.Count - 1 do
        LuaSkillCtrl:CallBuff(self, targetlist[i], (self.config).buffId, 1, (self.arglist)[2])
      end
    end
  end
end

bs_94209.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94209

