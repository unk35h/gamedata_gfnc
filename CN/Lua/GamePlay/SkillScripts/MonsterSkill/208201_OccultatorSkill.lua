-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_208201 = class("bs_208201", LuaSkillBase)
local base = LuaSkillBase
bs_208201.config = {skill_time = 37, start_time = 26, actionId = 1002, act_speed = 1, buffID_gongSu = 208201, buffID_yinShen = 208204, buffID_jianFang = 208203, effectId1 = 208206, effectId2 = 208205, audioId1 = 208201, buffId_170 = 170}
bs_208201.ctor = function(self)
  -- function num : 0_0
end

bs_208201.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
  self:AddAfterBuffRemoveTrigger("bs_208201_4", 1, self.AfterBuffRemove, self.caster, nil, (self.config).buffID_yinShen, nil)
end

bs_208201.AfterBuffRemove = function(self, buffId, target, removeType)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 0)
  LuaSkillCtrl:StopShowSkillDurationTime(self)
end

bs_208201.PlaySkill = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId1, self)
  local skillTrigger = BindCallback(self, self.OnSkillTrigger)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).act_speed, (self.config).start_time, skillTrigger)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, nil, true)
end

bs_208201.OnSkillTrigger = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local targetList = LuaSkillCtrl:GetAllFriendRolesRelative((self.caster).belongNum)
  if targetList ~= nil then
    local friNum = 0
    for i = 0, targetList.Count - 1 do
      local role = targetList[i]
      if role ~= nil and role.hp > 0 then
        friNum = friNum + 1
      end
    end
    local realtime = (friNum - 1) * (self.arglist)[3] + (self.arglist)[2]
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffID_gongSu, 1, realtime)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffID_jianFang, 1, realtime)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffID_yinShen, 1, realtime)
    LuaSkillCtrl:StartShowSkillDurationTime(self, realtime)
    -- DECOMPILER ERROR at PC62: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.caster).recordTable).curStartShowDurationSkill = self
  end
end

bs_208201.OnBreakSkill = function(self, role)
  -- function num : 0_5 , upvalues : _ENV
  if role ~= self.caster then
    return 
  end
  if self.timers ~= nil then
    local leng = (table.length)(self.timers)
    if leng > 0 then
      for i = 1, leng do
        if (self.timers)[i] ~= nil then
          ((self.timers)[i]):Stop()
          -- DECOMPILER ERROR at PC26: Confused about usage of register: R7 in 'UnsetPending'

          ;
          (self.timers)[i] = nil
        end
      end
    end
    do
      do
        self.timers = {}
        self:RemoveAllBreakKillEffects()
        if self.isSkillUncompleted then
          (self.caster):RemoveSkillWaitBuff()
          ;
          (self.cskill):ReturnCDTimeFromBreak()
          self.isSkillUncompleted = false
        end
        if (self.cskill).isNormalSkill and self.dataID == ((self.caster).recordTable).lastSkill then
          self:OnSkillDamageEnd()
        end
      end
    end
  end
end

bs_208201.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_208201

