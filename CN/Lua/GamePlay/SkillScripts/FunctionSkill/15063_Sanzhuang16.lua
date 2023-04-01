-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15063 = class("bs_15063", LuaSkillBase)
local base = LuaSkillBase
bs_15063.config = {effectId = 10955, buffId = 1255}
bs_15063.ctor = function(self)
  -- function num : 0_0
end

bs_15063.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_15063_1", 1, self.OnAfterBattleStart)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.CallBuffForSameCamp)
end

bs_15063.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["15063_damagePer"] = (self.arglist)[1]
end

bs_15063.CallBuffForSameCamp = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  if (role.summoner).summonerMaker == self.caster then
    local camp = role.camp
    if role.roleType == eBattleRoleType.realSummoner then
      camp = LuaSkillCtrl:GetSummonerCamp(role)
    end
    if camp == (self.caster).camp and role:GetBuffTier((self.config).buffId) == 0 then
      LuaSkillCtrl:CallBuff(self, role, (self.config).buffId, 1, nil)
      -- DECOMPILER ERROR at PC38: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (role.recordTable)["15063_damagePer"] = (self.arglist)[1]
    end
  end
end

bs_15063.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15063

