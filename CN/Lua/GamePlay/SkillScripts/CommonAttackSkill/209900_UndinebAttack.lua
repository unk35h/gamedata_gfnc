-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_209900 = class("bs_209900", bs_1)
local base = bs_1
bs_209900.config = {effectId_trail = 106111, effectId_trailHit = 106112, action1 = 1001, action2 = 1001, effectId_action_1 = 106110, effectId_action_2 = 106110, configId = 22}
bs_209900.config = setmetatable(bs_209900.config, {__index = base.config})
bs_209900.ctor = function(self)
  -- function num : 0_0
end

bs_209900.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.arg1 = ((self.caster).recordTable).arg_1
  self.arg2 = ((self.caster).recordTable).arg_2
end

bs_209900.ExecuteEffectAttack = function(self, data, atkActionId, target, effectId1, effectId2)
  -- function num : 0_2 , upvalues : _ENV
  local grid = LuaSkillCtrl:GetTargetWithGrid(target.x, target.y)
  if grid == nil then
    return 
  end
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_trail, self)
  local gridPos = grid:GetLogicPos()
  local shootDir = ((((CS.TrueSync).TSVector3).Subtract)(gridPos, ((self.caster).lsObject).localPosition)).normalized
  local shootDir2D = ((CS.TrueSync).TSVector2)(shootDir.x, shootDir.z)
  local OnCollition = BindCallback(self, self.OnCollision, shootDir2D)
  LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, grid, 15, 7, 14, OnCollition, nil, nil, nil, true, true)
end

bs_209900.OnCollision = function(self, shootDir2d, collider, index, entity)
  -- function num : 0_3 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 or entity == nil or entity.hp <= 0 then
    return 
  end
  local bornPos = ((self.caster).lsObject).localPosition
  if not ((entity.lsObject).localPosition):Equals(bornPos) then
    local tsVec2 = (CS.TrueSync).TSVector2
    local curDir = (((CS.TrueSync).TSVector3).Subtract)((entity.lsObject).localPosition, bornPos)
    local curDir2d = (tsVec2(curDir.x, curDir.z)).normalized
    local angle = LuaSkillCtrl:CallTSVec2Angle(curDir2d, shootDir2d)
    if angle > 100 or angle < -100 then
      return 
    end
  end
  do
    if entity.belongNum ~= (self.caster).belongNum and not LuaSkillCtrl:IsFixedObstacle(entity) then
      self:HurtEnermy(entity)
    end
  end
end

bs_209900.HurtEnermy = function(self, target)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_trailHit, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  local hpRate = target._curHp * 1000 // target.maxHp
  if hpRate <= 500 then
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {self.arg2})
    skillResult:EndResult()
  else
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {self.arg1})
    skillResult:EndResult()
  end
end

bs_209900.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_209900

