-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_81001 = class("bs_81001", LuaSkillBase)
local base = LuaSkillBase
bs_81001.config = {buffId = 1215, buffYS = 3004, buffXY = 1033}
bs_81001.ctor = function(self)
  -- function num : 0_0
end

bs_81001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_81000_1", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_81001_10", 1, self.OnRoleDie)
  self.totalYSS = 6
end

bs_81001.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local targetRole = targetlist[i]
    if targetRole.roleDataId == 1003 then
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, 1, nil, true)
      LuaSkillCtrl:CallStartLocalScale(targetRole, (Vector3.New)(1.3, 1.3, 1.3), 0.2)
    end
  end
  local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local targetRole = targetlist[i]
    if targetRole.roleDataId == 20058 then
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffYS, 1, 600, true)
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffXY, 1, 600, true)
    end
  end
  LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s12_1", nil, nil)
end

bs_81001.OnRoleDie = function(self, killer, role)
  -- function num : 0_3 , upvalues : _ENV
  if role.roleDataId == 40035 then
    self.totalYSS = self.totalYSS - 1
    if self.totalYSS == 3 then
      LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s12_2", nil, nil)
    end
    if self.totalYSS == 0 then
      local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
      if targetlist.Count < 1 then
        return 
      end
      for i = 0, targetlist.Count - 1 do
        local targetRole = targetlist[i]
        if targetRole.roleDataId == 20058 then
          LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffYS, 0)
          LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffXY, 0)
        end
      end
      LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s12_3", nil, nil)
    end
  end
end

bs_81001.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_81001

