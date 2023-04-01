-- params : ...
-- function num : 0 , upvalues : _ENV
local BattleCustomMoveCtrl = class("BattleCustomMoveCtrl")
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
BattleCustomMoveCtrl.ctor = function(self)
  -- function num : 0_0
end

BattleCustomMoveCtrl.CreateCustomMoveCtrl = function(bdCtrl)
  -- function num : 0_1 , upvalues : BattleCustomMoveCtrl
  local ctrl = (BattleCustomMoveCtrl.New)()
  ctrl:InitCustomMoveCtrl(bdCtrl)
  return ctrl
end

BattleCustomMoveCtrl.InitCustomMoveCtrl = function(self, bdCtrl)
  -- function num : 0_2 , upvalues : _ENV, eDynConfigData
  ConfigData:LoadDynCfg(eDynConfigData.brotato_role_amend)
  ConfigData:LoadDynCfg(eDynConfigData.brotato_monster_team)
end

BattleCustomMoveCtrl.BeginCustomControl = function(self, battleCtrl)
  -- function num : 0_3 , upvalues : _ENV
  battleCtrl:ShowCustomMoveInputUI()
  local roles = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  self.moveEnity = roles[0]
  self:AmendEntityProperty()
  self:ActiveEntityCustomComponent()
  battleCtrl:ChangeCmaeraSmoothFollw(true)
end

BattleCustomMoveCtrl.AmendEntityProperty = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.moveEnity == nil then
    return 
  end
  local roleAmendConfig = (ConfigData.brotato_role_amend)[(self.moveEnity).roleDataId]
  if roleAmendConfig == nil then
    return 
  end
  local moveSpeedFactor = roleAmendConfig.move_speed_factor * 0.01
  do
    if moveSpeedFactor ~= 1 then
      local moveSpeed = (self.moveEnity).moveSpeed
      ;
      (self.moveEnity):AddRoleProperty(eHeroAttr.moveSpeed, moveSpeed * (moveSpeedFactor - 1), eHeroAttrType.Origin)
    end
    local attackSpeedFactor = roleAmendConfig.attack_speed_factor * 0.01
    do
      if attackSpeedFactor ~= 1 then
        local attackSpeed = (self.moveEnity).speed
        ;
        (self.moveEnity):AddRoleProperty(eHeroAttr.speed, attackSpeed * (attackSpeedFactor - 1), eHeroAttrType.Origin)
      end
      local attackRangeFactor = roleAmendConfig.attack_range_factor * 0.01
      do
        if attackRangeFactor ~= 1 then
          local attackRange = (self.moveEnity).attackRange
          ;
          (self.moveEnity):AddRoleProperty(eHeroAttr.attackRange, attackRange * (attackRangeFactor - 1), eHeroAttrType.Origin)
        end
        local attackRangeFactor = roleAmendConfig.skill_range_factor * 0.01
        if attackRangeFactor ~= 1 then
          local skills = (self.moveEnity):GetBattleSkillList()
          if skills ~= nil then
            local skillCount = skills.Count
            if skillCount > 0 then
              for j = 0, skillCount - 1 do
                local csSkill = skills[j]
                if not csSkill.isCommonAttack then
                  local skillRange = csSkill.SkillRange
                  csSkill.SkillRange = attackRangeFactor * skillRange
                end
              end
            end
          end
        end
      end
    end
  end
end

BattleCustomMoveCtrl.EndCustomControl = function(self, battleCtrl)
  -- function num : 0_5
  battleCtrl:HideCutomMoveInputUI()
  battleCtrl:ChangeCmaeraSmoothFollw(false)
end

BattleCustomMoveCtrl.ActiveEntityCustomComponent = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if IsNull(self.moveEnity) then
    return 
  end
  ;
  (self.moveEnity):ActiveCustomMoveComponent()
end

BattleCustomMoveCtrl.DisactiveEntityCustomComponent = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if IsNull(self.moveEnity) then
    return 
  end
  ;
  (self.moveEnity):DisactiveCustomMoveComponent()
end

BattleCustomMoveCtrl.OnDelete = function(self)
  -- function num : 0_8 , upvalues : _ENV, eDynConfigData
  self.__inputWindow = nil
  ConfigData:ForceReleaseDynCfg(eDynConfigData.brotato_role_amend)
  ConfigData:ForceReleaseDynCfg(eDynConfigData.brotato_monster_team)
end

return BattleCustomMoveCtrl

