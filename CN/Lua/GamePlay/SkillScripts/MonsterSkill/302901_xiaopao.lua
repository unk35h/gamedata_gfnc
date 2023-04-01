-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_302901 = class("bs_302901", LuaSkillBase)
local base = LuaSkillBase
bs_302901.config = {timeDelay = 30, deathTime = 150, 
hurt_config = {hit_formula = 0, basehurt_formula = 10087, crit_formula = 0}
, effectId = 10973}
bs_302901.ctor = function(self)
  -- function num : 0_0
end

bs_302901.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.config).timeDelay, arriveCallBack, nil, -1, (self.config).timeDelay)
  local arriveCallBack1 = BindCallback(self, self.OnArriveAction1)
  self.timer2 = LuaSkillCtrl:StartTimer(nil, (self.config).deathTime, arriveCallBack1, nil, -1)
end

bs_302901.OnArriveAction1 = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.timer2 ~= nil and (self.timer2):IsOver() then
    self.timer2 = nil
  end
  LuaSkillCtrl:RemoveLife((self.caster).maxHp * 2, self, self.caster, true, nil, false, true, 2, true)
end

bs_302901.OnArriveAction = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 7, 10)
  if targetlist.Count < 1 then
    return 
  end
  local target = (targetlist[0]).targetRole
  if target == nil then
    return 
  end
  ;
  (self.caster):LookAtTarget(target)
  LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  local collisionTrigger = BindCallback(self, self.OnCollision, target)
  LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, target, 15, 10, eColliderInfluenceType.Enemy, collisionTrigger, nil, nil, nil, true, true, nil, nil)
end

bs_302901.OnCollision = function(self, target, collider, index, entity)
  -- function num : 0_4 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config)
  skillResult:EndResult()
end

bs_302901.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
  if self.timer2 ~= nil then
    (self.timer2):Stop()
    self.timer2 = nil
  end
end

return bs_302901

