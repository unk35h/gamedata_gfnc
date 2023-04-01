-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_208101 = class("bs_208101", LuaSkillBase)
local base = LuaSkillBase
bs_208101.config = {buffId = 105001, buffId_tip = 105005, effectId_pass = 105016, buffId_3002 = 3002, selectId = 9, configId = 3}
bs_208101.ctor = function(self)
  -- function num : 0_0
end

bs_208101.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.OnAfterBattleStart)
  self.arg1 = ((self.caster).recordTable).arg_1
  self.arg2 = ((self.caster).recordTable).arg_2
end

bs_208101.OnAfterBattleStart = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  if role ~= self.caster then
    return val
  end
  self.tigger = true
  LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_2_0 , upvalues : self
    self.tigger = false
  end
)
  if self.effectHalo == nil then
    self.effectHalo = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_pass, self)
  end
  local collisionEnter = BindCallback(self, self.OnCollisionEnter)
  local collisionExit = BindCallback(self, self.OnCollisionExit)
  self.halo = LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, self.caster, 100, 0, eColliderInfluenceType.Enemy, collisionEnter, nil, collisionExit, nil, false, false, nil, self.caster)
  local collisionEnter1 = BindCallback(self, self.OnCollisionEnter1)
  self.halo1 = LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, self.caster, 175, 0, eColliderInfluenceType.Enemy, collisionEnter1, nil, nil, nil, false, false, nil, self.caster)
end

bs_208101.OnCollisionEnter = function(self, collider, index, entity)
  -- function num : 0_3 , upvalues : _ENV
  if entity:GetBuffTier((self.config).buffId) < 1 and entity.belongNum == eBattleRoleBelong.enemy then
    LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId, self.arg1, nil, true)
    LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_tip, 1, nil)
  end
end

bs_208101.OnCollisionExit = function(self, collider, entity)
  -- function num : 0_4 , upvalues : _ENV
  if entity:GetBuffTier((self.config).buffId) >= 1 then
    LuaSkillCtrl:DispelBuff(entity, (self.config).buffId, 0)
    LuaSkillCtrl:DispelBuff(entity, (self.config).buffId_tip, 0)
  end
end

bs_208101.OnCollisionEnter1 = function(self, collider, index, entity)
  -- function num : 0_5 , upvalues : _ENV
  if self.tigger == true then
    LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_3002, 1, self.arg2)
  end
end

bs_208101.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
  if self.effectHalo ~= nil then
    (self.effectHalo):Die()
    self.effectHalo = nil
  end
  if self.halo ~= nil then
    (self.halo):EndAndDisposeEmission()
    self.halo = nil
  end
  if self.halo1 ~= nil then
    (self.halo1):EndAndDisposeEmission()
    self.halo1 = nil
  end
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

bs_208101.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : base
  (base.LuaDispose)(self)
  if self.halo ~= nil then
    (self.halo):EndAndDisposeEmission()
    self.halo = nil
  end
  if self.halo1 ~= nil then
    (self.halo1):EndAndDisposeEmission()
    self.halo1 = nil
  end
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
  self.effectHalo = nil
  self.halo = nil
  self.halo1 = nil
  self.timer = nil
end

return bs_208101

