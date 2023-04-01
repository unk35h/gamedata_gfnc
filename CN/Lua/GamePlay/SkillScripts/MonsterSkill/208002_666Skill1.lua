-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_208002 = class("bs_208002", LuaSkillBase)
local base = LuaSkillBase
bs_208002.config = {buffId_skill1 = 208002, buffId_speed = 208003, actionId = 1002, action_speed = 1, skill_time = 30, start_time = 15}
bs_208002.ctor = function(self)
  -- function num : 0_0
end

bs_208002.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnSixAttack, self.OnSixAttack)
end

bs_208002.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self:CallCasterWait((self.config).skill_time)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, data)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:CallBuff(self, self.caster, 170, 1, (self.arglist)[1] + (self.config).skill_time)
  self:AbandonSkillCdAutoReset(true)
end

bs_208002.OnAttackTrigger = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[1] + 2)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_skill1, 1, (self.arglist)[1])
  LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], function()
    -- function num : 0_3_0 , upvalues : self, _ENV
    if self.caster ~= nil and (self.caster).hp > 0 then
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_speed, 0)
      LuaSkillCtrl:DispelBuff(self.caster, 170, 0)
    end
    self:EndSkillAndCallNext()
  end
)
end

bs_208002.EndSkillAndCallNext = function(self)
  -- function num : 0_4 , upvalues : _ENV
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
  LuaSkillCtrl:StopShowSkillDurationTime(self)
end

bs_208002.OnSixAttack = function(self, target, sender, skill)
  -- function num : 0_5 , upvalues : _ENV
  if sender:GetBuffTier((self.config).buffId_skill1) > 0 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_speed, 1)
    local grid = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
    if grid ~= nil then
      LuaSkillCtrl:MoveRoleToTarget(self, grid, self.caster, false, self.OnArrive)
    end
  end
end

bs_208002.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : _ENV, base
  LuaSkillCtrl:StopShowSkillDurationTime(self)
  ;
  (base.OnCasterDie)(self)
end

return bs_208002

