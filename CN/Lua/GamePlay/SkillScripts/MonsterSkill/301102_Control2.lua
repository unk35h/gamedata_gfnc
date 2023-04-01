-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_301102 = class("bs_301102", LuaSkillBase)
local base = LuaSkillBase
bs_301102.config = {deathRoleId = 40027, monsterId = 34, effectId = 10264, selfDeathTime = 45, buffId1 = 175, buffId2 = 1033, buffId3 = 198}
bs_301102.ctor = function(self)
  -- function num : 0_0
end

bs_301102.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_301102_10", 1, self.OnRoleDie)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_301102_1", 10, self.OnAfterBattleStart)
end

bs_301102.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId1, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId2, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId3, 1, nil, true)
end

bs_301102.OnRoleDie = function(self, killer, role)
  -- function num : 0_3 , upvalues : _ENV
  if role.roleDataId == (self.config).deathRoleId then
    local cback = BindCallback(self, self.CallBack, role.x, role.y)
    LuaSkillCtrl:StartTimer(nil, 15, cback)
  end
end

bs_301102.CallBack = function(self, x, y)
  -- function num : 0_4 , upvalues : _ENV
  local target = LuaSkillCtrl:GetTargetWithGrid(x, y)
  LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).monsterId, x, y)
  summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * 2)
  summoner:SetAttr(eHeroAttr.pow, (self.caster).pow)
  summoner:SetAttr(eHeroAttr.skill_intensity, (self.caster).skill_intensity)
  summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
  summoner:SetAsRealEntity(1)
  local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
  LuaSkillCtrl:StartTimer(nil, (self.config).selfDeathTime, self.Death, self)
end

bs_301102.Death = function(self)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:ForceEndBattle(true)
end

bs_301102.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_301102

