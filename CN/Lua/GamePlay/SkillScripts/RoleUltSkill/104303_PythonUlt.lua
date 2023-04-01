-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104303 = class("bs_104303", LuaSkillBase)
local base = LuaSkillBase
bs_104303.config = {buff_unselected = 104306, buff_vulnerable = 104308, buff_Strong = 104307, buffId_151 = 3007, effectId_ZD = 104306, effectId_Smoke = 104305, actionId = 1006, action_speed = 1, start_time = 8, audioIdStart = 104309, audioIdMovie = 104310, audioIdEnd = 104311}
bs_104303.ctor = function(self)
  -- function num : 0_0
end

bs_104303.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104303.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait(20)
  if selectTargetCoord ~= nil then
    local targetGrid = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
    ;
    (self.caster):LookAtTarget(targetGrid)
    local attackTrigger = BindCallback(self, self.UltSkill, targetGrid)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
  end
end

bs_104303.UltSkill = function(self, targetGrid)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff_Strong, 1, (self.arglist)[3], true)
  LuaSkillCtrl:CallEffect(targetGrid, (self.config).effectId_ZD, self)
  local collisionEnter = BindCallback(self, self.OnCollisionEnter)
  local collisionExit = BindCallback(self, self.OnCollisionExit)
  LuaSkillCtrl:StartTimer(nil, 10, function()
    -- function num : 0_3_0 , upvalues : _ENV, targetGrid, self, collisionEnter, collisionExit
    local EnemyList = LuaSkillCtrl:FindAllRolesWithinRange(targetGrid, 1, true)
    for i = 0, EnemyList.Count - 1 do
      if EnemyList[i] ~= nil and (EnemyList[i]).hp > 0 and (EnemyList[i]).intensity > 0 and LuaSkillCtrl:CheckReletionWithRoleBelong(self.caster, EnemyList[i], eBelongReletionType.Enemy) then
        LuaSkillCtrl:CallBuff(self, EnemyList[i], (self.config).buffId_151, 1, 3, true)
      end
    end
    local effect = LuaSkillCtrl:CallEffect(targetGrid, (self.config).effectId_Smoke, self)
    LuaSkillCtrl:CallAddCircleColliderForEffect(effect, 100, eColliderInfluenceType.Player, nil, collisionEnter, collisionExit)
    LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], function()
      -- function num : 0_3_0_0 , upvalues : effect
      if effect ~= nil then
        effect:Die()
        effect = nil
      end
    end
)
  end
)
end

bs_104303.OnCollisionEnter = function(self, collider, index, entity)
  -- function num : 0_4 , upvalues : _ENV
  if entity ~= nil and entity.hp > 0 and entity.belongNum == (self.caster).belongNum and entity.belongNum ~= eBattleRoleBelong.neutral then
    LuaSkillCtrl:CallBuff(self, entity, (self.config).buff_unselected, 1, (self.arglist)[1], true)
    if entity.attackRange > 1 then
      LuaSkillCtrl:CallBuff(self, entity, (self.config).buff_vulnerable, 1, (self.arglist)[1], true)
    end
  end
end

bs_104303.OnCollisionExit = function(self, collider, entity)
  -- function num : 0_5 , upvalues : _ENV
  if entity ~= nil and entity.hp > 0 and entity:GetBuffTier((self.config).buff_unselected) >= 1 then
    LuaSkillCtrl:DispelBuff(entity, (self.config).buff_unselected, 1)
    if entity:GetBuffTier((self.config).buff_vulnerable) >= 1 then
      LuaSkillCtrl:DispelBuff(entity, (self.config).buff_vulnerable, 1)
    end
  end
end

bs_104303.PlayUltEffect = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_6 , upvalues : base, _ENV
  if selectRoles == nil or selectRoles.Count <= 0 then
    return true
  end
  ;
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_104303.OnUltRoleAction = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 0.55)
end

bs_104303.OnSkipUltView = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_104303.OnMovieFadeOut = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_104303.OnCasterDie = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_104303.LuaDispose = function(self)
  -- function num : 0_11 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_104303

