-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_209501 = class("bs_209501", LuaSkillBase)
local base = LuaSkillBase
bs_209501.config = {effectid_1 = 209504, effectid_2 = 209505, actionId = 1055, actionId_time = 64, action_speed = 1, buffId = 209504}
bs_209501.ctor = function(self)
  -- function num : 0_0
end

bs_209501.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.OnAfterBattleStart)
end

bs_209501.OnAfterBattleStart = function(self, summonerEntity)
  -- function num : 0_2 , upvalues : _ENV
  if summonerEntity == self.caster then
    local time = (self.config).actionId_time
    self:CallCasterWait(time)
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId, (self.config).action_speed)
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectid_1, self, nil)
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectid_2, self, nil)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, time)
  end
end

bs_209501.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_209501

