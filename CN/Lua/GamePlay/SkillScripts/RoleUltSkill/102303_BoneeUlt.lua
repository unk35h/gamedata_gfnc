-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_102303 = class("bs_102303", LuaSkillBase)
local base = LuaSkillBase
bs_102303.config = {effect_start = 102309, effect_loop = 102310, shieldFormula = 3021, 
aoe_config = {effect_shape = 1, aoe_select_code = 2, aoe_range = 10}
, movieEndRoleActionId = 1006}
bs_102303.ctor = function(self)
  -- function num : 0_0
end

bs_102303.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnBreakShield, "bs_102303_1", 99, self.OnBreakShield)
  self.hudunEffect = {}
end

bs_102303.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait(20)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_start, self, self.SkillEventFunc, nil)
end

bs_102303.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local SelfShieldValue = LuaSkillCtrl:GetShield(self.caster, 0) * (self.arglist)[1] // 1000
    LuaSkillCtrl:ClearShield(self.caster, 0)
    self.PlayerTargetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
    local shieldValue = SelfShieldValue + (self.caster).maxHp * (self.arglist)[2] // 1000
    for i = 0, (self.PlayerTargetList).Count - 1 do
      local role = (self.PlayerTargetList)[i]
      local IfRoleCotainsUnselectedBuff = LuaSkillCtrl:RoleContainsBuffFeature(role, 5)
      if role ~= self.caster and IfRoleCotainsUnselectedBuff == false and (role.recordTable).WillowPic ~= true then
        LuaSkillCtrl:AddRoleShield(role, eShieldType.Normal, shieldValue)
        -- DECOMPILER ERROR at PC72: Confused about usage of register: R12 in 'UnsetPending'

        if (self.hudunEffect)[role] == nil then
          (self.hudunEffect)[role] = LuaSkillCtrl:CallEffect(role, (self.config).effect_loop, self)
        end
      end
    end
  end
end

bs_102303.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_4
  if shieldType == 0 then
    self:Onover(target)
  end
end

bs_102303.Onover = function(self, target)
  -- function num : 0_5
  if (self.hudunEffect)[target] ~= nil then
    local effect = (self.hudunEffect)[target]
    effect:Die()
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.hudunEffect)[target] = nil
  end
end

bs_102303.PlayUltEffect = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_102303.OnUltRoleAction = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie, self)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005)
end

bs_102303.OnSkipUltView = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_102303.OnMovieFadeOut = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_102303.OnCasterDie = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_102303.LuaDispose = function(self)
  -- function num : 0_11 , upvalues : base
  (base.LuaDispose)(self)
  self.hudunEffect = nil
end

return bs_102303

