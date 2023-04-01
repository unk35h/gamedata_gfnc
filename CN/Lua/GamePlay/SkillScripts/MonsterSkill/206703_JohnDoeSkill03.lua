-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206703 = class("bs_206703", LuaSkillBase)
local base = LuaSkillBase
bs_206703.config = {effectIdGrid = 2067031, effectIdGo = 2067032, effectIdUp = 2067033, effectIdStart = 2067034, effectIdAttack = 2067035, effectIdHurt = 2067036, effectIdHit = 2067037, selectId = 40, actionId = 1105, skill_time = 30, start_time = 7, buffId_hurt = 2067031, buffId_skillTip = 2067032, buffId_Stun = 3006, 
Aoe = {effect_shape = eSkillResultShapeType.Target, aoe_select_code = 4, aoe_range = 1}
, configId = 3}
bs_206703.ctor = function(self)
  -- function num : 0_0
end

bs_206703.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.grid = {}
  self.gridEffect = nil
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).attackUp = (self.arglist)[4]
end

bs_206703.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self:AbandonSkillCdAutoReset(true)
  local target = LuaSkillCtrl:GetRoleWithPos(5, 2)
  do
    if target ~= nil and target.hp > 0 and target ~= self.caster then
      local grid1 = LuaSkillCtrl:CallFindEmptyGridNearest(target)
      LuaSkillCtrl:CallPhaseMove(self, target, grid1.x, grid1.y, 3, 69, 1)
    end
    local grid = LuaSkillCtrl:GetTargetWithGrid(5, 2)
    local gridrole = LuaSkillCtrl:GetGridWithPos(5, 2)
    self:ReadyPlaySkill(data, gridrole)
  end
end

bs_206703.ReadyPlaySkill = function(self, data, grid)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectIdGo, self)
  LuaSkillCtrl:SetRolePos(grid, self.caster)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectIdUp, self)
  self:CallCasterWait((self.config).skill_time)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  local lookGrid = LuaSkillCtrl:GetTargetWithGrid(0, 2)
  ;
  (self.caster):LookAtTarget(lookGrid)
  LuaSkillCtrl:PlayAuSource(self.caster, 465)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, 1, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_skillTip, 1, (self.arglist)[5] + (self.config).skill_time)
  self.gridEffect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectIdAttack, self)
  LuaSkillCtrl:StartTimer(nil, (self.config).skill_time, function()
    -- function num : 0_3_0 , upvalues : self
    self:EndSkillAndCallNext()
  end
)
end

bs_206703.EndSkillAndCallNext = function(self)
  -- function num : 0_4
  if self.caster == nil then
    return 
  end
  local skillMgr = (self.caster):GetSkillComponent()
  if skillMgr == nil then
    return 
  end
  skillMgr.lastSkill = self.cskill
  self:CallNextBossSkill()
end

bs_206703.OnAttackTrigger = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId, 10)
  LuaSkillCtrl:PlayAuSource(self.caster, 466)
  self:InspectGridTarget(targetList)
  LuaSkillCtrl:StartTimer(nil, (self.arglist)[3], BindCallback(self, self.KillAllGridEffect))
  self:CallHurt()
end

bs_206703.KillAllGridEffect = function(self)
  -- function num : 0_6
  if self.gridEffect ~= nil then
    (self.gridEffect):Die()
    self.gridEffect = nil
  end
end

bs_206703.CallHurt = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.grid == nil or (table.count)(self.grid) <= 0 then
    self:CancleCasterWait()
    return 
  end
  local time = (self.arglist)[3] // 15
  LuaSkillCtrl:StartTimer(nil, 15, function()
    -- function num : 0_7_0 , upvalues : self, _ENV
    for i = 1, 5 do
      local grid = (self.grid)[i]
      if grid ~= nil and grid.role ~= nil and not LuaSkillCtrl:IsFixedObstacle(grid.role) and (grid.role).belongNum ~= (self.caster).belongNum then
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, grid.role, (self.config).Aoe)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[2]})
        LuaSkillCtrl:CallEffect(grid.role, (self.config).effectIdHit, self)
        skillResult:EndResult()
      end
    end
  end
, self, time - 1)
end

bs_206703.PhaseMoveRole = function(self, role, emptyGrid)
  -- function num : 0_8 , upvalues : _ENV
  self:TryResetMoveState(role)
  LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_Stun, 1, (self.arglist)[1] + 3)
  LuaSkillCtrl:CallPhaseMove(self, role, emptyGrid.x, emptyGrid.y, 3, 63, 1)
end

bs_206703.InspectGridTarget = function(self, targetList)
  -- function num : 0_9 , upvalues : _ENV
  local isCheck = false
  for i = 5, 1, -1 do
    local grid = LuaSkillCtrl:GetGridWithPos(i - 1, 2)
    if grid ~= nil then
      if ((self.caster).recordTable).RootAddGrid ~= nil then
        LuaSkillCtrl:CallCreateEfcGrid(i - 1, 2, 15)
      end
      -- DECOMPILER ERROR at PC24: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.grid)[i] = grid
      if grid:IsGridEmpty() then
        if targetList.Count <= 0 then
          return 
        end
        if i == 5 then
          local roleT = self:FindTForFirstGrid(targetList)
          if roleT ~= nil then
            self:PhaseMoveRole(roleT, grid)
          else
            do
              if not isCheck then
                for j = targetList.Count - 1, 0, -1 do
                  local targetRole = (targetList[j]).targetRole
                  if not LuaSkillCtrl:CheckReletionWithRoleBelong(targetRole, self.caster, 2) or LuaSkillCtrl:RoleContainsBuffFeature(targetRole, eBuffFeatureType.CtrlImmunity) or targetRole.x < 5 and targetRole.y == 2 then
                    targetList:RemoveAt(j)
                  end
                end
                isCheck = true
              end
              for j = 0, targetList.Count - 1 do
                local targetRole = (targetList[j]).targetRole
                self:PhaseMoveRole(targetRole, grid)
                targetList:RemoveAt(j)
                break
              end
              do
                -- DECOMPILER ERROR at PC97: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC97: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                -- DECOMPILER ERROR at PC97: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC97: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC97: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC97: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC97: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC97: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC97: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
      end
    end
  end
end

bs_206703.FindTForFirstGrid = function(self, targetList)
  -- function num : 0_10 , upvalues : _ENV
  local topRole = ((self.caster).recordTable).lastAttackRole
  if topRole ~= nil and topRole.career == 1 and LuaSkillCtrl:CheckReletionWithRoleBelong(topRole, self.caster, 2) and not LuaSkillCtrl:RoleContainsBuffFeature(topRole, eBuffFeatureType.CtrlImmunity) then
    for i = 0, targetList.Count - 1 do
      if (targetList[i]).targetRole == topRole then
        targetList:RemoveAt(i)
        return topRole
      end
    end
  end
  do
    for i = targetList.Count - 1, 0, -1 do
      local target = targetList[i]
      local targetRole = target.targetRole
      if targetRole.career == 1 and LuaSkillCtrl:CheckReletionWithRoleBelong(targetRole, self.caster, 2) and not LuaSkillCtrl:RoleContainsBuffFeature(targetRole, eBuffFeatureType.CtrlImmunity) then
        targetList:RemoveAt(i)
        return targetRole
      end
    end
  end
end

bs_206703.OnCasterDie = function(self)
  -- function num : 0_11 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_206703.OnBreakSkill = function(self, breakRole)
  -- function num : 0_12 , upvalues : _ENV, base
  if breakRole == self.caster then
    LuaSkillCtrl:CanclePreSetPos(self.caster)
    self:KillAllGridEffect()
  end
  ;
  (base.OnBreakSkill)(self, breakRole)
end

bs_206703.LuaDispose = function(self)
  -- function num : 0_13 , upvalues : base
  (base.LuaDispose)(self)
  self.grid = nil
  self.gridEffect = nil
end

return bs_206703

