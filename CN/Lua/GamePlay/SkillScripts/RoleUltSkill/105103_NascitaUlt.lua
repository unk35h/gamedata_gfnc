-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105103 = class("bs_105103", LuaSkillBase)
local base = LuaSkillBase
bs_105103.config = {actionId_end = 1009, end_time = 30, buffId_ult = 1051031, audioIdStart = 105110, audioIdMovie = 105111, audioIdEnd = 105112}
bs_105103.ctor = function(self)
  -- function num : 0_0
end

bs_105103.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).ultSkill = (self.arglist)[4]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).ultPassive = (self.arglist)[3]
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).ult_skill = false
end

bs_105103.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_ult, 1, (self.arglist)[1])
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.caster).recordTable).ult_skill = true
end

bs_105103.OnUltRoleAction = function(self)
  -- function num : 0_3 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_105103.PlayUltEffect = function(self)
  -- function num : 0_4 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_105103.OnSkipUltView = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_105103.OnMovieFadeOut = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_105103.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_105103.LuaDispose = function(self)
  -- function num : 0_8 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_105103

