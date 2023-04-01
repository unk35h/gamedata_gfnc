-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104602 = class("bs_104602", LuaSkillBase)
local base = LuaSkillBase
bs_104602.config = {effectId_soundwave = 104605, effectId_start = 104606, effectId_hit = 104608, actionId_start = 1002, start_time = 17, skill_time = 35, buffId_inspire = 1046021, configId = 2, weaponLv = 0, effectId_weapon = 104619, effectId_weapon3 = 104620, buffId_1 = 104601}
bs_104602.ctor = function(self)
  -- function num : 0_0
end

bs_104602.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  if (self.config).weaponLv > 2 then
    self:AddAfterHurtTrigger("bs_104602_1", 1, self.OnAfterHurt, nil, nil, (self.caster).belongNum, nil, (self.caster).roleType)
  end
end

bs_104602.PlaySkill = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local last_target = ((self.caster).recordTable).lastAttackRole
  local target = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, (self.cskill).SkillRange) then
    target = last_target
  else
    local tempTarget = self:GetMoveSelectTarget()
    if tempTarget == nil then
      return 
    end
    target = tempTarget.targetRole
  end
  do
    if target == nil or target.hp <= 0 then
      return 
    end
    local direction = LuaSkillCtrl:GetTargetWithGrid(target.x, target.y)
    local shootWave = BindCallback(self, self.ShootWave, direction, target)
    ;
    (self.caster):LookAtTarget(target)
    self:CallCasterWait((self.config).skill_time)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, 1, (self.config).start_time, shootWave)
  end
end

bs_104602.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R9 in 'UnsetPending'

  if sender:GetBuffTier((self.config).buffId_inspire) > 0 and isCrit == true and (sender.recordTable).ult_time ~= nil and (sender.recordTable).ult_time < (self.arglist)[5] then
    (sender.recordTable).ult_time = (sender.recordTable).ult_time + 1
    local number = 50000 * (self.arglist)[6] // 1000
    LuaSkillCtrl:CallAddPlayerHmp(number)
  end
end

bs_104602.ShootWave = function(self, grid)
  -- function num : 0_4 , upvalues : _ENV
  if grid == nil then
    return 
  end
  LuaSkillCtrl:CallEffect(grid, (self.config).effectId_start, self)
  local effectId = (self.config).effectId_soundwave
  if (self.config).weaponLv > 1 then
    effectId = (self.config).effectId_weapon
  end
  if (self.config).weaponLv > 1 then
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_weapon3, self)
    local targetList = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local role = (targetList[i]).targetRole
        self:inspireFriend(role)
      end
    end
  end
  do
    self.number = 0
    local effect_zd = LuaSkillCtrl:CallEffect(grid, effectId, self)
    local gridPos = grid:GetLogicPos()
    local shootDir = ((((CS.TrueSync).TSVector3).Subtract)(gridPos, ((self.caster).lsObject).localPosition)).normalized
    local shootDir2D = ((CS.TrueSync).TSVector2)(shootDir.x, shootDir.z)
    local OnCollition = BindCallback(self, self.OnCollision, shootDir2D)
    local OnOver = BindCallback(self, self.OnOver)
    LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, grid, 70, 7, 14, OnCollition, nil, nil, effect_zd, true, true, OnOver)
  end
end

bs_104602.OnCollision = function(self, shootDir2d, collider, index, entity)
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
    if entity.belongNum == (self.caster).belongNum and (self.config).weaponLv < 2 then
      self:inspireFriend(entity)
    end
    if entity.belongNum ~= (self.caster).belongNum and not LuaSkillCtrl:IsFixedObstacle(entity) then
      self:HurtEnermy(entity)
    end
  end
end

bs_104602.inspireFriend = function(self, target)
  -- function num : 0_6 , upvalues : _ENV
  if target.hp <= 0 or target == nil or target.roleType ~= eBattleRoleType.character then
    return 
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (target.recordTable).haze_weaponLv = 0
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  if (self.config).weaponLv > 1 then
    (target.recordTable).haze_weaponLv = (self.arglist)[4]
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R2 in 'UnsetPending'

  if (self.config).weaponLv > 2 then
    (target.recordTable).ult_time = 0
  end
  LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_inspire, 1, (self.arglist)[2])
  if ((self.caster).recordTable).haze_buffNum ~= nil and ((self.caster).recordTable).haze_buffNum > 0 then
    local number = ((self.caster).recordTable).haze_buffNum
    local time = ((self.caster).recordTable).haze_buffTime
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_1, number, time, true)
  end
end

bs_104602.HurtEnermy = function(self, target)
  -- function num : 0_7 , upvalues : _ENV
  local hurt = (self.arglist)[1]
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {hurt})
  skillResult:EndResult()
end

bs_104602.OnOver = function(self)
  -- function num : 0_8
  self:OnSkillDamageEnd()
end

bs_104602.OnCasterDie = function(self)
  -- function num : 0_9
end

bs_104602.LuaDispose = function(self)
  -- function num : 0_10 , upvalues : base
  (base.LuaDispose)(self)
  self.audioloop = nil
end

return bs_104602

