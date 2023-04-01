-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1033022 = class("bs_1033022", LuaSkillBase)
local base = LuaSkillBase
bs_1033022.config = {actionId = 1002, skill_time = 19, start_time = 8, skill_speed = 1, selectId_skill = 45, buffId_tab = 10330201, effectId_start = 103305, audioId1 = 103304, buffId_170 = 170}
bs_1033022.ctor = function(self)
  -- function num : 0_0
end

bs_1033022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_1033022.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId_skill, 10)
  if targetList.Count <= 0 then
    return 
  end
  local skilltime = (self.config).skill_time * 100 // ((self.config).skill_speed * 100)
  local starttime = (self.config).start_time * 100 // ((self.config).skill_speed * 100)
  self:CallCasterWait(skilltime)
  local triggerCallBack = BindCallback(self, self.OnActionCallBack, targetList)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).skill_speed, starttime, triggerCallBack)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, starttime + (self.arglist)[1], true)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
end

bs_1033022.OnActionCallBack = function(self, targetList)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_start, self)
  LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[1])
  local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId_skill, 10)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = (targetList[i]).targetRole
      if role.belongNum ~= eBattleRoleBelong.neutral then
        local time = 5 - i
        if time > 0 then
          local buff = LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_tab, time, (self.arglist)[1])
          if not LuaSkillCtrl.IsInVerify and buff ~= nil and buff.listBattleEffect ~= nil then
            for i = 0, (buff.listBattleEffect).Count - 1 do
              local effect = (buff.listBattleEffect)[i]
              if effect ~= nil then
                local num = 5 - time
                effect:SetCountValue(num)
              end
            end
          end
        end
      end
    end
  end
end

bs_1033022.OnBreakSkill = function(self, role)
  -- function num : 0_4 , upvalues : _ENV, base
  if role == self.caster and self.isSkillUncompleted == true then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 0, true)
  end
  ;
  (base.OnBreakSkill)(self, role)
end

bs_1033022.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1033022

