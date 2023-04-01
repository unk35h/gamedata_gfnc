-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_208601 = class("bs_208601", LuaSkillBase)
local base = LuaSkillBase
bs_208601.config = {buffId_Wild = 208601, skill_time = 49, start_time = 30, actionId = 1002, act_speed = 1, effectId1 = 208605}
bs_208601.ctor = function(self)
  -- function num : 0_0
end

bs_208601.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_208601.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait((self.config).skill_time)
  local skillTrigger = BindCallback(self, self.OnSkillTrigger)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId1, self)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).act_speed, (self.config).start_time, skillTrigger)
end

bs_208601.OnSkillTrigger = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local targetList = LuaSkillCtrl:GetAllFriendRolesRelative((self.caster).belongNum)
  if targetList ~= nil then
    for i = 0, targetList.Count - 1 do
      local role = targetList[i]
      if role ~= self.caster then
        LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_Wild, 1, (self.arglist)[2])
      end
    end
  end
end

bs_208601.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_208601

