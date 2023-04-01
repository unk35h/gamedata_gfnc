-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105803 = class("bs_105803", LuaSkillBase)
local base = LuaSkillBase
bs_105803.config = {effectId_ct = 105820, effectId_ZD = 105814, effectId_ZDsj = 105813, effectId_ZDqk = 105815, effectId_xhqk = 105827, effectId_xhzd = 105816, effectId_sj = 105818, effectId_hj = 105817, effectTime = 10, buffId_Ult = 105803, buffId = 104401, configId = 13, 
aoe_config = {effect_shape = 2, aoe_select_code = 4, aoe_range = 1}
, audioIdStart = 105809, audioIdMovie = 105810, audioIdEnd = 105811}
bs_105803.ctor = function(self)
  -- function num : 0_0
end

bs_105803.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105803.PlaySkill = function(self, data, selectTargetCoord, selectRolesdata)
  -- function num : 0_2 , upvalues : _ENV
  if selectTargetCoord ~= nil then
    local targetGrid = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
    do
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Ult, 1, 35, true)
      self:TryResetMoveState(self.caster)
      local grid = LuaSkillCtrl:GetGridWithRole(self.caster)
      ;
      ((self.caster).lsObject):SetPositionForce(grid.fixLogicPosition)
      local time = 69
      self:CallCasterWait(time)
      ;
      (self.caster):LookAtTarget(targetGrid)
      if self.timer1 ~= nil then
        (self.timer1):Stop()
        self.timer1 = nil
      end
      if self.beginTimer ~= nil then
        (self.beginTimer):Stop()
        self.beginTimer = nil
      end
      if self.timer2 ~= nil then
        (self.timer2):Stop()
        self.timer2 = nil
      end
      self.timer1 = LuaSkillCtrl:StartTimer(nil, 4, function()
    -- function num : 0_2_0 , upvalues : _ENV, self, targetGrid
    LuaSkillCtrl:CallRoleAction(self.caster, 1006)
    self.beginTimer = LuaSkillCtrl:StartTimer(nil, 2, function()
      -- function num : 0_2_0_0 , upvalues : _ENV, targetGrid, self
      LuaSkillCtrl:CallEffectWithArg(targetGrid, (self.config).effectId_ct, self, false, false, self.CallEffectAndEmissions, targetGrid)
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_ZDqk, self)
    end
, nil, 4)
    self.timer2 = LuaSkillCtrl:StartTimer(nil, 25, function()
      -- function num : 0_2_0_1 , upvalues : _ENV, self, targetGrid
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_xhzd, self)
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_xhqk, self)
      LuaSkillCtrl:DispelBuff(self.caster, 196, 1, true)
      LuaSkillCtrl:StartTimer(nil, 6, function()
        -- function num : 0_2_0_1_0 , upvalues : _ENV, targetGrid, self
        local effect = LuaSkillCtrl:CallEffect(targetGrid, (self.config).effectId_hj, self)
        LuaSkillCtrl:StartTimer(nil, 10, function()
          -- function num : 0_2_0_1_0_0 , upvalues : _ENV, targetGrid, self, effect
          LuaSkillCtrl:StartTimer(nil, 2, function()
            -- function num : 0_2_0_1_0_0_0 , upvalues : _ENV, targetGrid, self
            local targetlist_enemy = LuaSkillCtrl:FindAllRolesWithinRange(targetGrid, 1, true)
            if targetlist_enemy ~= nil and targetlist_enemy.Count > 0 then
              local true_targetlist = {}
              for i = 0, targetlist_enemy.Count - 1 do
                if targetlist_enemy[i] ~= nil and (targetlist_enemy[i]).belongNum == eBattleRoleBelong.enemy and not (targetlist_enemy[i]):IsUnSelect(self.caster) then
                  local k = targetlist_enemy[i]
                  ;
                  (table.insert)(true_targetlist, k)
                end
              end
              local num = (table.length)(true_targetlist)
              local num_t = LuaSkillCtrl:CallRange(1, num)
              local target = true_targetlist[num_t]
              if target ~= nil and target.hp > 0 then
                local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
                LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[4]}, false)
                LuaSkillCtrl:CallEffect(target, (self.config).effectId_sj, self)
              end
            end
          end
, self, (self.arglist)[3] - 1, 1)
          LuaSkillCtrl:StartTimer(nil, 45, function()
            -- function num : 0_2_0_1_0_0_1 , upvalues : effect
            if effect ~= nil then
              effect:Die()
              effect = nil
            end
          end
)
        end
)
      end
)
    end
)
  end
)
    end
  end
end

bs_105803.CallEffectAndEmissions = function(self, inputTarget, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local collisionTrigger = BindCallback(self, self.OnCollision, inputTarget)
    LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, inputTarget, 30, 10, eColliderInfluenceType.Enemy, collisionTrigger, nil, nil, nil, true, false)
  end
end

bs_105803.OnCollision = function(self, inputTarget, collider, index, entity)
  -- function num : 0_4 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 or entity == nil or entity.hp <= 0 or entity.belongNum == (self.caster).belongNum then
    return 
  end
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[2]}, false)
  LuaSkillCtrl:CallEffect(entity, (self.config).effectId_ZDsj, self)
  skillResult:EndResult()
end

bs_105803.PlayUltEffect = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 40, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_105803.OnUltRoleAction = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_105803.OnSkipUltView = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_105803.OnMovieFadeOut = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_105803.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer1 ~= nil then
    (self.timer1):Stop()
    self.timer1 = nil
  end
  if self.beginTimer ~= nil then
    (self.beginTimer):Stop()
    self.beginTimer = nil
  end
  if self.timer2 ~= nil then
    (self.timer2):Stop()
    self.timer2 = nil
  end
end

bs_105803.OnBreakSkill = function(self, role)
  -- function num : 0_10 , upvalues : base
  if role == self.caster then
    self:CancleCasterWait()
  end
  ;
  (base.OnBreakSkill)(self, role)
end

bs_105803.LuaDispose = function(self)
  -- function num : 0_11 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_105803

