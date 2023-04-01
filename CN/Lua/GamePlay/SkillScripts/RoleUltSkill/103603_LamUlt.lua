-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_103603 = class("bs_103603", LuaSkillBase)
local base = LuaSkillBase
bs_103603.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 3024}
, effectId_startEffect = 10311, effectId_mainEffect = 10312, audioIdStart = 114, audioIdMovie = 115, audioIdEnd = 116, movieEndRoleActionId = 1006}
bs_103603.ctor = function(self)
  -- function num : 0_0
end

bs_103603.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
  self.hurt_config = {}
end

bs_103603.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait(13)
  if selectTargetCoord ~= nil then
    local inputTarget = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
    do
      (self.caster):LookAtTarget(inputTarget)
      LuaSkillCtrl:CallRoleAction(self.caster, 1010)
      LuaSkillCtrl:StartTimer(self, 3, function()
    -- function num : 0_2_0 , upvalues : _ENV, self, inputTarget, selectRoles
    LuaSkillCtrl:CallRoleAction(self.caster, 1006)
    LuaSkillCtrl:CallEffect(inputTarget, (self.config).effectId_mainEffect, self)
    self:GetSelectTargetAndExecute(selectRoles, BindCallback(self, self.CallSelectExecute))
  end
)
      -- DECOMPILER ERROR at PC31: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.caster).recordTable).lastAttackRole = nil
    end
  end
end

bs_103603.CallSelectExecute = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  if role ~= nil and role.belongNum ~= (self.caster).belongNum and not role:IsUnSelect(self.caster) then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {(self.arglist)[1]})
    skillResult:EndResult()
  end
end

bs_103603.PlayUltEffect = function(self)
  -- function num : 0_4 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_103603.OnUltRoleAction = function(self)
  -- function num : 0_5 , upvalues : _ENV, base
  LuaSkillCtrl:StartTimerInUlt(self, 11, self.PlayUltMovie)
  ;
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005)
end

bs_103603.OnSkipUltView = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_103603.OnMovieFadeOut = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_103603.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_103603.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_103603

