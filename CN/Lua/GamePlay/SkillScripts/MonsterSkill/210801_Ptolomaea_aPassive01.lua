-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210801 = class("bs_210801", LuaSkillBase)
local base = LuaSkillBase
bs_210801.config = {buffId_power = 210801, buffId_atrr1 = 210803, buffId_atrr2 = 210804, effectId = 210808}
bs_210801.ctor = function(self)
  -- function num : 0_0
end

bs_210801.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetDeadHurtTrigger("bs_210801", 99, self.OnSetDeadHurt, nil, self.caster)
end

bs_210801.OnSetDeadHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  local NoDeath = LuaSkillCtrl:RoleContainsBuffFeature(context.target, eBuffFeatureType.NoDeath)
  if context.target == self.caster and NoDeath == false then
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
    local targetList = LuaSkillCtrl:FindRolesAroundRole(self.caster)
    if targetList ~= nil and targetList.Count > 0 then
      for i = targetList.Count - 1, 0, -1 do
        local role = targetList[i]
        if role ~= nil and role.hp > 0 and role.belongNum == (self.caster).belongNum then
          LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_atrr1, 1)
          LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_atrr2, ((self.caster).recordTable).buff_num)
        end
      end
    end
    do
      local grid = LuaSkillCtrl:GetGridWithRole(self.caster)
      if grid ~= nil then
        LuaSkillCtrl:CallCreateEfcGrid((grid.coord).x, (grid.coord).y, 1126)
      end
    end
  end
end

bs_210801.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_210801

