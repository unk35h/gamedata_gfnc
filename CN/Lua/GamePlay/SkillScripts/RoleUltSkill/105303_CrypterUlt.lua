-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105303 = class("bs_105303", LuaSkillBase)
local base = LuaSkillBase
bs_105303.config = {effectId = 105315, effectId_end = 105317, buffId = 105302, HurtConfigID = 3, audioIdStart = 105309, audioIdMovie = 105316, audioIdEnd = 105306}
bs_105303.ctor = function(self)
  -- function num : 0_0
end

bs_105303.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).energy_Ult = (self.arglist)[4]
  self:AddBuffDieTrigger("bs_105303_buff_die", 1, self.OnBuffDie, nil, nil, (self.config).buffId)
end

bs_105303.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  self:CallCasterWait(20)
  self:GetSelectTargetAndExecute(selectRoles, BindCallback(self, self.CallSelectExecute))
end

bs_105303.CallSelectExecute = function(self, role)
  -- function num : 0_3
  if role ~= nil and role.belongNum ~= (self.caster).belongNum and not role:IsUnSelect(self.caster) then
    self:RealPlaySkill(role)
  end
end

bs_105303.RealPlaySkill = function(self, target)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  LuaSkillCtrl:CallBuffRepeated(self, target, (self.config).buffId, 1, (self.arglist)[1], false, self.OnBuffExecute)
end

bs_105303.OnBuffExecute = function(self, buff, targetRole)
  -- function num : 0_5 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {(self.arglist)[2] + ((self.caster).recordTable).energy_num * (self.arglist)[3]})
  skillResult:EndResult()
end

bs_105303.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_6 , upvalues : _ENV
  if buff.dataId == (self.config).buffId then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_end, self)
  end
end

bs_105303.OnUltRoleAction = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_105303.PlayUltEffect = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_105303.OnSkipUltView = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_105303.OnMovieFadeOut = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_105303.OnCasterDie = function(self)
  -- function num : 0_11 , upvalues : base
  self:CancleCasterWait()
  ;
  (base.OnCasterDie)(self)
end

bs_105303.LuaDispose = function(self)
  -- function num : 0_12 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_105303

