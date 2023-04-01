-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104703 = class("bs_104703", LuaSkillBase)
local base = LuaSkillBase
bs_104703.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 3000, def_formula = 9996, minhurt_formula = 9994, crit_formula = 0, crithur_ratio = 9995, correct_formula = 9989, lifesteal_formula = 1001, spell_lifesteal_formula = 1002, returndamage_formula = 1000, hurt_type = -1}
, buffId_Speed = 104702, effectId_UltID = 104705, effectId_hit = 104706, movieEndRoleActionId = 1006, selectId = 6, selectRange = 10, audioIdStart = 104707, audioIdMovie = 104708, audioIdEnd = 104709, audioId_Hit = 101211}
bs_104703.ctor = function(self)
  -- function num : 0_0
end

bs_104703.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
end

bs_104703.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait(8)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  if selectTargetCoord ~= nil then
    local inputTarget = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
    ;
    (self.caster):LookAtTarget(inputTarget)
    LuaSkillCtrl:StartTimer(nil, 3, (BindCallback(self, self.zhongzhuan, selectRoles, inputTarget)), nil, 0)
  end
end

bs_104703.zhongzhuan = function(self, selectRoles, inputTarget)
  -- function num : 0_3 , upvalues : _ENV
  (self.caster):LookAtTarget(inputTarget)
  self:CallSkillExecute(selectRoles)
  LuaSkillCtrl:CallEffect(inputTarget, (self.config).effectId_UltID, self, self.SkillEventFunc)
end

bs_104703.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Die then
    local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId, (self.config).selectRange)
    if targetList ~= 0 then
      for i = 0, targetList.Count - 1 do
        LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId_Speed, 1, (self.arglist)[4], false)
      end
    end
  end
end

bs_104703.CallSkillExecute = function(self, selectRoles)
  -- function num : 0_5 , upvalues : _ENV
  self:GetSelectTargetAndExecute(selectRoles, BindCallback(self, self.CallSelectExecute))
end

bs_104703.CallSelectExecute = function(self, role)
  -- function num : 0_6 , upvalues : _ENV
  if role == nil or role.hp <= 0 then
    return 
  end
  if role.belongNum ~= (self.caster).belongNum then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {(self.arglist)[1]}, false)
    LuaSkillCtrl:CallEffect(role, (self.config).effectId_hit, self)
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_Hit)
    skillResult:EndResult()
  end
end

bs_104703.PlayUltEffect = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_104703.OnUltRoleAction = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_104703.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

bs_104703.LuaDispose = function(self)
  -- function num : 0_10 , upvalues : base
  (base.LuaDispose)(self)
  self.timer = nil
end

return bs_104703

