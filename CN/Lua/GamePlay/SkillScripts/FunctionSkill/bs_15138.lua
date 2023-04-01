-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15138 = class("bs_15138", LuaSkillBase)
local base = LuaSkillBase
bs_15138.config = {}
bs_15138.ctor = function(self)
  -- function num : 0_0
end

bs_15138.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15138_1", 1, self.OnAfterBattleStart)
end

bs_15138.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.damTimer ~= nil then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
  self.damTimer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], self.CallBack, self, -1, (self.arglist)[1])
end

bs_15138.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      if (targetList[i]).roleDataId ~= 116 then
        local ShieldNum = (targetList[i]).maxHp * (self.arglist)[2] // 1000
        LuaSkillCtrl:AddRoleShield(targetList[i], eShieldType.Normal, ShieldNum)
      end
    end
  end
end

bs_15138.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.damTimer then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
end

return bs_15138

