-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_301502 = class("bs_301502", LuaSkillBase)
local base = LuaSkillBase
bs_301502.config = {select_id = 5, select_range = 1, buffStatue = 110013, buffSleep = 110032, buffWake = 110015, buffBati = 198, ExecuteInterval = 75, timeOffset = 15, effectId_Aoe = 12036, effectId_up = 12037, effectId_hit = 12039, 
hurt_config = {hit_formula = 0, basehurt_formula = 10077, crit_formula = 0}
, start_time = 13, actionId_wake = 1045, action_speed = 1, actionId_sleep = 1046, audioId = 4003501}
bs_301502.ctor = function(self)
  -- function num : 0_0
end

bs_301502.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.stateHalo = nil
  self.effectHaloSleep = nil
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_wake)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId)
  self.curAccFrame = 0
  self.Timer = LuaSkillCtrl:StartTimer(self, 1, BindCallback(self, self.OnCheckState), self, -1, 0)
  if self.stateHalo ~= nil then
    (self.stateHalo):Die()
    self.stateHalo = nil
  end
  local collisionStay = BindCallback(self, self.OnCollisionStay)
  local collisionExit = BindCallback(self, self.OnCollisionExit)
  self.stateHalo = LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, self.caster, 100, 0, 14, nil, collisionStay, collisionExit, nil, false, false, nil, self.caster)
  self.effectHaloSleep = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_Aoe, self)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffBati, 1, nil)
end

bs_301502.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_wake)
  self.curAccFrame = 0
  self.Timer = LuaSkillCtrl:StartTimer(self, 1, BindCallback(self, self.OnCheckState), self, -1, 0)
  if self.stateHalo ~= nil then
    (self.stateHalo):Die()
    self.stateHalo = nil
  end
  local collisionStay = BindCallback(self, self.OnCollisionStay)
  local collisionExit = BindCallback(self, self.OnCollisionExit)
  self.stateHalo = LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, self.caster, 100, 0, 14, nil, collisionStay, collisionExit, nil, false, false, nil, self.caster)
  self.effectHaloSleep = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_Aoe, self)
end

bs_301502.OnCollisionStay = function(self, Collider, role)
  -- function num : 0_3 , upvalues : _ENV
  if role.belongNum ~= (self.caster).belongNum and role.roleType == 1 and role:GetBuffTier((self.config).buffWake) <= 0 then
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffWake, 1)
  end
  if role.belongNum == (self.caster).belongNum and role.roleType == 1 and role.roleDataId ~= 40035 and role.roleDataId ~= 20057 and role:GetBuffTier((self.config).buffSleep) <= 0 then
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffSleep, 1)
  end
end

bs_301502.OnCollisionExit = function(self, collider, role)
  -- function num : 0_4 , upvalues : _ENV
  if role:GetBuffTier((self.config).buffWake) >= 1 then
    LuaSkillCtrl:DispelBuff(role, (self.config).buffWake, 0, true)
  end
  if role:GetBuffTier((self.config).buffSleep) >= 1 then
    LuaSkillCtrl:DispelBuff(role, (self.config).buffSleep, 0, true)
  end
end

bs_301502.OnCheckState = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if (self.arglist)[1] <= self.curAccFrame then
    self.curAccFrame = 0
    local targetlist = LuaSkillCtrl:CallTargetSelectWithRange(self, 5, 1)
    if targetlist.Count > 0 then
      for i = 0, targetlist.Count - 1 do
        local targetRole = (targetlist[i]).targetRole
        do
          if targetRole.belongNum ~= (self.caster).belongNum then
            local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
            LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config)
            skillResult:EndResult()
            LuaSkillCtrl:CallEffect(targetRole, (self.config).effectId_hit, self)
          end
          if targetRole.belongNum == (self.caster).belongNum and targetRole.roleType == 1 and targetRole.roleDataId ~= 20057 then
            local skills = targetRole:GetBattleSkillList()
            if skills ~= nil then
              local count = skills.Count
              if count > 0 then
                for j = 0, count - 1 do
                  if not (skills[j]).isCommonAttack then
                    local curCd = (skills[j]).totalCDTime * (self.arglist)[3] // 1000
                    LuaSkillCtrl:CallResetCDForSingleSkill(skills[j], curCd)
                  end
                end
              end
            end
          end
          do
            -- DECOMPILER ERROR at PC86: LeaveBlock: unexpected jumping out DO_STMT

          end
        end
      end
    end
  end
  do
    self.curAccFrame = self.curAccFrame + 1
  end
end

bs_301502.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
  if self.effectHaloSleep ~= nil then
    (self.effectHaloSleep):Die()
    self.effectHaloSleep = nil
  end
  if self.stateHalo ~= nil then
    (self.stateHalo):EndAndDisposeEmission()
    self.effectHaloSleep = nil
  end
  if self.Timer then
    (self.Timer):Stop()
    self.Timer = nil
  end
end

return bs_301502

