-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106102 = class("bs_106102", LuaSkillBase)
local base = LuaSkillBase
bs_106102.config = {
heal_config = {baseheal_formula = 3022}
, skilltime = 24, actionId = 1020, action_speed = 1.2, actionId_start_time = 19, effect_cast = 106116, effect_trail01 = 106119, effect_trail02 = 106118, effect_hit = 106117, configId = 17}
bs_106102.ctor = function(self)
  -- function num : 0_0
end

bs_106102.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_106102.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.caster).recordTable).NeedRestart = true
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_cast, self, nil)
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  local num = 0
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      if targetList[i] ~= self.caster then
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_trail01, self, nil, targetList[i])
        num = num + 1
      end
    end
  end
  do
    if num > 10 then
      num = 10
    end
    local attackTrigger = BindCallback(self, self.OnAttackTrigger, num)
    local time = (self.config).skilltime * 10 // 12
    self:CallCasterWait(time)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).actionId_start_time * 10 // 12, attackTrigger)
  end
end

bs_106102.OnAttackTrigger = function(self, num)
  -- function num : 0_3 , upvalues : _ENV
  local last_target = ((self.caster).recordTable).lastAttackRole
  local target = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, 1) then
    target = last_target
  else
    local tempTarget = self:GetMoveSelectTarget()
    if tempTarget == nil then
      return 
    end
    target = tempTarget.targetRole
  end
  do
    LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effect_trail02, self, self.caster, nil, nil, self.SkillEventFunc, num)
  end
end

bs_106102.SkillEventFunc = function(self, num, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if effect.dataId == (self.config).effect_trail02 and eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[1] + num * (self.arglist)[2]}, nil, nil)
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(target, (self.config).effect_hit, self, nil)
    self:OnSkillDamageEnd()
  end
end

bs_106102.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106102

