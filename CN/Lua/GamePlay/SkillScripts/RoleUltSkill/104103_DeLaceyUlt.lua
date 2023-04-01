-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104103 = class("bs_104103", LuaSkillBase)
local base = LuaSkillBase
bs_104103.config = {effectId_start = 104111, effectId_hd = 104112, effectId_sj = 104113, 
hurt_config = {hit_formula = 0, basehurt_formula = 10078, crit_formula = 0, returndamage_formula = 0}
, 
aoe_Enemy = {effect_shape = 2, aoe_select_code = 4, aoe_range = 10}
, audioIdStart = 104106, audioIdMovie = 104107}
bs_104103.ctor = function(self)
  -- function num : 0_0
end

bs_104103.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnAfterShieldHurt, "bs_104103_1", 1, self.OnAfterShieldHurt)
  self.MapBorder = LuaSkillCtrl:GetMapBorder()
end

bs_104103.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait(20)
  local SkillNum = (self.arglist)[1] // 10 - 1
  LuaSkillCtrl:StartTimer(nil, (self.arglist)[2], (BindCallback(self, self.PlayUltSkill)), nil, SkillNum, (self.arglist)[2])
end

bs_104103.OnAfterShieldHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  if (context.target).hp <= 0 or context.shield_type ~= eShieldType.Normal then
    return 
  end
  if ((context.target).recordTable)["10413_shield"] ~= nil and ((context.target).recordTable)["10413_shield"] > 0 then
    local tempValue = ((context.target).recordTable)["10413_shield"]
    tempValue = (math.max)(0, tempValue - context.shield_cost_hurt)
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((context.target).recordTable)["10413_shield"] = tempValue
  end
end

bs_104103.PlayUltSkill = function(self, data)
  -- function num : 0_4 , upvalues : _ENV
  local effectGrid = nil
  effectGrid = LuaSkillCtrl:GetTargetWithGrid(3, 2)
  if (self.MapBorder).x > 7 then
    effectGrid = LuaSkillCtrl:GetTargetWithGrid(5, 3)
  end
  LuaSkillCtrl:CallEffect(effectGrid, (self.config).effectId_start, self)
  local Enemy = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
  local Ally = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  for i = 0, Enemy.Count - 1 do
    LuaSkillCtrl:CallEffect((Enemy[i]).targetRole, (self.config).effectId_sj, self)
  end
  local skillResultEnemy = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster, (self.config).aoe_Enemy)
  local hurtConfig = (self.config).hurt_config
  LuaSkillCtrl:HurtResult(self, skillResultEnemy, hurtConfig)
  skillResultEnemy:EndResult()
  local shieldValue = (self.caster).skill_intensity * (self.arglist)[4] // 1000
  for i = 0, Ally.Count - 1 do
    local targetRole = (Ally[i]).targetRole
    if (targetRole.recordTable).WillowPic == true then
      return 
    end
    local shieldValue_104103 = (targetRole.recordTable)["10413_shield"]
    if shieldValue_104103 == nil or shieldValue_104103 == 0 and targetRole.hp > 0 then
      LuaSkillCtrl:AddRoleShield(targetRole, eShieldType.Normal, shieldValue)
      -- DECOMPILER ERROR at PC102: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (targetRole.recordTable)["10413_shield"] = shieldValue
      LuaSkillCtrl:CallEffect(targetRole, (self.config).effectId_hd, self)
    end
    if shieldValue_104103 ~= nil and shieldValue_104103 > 0 and shieldValue_104103 < shieldValue and targetRole.hp > 0 then
      LuaSkillCtrl:AddRoleShield(targetRole, eShieldType.Normal, shieldValue - shieldValue_104103)
      -- DECOMPILER ERROR at PC127: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (targetRole.recordTable)["10413_shield"] = shieldValue
      LuaSkillCtrl:CallEffect(targetRole, (self.config).effectId_hd, self)
    end
  end
end

bs_104103.PlayUltEffect = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_104103.OnUltRoleAction = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_104103.OnSkipUltView = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_104103.OnMovieFadeOut = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_104103.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_104103.LuaDispose = function(self)
  -- function num : 0_10 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_104103

