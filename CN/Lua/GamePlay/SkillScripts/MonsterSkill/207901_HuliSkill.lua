-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207901 = class("bs_207901", LuaSkillBase)
local base = LuaSkillBase
bs_207901.config = {HurtConfig = 12, buffId_csbuff = 207901, buffId_ksbuff = 207902, effectId_line = 207906, effectId_trail = 207906, effectId_line2 = 207908, effectId_trail2 = 207908, selectId = 10001, selectRange = 10, selectId2 = 34, skill_time = 19, start_time = 12, actionId = 1002, act_speed = 1, time_hurt = 3, audioId = 207903}
bs_207901.ctor = function(self)
  -- function num : 0_0
end

bs_207901.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.caster).recordTable).one = nil
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).two = nil
end

bs_207901.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId, (self.config).selectRange)
  if targetList.Count == 0 then
    LuaSkillCtrl:SetResetCdByReturnConfigOnce(self)
    return 
  end
  self:AbandonSkillCdAutoReset(true)
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  ;
  (self.caster):LookAtTarget((targetList[0]).targetRole)
  self:CallCasterWait((self.config).skill_time)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, (targetList[0]).targetRole, data)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).act_speed, (self.config).start_time, attackTrigger)
end

bs_207901.OnAttackTrigger = function(self, target, data)
  -- function num : 0_3
  self:RealPlaySkill(nil, target, 1)
  self:EndSkillAndCallNext()
end

bs_207901.RealPlaySkill = function(self, sender, target, JNId)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId)
  if sender == nil then
    LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effectId_trail, self, self.caster, false, false, self.SkillEventFunc, JNId)
  else
    if JNId <= 1 then
      LuaSkillCtrl:StartTimer(nil, (self.config).time_hurt, function()
    -- function num : 0_4_0 , upvalues : _ENV, target, self, sender, JNId
    LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effectId_trail, self, sender, false, false, self.SkillEventFunc, JNId)
  end
)
    else
      LuaSkillCtrl:StartTimer(nil, (self.config).time_hurt, function()
    -- function num : 0_4_1 , upvalues : _ENV, target, self, sender, JNId
    LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effectId_trail2, self, sender, false, false, self.SkillEventFunc, JNId)
  end
)
    end
  end
  if sender == nil and target == self.caster then
    return 
  end
end

bs_207901.SkillEventFunc = function(self, JNId, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  if (effect.dataId == (self.config).effectId_trail or effect.dataId == (self.config).effectId_trail2) and eventId == eBattleEffectEvent.Trigger then
    LuaSkillCtrl:StartTimer(nil, (self.config).time_hurt, BindCallback(self, self.CallBack, target.targetRole, JNId))
    local num = (self.caster):GetBuffTier((self.config).buffId_csbuff)
    if JNId <= (self.arglist)[2] + num then
      local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId2, (self.config).selectRange, target.targetRole)
      if targetList.Count == 0 then
        return 
      end
      if targetList.Count >= 2 then
        for i = 0, targetList.Count - 1 do
          if (targetList[i]).targetRole ~= nil and (targetList[i]).targetRole ~= target.targetRole and ((targetList[i]).targetRole).roleDataId ~= ((self.caster).recordTable).one then
            self:RealPlaySkill(target.targetRole, (targetList[i]).targetRole, JNId + 1)
            -- DECOMPILER ERROR at PC90: Confused about usage of register: R11 in 'UnsetPending'

            if ((self.caster).recordTable).one ~= nil then
              ((self.caster).recordTable).two = ((self.caster).recordTable).one
            end
            -- DECOMPILER ERROR at PC95: Confused about usage of register: R11 in 'UnsetPending'

            ;
            ((self.caster).recordTable).one = (target.targetRole).roleDataId
            break
          end
        end
      else
        do
          if (targetList[0]).targetRole ~= nil and (targetList[0]).targetRole ~= target.targetRole then
            self:RealPlaySkill(target.targetRole, (targetList[0]).targetRole, JNId + 1)
          end
        end
      end
    end
  end
end

bs_207901.CallBack = function(self, targetRole, healId)
  -- function num : 0_6 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfig, {healId}, false, false)
  skillResult:EndResult()
end

bs_207901.EndSkillAndCallNext = function(self)
  -- function num : 0_7
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

bs_207901.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207901

