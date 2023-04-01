-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_605 = class("bs_605", LuaSkillBase)
local base = LuaSkillBase
bs_605.config = {monsterId = 1018, buffId = 88}
bs_605.ctor = function(self)
  -- function num : 0_0
end

bs_605.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_605.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : _ENV, base
  local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).monsterId, (self.caster).x + 1, (self.caster).y)
  summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp)
  summoner:SetAsRealEntity(1)
  ;
  (base.OnCasterDie)(self)
  LuaSkillCtrl:StartTimer(nil, 30, function(summoner)
    -- function num : 0_2_0 , upvalues : _ENV, self
    local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
    LuaSkillCtrl:CallBuff(self, summonerEntity, (self.config).buffId, 1, nil, true)
  end
, summoner)
end

return bs_605

