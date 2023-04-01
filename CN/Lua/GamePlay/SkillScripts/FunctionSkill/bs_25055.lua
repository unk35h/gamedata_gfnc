-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25055 = class("bs_25055", LuaSkillBase)
local base = LuaSkillBase
bs_25055.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10187, crit_formula = 0}
}
bs_25055.ctor = function(self)
  -- function num : 0_0
end

bs_25055.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_25055_1", 1, self.OnAfterBattleStart)
end

bs_25055.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], arriveCallBack, self, -1)
end

bs_25055.OnArriveAction = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self:PlayChipEffect()
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 31, 10)
  if targetlist.Count < 1 then
    return 
  end
  local targetRole = (targetlist[0]).targetRole
  local hurt = targetRole.pow * (self.arglist)[2] // 1000
  local targetlistEnemy = LuaSkillCtrl:CallTargetSelect(self, 7, 10)
  if targetlistEnemy.Count < 1 then
    return 
  end
  local targetEnemy = (targetlistEnemy[0]).targetRole
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetEnemy)
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {hurt}, true)
  skillResult:EndResult()
end

bs_25055.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25055

