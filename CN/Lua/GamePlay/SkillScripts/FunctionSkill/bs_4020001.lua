-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4020001 = class("bs_4020001", LuaSkillBase)
local base = LuaSkillBase
bs_4020001.config = {
aoe_config = {effect_shape = 3, aoe_select_code = 5, aoe_range = 1}
, effectId = 12073, HurtConfigId = 14, buffId = 2090}
bs_4020001.ctor = function(self)
  -- function num : 0_0
end

bs_4020001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_4020001_1", 1, self.OnBattleStart)
  self.timer = nil
end

bs_4020001.OnBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.eventFunc)
  self.timer = LuaSkillCtrl:StartTimer(self, (self.arglist)[1], arriveCallBack, nil, -1)
end

bs_4020001.eventFunc = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local target_grid = LuaSkillCtrl:CallFindGridMostRolesArounded(eBattleRoleBelong.enemy)
  local target = target_grid.role
  do
    if target == nil then
      local targetList = LuaSkillCtrl:FindRolesAroundGrid(target_grid, eBattleRoleBelong.enemy)
      target = targetList[0]
    end
    if target == nil then
      return 
    end
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).aoe_config)
    if (skillResult.roleList).Count > 0 then
      for i = 0, (skillResult.roleList).Count - 1 do
        local targetRole = (skillResult.roleList)[i]
        if targetRole.belongNum == eBattleRoleBelong.enemy then
          LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, 1, (self.arglist)[3], nil)
          local skillResult1 = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
          LuaSkillCtrl:HurtResultWithConfig(self, skillResult1, (self.config).HurtConfigId, {(self.arglist)[2]}, true, true)
          skillResult1:EndResult()
        end
      end
    end
    do
      skillResult:EndResult()
    end
  end
end

bs_4020001.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_4020001.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  (base.LuaDispose)(self)
  self.timer = nil
end

return bs_4020001

