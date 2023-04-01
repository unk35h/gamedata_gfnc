-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104601 = class("bs_104601", LuaSkillBase)
local base = LuaSkillBase
bs_104601.config = {buffId_criticalDamage = 1046011, buffId_rangeUp = 1046012, effectId_wave = 104603, effectId_waveHit = 104604, configId = 2, action_time = 7, delayKillEffect = 15, weaponLv = 0, effectId_wave_ex = 104618, effectId_waveHit_weapon = 104621, buffId_1 = 104601}
bs_104601.ctor = function(self)
  -- function num : 0_0
end

bs_104601.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_104601_1", 1, self.OnAfterBattleStart)
  self:AddLuaTrigger(eSkillLuaTrigger.OnCommonAttackTrigger, self.OnCommonAttackTrigger)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).passive_ratio = (self.arglist)[3]
  self.hitpartners = 0
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).haze_buffNum = nil
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).haze_buffTime = nil
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R2 in 'UnsetPending'

  if (self.config).weaponLv > 0 then
    ((self.caster).recordTable).haze_buffNum = (self.arglist)[4]
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.caster).recordTable).haze_buffTime = (self.arglist)[5]
  end
end

bs_104601.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_criticalDamage, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_rangeUp, 1, nil, true)
end

bs_104601.OnCommonAttackTrigger = function(self, target, sender, skill)
  -- function num : 0_3 , upvalues : _ENV
  if sender ~= self.caster then
    return 
  end
  if target == nil or target.hp <= 0 then
    return 
  end
  self.hitpartners = 0
  local direction = LuaSkillCtrl:GetTargetWithGrid(target.x, target.y)
  self:ShootWave(direction, target)
end

bs_104601.ShootWave = function(self, direction, target)
  -- function num : 0_4 , upvalues : _ENV
  local effectId = (self.config).effectId_wave
  if (self.config).weaponLv > 0 then
    effectId = (self.config).effectId_wave_ex
  end
  local soundWave = LuaSkillCtrl:CallEffect(direction, effectId, self)
  local OnCollition = BindCallback(self, self.OnCollision, soundWave, target)
  self.emission = LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, target, 15, 7, 14, OnCollition, nil, nil, soundWave, true, true, BindCallback(self, self.OnArive, soundWave))
end

bs_104601.OnCollision = function(self, soundWave, attackTarget, collider, index, entity)
  -- function num : 0_5 , upvalues : _ENV
  if LuaSkillCtrl:IsFixedObstacle(entity) then
    return 
  end
  if entity.belongNum == (self.caster).belongNum and entity ~= self.caster and entity.roleType == 1 then
    self.hitpartners = self.hitpartners + 1
    if (self.config).weaponLv > 0 then
      local number = ((self.caster).recordTable).haze_buffNum
      local time = ((self.caster).recordTable).haze_buffTime
      LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_1, number, time, true)
    end
  end
  do
    if entity.belongNum ~= (self.caster).belongNum then
      if entity == attackTarget and self.hitpartners <= 0 then
        collider.isActive = false
        self:UnBindEfcForEmission(collider.bindEmission)
        self:DelayKillEffect(soundWave)
        return 
      end
      if entity.hp >= 0 and self.hitpartners > 0 then
        local effectId_hit = (self.config).effectId_waveHit
        if (self.config).weaponLv > 0 then
          effectId_hit = (self.config).effectId_waveHit_weapon
        end
        LuaSkillCtrl:CallEffect(entity, effectId_hit, self)
        local ratio = self.hitpartners * ((self.caster).recordTable).passive_ratio
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {ratio})
        skillResult:EndResult()
      end
    end
  end
end

bs_104601.OnArive = function(self, cusEffect, emission)
  -- function num : 0_6
  self:UnBindEfcForEmission(emission)
  self:DelayKillEffect(cusEffect)
end

bs_104601.UnBindEfcForEmission = function(self, emission)
  -- function num : 0_7
  emission.effect = nil
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (emission.collider).lsObject = nil
end

bs_104601.DelayKillEffect = function(self, soundWave)
  -- function num : 0_8 , upvalues : _ENV
  LuaSkillCtrl:StartTimer(nil, (self.config).delayKillEffect, function()
    -- function num : 0_8_0 , upvalues : soundWave
    if soundWave ~= nil and not soundWave:IsDie() then
      soundWave:Die()
    end
  end
)
end

bs_104601.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104601

