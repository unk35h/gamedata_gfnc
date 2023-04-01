-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70029 = class("bs_70029", LuaSkillBase)
local base = LuaSkillBase
bs_70029.config = {monsterId = 38, buffId = 1237, buffTier = 1, effectId = 10264, maxHpPer = 250, powPer = 1000, summonDelay = 30}
bs_70029.ctor = function(self)
  -- function num : 0_0
end

bs_70029.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_70029_1", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_70029_11", 10, self.OnRoleDie)
end

bs_70029.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil, true)
  self:OnSummon()
  self:OnSummon()
end

bs_70029.OnRoleDie = function(self, killer, role, killSkill)
  -- function num : 0_3 , upvalues : _ENV
  if role.roleDataId == (self.config).monsterId then
    local damage = (self.caster).maxHp * (self.arglist)[2] // 1000
    LuaSkillCtrl:RemoveLife(damage, self, self.caster)
    local arriveCallBack = BindCallback(self, self.OnArriveAction)
    LuaSkillCtrl:StartTimer(nil, (self.config).summonDelay, arriveCallBack)
  end
end

bs_70029.OnArriveAction = function(self)
  -- function num : 0_4
  if (self.caster).hp > 0 then
    self:OnSummon()
  end
end

bs_70029.OnSummon = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local gridData = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
  if gridData == nil then
    return 
  end
  local x = gridData.x
  local y = gridData.y
  local target = LuaSkillCtrl:GetTargetWithGrid(gridData.x, gridData.y)
  LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  if not ((self.caster).recordTable).CasterSkill then
    local cskill = self.cskill
  end
  local summoner = LuaSkillCtrl:CreateSummonerWithCSkill(cskill, (self.config).monsterId, x, y)
  summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.config).maxHpPer // 1000)
  summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.skill_intensity, (self.caster).skill_intensity * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
  summoner:SetAttr(eHeroAttr.def, (self.caster).def // 10)
  summoner:SetAttr(eHeroAttr.magic_res, (self.caster).magic_res // 10)
  summoner:SetAsRealEntity(1)
  local table = {CasterSkill = cskill}
  summoner:SetRecordTable(table)
  local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
end

bs_70029.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_70029

