-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105003 = class("bs_105003", LuaSkillBase)
local base = LuaSkillBase
bs_105003.config = {actionId_start = 1005, actionId_end = 1006, buffId_Super = 3003, buff_hitfly = 3019, shieldFormula = 105001, configId = 3, effectId1 = 105008, effectId2 = 105009, effectId3 = 105010, audioIdStart = 105011, audioIdMovie = 105012, audioIdEnd = 105013, buffId_shield = 105004}
bs_105003.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnBreakShield, "bs_105003_1", 1, self.OnBreakShield)
end

bs_105003.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_1 , upvalues : _ENV
  if shieldType == 0 and target:GetBuffTier((self.config).buffId_shield) > 0 then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_shield, 0)
  end
end

bs_105003.PlaySkill = function(self, data, selectTargetCoord, selectRoles, selectRolesType)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait(30)
  self:GetSelectTargetAndExecute(selectRoles, BindCallback(self, self.CallSelectExecute), selectRolesType)
end

bs_105003.CallSelectExecute = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end)
  if role == self.caster and not ((self.caster).recordTable)["105001_summoner_alive"] and ((self.caster).recordTable).ult_tip == true then
    LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.PuzzleSummonerTimerAcc, -1)
    LuaSkillCtrl:StartTimer(nil, 2, function()
    -- function num : 0_3_0 , upvalues : self, _ENV
    local role_ex = self.caster
    if ((self.caster).recordTable)["105001_summoner_alive"] then
      role_ex = ((self.caster).recordTable)["105001_summoner"]
    end
    do
      if role_ex == self.caster then
        local shieldValue = LuaSkillCtrl:CallFormulaNumberWithSkill((self.config).shieldFormula, self.caster, nil, self)
        if shieldValue > 0 then
          LuaSkillCtrl:AddRoleShield(role_ex, eShieldType.Normal, shieldValue)
          self:shieldBuff(role_ex)
        end
      end
      LuaSkillCtrl:CallEffect(role_ex, (self.config).effectId1, self)
      local grid_ex = LuaSkillCtrl:GetGridWithRole(role_ex)
      local roles_ex = LuaSkillCtrl:FindRolesAroundGrid(grid_ex, LuaSkillCtrl:GetRelationBelong((self.caster).belongNum, eBattleRoleBelong.enemy))
      if roles_ex == nil or roles_ex.Count <= 0 then
        return 
      end
      for i = 0, roles_ex.Count - 1 do
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, roles_ex[i])
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[3]})
        skillResult:EndResult()
        LuaSkillCtrl:CallEffect(roles_ex[i], (self.config).effectId3, self)
        LuaSkillCtrl:CallBuff(self, roles_ex[i], (self.config).buff_hitfly, 1, (self.arglist)[4])
      end
    end
  end
)
    return 
  end
  if role ~= nil then
    local shieldValue = LuaSkillCtrl:CallFormulaNumberWithSkill((self.config).shieldFormula, self.caster, nil, self)
    if shieldValue > 0 then
      LuaSkillCtrl:AddRoleShield(role, eShieldType.Normal, shieldValue)
      self:shieldBuff(role)
    end
    LuaSkillCtrl:CallEffect(role, (self.config).effectId1, self)
    local grid = LuaSkillCtrl:GetGridWithRole(role)
    local roles = LuaSkillCtrl:FindRolesAroundGrid(grid, LuaSkillCtrl:GetRelationBelong((self.caster).belongNum, eBattleRoleBelong.enemy))
    if roles == nil or roles.Count <= 0 then
      return 
    end
    for i = 0, roles.Count - 1 do
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, roles[i])
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[3]})
      skillResult:EndResult()
      LuaSkillCtrl:CallEffect(roles[i], (self.config).effectId3, self)
      LuaSkillCtrl:CallBuff(self, roles[i], (self.config).buff_hitfly, 1, (self.arglist)[4])
    end
  end
end

bs_105003.shieldBuff = function(self, role)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:StartTimer(self, 1, function()
    -- function num : 0_4_0 , upvalues : _ENV, role, self
    local shield_num = LuaSkillCtrl:GetShield(role, eShieldType.Normal)
    if shield_num > 0 then
      LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_shield, 1, nil)
    end
  end
)
end

bs_105003.PlayUltEffect = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_5 , upvalues : base, _ENV
  if not self:Check(selectRoles) then
    return true
  end
  ;
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Super, 1, 15, true)
  if selectRoles ~= nil and selectRoles.Count > 0 then
    self.target = selectRoles[0]
  end
  if self.target ~= nil then
    (self.caster):LookAtInstantly(self.target)
  end
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_105003.Check = function(self, selectRoles)
  -- function num : 0_6
  if selectRoles == nil or selectRoles.Count <= 0 then
    return false
  end
  return self:CheckManualSkillTakeAvailable(selectRoles[0])
end

bs_105003.OnUltRoleAction = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_start)
end

bs_105003.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_105003.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  self.target = nil
  ;
  (base.LuaDispose)(self)
end

return bs_105003

