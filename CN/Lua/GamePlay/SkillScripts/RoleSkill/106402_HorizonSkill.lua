-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106402 = class("bs_106402", LuaSkillBase)
local base = LuaSkillBase
bs_106402.config = {skill_time = 55, actionId_start_time = 36, actionId = 1002, action_speed = 1, effectId_pass = 106404, effectId_HIT = 106411, buffId_jc = 106401, buffId_back = 151, hurtConfig = 2, buffId_Taunt = 3002, buffId1 = 106403, buffId_shield = 106404, 
aoe_config = {effect_shape = 2, aoe_select_code = 4, aoe_range = 1}
}
bs_106402.ctor = function(self)
  -- function num : 0_0
end

bs_106402.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.targetlist = {}
  self:AddAfterPlaySkillTrigger("bs_106402_2", 1, self.OnAfterPlaySkill, self.caster)
  self:AddAfterAddBuffTrigger("bs_106402_3", 2, self.OnAfterAddBuff, nil, nil, nil, nil, (self.config).buffId1)
  self:AddBuffDieTrigger("bs_106402_4", 3, self.OnBuffDie, nil, nil, (self.config).buffId1)
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["106402_hurt"] = (self.arglist)[3]
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["106402_hurt2"] = (self.arglist)[5]
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["106402_ztime"] = (self.arglist)[1]
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["106402_Shield"] = (self.arglist)[8]
  self:AddTrigger(eSkillTriggerType.OnBreakShield, "bs_106402_5", 4, self.OnBreakShield)
end

bs_106402.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_2 , upvalues : _ENV
  if shieldType == 0 and target:GetBuffTier((self.config).buffId_shield) > 0 then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_shield, 0)
  end
end

bs_106402.PlaySkill = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, data)
  local time = (self.config).skill_time
  self:CallCasterWait(time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).actionId_start_time, attackTrigger)
end

bs_106402.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_4 , upvalues : _ENV
  if skill.maker == self.caster and (skill.dataId == 106403 or skill.dataId == 106402) and self.effectHalo ~= nil then
    if skill.dataId == 106402 then
      LuaSkillCtrl:StartTimer(nil, 35, function()
    -- function num : 0_4_0 , upvalues : self, _ENV
    if self.effectHalo ~= nil then
      self:ExtraDamage((self.effectHalo).target)
    end
    if self.loop1 ~= nil then
      (self.loop1):Stop()
      self.loop1 = nil
    end
    self.targetlist = {}
    if self.effectHalo ~= nil then
      (self.effectHalo):Die()
      self.effectHalo = nil
    end
    if self.jc ~= nil then
      LuaSkillCtrl:ClearColliderOrEmission(self.jc)
      self.jc = nil
    end
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.caster).recordTable).grid_wall = nil
  end
)
    else
      LuaSkillCtrl:StartTimer(nil, 6, function()
    -- function num : 0_4_1 , upvalues : self, _ENV
    if self.loop1 ~= nil then
      (self.loop1):Stop()
      self.loop1 = nil
    end
    self.targetlist = {}
    if self.effectHalo ~= nil then
      (self.effectHalo):Die()
      self.effectHalo = nil
    end
    if self.jc ~= nil then
      LuaSkillCtrl:ClearColliderOrEmission(self.jc)
      self.jc = nil
    end
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.caster).recordTable).grid_wall = nil
  end
)
    end
  end
end

bs_106402.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_5 , upvalues : _ENV
  if target:GetBuffTier((self.config).buffId_jc) < 1 then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_jc, 1)
  end
end

bs_106402.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_6 , upvalues : _ENV
  if target:GetBuffTier((self.config).buffId_jc) >= 1 then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_jc, 0)
  end
end

bs_106402.OnAttackTrigger = function(self, data)
  -- function num : 0_7 , upvalues : _ENV
  local dis = 0
  local target = nil
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  for i = 0, targetList.Count - 1 do
    if targetList[i] ~= nil then
      local grid = LuaSkillCtrl:GetGridWithRole(targetList[i])
      local dis_1 = grid.x
      if dis <= dis_1 then
        dis = dis_1
        target = targetList[i]
      end
    end
  end
  local grid_wall = LuaSkillCtrl:GetGridWithRole(target)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.caster).recordTable).grid_wall = grid_wall
  local shieldValue = (self.caster).pow * (self.arglist)[8] // 1000
  if shieldValue > 0 then
    LuaSkillCtrl:AddRoleShield(target, eShieldType.Normal, shieldValue)
    local SelfShieldValue = LuaSkillCtrl:GetShield(target, 0)
    if SelfShieldValue ~= 0 then
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_shield, 1)
    end
  end
  do
    local range = 2 - target.attackRange
    local targetlist_enemy = LuaSkillCtrl:CallTargetSelect(self, 9, range, target)
    if targetlist_enemy ~= nil and targetlist_enemy.Count > 0 then
      for i = 0, targetlist_enemy.Count - 1 do
        if targetlist_enemy[i] ~= nil then
          LuaSkillCtrl:CallBuff(self, (targetlist_enemy[i]).targetRole, (self.config).buffId_Taunt, 1, (self.arglist)[1], false, target)
        end
      end
    end
    do
      local range2 = 1 - target.attackRange
      local targetlist_enemy2 = LuaSkillCtrl:CallTargetSelect(self, 9, range2, target)
      if targetlist_enemy2 ~= nil and targetlist_enemy2.Count > 0 then
        for i = 0, targetlist_enemy2.Count - 1 do
          if targetlist_enemy2[i] ~= nil then
            local targetEnemyRole = (targetlist_enemy2[i]).targetRole
            local buff = nil
            local targetX = targetEnemyRole.x
            local targetY = targetEnemyRole.y
            buff = LuaSkillCtrl:CallBuff(self, targetEnemyRole, (self.config).buffId_back, 1, 3, false, target)
            if buff ~= nil and (targetEnemyRole.x ~= targetX or targetEnemyRole.y ~= targetY) then
              LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnHorizonCauseBacklash, targetEnemyRole)
            end
          end
        end
      end
      do
        if target ~= nil then
          local Grid1 = grid_wall
          local targetGrid1 = LuaSkillCtrl:GetTargetWithGrid(Grid1.x, Grid1.y)
          if targetGrid1 ~= nil then
            if self.effectHalo ~= nil then
              (self.effectHalo):Die()
              self.effectHalo = nil
            end
            self.effectHalo = LuaSkillCtrl:CallEffect(targetGrid1, (self.config).effectId_pass, self)
            if self.jc ~= nil then
              LuaSkillCtrl:ClearColliderOrEmission(self.jc)
              self.jc = nil
            end
            local collisionEnter = BindCallback(self, self.OnCollisionEnter)
            local collisionExit = BindCallback(self, self.OnCollisionExit)
            self.jc = LuaSkillCtrl:CallAddCircleColliderForEffect(self.effectHalo, 25, eColliderInfluenceType.Player, nil, collisionEnter, collisionExit)
            local collisionEnter2 = BindCallback(self, self.OnCollisionEnter2)
            local collisionExit2 = BindCallback(self, self.OnCollisionExit2)
            self.pz = LuaSkillCtrl:CallAddCircleColliderForEffect(self.effectHalo, 75, eColliderInfluenceType.Enemy, nil, collisionEnter2, collisionExit2)
            self.loop1 = LuaSkillCtrl:StartTimer(nil, (self.arglist)[7], function()
    -- function num : 0_7_0 , upvalues : self, _ENV
    if self.effectHalo ~= nil then
      self:ExtraDamage((self.effectHalo).target)
    end
    self.targetlist = {}
    if self.effectHalo ~= nil then
      (self.effectHalo):Die()
      self.effectHalo = nil
    end
    if self.jc ~= nil then
      LuaSkillCtrl:ClearColliderOrEmission(self.jc)
      self.jc = nil
    end
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.caster).recordTable).grid_wall = nil
  end
)
          end
        end
      end
    end
  end
end

bs_106402.OnCollisionEnter = function(self, collider, index, entity)
  -- function num : 0_8 , upvalues : _ENV
  if entity:GetBuffTier((self.config).buffId_jc) < 1 then
    LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_jc, 1)
  end
end

bs_106402.OnCollisionExit = function(self, collider, entity)
  -- function num : 0_9 , upvalues : _ENV
  if entity:GetBuffTier((self.config).buffId_jc) >= 1 then
    LuaSkillCtrl:DispelBuff(entity, (self.config).buffId_jc, 0)
  end
end

bs_106402.OnCollisionEnter2 = function(self, collider, index, entity)
  -- function num : 0_10 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  if (self.targetlist)[entity] == nil then
    (self.targetlist)[entity] = 0
  end
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.targetlist)[entity] = (self.targetlist)[entity] + 1
  if (self.targetlist)[entity] <= (self.arglist)[4] then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {(self.arglist)[3]})
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(entity, (self.config).effectId_HIT, self)
  end
end

bs_106402.OnCollisionExit2 = function(self, collider, entity)
  -- function num : 0_11 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  if (self.targetlist)[entity] == nil then
    (self.targetlist)[entity] = 0
  end
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.targetlist)[entity] = (self.targetlist)[entity] + 1
  if (self.targetlist)[entity] <= (self.arglist)[4] then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {(self.arglist)[3]})
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(entity, (self.config).effectId_HIT, self)
  end
end

bs_106402.ExtraDamage = function(self, target)
  -- function num : 0_12 , upvalues : _ENV
  if target ~= nil then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).aoe_config)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {(self.arglist)[5]})
    skillResult:EndResult()
  end
end

bs_106402.OnCasterDie = function(self)
  -- function num : 0_13 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  self.targetlist = {}
  if self.effectHalo ~= nil then
    (self.effectHalo):Die()
    self.effectHalo = nil
  end
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable).grid_wall = nil
  if self.loop1 ~= nil then
    (self.loop1):Stop()
    self.loop1 = nil
  end
  if self.jc ~= nil then
    LuaSkillCtrl:ClearColliderOrEmission(self.jc)
    self.jc = nil
  end
end

bs_106402.LuaDispose = function(self)
  -- function num : 0_14 , upvalues : base
  (base.LuaDispose)(self)
  self.effectHalo = nil
  self.jc = nil
  self.targetlist = nil
end

return bs_106402

