-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010426 = class("bs_4010426", LuaSkillBase)
local base = LuaSkillBase
bs_4010426.config = {buffId = 2087, buffId2 = 195, duration = 75}
bs_4010426.ctor = function(self)
  -- function num : 0_0
end

bs_4010426.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.CallSummonerBuff)
  self:AddAfterHurtTrigger("bs_4010426_1", 1, self.OnAfterHurt, nil, nil, (self.caster).belongNum, nil, eBattleRoleType.realSummoner, nil, nil, nil, false)
end

bs_4010426.CallSummonerBuff = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  if ((role.summoner).summonerMaker).belongNum == eBattleRoleBelong.player then
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffId, 1, (self.arglist)[1], true)
  end
end

bs_4010426.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if not isMiss and not isTriggerSet and sender.roleType == eBattleRoleType.realSummoner then
    local tier = sender:GetBuffTier((self.config).buffId)
    if tier ~= nil and tier > 0 then
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId2, 1, (self.config).duration, false)
    end
  end
end

bs_4010426.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010426

