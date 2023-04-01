-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207703 = class("bs_207703", LuaSkillBase)
local base = LuaSkillBase
bs_207703.config = {action_start_time = 3, action_loop_time = 15, action_start = 1008, action_loop = 1007, action_speed = 1, selectId = 3, selectRange = 10, 
heal_config = {baseheal_formula = 3021}
, effectId_AoeHit = 207706, effectId_loop = 207705, HurtConfigID = 3, buffFeature_ignoreDie = 6, buffId_Bati = 207703, effect_heal = 207709}
bs_207703.ctor = function(self)
  -- function num : 0_0
end

bs_207703.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.OnSelfAfterMove, "bs_207701_OnSelfAfterMove", 1, self.OnSelfAfterMove)
  self.arg1 = ((self.caster).recordTable).arg_1
  self.arg2 = ((self.caster).recordTable).arg_2
  self.arg3 = ((self.caster).recordTable).arg_3
end

bs_207703.OnSelfAfterMove = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:FindRolesAroundRole(self.caster)
  if targetList ~= nil and targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      if LuaSkillCtrl:CheckReletionWithRoleBelong(self.caster, targetList[i], eBelongReletionType.Enemy) then
        self:doskill()
        break
      end
    end
  end
end

bs_207703.OnAfterBattleStart = function(self, summonerEntity)
  -- function num : 0_3 , upvalues : _ENV
  if summonerEntity == self.caster then
    local targetList = LuaSkillCtrl:FindRolesAroundRole(self.caster)
    if targetList ~= nil and targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        if LuaSkillCtrl:CheckReletionWithRoleBelong(self.caster, targetList[i], eBelongReletionType.Enemy) then
          self:doskill()
          break
        end
      end
    end
  end
end

bs_207703.doskill = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local Skill_time = (self.config).action_start_time + (self.config).action_loop_time * self.arg1 // 10
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Bati, 1, Skill_time, true)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  self:AddCasterWait(Skill_time)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).action_start)
  LuaSkillCtrl:StartTimer(nil, (self.config).action_start_time, function()
    -- function num : 0_4_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).action_loop)
    self.effect_loop_207703 = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_loop, self)
  end
)
  self.Boom = LuaSkillCtrl:StartTimer(nil, Skill_time, attackTrigger)
end

bs_207703.OnAttackTrigger = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.effect_loop_207703 ~= nil then
    (self.effect_loop_207703):Die()
    self.effect_loop_207703 = nil
  end
  local targetList = LuaSkillCtrl:FindAllRolesWithinRange(self.caster, 1, false)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      if (targetList[i]).belongNum ~= (self.caster).belongNum then
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetList[i])
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {self.arg2})
        skillResult:EndResult()
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_AoeHit, self)
      end
    end
  end
  do
    local targetCUrList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId, (self.config).selectRange)
    if targetCUrList.Count ~= 0 then
      LuaSkillCtrl:CallEffectWithArg(targetCUrList[0], (self.config).effect_heal, self, nil, false, self.Doheal)
    end
    local IfRoleCotainsIgnoreDieBuff = LuaSkillCtrl:RoleContainsBuffFeature(self.caster, (self.config).buffFeature_ignoreDie)
    if IfRoleCotainsIgnoreDieBuff == true then
      local buff_ignoreDie = LuaSkillCtrl:GetRoleAllBuffsByFeature(self.caster, (self.config).buffFeature_ignoreDie)
      if buff_ignoreDie.Count > 0 then
        for i = 0, buff_ignoreDie.Count - 1 do
          LuaSkillCtrl:DispelBuff(self.caster, (buff_ignoreDie[i]).dataId, 0)
          IfRoleCotainsIgnoreDieBuff = false
        end
      end
    end
    do
      LuaSkillCtrl:RemoveLife((self.caster).hp, self, self.caster, true, nil, false, true, eHurtType.RealDmg, true)
    end
  end
end

bs_207703.Doheal = function(self, effect, eventId, target)
  -- function num : 0_6 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {self.arg3}, false, false)
    skillResult:EndResult()
  end
end

bs_207703.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  if self.effect_loop_207703 ~= nil then
    (self.effect_loop_207703):Die()
    self.effect_loop_207703 = nil
  end
  if self.Boom ~= nil then
    (self.Boom):Stop()
    self.Boom = nil
  end
  ;
  (base.OnCasterDie)(self)
end

bs_207703.LuaDispose = function(self)
  -- function num : 0_8 , upvalues : base
  self.effect_loop_207703 = nil
  self.Boom = nil
  ;
  (base.LuaDispose)(self)
end

return bs_207703

