-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_200104 = class("bs_200104", LuaSkillBase)
local base = LuaSkillBase
bs_200104.config = {selectTargetId = 9, select_range = 0, action = 1009, buffId_196 = 196}
bs_200104.ctor = function(self)
  -- function num : 0_0
end

bs_200104.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.BeforePlaySkill, "CommonTDMonsterAttackPassive_checkPlaySkill", 1, self.OnBeforePlaySkill)
end

bs_200104.OnBeforePlaySkill = function(self, role, context)
  -- function num : 0_2 , upvalues : _ENV
  if role ~= self.caster then
    return 
  end
  if ((context.skill).moveSelectTarget).targetRole == campRole and self:IsReadyToTake() then
    context.active = false
    self:AttackTowerCamp()
    if self.cskill ~= nil then
      self:OnSkillTake()
    end
  end
end

bs_200104.PlaySkill = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  local grid = LuaSkillCtrl:GetGridWithRole(self.caster)
  local targetRoles = LuaSkillCtrl:FindRolesAroundGrid(grid, eBattleRoleBelong.player)
  if targetRoles == nil then
    return 
  end
  local luaGridTab = {}
  for i = targetRoles.Count - 1, 0, -1 do
    local tempRole = targetRoles[i]
    local efcGrid = LuaSkillCtrl:GetEfcGridWithPos(tempRole.x, tempRole.y)
    if efcGrid ~= nil and efcGrid.isContainObstacle and not efcGrid.isAbandonEquipmentTower then
      targetRoles:RemoveAt(i)
    else
      ;
      (table.insert)(luaGridTab, tempRole)
    end
  end
  if #luaGridTab <= 0 then
    return 
  end
  ;
  (table.sort)(luaGridTab, BindCallback(self, self.SortTargetRoles))
  local curAtkRole = luaGridTab[1]
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_196, 1, 7, true)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).action, 1, 7, BindCallback(self, self.AttackTrigger, curAtkRole))
end

bs_200104.SortTargetRoles = function(self, a, b)
  -- function num : 0_4 , upvalues : _ENV
  local campRole = (self.caster):GetRoleMoveFollowTarget()
  local distanceA = LuaSkillCtrl:GetGridsDistance(a.x, a.y, campRole.x, campRole.y)
  local distanceB = LuaSkillCtrl:GetGridsDistance(b.x, b.y, campRole.x, campRole.y)
  do return distanceA < distanceB end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

bs_200104.AttackTrigger = function(self, curAtkRole)
  -- function num : 0_5 , upvalues : _ENV
  do
    if curAtkRole ~= nil and curAtkRole.hp > 0 and curAtkRole.belongNum ~= (self.caster).belongNum then
      local hurtResult = curAtkRole.maxHp * (self.arglist)[1] // 1000
      LuaSkillCtrl:RemoveLife(hurtResult, self, curAtkRole, false, nil, true)
    end
    LuaSkillCtrl:RemoveLife((self.caster).maxHp, self, self.caster)
  end
end

bs_200104.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_200104

