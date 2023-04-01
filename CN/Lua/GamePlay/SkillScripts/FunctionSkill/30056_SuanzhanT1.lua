-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_30056 = class("bs_30056", LuaSkillBase)
local base = LuaSkillBase
bs_30056.config = {buffWKId = 1248, buffDuration = 60, buffDuration2 = 120, buffDamageTime = 15, 
aoe_config = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
, 
hurt_config = {hit_formula = 0, basehurt_formula = 10185, crit_formula = 0}
, effectIdHit = 10939, effectIdXS = 10940}
bs_30056.ctor = function(self)
  -- function num : 0_0
end

bs_30056.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_30056_1", 1, self.OnAfterBattleStart)
  self:AddBeforeBuffDispelTrigger("bs_30056_1", 1, self.BeforeBuffDispel, self.caster, nil, (self.config).buffWKId)
  self:AddBuffDieTrigger("bs_30056_2", 1, self.OnBuffDie, self.caster, nil, (self.config).buffWKId)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["30056_WK"] = true
  self:AddAfterAddBuffTrigger("bs_30056", 1, self.OnAfterAddBuff, nil, self.caster, nil, nil, (self.config).buffWKId)
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).ishavetimer = false
end

bs_30056.BeforeBuffDispel = function(self, targetRole, context)
  -- function num : 0_2
  local buffTier = (self.caster):GetBuffTier((self.config).buffWKId)
  if buffTier == 0 then
    if self.timer ~= nil then
      (self.timer):Stop()
      self.timer = nil
    end
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.caster).recordTable).ishavetimer = false
  end
end

bs_30056.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_3
  local buffTier = (self.caster):GetBuffTier((self.config).buffWKId)
  if buffTier == 0 then
    if self.timer ~= nil then
      (self.timer):Stop()
      self.timer = nil
    end
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.caster).recordTable).ishavetimer = false
  end
end

bs_30056.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  if target == self.caster and not ((self.caster).recordTable).ishavetimer then
    ((self.caster).recordTable).ishavetimer = true
    local arriveCallBack2 = BindCallback(self, self.OnArriveAction2)
    local damageTime = (self.config).buffDuration2 // (self.config).buffDamageTime
    if self.timer == nil then
      self.timer = LuaSkillCtrl:StartTimer(nil, (self.config).buffDamageTime, arriveCallBack2, nil, -1, (self.config).buffDamageTime)
    else
      if self.timer ~= nil then
        (self.timer):Stop()
        self.timer = nil
      end
      self.timer = LuaSkillCtrl:StartTimer(nil, (self.config).buffDamageTime, arriveCallBack2, nil, -1, (self.config).buffDamageTime)
    end
  end
end

bs_30056.OnAfterBattleStart = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  self.timer2 = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], arriveCallBack, nil, -1)
end

bs_30056.OnArriveAction = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self.timer2 ~= nil and (self.timer2):IsOver() then
    self.timer2 = nil
  end
  if ((self.caster).recordTable)["30056_WK"] then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffWKId, (self.arglist)[2], (self.config).buffDuration2)
  else
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffWKId, (self.arglist)[2], (self.config).buffDuration)
  end
end

bs_30056.OnArriveAction2 = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local tier = (self.caster):GetBuffTier((self.config).buffWKId)
  if tier > 0 then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster, (self.config).aoe_config)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {tier}, true)
    if (skillResult.roleList).Count > 0 then
      for i = 0, (skillResult.roleList).Count - 1 do
        local role = (skillResult.roleList)[i]
        LuaSkillCtrl:CallEffect(role, (self.config).effectIdHit, self)
      end
    end
    do
      do
        skillResult:EndResult()
        if self.timer ~= nil then
          (self.timer):Stop()
          self.timer = nil
        end
        -- DECOMPILER ERROR at PC66: Confused about usage of register: R2 in 'UnsetPending'

        ;
        ((self.caster).recordTable).ishavetimer = false
      end
    end
  end
end

bs_30056.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
  if self.timer2 ~= nil then
    (self.timer2):Stop()
    self.timer2 = nil
  end
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable).ishavetimer = false
end

bs_30056.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
  if self.timer2 ~= nil then
    (self.timer2):Stop()
    self.timer2 = nil
  end
  ;
  (base.LuaDispose)(self)
end

return bs_30056

