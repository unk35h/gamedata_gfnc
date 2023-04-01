-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_81004 = class("bs_81004", LuaSkillBase)
local base = LuaSkillBase
bs_81004.config = {}
bs_81004.ctor = function(self)
  -- function num : 0_0
end

bs_81004.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_81004_4", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.OnBattleEnd, "bs_81004", 1, self.OnBattleEnd)
  self.flag = false
end

bs_81004.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local targetRole = targetlist[i]
    if targetRole.roleDataId == 20097 then
      self.flag = true
    end
  end
end

bs_81004.OnBattleEnd = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.flag then
    LuaSkillCtrl:StartAvgWithPauseGame("23winter_s11_1", nil, nil)
  end
end

bs_81004.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_81004

