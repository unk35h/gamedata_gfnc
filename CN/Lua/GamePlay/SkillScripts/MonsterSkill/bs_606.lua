-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_606 = class("bs_606", LuaSkillBase)
local base = LuaSkillBase
bs_606.config = {buffId = 88}
bs_606.ctor = function(self)
  -- function num : 0_0
end

bs_606.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.OnAfterBattleStart)
end

bs_606.OnAfterBattleStart = function(self, summonerEntity)
  -- function num : 0_2 , upvalues : _ENV
  if summonerEntity == self.caster then
    local collisionEnter = BindCallback(self, self.OnCollisionEnter)
    self.fireCollider = LuaSkillCtrl:CallGetCircleSkillCollider(self, 50, eColliderInfluenceType.Enemy, collisionEnter, nil, nil)
  end
end

bs_606.OnCollisionEnter = function(self, collider, index, entity)
  -- function num : 0_3 , upvalues : _ENV
  print("此处应该加钱")
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  LuaSkillCtrl:RemoveLife((self.caster).maxHp * 2, self, self.caster, true, nil, false, true)
  LuaSkillCtrl:ClearColliderOrEmission(collider)
end

bs_606.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  self.fireCollider = nil
end

return bs_606

