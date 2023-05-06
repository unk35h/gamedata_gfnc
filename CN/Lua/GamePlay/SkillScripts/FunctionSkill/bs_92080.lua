-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92080 = class("bs_92080", LuaSkillBase)
local base = LuaSkillBase
bs_92080.config = {buffId = 2073, buffId2 = 2075}
bs_92080.ctor = function(self)
  -- function num : 0_0
end

bs_92080.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_92080", 1, self.AfterBattleStart)
end

bs_92080.AfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local target = self:findMaxPow()
  LuaSkillCtrl:StartTimer(self, 4, BindCallback(self, self.eventFunc, target))
end

bs_92080.eventFunc = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  if target == nil then
    return 
  end
  LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId, 1, nil, false)
  local roleList = LuaSkillCtrl:FindRolesAroundRole(target.targetRole)
  if roleList == nil or roleList.Count < 1 then
    return 
  end
  for i = 0, roleList.Count - 1 do
    if (roleList[i]).belongNum == eBattleRoleBelong.player then
      LuaSkillCtrl:CallBuff(self, roleList[i], (self.config).buffId2, 1, nil, true)
    end
  end
end

bs_92080.findMaxPow = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (LuaSkillCtrl:CallTargetSelect(self, 59, 10))
  local targetList = nil
  local target = nil
  local i = 0
  while 1 do
    if target == nil or (target.targetRole).roleType ~= eBattleRoleType.character then
      target = targetList[i]
      i = i + 1
      -- DECOMPILER ERROR at PC18: LeaveBlock: unexpected jumping out IF_THEN_STMT

      -- DECOMPILER ERROR at PC18: LeaveBlock: unexpected jumping out IF_STMT

    end
  end
  return target
end

bs_92080.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92080

