-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001220 = class("bs_4001220", LuaSkillBase)
local bs_4001220 = class("bs_4001220", base)
bs_4001220.config = {buffId = 2016}
bs_4001220.ctor = function(self)
  -- function num : 0_0
end

bs_4001220.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_4001220_1", 1, self.OnAfterBattleStart)
end

bs_4001220.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local collisionEnter = BindCallback(self, self.OnCollisionEnter)
  local collisionExit = BindCallback(self, self.OnCollisionExit)
  self.halo_em = LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, self.caster, 100, 0, eColliderInfluenceType.Enemy, collisionEnter, nil, collisionExit, nil, false, false, nil, self.caster)
end

bs_4001220.OnCollisionEnter = function(self, collider, index, entity)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1)
end

bs_4001220.OnCollisionExit = function(self, collider, entity)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, -1)
end

bs_4001220.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.halo_em ~= nil then
    (self.halo_em):EndAndDisposeEmission()
    self.halo_em = nil
  end
  ;
  (base.OnCasterDie)(self)
end

bs_4001220.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : _ENV
  (base.LuaDispose)(self)
  self.halo_em = nil
end

return bs_4001220

