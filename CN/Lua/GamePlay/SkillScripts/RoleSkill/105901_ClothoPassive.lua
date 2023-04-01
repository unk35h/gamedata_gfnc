-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105901 = class("bs_105901", LuaSkillBase)
local base = LuaSkillBase
bs_105901.config = {buffId_live = 3009, nanaka_buffId = 102603, buffId = 105901, buffId_heal = 105902, buffId_1 = 105905, buffId_def = 105906, buffId_times = 105907, 
heal_config = {baseheal_formula = 3022}
, effectId_trail = 105904}
bs_105901.ctor = function(self)
  -- function num : 0_0
end

bs_105901.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetDeadHurtTrigger("bs_105901_1", 999, self.OnSetDeadHurt, nil, nil, nil, (self.caster).belongNum)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_105901_2", 10, self.OnRoleDie)
  self:AddTrigger(eSkillTriggerType.OnBreakShield, "bs_105901_3", 1, self.OnBreakShield)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_105901_4", 1, self.OnAfterBattleStart)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).Soul_Num = 0
  self.SoulnumMax = (self.arglist)[4]
  self.times = 1
  self:AddTrigger(eSkillTriggerType.BeforeBattleEnd, "bs_105901_5", 1, self.BeforeEndBattle)
end

bs_105901.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_def, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_times, 1)
end

bs_105901.OnSetDeadHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  local NoDeath = LuaSkillCtrl:RoleContainsBuffFeature(context.target, eBuffFeatureType.NoDeath)
  if (context.target).belongNum == (self.caster).belongNum and (context.target).roleType == 1 and context.target ~= context.sender and (context.target):GetBuffTier((self.config).nanaka_buffId) <= 0 and self.times >= 1 and NoDeath == false then
    self.times = self.times - 1
    LuaSkillCtrl:CallBuff(self, context.target, (self.config).buffId_live, 1, 1, true)
    LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_3_0 , upvalues : context, self, _ENV
    if context.target == nil or (context.target).hp <= 0 or self.caster == nil then
      return 
    end
    do
      if LuaSkillCtrl:InInPhaseMove(context.target) then
        local targetGrid = LuaSkillCtrl:GetGridWithRole(context.target)
        -- DECOMPILER ERROR at PC26: Confused about usage of register: R1 in 'UnsetPending'

        if targetGrid ~= nil then
          ((context.target).lsObject).localPosition = targetGrid.fixLogicPosition
          ;
          ((context.target).lsObject):ResetGameObjectPosition()
        end
      end
      LuaSkillCtrl:CallBuffRepeated(self, context.target, (self.config).buffId_heal, 1, (self.arglist)[1], false, self.OnBuffExecute)
      LuaSkillCtrl:CallBuff(self, context.target, (self.config).buffId_1, 1, (self.arglist)[1], true)
      LuaSkillCtrl:SetGameObjectActive((context.target).lsObject, false)
      local value = (self.caster).maxHp * (self.arglist)[3] // 1000
      LuaSkillCtrl:AddRoleShield(context.target, eShieldType.Beelneith, value)
      LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], function()
      -- function num : 0_3_0_0 , upvalues : _ENV, context
      local SelfShieldValue = LuaSkillCtrl:GetShield(context.target, 3)
      if SelfShieldValue ~= 0 then
        LuaSkillCtrl:ClearShield(context.target, 3)
        LuaSkillCtrl:SetGameObjectActive((context.target).lsObject, true)
      end
    end
, nil)
      if self.caster ~= nil then
        LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_times, 1)
      end
    end
  end
, nil)
  end
end

bs_105901.OnBuffExecute = function(self, buff, targetRole)
  -- function num : 0_4 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
  LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {(self.arglist)[2]}, true)
  skillResult:EndResult()
end

bs_105901.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_5 , upvalues : _ENV
  if target.belongNum == (self.caster).belongNum and shieldType == 3 and target:GetBuffTier((self.config).buffId_heal) > 0 then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_heal, 1)
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_1, 1)
    if not LuaSkillCtrl.IsInVerify then
      LuaSkillCtrl:SetGameObjectActive(target.lsObject, true)
    end
  end
end

bs_105901.OnRoleDie = function(self, killer, role)
  -- function num : 0_6 , upvalues : _ENV
  if role.belongNum ~= 0 and ((self.caster).recordTable).Soul_Num < self.SoulnumMax and role.roleType == 1 then
    LuaSkillCtrl:CallEffectWithArgOverride(self.caster, (self.config).effectId_trail, self, role, nil, nil, self.getSoul)
  end
end

bs_105901.getSoul = function(self, effect, eventId, target)
  -- function num : 0_7 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_trail and eventId == eBattleEffectEvent.Trigger then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_times, 1)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1)
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R4 in 'UnsetPending'

    if ((self.caster).recordTable).Soul_Num < self.SoulnumMax then
      ((self.caster).recordTable).Soul_Num = ((self.caster).recordTable).Soul_Num + 1
      self.times = self.times + 1
    end
  end
end

bs_105901.BeforeEndBattle = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = targetList[i]
      if role ~= nil and role.hp > 0 and role:GetBuffTier((self.config).buffId_1) > 0 then
        LuaSkillCtrl:DispelBuff(role, (self.config).buffId_1, 1)
        LuaSkillCtrl:DispelBuff(role, (self.config).buffId_heal, 1)
        LuaSkillCtrl:SetGameObjectActive(role.lsObject, true)
      end
    end
  end
end

bs_105901.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105901

