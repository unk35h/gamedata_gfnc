-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_81000 = class("bs_81000", LuaSkillBase)
local base = LuaSkillBase
bs_81000.config = {buffStatue = 110013}
bs_81000.ctor = function(self)
  -- function num : 0_0
end

bs_81000.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_81000_1", 1, self.OnAfterBattleStart)
end

bs_81000.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local targetRole = targetlist[i]
    LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffStatue, 0)
  end
  LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s06_1", nil, nil)
  local arriveCallBack2 = BindCallback(self, self.OnArriveAction2)
  LuaSkillCtrl:StartTimer(nil, 30, arriveCallBack2)
end

bs_81000.OnArriveAction2 = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s06_2", nil, nil)
end

bs_81000.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_81000

