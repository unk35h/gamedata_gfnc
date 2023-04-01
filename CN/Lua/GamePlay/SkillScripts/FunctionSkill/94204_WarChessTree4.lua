-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94204 = class("bs_94204", LuaSkillBase)
local base = LuaSkillBase
bs_94204.config = {buffId = 110060}
bs_94204.ctor = function(self)
  -- function num : 0_0
end

bs_94204.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterPlaySkill, "bs_94204_13", 1, self.OnAfterPlaySkill)
end

bs_94204.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC18: Unhandled construct in 'MakeBoolean' P3

  if (skill.maker == self.caster and skill.dataId == 5131) or skill.dataId == 5133 then
    local playerList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
    if playerList.Count > 0 then
      for i = 0, playerList.Count - 1 do
        local targetRole = playerList[i]
        LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffId, 0, false)
        LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, 1, (self.arglist)[2], ture)
      end
    end
  end
end

bs_94204.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94204

