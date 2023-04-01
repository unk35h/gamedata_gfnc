-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21020 = class("bs_21020", LuaSkillBase)
local base = LuaSkillBase
bs_21020.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10077, crit_formula = 0}
, buffId = 65, effectId = 10946}
bs_21020.ctor = function(self)
  -- function num : 0_0
end

bs_21020.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21020_1", 1, self.OnAfterBattleStart)
  self.hurtTimer = nil
end

bs_21020.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.hurtTime ~= nil then
    (self.hurtTime):Stop()
    self.hurtTime = nil
  end
  local callback = BindCallback(self, self.FunSkill)
  self.hurtTime = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], callback, nil, -1, (self.arglist)[1])
end

bs_21020.FunSkill = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:FindAllRolesWithinRange(self.caster, 1, false)
  if targetlist.Count > 0 then
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
    for i = 0, targetlist.Count - 1 do
      local role = targetlist[i]
      if role.belongNum ~= eBattleRoleBelong.player then
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
        LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, nil, true)
        skillResult:EndResult()
        LuaSkillCtrl:CallBuff(self, role, (self.config).buffId, 1, 1)
      end
    end
  end
end

bs_21020.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.hurtTime ~= nil then
    (self.hurtTime):Stop()
    self.hurtTime = nil
  end
end

bs_21020.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  (base.LuaDispose)(self)
  if self.hurtTime ~= nil then
    (self.hurtTime):Stop()
    self.hurtTime = nil
  end
end

return bs_21020

