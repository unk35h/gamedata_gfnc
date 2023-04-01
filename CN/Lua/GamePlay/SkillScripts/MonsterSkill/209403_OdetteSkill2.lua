-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_209403 = class("bs_209403", LuaSkillBase)
local base = LuaSkillBase
bs_209403.config = {effectId_trail = 209410, effectId_hit = 209411, effectId_xuli = 209409, actionId = 1020, act_speed = 1, start_time = 19, skill_time = 56, configId = 3, buffId = 1257}
bs_209403.ctor = function(self)
  -- function num : 0_0
end

bs_209403.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_209403.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self:OnSkillTake()
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallBuff(self, self.caster, 170, 1, (self.config).skill_time, true)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_xuli, self)
  local skillTrigger = BindCallback(self, self.OnSkillTrigger)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).act_speed, (self.config).start_time, skillTrigger)
  local callnextskill = BindCallback(self, self.EndSkillAndCallNext)
  LuaSkillCtrl:StartTimer(nil, (self.config).skill_time, callnextskill)
  self:AbandonSkillCdAutoReset(true)
end

bs_209403.OnSkillTrigger = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local target = nil
  local targets = LuaSkillCtrl:CallTargetSelect(self, 48, 10)
  if targets.Count > 0 then
    for i = 0, targets.Count - 1 do
      if ((targets[i]).targetRole):GetBuffTier((self.config).buffId) == 0 then
        target = (targets[i]).targetRole
        break
      end
    end
  end
  do
    do
      if target == nil then
        local randTarget = LuaSkillCtrl:CallTargetSelect(self, 19, 10)
        if randTarget == nil or randTarget.Count == 0 then
          return 
        end
        target = (randTarget[0]).targetRole
      end
      ;
      (self.caster):LookAtTarget(target)
      local grid = LuaSkillCtrl:GetTargetWithGrid(target.x, target.y)
      local effect_zd = LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self)
      local gridPos = grid:GetLogicPos()
      local shootDir = ((((CS.TrueSync).TSVector3).Subtract)(gridPos, ((self.caster).lsObject).localPosition)).normalized
      local shootDir2D = ((CS.TrueSync).TSVector2)(shootDir.x, shootDir.z)
      local OnCollition = BindCallback(self, self.OnCollision, shootDir2D)
      local skillEmission = LuaSkillCtrl:CallCircledEmissionStraightly(self, target, self.caster, 25, 3, 4, OnCollition, nil, nil, effect_zd, true, true)
      if self.timer ~= nil then
        (self.timer):Stop()
        self.timer = nil
      end
      local cusEffect1 = LuaSkillCtrl:CallEffectWithEmission(skillEmission, (self.config).effectId_trail, self, nil, self.caster, 1, true)
      self.effectGrid = {}
      self.timer = LuaSkillCtrl:StartTimer(nil, 3, (BindCallback(self, self.findGrid, skillEmission, target, effect_zd)), nil, -1, 3)
    end
  end
end

bs_209403.findGrid = function(self, skillEmission, target, effect)
  -- function num : 0_4 , upvalues : _ENV
  if effect == nil or effect:IsDie() then
    (self.timer):Stop()
    self.timer = nil
  end
  local collider = skillEmission.collider
  if collider ~= nil then
    local pos = collider.coliderPos
    local grids = LuaSkillCtrl:FindAllGridsWithUnityRange(pos, (collider.colliderRadius):AsFloat())
    if grids ~= nil then
      for k,v in pairs(grids) do
        if (self.effectGrid)[v] == nil then
          LuaSkillCtrl:CallCreateEfcGrid((v.coord).x, (v.coord).y, 1125)
          -- DECOMPILER ERROR at PC40: Confused about usage of register: R12 in 'UnsetPending'

          ;
          (self.effectGrid)[v] = true
        end
      end
    end
  end
end

bs_209403.OnCollision = function(self, shootDir2d, collider, index, entity)
  -- function num : 0_5 , upvalues : _ENV
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

bs_209403.HurtEnermy = function(self, target)
  -- function num : 0_6 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[1]})
  skillResult:EndResult()
end

bs_209403.EndSkillAndCallNext = function(self)
  -- function num : 0_7
  if self.caster == nil then
    return 
  end
  local skillMgr = (self.caster):GetSkillComponent()
  if skillMgr == nil then
    return 
  end
  skillMgr.lastSkill = self.cskill
  self:CancleCasterWait()
  ;
  (self.caster):CallUnFreezeNextSkill()
end

bs_209403.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_209403.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  (base.LuaDispose)(self)
  self.effectGrid = nil
end

return bs_209403

