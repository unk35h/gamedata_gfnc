-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70036 = class("bs_70036", LuaSkillBase)
local base = LuaSkillBase
bs_70036.config = {effectId = 5}
bs_70036.ctor = function(self)
  -- function num : 0_0
end

bs_70036.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_70036_04", 1, self.OnRoleDie, nil, nil, nil, eBattleRoleBelong.enemy)
end

bs_70036.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if killer.belongNum == eBattleRoleBelong.player then
    local target = LuaSkillCtrl:GetTargetWithGrid(role.x, role.y)
    local effect = LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
    local collisionEnter = BindCallback(self, self.OnCollisionEnter, effect)
    LuaSkillCtrl:CallAddCircleColliderForEffect(effect, 50, eColliderInfluenceType.Player, nil, collisionEnter)
  end
end

bs_70036.OnCollisionEnter = function(self, effect, collider, index, entity)
  -- function num : 0_3 , upvalues : _ENV
  if effect ~= nil then
    effect:Die()
    effect = nil
  end
  print("此处应该加钱")
  LuaSkillCtrl:ClearColliderOrEmission(collider)
end

bs_70036.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_70036

