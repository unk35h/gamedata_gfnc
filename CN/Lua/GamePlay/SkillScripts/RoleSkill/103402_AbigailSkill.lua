-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_103402 = class("bs_103402", LuaSkillBase)
local base = LuaSkillBase
bs_103402.config = {effectId = 10455, buffId_Crit = 103402, 
aoe_config = {effect_shape = 1, aoe_select_code = 3, aoe_range = 10}
, speed = 1, skill_time = 15, actionId = 1002, buffId_170 = 170, audioId1 = 278, audioId2 = 279, weaponLv = 0, buffId_Crit_ex = 103403}
bs_103402.ctor = function(self)
  -- function num : 0_0
end

bs_103402.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  if (self.config).weaponLv > 1 then
    self:AddAfterHurtTrigger("bs_103402_2", 9, self.OnAfterHurt, nil, nil, (self.caster).belongNum)
  end
end

bs_103402.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId, (self.config).speed)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self, self.SkillEventFunc, nil, (self.config).speed, nil, false)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, (self.arglist)[1], true)
  LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[1])
end

bs_103402.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).aoe_config)
    if (skillResult.roleList).Count > 0 then
      for i = 0, (skillResult.roleList).Count - 1 do
        local buffId = (self.config).buffId_Crit
        if (self.config).weaponLv > 1 then
          buffId = (self.config).buffId_Crit_ex
          -- DECOMPILER ERROR at PC35: Confused about usage of register: R10 in 'UnsetPending'

          ;
          (((skillResult.roleList)[i]).recordTable).Crit = ((self.caster).recordTable).Crit
          -- DECOMPILER ERROR at PC42: Confused about usage of register: R10 in 'UnsetPending'

          ;
          (((skillResult.roleList)[i]).recordTable).CritHurt = ((self.caster).recordTable).CritHurt
          -- DECOMPILER ERROR at PC49: Confused about usage of register: R10 in 'UnsetPending'

          ;
          (((skillResult.roleList)[i]).recordTable).CritMax = ((self.caster).recordTable).CritMax
        end
        LuaSkillCtrl:CallBuff(self, (skillResult.roleList)[i], buffId, 1, (self.arglist)[1])
      end
      skillResult:EndResult()
    end
  end
end

bs_103402.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  if (sender:GetBuffTier((self.config).buffId_Crit) > 0 or sender:GetBuffTier((self.config).buffId_Crit_ex) > 0) and sender.belongNum == (self.caster).belongNum and isTriggerSet ~= true and isCrit == true and hurt > 0 then
    local time = ((self.caster).recordTable).Time
    if time ~= nil then
      LuaSkillCtrl:CallResetCDNumForRole(self.caster, time)
    end
  end
end

bs_103402.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_103402

