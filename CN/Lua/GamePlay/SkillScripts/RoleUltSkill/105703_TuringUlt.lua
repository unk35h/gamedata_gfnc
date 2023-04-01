-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105703 = class("bs_105703", LuaSkillBase)
local base = LuaSkillBase
bs_105703.config = {buffId_skill_intensity_Shield = 105704, buffId_pow_Shield = 105703, effectId = 105712, audioIdStart = 105709, audioIdMovie = 105710, audioIdEnd = 105711}
bs_105703.ctor = function(self)
  -- function num : 0_0
end

bs_105703.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105703.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  self:CallCasterWait(20)
  self:GetSelectTargetAndExecute(selectRoles, BindCallback(self, self.CallSelectExecute))
end

bs_105703.CallSelectExecute = function(self, role)
  -- function num : 0_3
  if role ~= nil and role.belongNum ~= (self.caster).belongNum and not role:IsUnSelect(self.caster) then
    self:RealPlaySkill(role)
  end
end

bs_105703.RealPlaySkill = function(self, target)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self, nil)
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  if targetList.Count > 0 then
    if target.pow < target.skill_intensity then
      for i = 0, targetList.Count - 1 do
        if ((targetList[i]).recordTable).WillowPic ~= true then
          LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffId_skill_intensity_Shield, 1, (self.arglist)[1])
          local shieldValue = (self.caster).skill_intensity * (self.arglist)[2] // 1000
          if shieldValue > 0 then
            LuaSkillCtrl:AddRoleShield(targetList[i], eShieldType.Normal, shieldValue)
          end
        end
      end
    else
      do
        for i = 0, targetList.Count - 1 do
          if ((targetList[i]).recordTable).WillowPic ~= true then
            LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffId_pow_Shield, 1, (self.arglist)[1])
            local shieldValue = (self.caster).skill_intensity * (self.arglist)[2] // 1000
            if shieldValue > 0 then
              LuaSkillCtrl:AddRoleShield(targetList[i], eShieldType.Normal, shieldValue)
            end
          end
        end
      end
    end
  end
end

bs_105703.OnUltRoleAction = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 0.8)
end

bs_105703.PlayUltEffect = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_105703.OnSkipUltView = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_105703.OnMovieFadeOut = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_105703.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_105703.LuaDispose = function(self)
  -- function num : 0_10 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_105703

