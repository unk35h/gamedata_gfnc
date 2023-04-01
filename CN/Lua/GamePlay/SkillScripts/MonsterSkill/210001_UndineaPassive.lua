-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210001 = class("bs_210001", LuaSkillBase)
local base = LuaSkillBase
bs_210001.config = {buffId = 209801}
bs_210001.ctor = function(self)
  -- function num : 0_0
end

bs_210001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.OnRealSummonerCaster)
end

bs_210001.OnRealSummonerCaster = function(self, summonerEntity)
  -- function num : 0_2 , upvalues : _ENV
  if summonerEntity.belongNum == (self.caster).belongNum then
    local collisionEnter = BindCallback(self, self.OnCollisionEnter)
    local collisionExit = BindCallback(self, self.OnCollisionExit)
    self.halo = LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, self.caster, 375, 0, eColliderInfluenceType.Player, collisionEnter, nil, collisionExit, nil, false, false, nil, self.caster)
  end
end

bs_210001.OnCollisionEnter = function(self, collider, index, entity)
  -- function num : 0_3 , upvalues : _ENV
  if entity:GetBuffTier((self.config).buffId) < 1 then
    LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId, 1)
  end
end

bs_210001.OnCollisionExit = function(self, collider, entity)
  -- function num : 0_4 , upvalues : _ENV
  if entity:GetBuffTier((self.config).buffId) >= 1 then
    LuaSkillCtrl:DispelBuff(entity, (self.config).buffId, 1)
  end
end

bs_210001.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
  if self.halo ~= nil then
    (self.halo):EndAndDisposeEmission()
    self.halo = nil
  end
end

bs_210001.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
  self.halo = nil
end

return bs_210001

