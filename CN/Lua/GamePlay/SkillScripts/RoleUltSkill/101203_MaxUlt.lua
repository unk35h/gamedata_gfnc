-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101203 = class("bs_101203", LuaSkillBase)
local base = LuaSkillBase
bs_101203.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 3026, def_formula = 9996, minhurt_formula = 9994, crit_formula = 0, crithur_ratio = 9995, correct_formula = 9989, lifesteal_formula = 1001, spell_lifesteal_formula = 1002, returndamage_formula = 1000, hurt_type = 2}
, buffId_66 = 66, buffId1 = 101201, effectId_UltID = 101212, effectId_Hurt = 101213, effect_hit = 101214, movieEndRoleActionId = 1006, audioIdStart = 101207, audioIdMovie = 101208, audioIdEnd = 101209, audioId_Hit = 101211}
bs_101203.ctor = function(self)
  -- function num : 0_0
end

bs_101203.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
end

bs_101203.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait(8)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  if selectTargetCoord ~= nil then
    local inputTarget = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
    do
      (self.caster):LookAtTarget(inputTarget)
      LuaSkillCtrl:StartTimer(nil, 3, (BindCallback(self, self.zhongzhuan, selectRoles, inputTarget)), nil, 0)
      LuaSkillCtrl:StartTimer(self, 7, function()
    -- function num : 0_2_0 , upvalues : _ENV, inputTarget, self
    LuaSkillCtrl:CallEffect(inputTarget, (self.config).effectId_Hurt, self)
  end
)
    end
  end
end

bs_101203.zhongzhuan = function(self, selectRoles, inputTarget)
  -- function num : 0_3 , upvalues : _ENV
  (self.caster):LookAtTarget(inputTarget)
  self:CallSkillExecute(selectRoles)
  LuaSkillCtrl:CallEffect(inputTarget, (self.config).effectId_UltID, self)
end

bs_101203.CallSkillExecute = function(self, selectRoles)
  -- function num : 0_4 , upvalues : _ENV
  self:GetSelectTargetAndExecute(selectRoles, BindCallback(self, self.CallSelectExecute))
end

bs_101203.CallSelectExecute = function(self, role)
  -- function num : 0_5 , upvalues : _ENV
  if role == nil or role.hp <= 0 then
    return 
  end
  if role.belongNum ~= (self.caster).belongNum then
    local times = (self.arglist)[3] // 15 - 1
    self.timer = LuaSkillCtrl:StartTimer(nil, 15, function()
    -- function num : 0_5_0 , upvalues : role, self, _ENV
    if role == nil or role.hp <= 0 then
      if self.timer ~= nil then
        (self.timer):Stop()
        self.timer = nil
      end
      return 
    end
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {(self.arglist)[1]}, false)
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_Hit)
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffId1, 1, (self.arglist)[3])
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_66, 1, (self.arglist)[2])
    skillResult:EndResult()
  end
, self, times, 12)
  end
end

bs_101203.PlayUltEffect = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_101203.OnUltRoleAction = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_101203.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

bs_101203.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  (base.LuaDispose)(self)
  self.timer = nil
end

return bs_101203

