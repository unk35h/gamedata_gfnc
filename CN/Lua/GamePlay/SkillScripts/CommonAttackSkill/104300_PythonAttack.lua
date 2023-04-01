-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_104300 = class("bs_104300", bs_1)
local base = bs_1
bs_104300.config = {action1 = 1001, action2 = 1004, action3 = 1021, baseActionSpd = 1, skill_time = 46, start_time = 9, effectId_1 = 104301, effectId_2 = 104302, effectId_ex = 104304, effectId_exhit = 104317, buff_Strong = 104307, audioId1 = 104301, audioId2 = 104302, audioId_ex = 104303}
bs_104300.config = setmetatable(bs_104300.config, {__index = base.config})
bs_104300.ctor = function(self)
  -- function num : 0_0
end

bs_104300.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104300.RealPlaySkill = function(self, target, data)
  -- function num : 0_2 , upvalues : _ENV, base
  local buffs = LuaSkillCtrl:GetRoleBuffById(self.caster, (self.config).buff_Strong)
  if ((self.caster).recordTable).Aoe == true or buffs ~= nil then
    local atkSpeed = LuaSkillCtrl:CallFormulaNumber(9997, self.caster, self.caster)
    local atkSpeedRatio = 1
    local atkActionId = data.action3
    local atkTriggerFrame = 0
    atkSpeedRatio = self:CalcAtkActionSpeedForAirplane(atkSpeed, 1) * (self.config).baseActionSpd
    atkActionId = data.action3
    atkTriggerFrame = self:GetAtkTriggerFrameForAirplane(1, atkSpeed)
    local attackTrigger2 = BindCallback(self, self.OnAttackTrigger2, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
    self:CallCasterWait(atkSpeed + 2)
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.caster).recordTable).lastAttackRole = target
    LuaSkillCtrl:CallEffect(target, data.effectId_ex, self, nil, nil, atkSpeedRatio, true)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).action3, atkSpeedRatio, atkTriggerFrame, attackTrigger2)
    -- DECOMPILER ERROR at PC71: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.caster).recordTable).Aoe = false
  else
    do
      ;
      (base.RealPlaySkill)(self, target, data)
    end
  end
end

bs_104300.OnAttackTrigger2 = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  local TargetGrids = LuaSkillCtrl:CallFindGridsInDirSectorRange(self.caster, target)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_ex)
  if TargetGrids == nil or #TargetGrids <= 0 then
    return 
  end
  for i = 1, #TargetGrids do
    local RealTarget = LuaSkillCtrl:GetRoleWithPos((TargetGrids[i]).x, (TargetGrids[i]).y)
    if RealTarget ~= nil and RealTarget.hp > 0 and (RealTarget.belongNum == eBattleRoleBelong.neutral or LuaSkillCtrl:CheckReletionWithRoleBelong(RealTarget, self.caster, eBelongReletionType.Enemy)) then
      local IfRoleCotainsUnselectedBuff = LuaSkillCtrl:RoleContainsBuffFeature(RealTarget, 5)
      if IfRoleCotainsUnselectedBuff == false then
        LuaSkillCtrl:CallEffect(RealTarget, (self.config).effectId_exhit, self)
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, RealTarget)
        LuaSkillCtrl:HurtResult(self, skillResult)
        skillResult:EndResult()
      end
    end
  end
end

bs_104300.CalcAtkActionSpeedForAirplane = function(self, atkInterval, atkId)
  -- function num : 0_4
  local atkTotalFrames = (self.config).skill_time
  if atkInterval < atkTotalFrames then
    return atkTotalFrames / atkInterval
  else
    return 1
  end
end

bs_104300.GetAtkTriggerFrameForAirplane = function(self, atkId, atkInterval)
  -- function num : 0_5
  local atkTotalFrames = (self.config).skill_time
  local triggerFrameCfg = (self.config).start_time
  if atkInterval < atkTotalFrames then
    return triggerFrameCfg * atkInterval // atkTotalFrames
  else
    return triggerFrameCfg
  end
end

bs_104300.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104300

