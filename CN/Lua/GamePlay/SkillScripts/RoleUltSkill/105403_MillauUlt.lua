-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105403 = class("bs_105403", LuaSkillBase)
local base = LuaSkillBase
bs_105403.config = {buffId_tasterMark = 105406, buffId_ultAttackUp = 105405, buffId_ultHemUp = 105407, buffId_shield = 105412, buffId_ultAttackUp2 = 105409, buffId_ultHemUp2 = 105410, effectId_Ult = 105408, buffId_100802 = 100802, buffId_Super = 3003, audioIdStart = 105412, audioIdMovie = 105413, audioIdEnd = 105414, movieEndRoleActionId = 1006, 
aoe_config = {effect_shape = 1, aoe_select_code = 3, aoe_range = 10}
, 
heal_config = {baseheal_formula = 100801, heal_number = 0, crit_formula = 0, crithur_ratio = 0, correct_formula = 9990}
, 
heal_configF = {baseheal_formula = 100802, heal_number = 0, crit_formula = 0, crithur_ratio = 0, correct_formula = 9990}
}
bs_105403.ctor = function(self)
  -- function num : 0_0
end

bs_105403.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self.hurt_config = {}
  self.MapBorder = LuaSkillCtrl:GetMapBorder()
  self:AddTrigger(eSkillTriggerType.OnBreakShield, "bs_105403_1", 1, self.OnBreakShield)
end

bs_105403.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_2 , upvalues : _ENV
  if shieldType == 0 and target:GetBuffTier((self.config).buffId_shield) > 0 then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_shield, 0)
  end
end

bs_105403.PlaySkill = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait(20)
  local effectGrid = LuaSkillCtrl:GetTargetWithGrid(3, 2)
  effectGrid = LuaSkillCtrl:GetTargetWithGrid(3, 2)
  if (self.MapBorder).x > 7 then
    effectGrid = LuaSkillCtrl:GetTargetWithGrid(5, 3)
  end
  LuaSkillCtrl:CallEffect(effectGrid, (self.config).effectId_Ult, self, self.SkillEventFunc, nil, 0.5)
  LuaSkillCtrl:CallBattleCamShake()
end

bs_105403.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    self.PlayerTargetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
    for i = 0, (self.PlayerTargetList).Count - 1 do
      local role = (self.PlayerTargetList)[i]
      local IfRoleCotainsUnselectedBuff = LuaSkillCtrl:RoleContainsBuffFeature(role, eBuffFeatureType.NotBeSelected)
      if IfRoleCotainsUnselectedBuff == false and (role.recordTable).WillowPic ~= true then
        local buff1 = LuaSkillCtrl:GetRoleBuffById(role, (self.config).buffId_tasterMark)
        if buff1 ~= nil then
          local shieldValue1 = (self.caster).def * (self.arglist)[1] // 1000 * 2
          if shieldValue1 > 0 then
            LuaSkillCtrl:AddRoleShield(role, eShieldType.Normal, shieldValue1)
            local SelfShieldValue = LuaSkillCtrl:GetShield(role, 0)
            if SelfShieldValue ~= 0 then
              LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_shield, 1)
            end
          end
          do
            do
              LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_ultAttackUp2, 2, (self.arglist)[4])
              LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_ultHemUp2, 2, (self.arglist)[4])
              local shieldValue2 = (self.caster).def * (self.arglist)[1] // 1000
              if shieldValue2 > 0 then
                LuaSkillCtrl:AddRoleShield(role, eShieldType.Normal, shieldValue2)
                local SelfShieldValue = LuaSkillCtrl:GetShield(role, 0)
                if SelfShieldValue ~= 0 then
                  LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_shield, 1)
                end
              end
              do
                do
                  LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_ultAttackUp, 1, (self.arglist)[4])
                  LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_ultHemUp, 1, (self.arglist)[4])
                  -- DECOMPILER ERROR at PC140: LeaveBlock: unexpected jumping out DO_STMT

                  -- DECOMPILER ERROR at PC140: LeaveBlock: unexpected jumping out DO_STMT

                  -- DECOMPILER ERROR at PC140: LeaveBlock: unexpected jumping out DO_STMT

                  -- DECOMPILER ERROR at PC140: LeaveBlock: unexpected jumping out IF_THEN_STMT

                  -- DECOMPILER ERROR at PC140: LeaveBlock: unexpected jumping out IF_STMT

                  -- DECOMPILER ERROR at PC140: LeaveBlock: unexpected jumping out IF_THEN_STMT

                  -- DECOMPILER ERROR at PC140: LeaveBlock: unexpected jumping out IF_STMT

                end
              end
            end
          end
        end
      end
    end
  end
end

bs_105403.PlayUltEffect = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Super, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_105403.OnUltRoleAction = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie, self)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005)
end

bs_105403.OnSkipUltView = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_105403.OnMovieFadeOut = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_105403.OnCasterDie = function(self)
  -- function num : 0_9
  self:KillEquipmentSummoner()
  self:RemoveAllTimers()
  self:RemoveAllBreakKillEffects()
  self:RemoveAllLuaTrigger()
  self:RemoveAllHaleEmission()
end

return bs_105403

