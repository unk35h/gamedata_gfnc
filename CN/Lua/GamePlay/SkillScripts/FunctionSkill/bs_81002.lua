-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_81002 = class("bs_81002", LuaSkillBase)
local base = LuaSkillBase
bs_81002.config = {buffId = 32, buffId2 = 88}
bs_81002.ctor = function(self)
  -- function num : 0_0
end

bs_81002.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_81002_1", 1, self.OnAfterBattleStart)
  self:AddSetHurtTrigger("104702_14", 90, self.OnSetHurt, nil, nil, nil, eBattleRoleBelong.enemy)
  self.curTime = 0
end

bs_81002.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.target).roleDataId == 20057 then
    if LuaSkillCtrl:GetRoleAllShield(context.target) > 0 then
      context.hurt = LuaSkillCtrl:GetRoleAllShield(context.target)
    else
      context.hurt = (context.target).maxHp // 80
    end
  end
end

bs_81002.OnAfterBattleStart = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s16_1", nil, nil)
  local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local targetRole = targetlist[i]
    if targetRole.roleDataId == 20057 then
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, 1, nil, true)
      LuaSkillCtrl:RegisterRoleHpCostEvent(self, targetRole, {900, 800, 700, 600, 500, 400, 300, 200, 100, 10}, self.OnHpSubCost, false)
    end
  end
end

bs_81002.OnHpSubCost = function(self, curHp, TargetValue)
  -- function num : 0_4 , upvalues : _ENV
  self.curTime = self.curTime + 1
  if self.curTime == 1 then
    LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s16_2", nil, nil)
    self:Wudi()
  else
    if self.curTime == 2 then
      LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s16_3", nil, nil)
      self:Wudi()
    else
      if self.curTime == 3 then
        LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s16_4", nil, nil)
        self:Wudi()
      else
        if self.curTime == 4 then
          LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s16_5", nil, nil)
          self:Wudi()
        else
          if self.curTime == 5 then
            LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s16_6", nil, nil)
            self:Wudi()
          else
            if self.curTime == 6 then
              LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s16_7", nil, nil)
              self:Wudi()
            else
              if self.curTime == 7 then
                LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s16_8", nil, nil)
                self:Wudi()
              else
                if self.curTime == 8 then
                  LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s16_9", nil, nil)
                  self:Wudi()
                else
                end
              end
            end
          end
        end
      end
    end
  end
  if self.curTime == 9 then
    LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s16_10", nil, nil)
    local arriveCallBack2 = BindCallback(self, self.OnArriveAction2)
    LuaSkillCtrl:StartTimer(nil, 3, arriveCallBack2)
  end
end

bs_81002.OnArriveAction2 = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local targetRole = targetlist[i]
    if targetRole.roleDataId == 20057 then
      LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffId, 0)
    end
  end
end

bs_81002.Wudi = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local targetRole = targetlist[i]
    if targetRole.roleDataId == 20057 then
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId2, 1, 60, true)
    end
  end
end

bs_81002.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_81002

