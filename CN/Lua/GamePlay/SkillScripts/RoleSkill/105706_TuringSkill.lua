-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105706 = class("bs_105706", LuaSkillBase)
local base = LuaSkillBase
bs_105706.config = {buffId = 105706, effectid = 105705, effectid_1 = 105704, actionId = 1002, action_speed = 1, actionId_start_time = 25, skilltime = 46}
bs_105706.ctor = function(self)
  -- function num : 0_0
end

bs_105706.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105706.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectid, self, nil)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, data)
  local time = (self.config).skilltime
  self:CallCasterWait(time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).actionId_start_time, attackTrigger)
end

bs_105706.OnAttackTrigger = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnTuringSkill)
  local target_pow, target_skill_intensity, target = nil, nil, nil
  local targets_pow = LuaSkillCtrl:CallTargetSelect(self, 59, 10)
  if targets_pow.Count > 0 then
    for i = 0, targets_pow.Count - 1 do
      if ((targets_pow[i]).targetRole):GetBuffTier((self.config).buffId) == 0 and (targets_pow[i]).targetRole ~= self.caster then
        local skills = ((targets_pow[i]).targetRole):GetBattleSkillList()
        if skills.Count > 0 then
          for j = 0, skills.Count - 1 do
            if (skills[j]).isNormalSkill then
              target_pow = (targets_pow[i]).targetRole
              break
            end
          end
        end
      end
    end
    do
      if target_pow ~= nil or target_pow == nil then
        target_pow = (targets_pow[0]).targetRole
      end
      local targets_skill_intensity = LuaSkillCtrl:CallTargetSelect(self, 64, 10)
      if targets_skill_intensity.Count > 0 then
        for i = 0, targets_skill_intensity.Count - 1 do
          if ((targets_skill_intensity[i]).targetRole):GetBuffTier((self.config).buffId) == 0 and (targets_skill_intensity[i]).targetRole ~= self.caster then
            local skills = ((targets_skill_intensity[i]).targetRole):GetBattleSkillList()
            if skills.Count > 0 then
              for j = 0, skills.Count - 1 do
                if (skills[j]).isNormalSkill then
                  target_skill_intensity = (targets_skill_intensity[i]).targetRole
                  break
                end
              end
            end
          end
        end
        do
          if target_skill_intensity ~= nil or target_skill_intensity == nil then
            target_skill_intensity = (targets_skill_intensity[0]).targetRole
          end
          if target_skill_intensity.skill_intensity <= target_pow.pow then
            target = target_pow
          else
            target = target_skill_intensity
          end
          LuaSkillCtrl:CallEffect(self.caster, (self.config).effectid_1, self, nil)
          LuaSkillCtrl:StartTimer(nil, 7, function()
    -- function num : 0_3_0 , upvalues : _ENV, self, target
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, nil, true)
    LuaSkillCtrl:CallResetCDNumForRole(target, (self.arglist)[3])
  end
, nil)
        end
      end
    end
  end
end

bs_105706.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105706

