-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105401 = class("bs_105401", LuaSkillBase)
local base = LuaSkillBase
bs_105401.config = {buffId_healUp = 105402, buffId_attackHeal = 105403, buffId_tasterMark = 105406, buffId_attackUp = 105401, buffId_shield = 105411, buffId_attackUp2 = 105408, buffId_attackUpG = 105413, buffId_attackUpG2 = 105414, effectId_food_loop = 105406, effectId_dandao = 105419, effectId_kaisi = 105420, superBuffId = 271, 
aoe_config = {effect_shape = 3, aoe_select_code = 5, aoe_range = 1}
, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0, crithur_ratio = 0}
, audioId1 = 105405, audioId2 = 108, audioId3 = 109, selectCode = 57}
bs_105401.ctor = function(self)
  -- function num : 0_0
end

bs_105401.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_105401_1", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.OnBreakShield, "bs_105401_1", 1, self.OnBreakShield)
  self._delayManageCollisionEnter = BindCallback(self, self.DelayManageCollisionEnter)
  self.food_list = {}
  self.food_targetTable = {}
end

bs_105401.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_2 , upvalues : _ENV
  if shieldType == 0 and target:GetBuffTier((self.config).buffId_shield) > 0 then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_shield, 0)
  end
end

bs_105401.OnAfterBattleStart = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_kaisi, self)
  local start_time = (self.arglist)[2] - (self.arglist)[1]
  self.passive = LuaSkillCtrl:StartTimer(nil, (self.arglist)[2], self.Callback, self, -1, start_time)
  local targetlist = LuaSkillCtrl:CallTargetSelectWithRange(self, 6, 1)
  if targetlist.Count > 0 then
    for i = 0, targetlist.Count - 1 do
      if (targetlist[i]).targetRole ~= nil then
        LuaSkillCtrl:CallBuff(self, (targetlist[i]).targetRole, (self.config).buffId_tasterMark, 1)
        LuaSkillCtrl:CallBuff(self, (targetlist[i]).targetRole, (self.config).buffId_attackHeal, 1)
      end
    end
  end
end

bs_105401.Callback = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.passive ~= nil and (self.passive):IsOver() then
    self.passive = nil
  end
  local tempTable = {}
  local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetlist.Count > 0 then
    for i = 0, targetlist.Count - 1 do
      if targetlist[i] ~= nil then
        local role = targetlist[i]
        local grid_dict = LuaSkillCtrl:FindEmptyGridsWithinRange(role.x, role.y, 3)
        if grid_dict ~= nil and grid_dict.Count > 0 then
          for i = 0, grid_dict.Count - 1 do
            local grid = grid_dict[i]
            if tempTable[grid] == nil and (self.food_list)[grid] == nil then
              tempTable[grid] = LuaSkillCtrl:GetGridsDistance(grid.x, grid.y, role.x, role.y)
            end
          end
          do
            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  local grid_dict = LuaSkillCtrl:FindEmptyGridsWithinRange((self.caster).x, (self.caster).y, 1)
  if grid_dict ~= nil then
    for i = 0, grid_dict.Count - 1 do
      local grid = grid_dict[i]
      if tempTable[grid] ~= nil then
        tempTable[grid] = nil
      end
    end
  end
  do
    local resultGrid = nil
    local minDis = 99
    for k,v in pairs(tempTable) do
      if v ~= nil then
        if v == 1 then
          resultGrid = k
          minDis = v
          break
        else
          if resultGrid == nil or v < minDis then
            resultGrid = k
            minDis = v
          end
        end
      end
    end
    do
      do
        if resultGrid == nil then
          local grid = LuaSkillCtrl:FindEmptyGrid(function(x, y)
    -- function num : 0_4_0 , upvalues : _ENV, self
    local grid_this = LuaSkillCtrl:GetGridWithPos(x, y)
    do return (self.food_list)[grid_this] == nil end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
        end
        if resultGrid ~= nil then
          local target_role = LuaSkillCtrl:GetTargetWithGrid(resultGrid.x, resultGrid.y)
          local effect = LuaSkillCtrl:CallEffect(target_role, (self.config).effectId_food_loop, self)
          local collisionEnter = BindCallback(self, self.OnCollisionEnter, resultGrid, effect)
          LuaSkillCtrl:CallAddCircleColliderForEffect(effect, 100, eColliderInfluenceType.Player, nil, collisionEnter, nil)
          local Callback = BindCallback(self, self.AutoGive, effect, resultGrid)
          LuaSkillCtrl:StartTimer(nil, (self.arglist)[7], Callback, self)
          -- DECOMPILER ERROR at PC155: Confused about usage of register: R10 in 'UnsetPending'

          ;
          (self.food_list)[resultGrid] = effect
          LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
        end
      end
    end
  end
end

bs_105401.AutoGive = function(self, effect, grid)
  -- function num : 0_5 , upvalues : _ENV
  if effect == nil or effect:IsDie() then
    return 
  end
  local tempEffect = (self.food_list)[grid]
  if tempEffect == nil or tempEffect ~= effect then
    return 
  end
  local target = LuaSkillCtrl:GetTargetWithGrid(grid.x, grid.y)
  if target == nil then
    return 
  end
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 501101, 20)
  local attack_int = 0
  local pass_target1 = nil
  if targetList ~= nil and targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = (targetList[i]).targetRole
      if role.belongNum == (self.caster).belongNum and (attack_int < role.pow or attack_int < role.skill_intensity) then
        pass_target1 = role
        if role.skill_intensity <= role.pow then
          attack_int = role.pow
        else
          attack_int = role.skill_intensity
        end
      end
    end
  end
  do
    LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effectId_dandao, self, pass_target1, false, false, self.SkillEventFunc2, pass_target1)
    if effect ~= nil then
      effect:Die()
      effect = nil
    end
  end
end

bs_105401.SkillEventFunc2 = function(self, entity, effect, eventId, target)
  -- function num : 0_6 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_dandao and eventId == eBattleEffectEvent.Trigger then
    local grid = target
    local buff1 = LuaSkillCtrl:GetRoleBuffById(entity, (self.config).buffId_tasterMark)
    if buff1 ~= nil then
      LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_attackUpG2, 2, (self.arglist)[6])
      local value1 = (self.caster).def * (self.arglist)[8] // 1000 * 2
      if value1 > 0 then
        LuaSkillCtrl:AddRoleShield(entity, eShieldType.Normal, value1)
        local SelfShieldValue = LuaSkillCtrl:GetShield(entity, 0)
        if SelfShieldValue ~= 0 then
          LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_shield, 1)
        end
      end
    else
      do
        LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_attackUpG, 1, (self.arglist)[6])
        local value2 = (self.caster).def * (self.arglist)[8] // 1000
        if value2 > 0 then
          LuaSkillCtrl:AddRoleShield(entity, eShieldType.Normal, value2)
          local SelfShieldValue = LuaSkillCtrl:GetShield(entity, 0)
          if SelfShieldValue ~= 0 then
            LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_shield, 1)
          end
        end
      end
    end
  end
end

bs_105401.OnCollisionEnter = function(self, grid, effect, collider, index, entity)
  -- function num : 0_7 , upvalues : _ENV
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R6 in 'UnsetPending'

  if entity ~= nil and entity.hp > 0 and entity.belongNum == (self.caster).belongNum and entity.belongNum ~= eBattleRoleBelong.neutral and entity.roleType == eBattleRoleType.character and (entity.recordTable).WillowPic ~= true then
    if (self.food_targetTable)[effect] == nil then
      (self.food_targetTable)[effect] = {}
      local tempTable = {}
      tempTable.effect = effect
      tempTable.grid = grid
      LuaSkillCtrl:StartTimer(self, 1, self._delayManageCollisionEnter, tempTable)
      -- DECOMPILER ERROR at PC42: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (self.food_list)[grid] = nil
    end
    do
      -- DECOMPILER ERROR at PC45: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self.food_targetTable)[effect])[index] = entity
    end
  end
end

bs_105401.DelayManageCollisionEnter = function(self, tempTable)
  -- function num : 0_8 , upvalues : _ENV
  local addTarget = nil
  local effect = tempTable.effect
  local grid = tempTable.grid
  local target = LuaSkillCtrl:GetTargetWithGrid(grid.x, grid.y)
  local maxAttack = 0
  for k,v in pairs(self.food_targetTable) do
    if k == effect then
      for k2,v2 in pairs(v) do
        if maxAttack < v2.pow then
          maxAttack = v2.pow
          addTarget = v2
        end
      end
    end
  end
  if addTarget ~= nil then
    LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effectId_dandao, self, addTarget, false, false, self.SkillEventFunc, addTarget)
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.food_targetTable)[effect] = nil
    if effect ~= nil then
      effect:Die()
      effect = nil
    end
  end
end

bs_105401.SkillEventFunc = function(self, entity, effect, eventId, target)
  -- function num : 0_9 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Die then
    local grid = target
    local buff1 = LuaSkillCtrl:GetRoleBuffById(entity, (self.config).buffId_tasterMark)
    if buff1 ~= nil then
      LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_attackUp2, 2, (self.arglist)[6])
      local value1 = (self.caster).def * (self.arglist)[4] // 1000 * 2
      if value1 > 0 then
        LuaSkillCtrl:AddRoleShield(entity, eShieldType.Normal, value1)
        local SelfShieldValue = LuaSkillCtrl:GetShield(entity, 0)
        if SelfShieldValue ~= 0 then
          LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_shield, 1)
        end
      end
    else
      do
        LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_attackUp, 1, (self.arglist)[6])
        local value2 = (self.caster).def * (self.arglist)[4] // 1000
        if value2 > 0 then
          LuaSkillCtrl:AddRoleShield(entity, eShieldType.Normal, value2)
          local SelfShieldValue = LuaSkillCtrl:GetShield(entity, 0)
          if SelfShieldValue ~= 0 then
            LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_shield, 1)
          end
        end
      end
    end
  end
end

bs_105401.OnCasterDie = function(self)
  -- function num : 0_10
  if self.passive ~= nil then
    (self.passive):Stop()
    self.passive = nil
  end
  self:KillEquipmentSummoner()
  self:RemoveAllTimers()
  self:RemoveAllBreakKillEffects()
  self:RemoveAllLuaTrigger()
  self:RemoveAllHaleEmission()
end

bs_105401.LuaDispose = function(self)
  -- function num : 0_11 , upvalues : base
  if self.passive ~= nil then
    (self.passive):Stop()
    self.passive = nil
  end
  self.food_list = nil
  self.food_targetTable = nil
  ;
  (base.LuaDispose)(self)
end

return bs_105401

