-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105802 = class("bs_105802", LuaSkillBase)
local base = LuaSkillBase
bs_105802.config = {effectId_skill = 105811, effectId_skillQk = 105812, effectId_skillBz = 105810, actionId = 1002, audioId1 = 101003, skill_time = 55, start_time = 23, selectRange = 10, selectId2 = 34, hurtConfig = 13, HurtConfig = 3, buffIdys = 105801, buffIdcx = 105802}
bs_105802.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105802.PlaySkill = function(self, data)
  -- function num : 0_1 , upvalues : _ENV
  local realgrid = LuaSkillCtrl:CallFindGridMostRolesArounded(2)
  if realgrid ~= nil then
    local target = LuaSkillCtrl:GetTargetWithGrid(realgrid.x, realgrid.y)
    local attackTrigger = BindCallback(self, self.OnActionCallBack, target, realgrid)
    ;
    (self.caster):LookAtTarget(target)
    self:CallCasterWait((self.config).skill_time)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, 1, (self.config).start_time, attackTrigger)
  end
end

bs_105802.OnActionCallBack = function(self, target, realgrid)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_skill, self, false, false, self.OnEffectTrigger, realgrid)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_skillQk, self)
end

bs_105802.OnEffectTrigger = function(self, realgrid, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_skill and eventId == eBattleEffectEvent.Trigger then
    local roles = LuaSkillCtrl:FindRolesAroundGrid(realgrid, 2)
    local roles_net = LuaSkillCtrl:FindRolesAroundGrid(realgrid, 0)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_skillBz, self)
    if roles ~= nil and roles.Count > 0 then
      for i = 0, roles.Count - 1 do
        if roles[i] ~= nil and (roles[i]).hp > 0 then
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, roles[i])
          LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {(self.arglist)[1]})
          skillResult:EndResult()
          LuaSkillCtrl:CallBuff(self, roles[i], (self.config).buffIdys, 1, (self.arglist)[2])
          LuaSkillCtrl:CallBuffRepeated(self, roles[i], (self.config).buffIdcx, 1, (self.arglist)[2] + 1, false, self.OnBuffExecute)
        end
      end
    end
    do
      if roles_net ~= nil and roles_net.Count > 0 then
        for i = 0, roles_net.Count - 1 do
          if roles_net[i] ~= nil and (roles_net[i]).hp > 0 then
            local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, roles_net[i])
            LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {(self.arglist)[1]})
            skillResult:EndResult()
          end
        end
      end
      do
        self:OnSkillDamageEnd()
      end
    end
  end
end

bs_105802.OnBuffExecute = function(self, buff, targetRole)
  -- function num : 0_4 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfig, {(self.arglist)[5]}, true)
  skillResult:EndResult()
end

bs_105802.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105802

