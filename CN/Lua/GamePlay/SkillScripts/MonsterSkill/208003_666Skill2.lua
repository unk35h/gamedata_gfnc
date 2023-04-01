-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_208003 = class("bs_208003", LuaSkillBase)
local base = LuaSkillBase
bs_208003.config = {hurtRusultId = 11, effectId_go = 208009, effectId_down = 208010, effectId_loop = 208012, effectId_hit = 208011, buffId_66 = 3006, buffId_196 = 208006, buffId_170 = 170, skill_time = 59, start_time = 20, actionId_start = 1022, actionId_loop = 1023, actionId_end = 1024, action_speed = 1, buffId_skill2 = 208004}
bs_208003.ctor = function(self)
  -- function num : 0_0
end

bs_208003.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_208003.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 60, 10)
  if targetList ~= nil and targetList.Count > 0 and targetList[0] ~= nil then
    LuaSkillCtrl:CallBuff(self, (targetList[0]).targetRole, (self.config).buffId_skill2, 1, (self.arglist)[1])
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, (self.arglist)[1] + (self.config).skill_time)
    LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[1] + (self.config).start_time)
    local realPlaySkill = BindCallback(self, self.RealPlaySkill, (targetList[0]).targetRole, data)
    LuaSkillCtrl:StartTimer(self, (self.arglist)[1], realPlaySkill)
    self:AbandonSkillCdAutoReset(true)
  else
    do
      self:EndSkillAndCallNext()
    end
  end
end

bs_208003.RealPlaySkill = function(self, target, data)
  -- function num : 0_3 , upvalues : _ENV
  if target ~= nil and target.hp > 0 then
    self:CallCasterWait((self.config).skill_time)
    ;
    (self.caster):LookAtTarget(target)
    local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, data)
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_start, 1)
    LuaSkillCtrl:StartTimer(nil, (self.config).start_time, attackTrigger)
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_go, self)
  else
    do
      self:EndSkillAndCallNext()
      LuaSkillCtrl:DispelBuff(self.caster, 170, 0)
      LuaSkillCtrl:StopShowSkillDurationTime(self)
    end
  end
end

bs_208003.OnAttackTrigger = function(self, target, ata)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, 170, 0)
  self:EndSkillAndCallNext()
  if target ~= nil and target.hp > 0 then
    local grid = LuaSkillCtrl:CallFindEmptyGridNearest(target)
    if grid ~= nil then
      local grid_target = LuaSkillCtrl:GetGridWithPos(target.x, target.y)
      LuaSkillCtrl:SetRolePos(grid, target)
      LuaSkillCtrl:SetRolePos(grid_target, self.caster)
      LuaSkillCtrl:StartTimer(nil, 3, function()
    -- function num : 0_4_0 , upvalues : _ENV, self, target
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtRusultId, {(self.arglist)[2]})
    skillResult:EndResult()
    local roles = LuaSkillCtrl:FindRolesAroundRole(self.caster)
    if roles ~= nil and roles.Count > 0 then
      for i = 0, roles.Count - 1 do
        if roles[i] ~= nil and (roles[i]).hp > 0 and (roles[i]).belongNum ~= (self.caster).belongNum then
          LuaSkillCtrl:CallBuff(self, roles[i], (self.config).buffId_66, 1, (self.arglist)[3])
        end
      end
    end
  end
)
    end
  end
  do
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_down, self)
    LuaSkillCtrl:CallRoleAction(self, (self.config).actionId_end, 1)
    LuaSkillCtrl:StartTimer(nil, 20, function()
    -- function num : 0_4_1
  end
)
  end
end

bs_208003.EndSkillAndCallNext = function(self)
  -- function num : 0_5
  if self.caster == nil then
    return 
  end
  self:CancleCasterWait()
  local skillMgr = (self.caster):GetSkillComponent()
  if skillMgr == nil then
    return 
  end
  skillMgr.lastSkill = self.cskill
  self:CallNextBossSkill()
end

bs_208003.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : _ENV, base
  LuaSkillCtrl:StopShowSkillDurationTime(self)
  ;
  (base.OnCasterDie)(self)
end

return bs_208003

