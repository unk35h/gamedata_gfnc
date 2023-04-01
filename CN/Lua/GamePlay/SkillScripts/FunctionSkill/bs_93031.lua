-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93031 = class("bs_93031", LuaSkillBase)
local base = LuaSkillBase
bs_93031.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10127, crit_formula = 0}
, effectId = 10979, buffId = 2055, checkBuffId = 2055}
bs_93031.ctor = function(self)
  -- function num : 0_0
end

bs_93031.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_93031_1", 1, self.OnAfterBattleStart)
  self:AddOnRoleDieTrigger("bs_93031_02", 1, self.OnRoleDie)
  self:AddAfterAddBuffTrigger("bs_93031_03", 1, self.OnAfterAddBuff, nil, nil, nil, nil, (self.config).buffId)
  self.countBuffEffect = {}
end

bs_93031.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], arriveCallBack, nil, -1, (self.arglist)[1])
end

bs_93031.OnRoleDie = function(self, killer, role)
  -- function num : 0_3
  if role.belongNum ~= (self.caster).belongNum then
    local newBuffTier = role:GetBuffTier((self.config).buffId)
    if (self.countBuffEffect)[role.uid] ~= nil then
      ((self.countBuffEffect)[role.uid]):Die()
      -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (self.countBuffEffect)[role.uid] = nil
    end
  end
end

bs_93031.OnArriveAction = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local target = (targetlist[i]).targetRole
    if LuaSkillCtrl:FindRolesAroundRole(target) == nil then
      return 
    end
    local targetlist1 = LuaSkillCtrl:FindRolesAroundRole(target)
    if targetlist1.Count < 1 then
      return 
    end
    local buffTier = target:GetBuffTier((self.config).checkBuffId)
    local targetlist2 = LuaSkillCtrl:CallTargetSelect(self, 51, 10)
    if targetlist2.Count < 0 then
      return 
    end
    local targetRole = (targetlist2[0]).targetRole
    local skill_intensity = targetRole.skill_intensity
    if target ~= nil and buffTier ~= 0 then
      LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, 14, {buffTier * (self.arglist)[2] * skill_intensity // 1000}, true, true)
      skillResult:EndResult()
      for i = 0, targetlist1.Count - 1 do
        local target1 = targetlist1[i]
        if target1.belongNum == target.belongNum then
          local skillResult1 = LuaSkillCtrl:CallSkillResultNoEffect(self, target1)
          LuaSkillCtrl:HurtResultWithConfig(self, skillResult1, 14, {buffTier * (self.arglist)[2] * skill_intensity // 1000}, true, true)
          skillResult1:EndResult()
          LuaSkillCtrl:CallBuff(self, target1, (self.config).buffId, buffTier)
        end
      end
    end
  end
end

bs_93031.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_5 , upvalues : _ENV
  if buff.dataId == (self.config).buffId and target ~= nil and target.hp > 0 then
    local buffTier1 = target:GetBuffTier((self.config).buffId)
    local isHaveEffect = (self.countBuffEffect)[target] ~= nil
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R5 in 'UnsetPending'

    if not isHaveEffect or buffTier1 == 0 then
      (self.countBuffEffect)[target] = LuaSkillCtrl:CallEffect(target, 10974, self)
      LuaSkillCtrl:EffectSetCountValue((self.countBuffEffect)[target], buffTier1 - 1)
    else
      LuaSkillCtrl:EffectSetCountValue((self.countBuffEffect)[target], buffTier1 - 1)
    end
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

bs_93031.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_93031.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : base
  self.countBuffEffect = nil
  ;
  (base.LuaDispose)(self)
end

return bs_93031

