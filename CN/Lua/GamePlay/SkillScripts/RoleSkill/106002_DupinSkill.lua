-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106002 = class("bs_106002", LuaSkillBase)
local base = LuaSkillBase
bs_106002.config = {skill_time = 20, start_time = 15, buffId_skill = 106002, buffId_170 = 170, buffId_3004 = 3004, buffId_3024 = 3024, effectId_start = 106009, effectId_start2 = 106014, effectId_go = 106007, effectId_down = 106008, actionId = 1002, action_speed = 1}
bs_106002.ctor = function(self)
  -- function num : 0_0
end

bs_106002.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).passive_skill1 = (self.arglist)[1]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).passive_arg4 = (self.arglist)[4]
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).passive_arg5 = (self.arglist)[5]
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).passive_arg6 = (self.arglist)[6]
end

bs_106002.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_start, self)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_start2, self)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_3024, 1, (self.config).start_time + (self.arglist)[2], true)
end

bs_106002.OnAttackTrigger = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_go, self)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable).turn = nil
  local behindGrid = nil
  local onFireRole = (self.caster):TryToGetFocusFiringRole()
  if onFireRole ~= nil then
    behindGrid = LuaSkillCtrl:FindEmptyGridAroundRole(onFireRole)
  end
  if behindGrid == nil then
    local clueTable = ((self.caster).recordTable).clueTable
    if #clueTable > 0 then
      local tempTable = {}
      for i,v in ipairs(clueTable) do
        local uid = (math.modf)(v / 100000)
        if tempTable[uid] == nil then
          tempTable[uid] = 1
        else
          tempTable[uid] = tempTable[uid] + 1
        end
      end
      local count = 0
      for k,v in pairs(tempTable) do
        count = count + 1
      end
      behindGrid = self:FindAroundGrid(tempTable, count)
    end
  end
  do
    do
      if behindGrid == nil then
        local lastAttackRole = ((self.caster).recordTable).lastAttackRole
        -- DECOMPILER ERROR at PC71: Confused about usage of register: R4 in 'UnsetPending'

        ;
        ((self.caster).recordTable).turn = ((self.caster).recordTable).lastAttackRole
        if lastAttackRole ~= nil then
          behindGrid = LuaSkillCtrl:FindEmptyGridAroundRole(lastAttackRole)
        end
      end
      do
        if behindGrid == nil then
          local moveTarget = self:GetMoveSelectTarget()
          if moveTarget == nil then
            return 
          end
          behindGrid = LuaSkillCtrl:FindEmptyGridAroundRole(moveTarget.targetRole)
          -- DECOMPILER ERROR at PC94: Confused about usage of register: R4 in 'UnsetPending'

          ;
          ((self.caster).recordTable).turn = moveTarget.targetRole
        end
        -- DECOMPILER ERROR at PC110: Confused about usage of register: R3 in 'UnsetPending'

        if behindGrid ~= nil then
          if ((self.caster).recordTable).lastAttackRole ~= ((self.caster).recordTable).turn then
            ((self.caster).recordTable).lastAttackRole = ((self.caster).recordTable).turn
          end
          LuaSkillCtrl:SetRolePos(behindGrid, self.caster)
          if ((self.caster).recordTable).turn ~= nil then
            (self.caster):LookAtTarget(((self.caster).recordTable).turn)
          end
        end
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_down, self)
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_skill, 1, (self.arglist)[2])
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_3004, 1, (self.arglist)[7])
      end
    end
  end
end

bs_106002.FindAroundGrid = function(self, clueCountTable, index)
  -- function num : 0_4 , upvalues : _ENV
  if index == 0 then
    return nil
  end
  local targetUid = 0
  local maxCount = 0
  for k,v in pairs(clueCountTable) do
    if maxCount < v then
      targetUid = k
      maxCount = v
    end
  end
  if targetUid ~= 0 then
    local enemyList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
    for i = 0, enemyList.Count - 1 do
      if (enemyList[i]).uid == targetUid then
        local behindGrid = LuaSkillCtrl:FindEmptyGridAroundRole(enemyList[i])
        if behindGrid == nil then
          return self:FindAroundGrid(clueCountTable, index - 1)
        else
          -- DECOMPILER ERROR at PC47: Confused about usage of register: R11 in 'UnsetPending'

          ;
          ((self.caster).recordTable).turn = enemyList[i]
          return behindGrid
        end
      end
    end
  end
  do
    return self:FindAroundGrid(clueCountTable, index - 1)
  end
end

bs_106002.GetRoleBehindGrid = function(self, role)
  -- function num : 0_5 , upvalues : _ENV
  local grid = LuaSkillCtrl:FindEmptyGridAroundRole(role)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  if grid ~= nil then
    ((self.caster).recordTable).turn = role
    return grid
  end
  return nil
end

bs_106002.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106002

