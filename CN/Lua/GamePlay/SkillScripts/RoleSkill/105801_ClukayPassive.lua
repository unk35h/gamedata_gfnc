-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105801 = class("bs_105801", LuaSkillBase)
local base = LuaSkillBase
bs_105801.config = {effectId_xb = 105801, hurtConfig = 13, buffIdys = 105801, 
aoe_config = {effect_shape = 3, aoe_select_code = 5, aoe_range = 2}
, frameMaxEffectNum = 4}
bs_105801.ctor = function(self)
  -- function num : 0_0
end

bs_105801.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_105803_2", 1, self.OnRoleDie)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_105803_3", 1, self.OnAfterBattleStart)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["105801_Roll"] = (self.arglist)[1]
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["105801_arg2"] = (self.arglist)[2]
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["105801_arg3"] = (self.arglist)[3]
  self.callEffectQueue = {}
end

bs_105801.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.updateTimer = LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_2_0 , upvalues : self, _ENV
    if self.callEffectQueue ~= nil and #self.callEffectQueue > 0 then
      for i = 1, (self.config).frameMaxEffectNum do
        if #self.callEffectQueue > 0 then
          local role = (self.callEffectQueue)[1]
          LuaSkillCtrl:CallEffect(role, (self.config).effectId_xb, self)
          ;
          (table.remove)(self.callEffectQueue, 1)
        else
          break
        end
      end
    end
  end
, nil, -1)
end

bs_105801.OnRoleDie = function(self, killer, role)
  -- function num : 0_3 , upvalues : _ENV
  if killer == self.caster or role:GetBuffTier((self.config).buffIdys) >= 1 then
    if role.belongNum ~= (self.caster).belongNum and role.hp == 0 and role ~= nil and role.belongNum ~= eBattleRoleBelong.neutral then
      (table.insert)(self.callEffectQueue, role)
      LuaSkillCtrl:StartTimer(nil, 12, function()
    -- function num : 0_3_0 , upvalues : _ENV, self, role
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role, (self.config).aoe_config)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {(self.arglist)[4]})
    skillResult:EndResult()
  end
)
    end
    LuaSkillCtrl:DispelBuff(role, (self.config).buffIdys, 0)
  end
end

bs_105801.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.updateTimer ~= nil then
    (self.updateTimer):Stop()
    self.updateTimer = nil
  end
  self.callEffectQueue = nil
end

bs_105801.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  (base.LuaDispose)(self)
  if self.updateTimer ~= nil then
    (self.updateTimer):Stop()
    self.updateTimer = nil
  end
  self.callEffectQueue = nil
end

return bs_105801

