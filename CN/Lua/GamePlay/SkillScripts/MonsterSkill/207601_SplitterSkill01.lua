-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207601 = class("bs_207601", LuaSkillBase)
local base = LuaSkillBase
bs_207601.config = {monsterId = 42, effectId_summon1 = 207602, effectId_summon2 = 207603, buffId_live = 3009, 
heal_config = {baseheal_formula = 3022, correct_formula = 0}
}
bs_207601.ctor = function(self)
  -- function num : 0_0
end

bs_207601.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetDeadHurtTrigger("bs_207601_1", 99, self.OnSetDeadHurt, nil, self.caster)
end

bs_207601.OnSetDeadHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if self:IsReadyToTake() and context.target == self.caster and (context.target):GetBuffTier((self.config).nanaka_buffId) <= 0 then
    self:PlaySkill()
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_summon1, self)
    LuaSkillCtrl:CallBuff(self, context.target, (self.config).buffId_live, 1, 1, true)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {1000}, false, false)
    skillResult:EndResult()
  end
  do
    self:OnSkillTake()
  end
end

bs_207601.PlaySkill = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local Grid = LuaSkillCtrl:FindRoleRightEmptyGrid(self.caster, 10)
  if Grid == nil then
    Grid = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
  end
  if Grid ~= nil then
    local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).monsterId, Grid.x, Grid.y)
    summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp)
    summoner:SetAttr(eHeroAttr.pow, (self.caster).pow)
    summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
    summoner:SetAttr(eHeroAttr.moveSpeed, (self.caster).moveSpeed)
    summoner:SetAttr(eHeroAttr.def, (self.caster).def)
    summoner:SetAttr(eHeroAttr.magic_res, (self.caster).magic_res)
    summoner:SetAttr(eHeroAttr.lucky, self.lucky)
    summoner:SetAsRealEntity(1)
    local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
    LuaSkillCtrl:CallEffect(summonerEntity, (self.config).effectId_summon2, self)
  end
end

bs_207601.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207601

