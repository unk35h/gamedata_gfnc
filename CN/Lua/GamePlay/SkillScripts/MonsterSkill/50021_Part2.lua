-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.MonsterSkill.50023_equipmentCommonSkill")
local bs_50021 = class("bs_50021", base)
bs_50021.config = {selectId_skill = 21, buffId_124 = 124, buffId_63 = 63, buffId_fly = 5002101, buffId_69 = 69, buffId_198 = 198, configId_Repel = 3, effectId_caster = 5002101, effectId_hit = 5002102, goSpeed = 2}
bs_50021.ctor = function(self)
  -- function num : 0_0
end

bs_50021.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_50021.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local caster = LuaSkillCtrl:GetEquipmentSummonerOrHostEntity(self.caster)
  self.skill = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], (BindCallback(self, self.OnCharge, caster)), nil, -1, (self.arglist)[1] - 1)
end

bs_50021.OnCharge = function(self, caster)
  -- function num : 0_3 , upvalues : _ENV, base
  local targetList = (LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId_skill, 10, caster))
  -- DECOMPILER ERROR at PC8: Overwrote pending register: R3 in 'AssignReg'

  local role = .end
  if targetList.Count > 0 then
    do
      for i = 0, targetList.Count - 1 do
        local target = (targetList[i]).targetRole
        if target.intensity ~= 0 and target.belongNum ~= eBattleRoleBelong.neutral then
          if not LuaSkillCtrl:RoleContainsBuffFeature(target, eBuffFeatureType.CtrlImmunity) then
            role = target
            break
          end
          if LuaSkillCtrl:RoleContainsBuffFeature(target, eBuffFeatureType.CtrlImmunity) then
            local gridList = LuaSkillCtrl:FindEmptyGridAroundRole(target)
            if gridList ~= nil then
              role = target
              break
            end
          end
        end
      end
    end
    do
      local grid_go, grid_up = nil, nil
      if role == nil then
        return 
      end
      if not LuaSkillCtrl:RoleContainsBuffFeature(role, eBuffFeatureType.CtrlImmunity) then
        local gridList = LuaSkillCtrl:FindEmptyGridsWithinRange(role.x, role.y, 5)
        if gridList == nil then
          return 
        end
        if gridList.Count > 0 then
          grid_go = LuaSkillCtrl:GetGridWithRole(role)
          grid_up = gridList[0]
        end
      else
        do
          do
            local gridList = LuaSkillCtrl:FindEmptyGridsWithinRange(role.x, role.y, 1)
            if gridList == nil then
              return 
            end
            if gridList.Count > 0 then
              grid_go = gridList[0]
            end
            if grid_go == nil then
              return 
            end
            LuaSkillCtrl:CallRoleAction(self.caster, 1008, 1)
            if grid_up ~= nil then
              LuaSkillCtrl:PreSetRolePos(grid_up, self.caster)
            else
              LuaSkillCtrl:PreSetRolePos(grid_go, self.caster)
            end
            local MoveTime = LuaSkillCtrl:GetGridsDistance(grid_go.x, grid_go.y, caster.x, caster.y) * (self.config).goSpeed
            LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_124, 1, 10 + MoveTime)
            LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_198, 1, 10 + MoveTime)
            LuaSkillCtrl:StartTimer(nil, 10, function()
    -- function num : 0_3_0 , upvalues : grid_up, _ENV, self, caster, grid_go, MoveTime, role, base
    if grid_up == nil then
      LuaSkillCtrl:CanclePreSetPos(self.caster)
    end
    if not LuaSkillCtrl:InInPhaseMove(caster) then
      local casterEffect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_caster, self)
      do
        caster:LookAtTarget(LuaSkillCtrl:GetTargetWithGrid(grid_go.x, grid_go.y))
        LuaSkillCtrl:CallPhaseMoveWithoutTurnAndAllowCcd(self, caster, grid_go.x, grid_go.y, MoveTime, (self.config).buffId_69)
        LuaSkillCtrl:StartTimer(nil, MoveTime, function()
      -- function num : 0_3_0_0 , upvalues : casterEffect, _ENV, self, role, grid_up, caster, grid_go, base
      if casterEffect ~= nil then
        casterEffect:Die()
        casterEffect = nil
      end
      LuaSkillCtrl:CallRoleAction(self.caster, 1009, 1)
      if role == nil or role.hp <= 0 then
        return 
      end
      if grid_up ~= nil then
        LuaSkillCtrl:CanclePreSetPos(self.caster)
        if not LuaSkillCtrl:InInPhaseMove(caster) and role.x == grid_go.x and role.y == grid_go.y then
          LuaSkillCtrl:CallPhaseMove(self, role, grid_up.x, grid_up.y, 3, (self.config).buffId_63)
          LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_fly, 1, 3, true)
          ;
          (base.OnSyncAttrFromHost)(self, caster)
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
          LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId_Repel, {(self.arglist)[2]}, true)
          skillResult:EndResult()
          LuaSkillCtrl:CallEffect(role, (self.config).effectId_hit, self)
        end
      else
        do
          ;
          (base.OnSyncAttrFromHost)(self, caster)
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
          LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId_Repel, {(self.arglist)[2]}, true)
          skillResult:EndResult()
          LuaSkillCtrl:CallEffect(role, (self.config).effectId_hit, self)
        end
      end
    end
)
      end
    end
  end
)
          end
        end
      end
    end
  end
end

bs_50021.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  LuaSkillCtrl:CanclePreSetPos(self.caster)
  if self.skill ~= nil then
    (self.skill):Stop()
    self.skill = nil
  end
end

return bs_50021

