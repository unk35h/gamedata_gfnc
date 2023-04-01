-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20118 = class("bs_20118", LuaSkillBase)
local base = LuaSkillBase
bs_20118.config = {waveRadium = 30, waveEffect = 12010, waveEffectBoom = 12011, phaseMoveBuffId = 63, flyBuff = 110002, stunBuff = 110006, waveGrid = 1106, waveLeftEffect = 12013, waveRightEffect = 12012, beatBackDurationTimePerGrid = 2, waveStunDuration = 30, waveInterval = 90, waveEffectStartTimer = 65, healEffectId = 10092, extraHealFormula = 3022, 
heal_config = {baseheal_formula = 3022}
}
local WaveDir = {left = 1, right = -1}
bs_20118.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_20118_1", 1, self.OnStartBattle)
  self:AddLuaTrigger(eSkillLuaTrigger.CallWave, self.CallWaveWithDir)
end

bs_20118.MakeUpBorderData = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local border = LuaSkillCtrl:GetMapBorder()
  self.borderPosX = border.x - 1
  self.borderPosY = border.y - 1
end

bs_20118.OnStartBattle = function(self)
  -- function num : 0_2
  self:MakeUpBorderData()
  if ((self.caster).recordTable).OverrideCallWave then
    return 
  end
end

bs_20118.CallNextWaveCountDown = function(self)
  -- function num : 0_3 , upvalues : _ENV
  MsgCenter:Broadcast(eMsgEventId.WaveComing, eWaveType.normalWave)
end

bs_20118.CallWaveEffect = function(self)
  -- function num : 0_4 , upvalues : _ENV, WaveDir
  local gridTarget = LuaSkillCtrl:GetTargetWithGrid(0, 0)
  if self.waveDir == WaveDir.right then
    gridTarget = LuaSkillCtrl:GetTargetWithGrid(self.borderPosX - (self.borderPosY & 1), self.borderPosY)
    LuaSkillCtrl:CallEffect(gridTarget, (self.config).waveRightEffect, self)
  else
    LuaSkillCtrl:CallEffect(gridTarget, (self.config).waveLeftEffect, self)
  end
end

bs_20118.CallWave = function(self)
  -- function num : 0_5
  self:CallWaveWithDir(self.waveDir, (self.config).waveEffect)
  self.waveDir = self.waveDir * -1
end

bs_20118.CallWaveWithDir = function(self, waveDirection, effectId, withoutEfcGrid, withouEndEffect)
  -- function num : 0_6 , upvalues : _ENV, WaveDir
  for i = 0, self.borderPosY do
    local startStepX = 0
    local nextOffsetArg = 1
    local rotation = (Quaternion.Euler)(0, 0, 0)
    if waveDirection == WaveDir.right then
      nextOffsetArg = -1
      local rowArg = i & 1
      startStepX = self.borderPosX - rowArg
      rotation = (Quaternion.Euler)(0, 180, 0)
    end
    do
      local nextStepX = startStepX + nextOffsetArg
      local target = LuaSkillCtrl:GetTargetWithGrid(nextStepX, i)
      if target ~= nil then
        local curTarget = (LuaSkillCtrl:GetTargetWithGrid(startStepX, i))
        local effect = nil
        if effectId ~= nil and effectId > 0 then
          effect = LuaSkillCtrl:CallEffect(curTarget, effectId, self)
        end
        -- DECOMPILER ERROR at PC59: Confused about usage of register: R16 in 'UnsetPending'

        if not LuaSkillCtrl.IsInVerify and effect ~= nil then
          ((effect.lsObject).transform).localRotation = rotation
        end
        local grid = LuaSkillCtrl:GetGridWithPos(startStepX, i)
        -- DECOMPILER ERROR at PC68: Confused about usage of register: R17 in 'UnsetPending'

        ;
        ((self.caster).lsObject).localPosition = grid.fixLogicPosition
        local hasPhaseMove = {}
        local curWavetimer = nil
        do
          do
            if not withoutEfcGrid then
              local waveTimeGrid = {}
              waveTimeGrid.x = (curTarget.targetCoord).x
              waveTimeGrid.y = (curTarget.targetCoord).y
              curWavetimer = LuaSkillCtrl:StartTimer(nil, 2, (BindCallback(self, self.OnCreateEfcGrid, waveTimeGrid, nextOffsetArg)), nil, -1, 2)
            end
            LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, target, (self.config).waveRadium, 5, 14, (BindCallback(self, self.OnCollisionEnter, effect, waveDirection, hasPhaseMove, curWavetimer, withouEndEffect)), nil, nil, effect, true, true, BindCallback(self, self.OnArrive, curWavetimer))
            -- DECOMPILER ERROR at PC123: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC123: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC123: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC123: LeaveBlock: unexpected jumping out DO_STMT

          end
        end
      end
    end
  end
end

bs_20118.OnCreateEfcGrid = function(self, waveTimeGrid, nextOffsetArg)
  -- function num : 0_7 , upvalues : _ENV
  local x = waveTimeGrid.x
  local y = waveTimeGrid.y
  waveTimeGrid.x = waveTimeGrid.x + nextOffsetArg
  local efcGrid = LuaSkillCtrl:GetEfcGridWithPos(x, y)
  if efcGrid ~= nil then
    return 
  end
  local normalGrid = LuaSkillCtrl:GetGridWithPos(x, y)
  if normalGrid == nil then
    return 
  end
  if normalGrid.role ~= nil and (normalGrid.role).belongNum == eBattleRoleBelong.neutral then
    return 
  end
  LuaSkillCtrl:CallCreateEfcGrid(x, y, (self.config).waveGrid)
end

bs_20118.OnCollisionEnter = function(self, effect, dir, hasPhaseMove, curWavetimer, withouEndEffect, collider, index, entity)
  -- function num : 0_8 , upvalues : _ENV, WaveDir
  if (self.config).waveEffectBoom ~= nil and (self.config).waveEffectBoom > 0 and not withouEndEffect then
    LuaSkillCtrl:CallEffect(entity, (self.config).waveEffectBoom, self)
  end
  local nextArg = dir == WaveDir.left and 1 or -1
  if entity.belongNum == eBattleRoleBelong.neutral then
    if effect ~= nil then
      effect:Die()
    end
    ;
    (collider.bindEmission):EndAndDisposeEmission()
    if curWavetimer ~= nil then
      curWavetimer:Stop()
    end
  end
  self:CallNextRolePhaseMove(collider, hasPhaseMove, entity, nextArg)
end

bs_20118.OnArrive = function(self, curWavetimer, emission)
  -- function num : 0_9
  if curWavetimer ~= nil then
    curWavetimer:Stop()
  end
end

bs_20118.CallNextRolePhaseMove = function(self, collider, hasPhaseMove, entity, nextArg)
  -- function num : 0_10 , upvalues : _ENV
  if hasPhaseMove[entity] then
    return false
  end
  hasPhaseMove[entity] = true
  if entity.belongNum == eBattleRoleBelong.neutral then
    return false
  end
  if entity.hp <= 0 then
    return false
  end
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnWaveCollision, entity)
  self:CallExtraResult(entity)
  if entity:ContainBuffFeature(eBuffFeatureType.CtrlImmunity) then
    return false
  end
  local result, nextGrid, emptyGrid = self:CollectFurthestGrid(entity, nextArg)
  if nextGrid == nil then
    return false
  end
  if not result then
    local nextEntity = nextGrid.role
    if nextEntity == nil then
      return false
    end
    local result, resultGrid = self:CallNextRolePhaseMove(collider, hasPhaseMove, nextEntity, nextArg)
    nextGrid = resultGrid
    if not result then
      if emptyGrid ~= nil then
        nextGrid = emptyGrid
      else
        return false
      end
    end
  end
  do
    if LuaSkillCtrl:RoleContainsBuffFeature(entity, eBuffFeatureType.BeatBack) or self:CheckSpecialRole(entity) then
      return false
    end
    local catchLastGridArg = -1
    local curX = entity.x
    if entity.collider ~= nil and (entity.collider).isActive then
      self:TryResetMoveState(entity)
      local duration = (math.abs)(entity.x - nextGrid.x) * (self.config).beatBackDurationTimePerGrid
      if (entity.recordTable)["10301_flag"] == nil then
        LuaSkillCtrl:CallBuff(self, entity, (self.config).stunBuff, 1, (self.config).waveStunDuration)
      end
      LuaSkillCtrl:CallPhaseMoveWithoutTurn(self, entity, nextGrid.x, nextGrid.y, duration, (self.config).phaseMoveBuffId, 1)
      LuaSkillCtrl:CallBuff(self, entity, (self.config).flyBuff, 1, duration)
    end
    do
      local targetX = nextGrid.x
      local lastRoleGrid = nextGrid
      local step = nextArg * catchLastGridArg
      for i = targetX, curX, step do
        lastRoleGrid = LuaSkillCtrl:GetGridWithPos(i, nextGrid.y)
      end
      do
        if lastRoleGrid ~= nil and not lastRoleGrid:IsGridEmpty() then
          return true, lastRoleGrid
        end
      end
    end
  end
end

bs_20118.CheckSpecialRole = function(self, role)
  -- function num : 0_11 , upvalues : _ENV
  if role.roleDataId ~= 1049 then
    return false
  end
  if role:GetBuffTier(104902) <= 0 then
    return false
  end
  LuaSkillCtrl:CallBuff(self, role, 104903, 1, 1)
  return true
end

bs_20118.CallExtraResult = function(self, entity)
  -- function num : 0_12 , upvalues : _ENV
  local skillCasterAttr = (self.caster).sunder
  if skillCasterAttr <= 0 then
    return 
  end
  if entity.belongNum == eBattleRoleBelong.player then
    LuaSkillCtrl:CallEffect(entity, (self.config).healEffectId, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {skillCasterAttr}, false, false)
    skillResult:EndResult()
  end
end

bs_20118.CollectFurthestGrid = function(self, entity, nextArg)
  -- function num : 0_13 , upvalues : _ENV
  local endX = 0
  if nextArg > 0 then
    endX = self.borderPosX - (entity.y & 1)
  else
    endX = 0
  end
  if endX == entity.x then
    return false
  end
  local result = true
  local grid, emptyGrid = nil, nil
  local startX = entity.x + nextArg
  for i = startX, endX, nextArg do
    grid = LuaSkillCtrl:GetGridWithPos(i, entity.y)
    if grid == nil then
      return false
    end
    result = grid:IsGridEmpty()
    if result then
      do
        emptyGrid = grid
        -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  return result, grid, emptyGrid
end

bs_20118.LuaDispose = function(self)
  -- function num : 0_14 , upvalues : base
  self.waveDir = nil
  ;
  (base.LuaDispose)(self)
end

return bs_20118

