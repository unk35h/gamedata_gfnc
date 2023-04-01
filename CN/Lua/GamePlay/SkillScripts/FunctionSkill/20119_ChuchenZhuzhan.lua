-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20119 = class("bs_20119", LuaSkillBase)
local base = LuaSkillBase
bs_20119.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10076, crit_formula = 0}
, 
aoe_config = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
, effectId = 10923}
bs_20119.ctor = function(self)
  -- function num : 0_0
end

bs_20119.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnSelfAfterMove, "bs_20119_1", 1, self.OnAfterMove)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRoleSplash, self.OnRoleSplash)
end

bs_20119.OnAfterMove = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local grid = LuaSkillCtrl:GetGridWithRole(self.caster)
  local targetList = LuaSkillCtrl:FindRolesAroundGrid(grid, eBattleRoleBelong.enemy)
  if targetList ~= nil and targetList.Count > 0 and self:IsReadyToTake() then
    self:DoDamage()
  end
end

bs_20119.OnRoleSplash = function(self, role, grid)
  -- function num : 0_3 , upvalues : _ENV
  if role == self.caster and role.curCoord == grid.coord and self:IsReadyToTake() then
    local grid = LuaSkillCtrl:GetGridWithRole(self.caster)
    local targetList = LuaSkillCtrl:FindRolesAroundGrid(grid, eBattleRoleBelong.enemy)
    if targetList ~= nil and targetList.Count > 0 then
      self:DoDamage()
    end
  end
end

bs_20119.DoDamage = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self:OnSkillTake()
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster, (self.config).aoe_config)
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config)
  skillResult:EndResult()
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
end

bs_20119.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20119

