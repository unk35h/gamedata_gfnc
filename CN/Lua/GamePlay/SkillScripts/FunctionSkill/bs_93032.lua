-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93032 = class("bs_93032", LuaSkillBase)
local base = LuaSkillBase
bs_93032.config = {buffId = 66, effectId = 10989, 
aoe_config = {effect_shape = 3, aoe_select_code = 5, aoe_range = 1}
, 
hurt_config = {hit_formula = 0, crit_formula = 0, basehurt_formula = 502}
}
bs_93032.ctor = function(self)
  -- function num : 0_0
end

bs_93032.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_93032_1", 1, self.OnAfterBattleStart)
  self.HurtNum = 0
  self.HurtTarget = nil
end

bs_93032.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.damTimer = LuaSkillCtrl:StartTimer(self, (self.arglist)[3], self.CallBack, self, -1, (self.arglist)[3])
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if targetlist.Count <= 0 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    self.HurtNum = self.HurtNum + ((targetlist[i]).targetRole).maxHp
  end
  self.HurtNum = self.HurtNum * (self.arglist)[1] // 100
end

bs_93032.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.damTimer ~= nil and (self.damTimer):IsOver() then
    self.damTimer = nil
  end
  local belongNum = 2
  local grid = LuaSkillCtrl:CallFindGridMostRolesArounded(belongNum)
  if grid ~= nil then
    local target = LuaSkillCtrl:GetTargetWithGrid(grid.x, grid.y)
    local rocklist = LuaSkillCtrl:FindRolesAroundGrid(grid, eBattleRoleBelong.neutral)
    local roleslist = LuaSkillCtrl:FindRolesAroundGrid(grid, belongNum)
    if roleslist == nil or roleslist.Count == 0 then
      return 
    end
    local Num = roleslist.Count
    local hurtNum = self.HurtNum // Num
    if roleslist.Count > 0 then
      for i = 0, roleslist.Count - 1 do
        LuaSkillCtrl:CallBuff(self, roleslist[i], (self.config).buffId, 1, (self.arglist)[2])
      end
    end
    do
      LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).aoe_config)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {hurtNum})
      skillResult:EndResult()
      self:PlayChipEffect()
      if rocklist == nil or rocklist.Count == 0 then
        return 
      end
      if rocklist.Count > 0 then
        for i = 0, rocklist.Count - 1 do
          LuaSkillCtrl:RemoveLife((rocklist[i]).hp, self, rocklist[i], true, nil, false, true, eHurtType.RealDmg, true)
        end
      end
    end
  end
end

bs_93032.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.damTimer then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
end

return bs_93032

