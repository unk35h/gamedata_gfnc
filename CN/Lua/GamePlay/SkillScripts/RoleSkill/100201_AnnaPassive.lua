-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100201 = class("bs_100201", LuaSkillBase)
local base = LuaSkillBase
bs_100201.config = {effectId_trail = 100208, effectId_line = 100207, buffId_cockhourse2 = 100203, buffId_bk = 100204, buffId_cockhourse = 3010, buffId_dizzy = 100201, buffId_dizzy_cha = 100202, time = nil, tier = 1, tier_skill = 1, selectId_pass = 20, selectId_skill = 9, select_range = 15, weaponLv = 0}
bs_100201.ctor = function(self)
  -- function num : 0_0
end

bs_100201.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
  self.cockHourseBuffId = nil
  if (self.config).weaponLv >= 1 then
    self.cockHourseBuffId = (self.config).buffId_cockhourse2
  else
    self.cockHourseBuffId = (self.config).buffId_cockhourse
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).cockBuffId = self.cockHourseBuffId
  self:AddAfterAddBuffTrigger("bs_100201_7", 1, self.OnAfterAddBuff, self.caster, nil, nil, nil, self.cockHourseBuffId)
  self:AddAfterHurtTrigger("bs_100201_1", 1, self.OnAfterHurt, self.caster)
  self:AddSetDeadHurtTrigger("bs_100201_3", 20, self.OnSetDeadHurt)
end

bs_100201.OnSetDeadHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if self.caster == nil then
    return 
  end
  if (self.caster).belongNum ~= (context.target).belongNum and (context.target):GetBuffTier(self.cockHourseBuffId) > 0 then
    local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId_pass, (self.config).select_range, context.target)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local role_target = (targetList[i]).targetRole
        if role_target.intensity ~= 0 and role_target ~= nil and role_target.hp > 0 then
          local tier = (context.target):GetBuffTier(self.cockHourseBuffId)
          LuaSkillCtrl:CallEffect((targetList[i]).targetRole, (self.config).effectId_line, self, nil, context.target)
          LuaSkillCtrl:CallEffectWithArgOverride((targetList[i]).targetRole, (self.config).effectId_trail, self, context.target, false, false, self.SkillEventFunc, tier)
          break
        end
      end
    end
    do
      LuaSkillCtrl:DispelBuff(context.target, self.cockHourseBuffId, 0, true)
    end
  end
end

bs_100201.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and not isMiss and target.intensity ~= 0 and target.hp > 0 then
    LuaSkillCtrl:CallBuff(self, target, self.cockHourseBuffId, (self.config).tier, (self.config).time)
  end
  if sender == self.caster and (skill.dataId == 100202 or skill.dataId == 100205) and isTriggerSet ~= true then
    local transferList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId_skill, (self.config).select_range)
    if transferList ~= 0 then
      for i = 0, transferList.Count - 1 do
        local role = (transferList[i]).targetRole
        if role ~= nil and role.intensity ~= 0 then
          LuaSkillCtrl:CallBuff(self, role, self.cockHourseBuffId, (self.config).tier, (self.config).time)
        end
      end
    end
  end
end

bs_100201.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_4 , upvalues : _ENV
  local maker = (buff.battleSkill).maker
  if buff.dataId == self.cockHourseBuffId and target.belongNum ~= maker.belongNum and target ~= self.caster then
    local restTier = target:GetBuffTier(self.cockHourseBuffId)
    if (self.arglist)[1] <= restTier and self.caster ~= nil then
      if (self.config).weaponLv >= 1 then
        LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnAnnaStun, target)
        local time = (self.arglist)[2] + (self.arglist)[3]
        if LuaSkillCtrl:GetCasterSkinId(maker) == 300203 then
          LuaSkillCtrl:CallBuffLifeEvent(self, target, (self.config).buffId_dizzy, (self.config).tier, time, BindCallback(self, self.OnBuffLifeEvent, target))
        else
          LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_dizzy, (self.config).tier, time)
        end
      else
        do
          if LuaSkillCtrl:GetCasterSkinId(maker) == 300203 then
            LuaSkillCtrl:CallBuffLifeEvent(self, target, (self.config).buffId_dizzy, (self.config).tier, (self.arglist)[2], BindCallback(self, self.OnBuffLifeEvent, target))
          else
            LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_dizzy, (self.config).tier, (self.arglist)[2])
          end
          LuaSkillCtrl:DispelBuff(target, self.cockHourseBuffId, (self.arglist)[1], true)
        end
      end
    end
  end
end

bs_100201.OnBuffLifeEvent = function(self, role, lifeType, arg)
  -- function num : 0_5 , upvalues : _ENV
  if lifeType == eBuffLifeEvent.NewAdd then
    LuaSkillCtrl:CallStartLocalScale(role, (Vector3.New)(0.1, 0.9, 0.1), 0.1)
  else
    if lifeType == eBuffLifeEvent.Remove then
      LuaSkillCtrl:CallStartLocalScale(role, (Vector3.New)(1, 1, 1), 0.1)
    end
  end
end

bs_100201.SkillEventFunc = function(self, tier, effect, eventId, target)
  -- function num : 0_6 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger and target ~= nil then
    LuaSkillCtrl:CallBuff(self, target.targetRole, self.cockHourseBuffId, tier, (self.config).time)
  end
end

bs_100201.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : _ENV
  (self.caster):SetRoleState((CS.eBattleRoleState).Normal)
  self:RemoveAllTimers()
  self:RemoveAllBreakKillEffects()
end

return bs_100201

