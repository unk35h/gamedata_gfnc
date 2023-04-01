-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1034012 = class("bs_1034012", base)
bs_1034012.config = {effectId = 10459, buffId_179 = 103401}
bs_1034012.ctor = function(self)
  -- function num : 0_0
end

bs_1034012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.effectHalo = nil
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1034012_1", 1, self.OnAfterBattleStart)
end

bs_1034012.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.effectHalo == nil then
    self.effectHalo = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
  end
  local collisionEnter = BindCallback(self, self.OnCollisionEnter)
  local collisionExit = BindCallback(self, self.OnCollisionExit)
  self.times = 0
  self.halo_em = LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, self.caster, 100, 0, eColliderInfluenceType.Player, collisionEnter, nil, collisionExit, nil, false, false, nil, self.caster)
end

bs_1034012.OnCollisionEnter = function(self, collider, index, entity)
  -- function num : 0_3 , upvalues : _ENV
  if entity:GetBuffTier((self.config).buffId_179) < 1 then
    LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_179, 1, nil, true)
  end
end

bs_1034012.OnCollisionExit = function(self, collider, entity)
  -- function num : 0_4 , upvalues : _ENV
  if entity:GetBuffTier((self.config).buffId_179) >= 1 then
    LuaSkillCtrl:DispelBuff(entity, (self.config).buffId_179, 0, true)
  end
end

bs_1034012.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
  if self.effectHalo ~= nil then
    (self.effectHalo):Die()
    self.effectHalo = nil
  end
  if self.halo_em ~= nil then
    (self.halo_em):EndAndDisposeEmission()
    self.halo_em = nil
  end
end

bs_1034012.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
  self.effectHalo = nil
  self.halo_em = nil
end

return bs_1034012

