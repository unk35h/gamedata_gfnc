-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106209 = class("bs_106209", LuaSkillBase)
local base = LuaSkillBase
bs_106209.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 10003}
, skill_time = 30, start_time = 11, actionId = 1002, actionId2 = 1003, skill_time2 = 34, action_speed = 1, skill_selectId = 1001, audioId1 = 234, audioId2 = 235, buffId_Taunt = 3002, buffId1 = 106201, buffId2 = 106202, buffId3 = 106203, 
aoe_config = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
, effectId_show = 106216, effectId_pg = 106217, effectId_skill = 102210, effectId_hit = 102211, effectId_loop = 106214, effectId_end = 106215, hurtConfig = 25, effectId_show_wx = 106221, effectId_pg_wx = 106222}
bs_106209.ctor = function(self)
  -- function num : 0_0
end

bs_106209.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.arg1 = ((self.caster).recordTable).arg_1
  self.arg3 = ((self.caster).recordTable).arg_3
  self.arg4 = ((self.caster).recordTable).arg_4
  self.skinId = ((self.caster).recordTable).skinId
  self.num1 = 0
  self.num2 = 0
  LuaSkillCtrl:CallBuff(self, self.caster, 106205, 1, 999999, true)
  self:AddAfterHurtTrigger("bs_106209_1", 9, self.OnAfterHurt, nil, self.caster, nil, nil, nil, nil, nil)
  self:AddAfterAddBuffTrigger("bs_106209_7", 1, self.OnAfterAddBuff, nil, self.caster, nil, nil, (self.config).buffId2)
  self.callback = LuaSkillCtrl:StartTimer(nil, 15, self.CallBack, self, -1, 15 - (self.config).skill_time2 - 10)
  LuaSkillCtrl:StartTimer(self, 1, function()
    -- function num : 0_1_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, 1003)
    local targetList = LuaSkillCtrl:CallTargetSelectWithRange(self, 9, 1)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        do
          if ((targetList[i]).targetRole).intensity ~= 0 and targetList[0] ~= nil then
            (self.caster):LookAtTarget((targetList[0]).targetRole)
            LuaSkillCtrl:StartTimer(self, 12, function()
      -- function num : 0_1_0_0 , upvalues : _ENV, self, targetList, i
      LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId_Taunt, 1, self.arg3)
      LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId3, 1, 1)
    end
)
          end
        end
      end
    end
    do
      if self.skinId == 306203 then
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_show_wx, self)
      else
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_show, self)
      end
    end
  end
)
end

bs_106209.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if not isTriggerSet and not isMiss then
    self.num1 = self.num1 + 1
    if self.arg4 <= self.num2 + self.num1 then
      local targetList = LuaSkillCtrl:CallTargetSelectWithRange(self, 9, 1)
      if targetList.Count > 0 then
        for i = 0, targetList.Count - 1 do
          if ((targetList[i]).targetRole).intensity ~= 0 then
            LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId3, 1, 1)
          end
        end
      end
      do
        LuaSkillCtrl:DispelBuff(self.caster, 106205)
        LuaSkillCtrl:RemoveLife((self.caster).maxHp * 10, self, self.caster, false, nil, false, true, 1, true)
      end
    end
  end
end

bs_106209.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if (self.caster):GetBuffTier(196) <= 0 then
    if self.skinId == 306203 then
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_pg_wx, self)
    else
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_pg, self)
    end
    LuaSkillCtrl:CallRoleAction(self.caster, 1001)
    LuaSkillCtrl:StartTimer(self, 10, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster, (self.config).aoe_config)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {self.arg1})
    for i = 0, (skillResult.roleList).Count - 1 do
      if LuaSkillCtrl:IsObstacle((skillResult.roleList)[i]) then
        return 
      end
      if not LuaSkillCtrl:GetRoleBuffById((skillResult.roleList)[i], (self.config).buffId_fly) then
        LuaSkillCtrl:CallBuff(self, (skillResult.roleList)[i], (self.config).buffId3, 1, 1)
      end
    end
  end
)
  end
  LuaSkillCtrl:StartTimer(self, 13, function()
    -- function num : 0_3_1 , upvalues : self, _ENV
    self.num2 = self.num2 + 1
    if self.arg4 <= self.num2 + self.num1 then
      local targetList = LuaSkillCtrl:CallTargetSelectWithRange(self, 9, 1)
      if targetList.Count > 0 then
        for i = 0, targetList.Count - 1 do
          if ((targetList[i]).targetRole).intensity ~= 0 then
            LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId3, 1, 1)
            LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId3, 1, 1)
          end
        end
      end
      do
        LuaSkillCtrl:DispelBuff(self.caster, 106205)
        LuaSkillCtrl:RemoveLife((self.caster).maxHp * 10, self, self.caster, false, nil, false, true, 1, true)
      end
    end
  end
)
end

bs_106209.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallRoleAction(self.caster, 1010)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 80, true)
  self.skillLoop = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_loop, self, nil, nil, nil, true)
  LuaSkillCtrl:StartTimer(self, 25, function()
    -- function num : 0_4_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, 1006)
  end
)
  self.beginTimer = LuaSkillCtrl:StartTimer(self, 15, function()
    -- function num : 0_4_1 , upvalues : self
    self:beginAttack()
  end
, self, -1, 14)
  self.time = LuaSkillCtrl:StartTimer(self, 60, function()
    -- function num : 0_4_2 , upvalues : self
    if self.beginTimer ~= nil then
      (self.beginTimer):Stop()
      self.beginTimer = nil
    end
    self:endAttack()
  end
)
end

bs_106209.beginAttack = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelectWithRange(self, 9, 1)
  if targetlist.Count > 0 then
    for i = 0, targetlist.Count - 1 do
      if (targetlist[i]).targetRole ~= nil then
        local num = 3
        local hurt = self.arg1 * num
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, (targetlist[i]).targetRole)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {hurt})
        skillResult:EndResult()
      end
    end
  end
end

bs_106209.endAttack = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self.beginTimer ~= nil then
    (self.beginTimer):Stop()
    self.beginTimer = nil
  end
  if self.time ~= nil then
    (self.time):Stop()
    self.time = nil
  end
  LuaSkillCtrl:StartTimer(self, 20, function()
    -- function num : 0_6_0 , upvalues : self
    self:CancleCasterWait()
  end
)
end

bs_106209.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
  if self.skillLoop ~= nil then
    (self.skillLoop):Die()
    self.skillLoop = nil
  end
  if self.beginTimer ~= nil then
    (self.beginTimer):Stop()
    self.beginTimer = nil
  end
  if self.time ~= nil then
    (self.time):Stop()
    self.time = nil
  end
  if self.callback ~= nil then
    (self.callback):Stop()
    self.callback = nil
  end
end

bs_106209.LuaDispose = function(self)
  -- function num : 0_8 , upvalues : base
  (base.LuaDispose)(self)
  if self.skillLoop ~= nil then
    (self.skillLoop):Die()
    self.skillLoop = nil
  end
  if self.beginTimer ~= nil then
    (self.beginTimer):Stop()
    self.beginTimer = nil
  end
  if self.time ~= nil then
    (self.time):Stop()
    self.time = nil
  end
  if self.callback ~= nil then
    (self.callback):Stop()
    self.callback = nil
  end
end

return bs_106209

