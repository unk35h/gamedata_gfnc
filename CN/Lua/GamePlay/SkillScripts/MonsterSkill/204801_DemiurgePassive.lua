-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204801 = class("bs_204801", LuaSkillBase)
local base = LuaSkillBase
bs_204801.config = {buff_superman = 204801, 
aoe = {effect_shape = 1, aoe_select_code = 2, aoe_range = 10}
, buff_bati = 196}
bs_204801.ctor = function(self)
  -- function num : 0_0
end

bs_204801.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_204801", 10, self.OnRoleDie)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_204801_1", 1, self.OnAfterBattleStart)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).Demiurge = true
end

bs_204801.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local breakComponent = (self.caster):GetBreakComponent()
  if breakComponent == nil then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff_bati, 1, nil, true)
  end
end

bs_204801.OnRoleDie = function(self, killer, role)
  -- function num : 0_3 , upvalues : _ENV
  local role1 = role
  local camp = role.camp
  if role.roleType == eBattleRoleType.realSummoner then
    camp = LuaSkillCtrl:GetSummonerCamp(role)
  end
  if camp == (self.caster).camp and role1.hp == 0 and role1 ~= nil then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster, (self.config).aoe)
    if (skillResult.roleList).Count <= 0 then
      return 
    end
    for i = 0, (skillResult.roleList).Count - 1 do
      if ((skillResult.roleList)[i]).camp == (self.caster).camp then
        LuaSkillCtrl:CallBuff(self, (skillResult.roleList)[i], (self.config).buff_superman, 1, (self.arglist)[1])
      end
    end
  end
end

bs_204801.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_204801

