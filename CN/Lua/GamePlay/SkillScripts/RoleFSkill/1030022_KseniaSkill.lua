-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1030022 = class("bs_1030022", LuaSkillBase)
local base = LuaSkillBase
bs_1030022.config = {buffId_def = 103001, effectId_start = 103006, effectId_open = 103005, effectId_trail = 103007, actionId = 1002, skill_time = 29, start_time = 7, skill_speed = 1, selectId_skill = 6}
bs_1030022.ctor = function(self)
  -- function num : 0_0
end

bs_1030022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_1030022.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local role = ((self.caster).recordTable).pass_target
  if role == nil or role.hp <= 0 then
    return 
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  if LuaSkillCtrl.IsInTDBattle and role.x == (ConfigData.buildinConfig).BenchX then
    ((self.caster).recordTable).pass_target = nil
    return 
  end
  local skilltime = (self.config).skill_time * 100 // ((self.config).skill_speed * 100)
  local starttime = (self.config).start_time * 100 // ((self.config).skill_speed * 100)
  self:CallCasterWait(skilltime)
  local triggerCallBack = BindCallback(self, self.OnActionCallBack, role)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).skill_speed, starttime, triggerCallBack)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_start, self, nil, nil, nil, true)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_open, self)
end

bs_1030022.OnActionCallBack = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(role, (self.config).effectId_trail, self, self.OnEffectTrigger)
end

bs_1030022.OnEffectTrigger = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger and target ~= nil and (target.targetRole).hp > 0 then
    LuaSkillCtrl:StartTimer(nil, 9, function()
    -- function num : 0_4_0 , upvalues : _ENV, self, target
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_def, 1, (self.arglist)[3])
    local shieldValue = (self.caster).skill_intensity * (self.arglist)[1] // 1000
    LuaSkillCtrl:AddRoleShield(target.targetRole, eShieldType.Normal, shieldValue)
  end
)
  end
end

bs_1030022.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1030022

