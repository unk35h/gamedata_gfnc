-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80017 = class("bs_80017", LuaSkillBase)
local base = LuaSkillBase
bs_80017.config = {buffId1 = 195, buffId2 = 110057}
bs_80017.ctor = function(self)
  -- function num : 0_0
end

bs_80017.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_80017_1", 1, self.OnAfterBattleStart)
end

bs_80017.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.doFun)
  LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], arriveCallBack, nil, -1)
end

bs_80017.doFun = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local playList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  if playList.Count > 0 then
    for i = playList.Count - 1, 0, -1 do
      local targetRole = playList[i]
      if targetRole.intensity > 0 then
        LuaSkillCtrl:RemoveLife((math.max)(1, targetRole.maxHp * (self.arglist)[2] // 1000), self, targetRole, true, nil, true, true, eHurtType.RealDmg)
      end
    end
  end
  do
    local enemyList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
    if enemyList.Count > 0 then
      for i = enemyList.Count - 1, 0, -1 do
        local targetRole = enemyList[i]
        if targetRole.intensity > 0 then
          LuaSkillCtrl:RemoveLife((math.max)(1, targetRole.maxHp * (self.arglist)[2] // 1000), self, targetRole, true, nil, true, true, eHurtType.RealDmg)
        end
      end
    end
    do
      local neutralList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.neutral)
      if neutralList.Count > 0 then
        for i = neutralList.Count - 1, 0, -1 do
          local targetRole = neutralList[i]
          if targetRole.intensity > 0 then
            LuaSkillCtrl:RemoveLife((math.max)(1, targetRole.maxHp * (self.arglist)[2] // 1000), self, targetRole, true, nil, true, true, eHurtType.RealDmg)
          end
        end
      end
    end
  end
end

bs_80017.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80017

