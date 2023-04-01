-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104403 = class("bs_104403", LuaSkillBase)
local base = LuaSkillBase
bs_104403.config = {effectId_ZD = 104410, effectTime = 10, effectId_Loop = 104412, buffId = 104401, configId = 3, 
aoe_config = {effect_shape = 2, aoe_select_code = 4, aoe_range = 1}
, audioIdStart = 104410, audioIdMovie = 104411, audioIdEnd = 104412}
bs_104403.ctor = function(self)
  -- function num : 0_0
end

bs_104403.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_104403_2", 99, self.OnSetHurt, nil, nil, (self.caster).belongNum)
end

bs_104403.PlaySkill = function(self, data, selectTargetCoord, selectRolesdata)
  -- function num : 0_2 , upvalues : _ENV
  if selectTargetCoord ~= nil then
    local targetGrid = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
    do
      (self.caster):LookAtTarget(targetGrid)
      self:CallCasterWait(5)
      LuaSkillCtrl:CallEffect(targetGrid, (self.config).effectId_ZD, self)
      LuaSkillCtrl:StartTimer(nil, (self.config).effectTime, function()
    -- function num : 0_2_0 , upvalues : targetGrid, _ENV, self
    if targetGrid ~= nil then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetGrid, (self.config).aoe_config)
      do
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[1]})
        skillResult:EndResult()
        local effect = LuaSkillCtrl:CallEffect(targetGrid, (self.config).effectId_Loop, self)
        local collisionEnter = BindCallback(self, self.OnCollisionEnter)
        local collisionExit = BindCallback(self, self.OnCollisionExit)
        LuaSkillCtrl:CallAddCircleColliderForEffect(effect, 100, eColliderInfluenceType.Enemy, nil, collisionEnter, collisionExit)
        LuaSkillCtrl:StartTimer(nil, (self.arglist)[2], function()
      -- function num : 0_2_0_0 , upvalues : effect
      if effect ~= nil then
        effect:Die()
        effect = nil
      end
    end
)
      end
    end
  end
)
    end
  end
end

bs_104403.OnCollisionEnter = function(self, collider, index, entity)
  -- function num : 0_3 , upvalues : _ENV
  if entity ~= nil and entity.hp > 0 and entity.belongNum ~= (self.caster).belongNum and not LuaSkillCtrl:IsFixedObstacle(entity) then
    LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId, 1)
  end
end

bs_104403.OnCollisionExit = function(self, collider, entity)
  -- function num : 0_4 , upvalues : _ENV
  if entity ~= nil and entity.hp > 0 and entity:GetBuffTier((self.config).buffId) >= 1 then
    LuaSkillCtrl:DispelBuff(entity, (self.config).buffId, 1)
  end
end

bs_104403.OnSetHurt = function(self, context)
  -- function num : 0_5 , upvalues : _ENV
  if (context.target).belongNum ~= (self.caster).belongNum and context.target ~= self.caster and context.hurt > 0 and context.isTriggerSet ~= true and context.extraArg ~= (ConfigData.buildinConfig).HurtIgnoreKey and (context.target):GetBuffTier((self.config).buffId) > 0 then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, context.target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[3]}, true)
    skillResult:EndResult()
  end
end

bs_104403.PlayUltEffect = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_104403.OnUltRoleAction = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 0.55)
end

bs_104403.OnSkipUltView = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_104403.OnMovieFadeOut = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_104403.OnCasterDie = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_104403.LuaDispose = function(self)
  -- function num : 0_11 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_104403

